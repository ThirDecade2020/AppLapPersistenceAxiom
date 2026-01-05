# AppLap Persistence Axioms — Top 10

## Persistence Axiom 1 — Fixed-Size Records

**What**  
Each record occupies a fixed number of bytes in storage.

**Why**  
Fixed-size records allow deterministic addressing, simplify memory layout, and make computation of offsets straightforward.

### Mathematical Solution (Maths)
size(r_i) = constant_bytes  
# Each record occupies the same number of bytes

### Assembly Language Solution (Codes)
.align 8                    
record:
    .space constant_bytes   

---

## Persistence Axiom 2 — Atomic Writes

**What**  
Writes to persistent storage must be atomic.

**Why**  
Prevents partially-written records from corrupting the state in crashes or power loss.

### Mathematical Solution (Maths)
∀ r_i ∈ S, write(r_i) → complete or no_change  
# Either fully succeed or leave previous state intact

### Assembly Language Solution (Codes)
mov x16, #5       // sys_open
mov x0, fd_path
mov x1, #0x201    // O_CREAT | O_WRONLY | O_TRUNC
svc #0
mov x16, #4       // sys_write
svc #0
mov x16, #6       // sys_close
svc #0

---

## Persistence Axiom 3 — Deterministic Addressing

**What**  
The location of each record is computable from its key.

**Why**  
Direct access to any record without searching, enabling fast retrieval.

### Mathematical Solution (Maths)
addr(r_i) = base_page + size(r_i) * index(k_i)  
# Storage address = page base + key-derived offset

### Assembly Language Solution (Codes)
adrp x1, page@PAGE         
add  x1, x1, buffer_offset 

---

## Persistence Axiom 4 — Isolation

**What**  
No external process may modify the state outside defined routines.

**Why**  
Prevents corruption and ensures only authorized routines can modify state.

### Mathematical Solution (Maths)
∀ r_i ∈ S, external_write(r_i) ⇒ invalid  

### Assembly Language Solution (Codes)
mov x16, #5       
mov x0, fd_path   
mov x1, #0x201    
svc #0            

---

## Persistence Axiom 5 — Page Integrity

**What**  
Pages must not overlap and must have fixed size and alignment.

**Why**  
Ensures deterministic addressing and hardware-aligned storage.

### Mathematical Solution (Maths)
∀ P_i, P_j ∈ S, i ≠ j ⇒ P_i ∩ P_j = ∅  

### Assembly Language Solution (Codes)
.section __DATA,__data
page:
    .align 8   
    .space 256 

---

## Persistence Axiom 6 — Key Uniqueness

**What**  
Each key in the state space is unique.

**Why**  
Prevents collisions and ensures that every record is identifiable by its key.

### Mathematical Solution (Maths)
∀ r_i, r_j ∈ S, i ≠ j ⇒ k_i ≠ k_j  

### Assembly Language Solution (Codes)
// Check before insert/update that no duplicate keys exist
// Example conceptual assembly: compute key address and compare with existing keys

---

## Persistence Axiom 7 — Value Integrity

**What**  
Values stored must exactly match what was written.

**Why**  
Guarantees that persisted data remains unchanged until explicitly updated.

### Mathematical Solution (Maths)
read(r_i) = v_i, ∀ r_i ∈ S  

### Assembly Language Solution (Codes)
ldr b0, [x_addr]    // Load byte from storage
cmp b0, expected_val // Compare with expected
// Loop through record to verify integrity

---

## Persistence Axiom 8 — Range Queries

**What**  
It must be possible to retrieve all records within a contiguous key range efficiently.

**Why**  
Allows batch reads or analytics without scanning the entire state space.

### Mathematical Solution (Maths)
range(k1, k2) = { r_i | k1 ≤ k_i ≤ k2 }  

### Assembly Language Solution (Codes)
// Compute start offset for k1, iterate through page until k2
adrp x1, page@PAGE
add  x1, x1, offset(k1)
// Loop and read records until k2 reached

---

## Persistence Axiom 9 — Recoverable State

**What**  
After a crash or restart, all previously persisted records must be recoverable.

**Why**  
Ensures continuity and reliability of the application state.

### Mathematical Solution (Maths)
∀ r_i ∈ S, write(r_i) → r_i ∈ S after restart  

### Assembly Language Solution (Codes)
// Open file, read into page buffer
mov x16, #5
mov x0, fd_path
mov x1, #0       // O_RDONLY
svc #0
mov x16, #0      // sys_read
svc #0

---

## Persistence Axiom 10 — Minimal Footprint

**What**  
State storage must avoid wasting space and align data to pages efficiently.

**Why**  
Improves performance and reduces I/O overhead.

### Mathematical Solution (Maths)
Σ size(r_i) ≤ page_size, aligned  

### Assembly Language Solution (Codes)
.align 8
page:
    .space 256      // allocate single page efficiently
// Use fixed offsets for each record

