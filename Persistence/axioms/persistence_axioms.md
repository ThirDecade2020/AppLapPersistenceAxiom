# Persistence Layer: Mathematical Specification

## Purpose
The Persistence layer defines the authoritative state space `S` of the system, encoding all durable information. It guarantees that state persists across program executions, machine restarts, and power cycles, without reliance on third-party systems.

## Scope
- State `S` is fully controlled and represented as bytes on the local storage medium.
- All operations on `S` must preserve invariants defined in this specification.
- No external database engines, cloud services, or runtime abstractions are used.

## Core Objects

1. **State Space**
   - Let S be the total system state: S = { r_0, r_1, ..., r_n }
   - Each r_i is a record mapping key k_i to value v_i
   - r_i : K → V ∪ {⊥}, where ⊥ denotes absence

2. **Keys**
   - K = {k_0, k_1, ..., k_m} is the set of all valid keys
   - Keys are fixed-width byte sequences for deterministic addressing

3. **Values**
   - V = {v_0, v_1, ..., v_p} is the set of all valid values
   - Values are fixed-width byte sequences; variable-length values can be added in later iterations

## Invariants

- **Uniqueness:** ∀ r_i, r_j ∈ S, if i ≠ j then k_i ≠ k_j
- **Deterministic Mapping:** The address of r_i in state storage is computable from k_i
- **Persistence:** Once r_i is written to disk, it remains retrievable until explicitly deleted
- **Isolation:** No external system may modify S outside defined operations
- **Page Integrity:** Pages storing records must not overlap; each page has a fixed size and byte alignment

## Operations

- `get(k) : S → V ∪ {⊥}` — Retrieves the value for key k
- `insert(k, v) : S → S` — Adds or updates record r = (k, v)
- `delete(k) : S → S` — Removes record with key k
- `range(k1, k2) : S → {r_i | k1 ≤ k_i ≤ k2}` — Returns all records within the key range

## Physical Mapping (Informal)

- S is stored as fixed-size pages in the `state/` directory.
- Each record r_i occupies a fixed byte layout within a page.
- Pages are addressed sequentially on disk; mapping from key K to disk offset is deterministic.
- Alignment with cache lines and page boundaries is maintained for hardware efficiency.

