.section __TEXT,__text
.globl _main

_main:
    /* r0 = color_id (for demo, use 0) */
    mov x0, #0                 /* demo color ID */

    /* Load page into memory */
    adrp x1, page@PAGE
    add x1, x1, page@PAGEOFF

    /* Compute offset = color_id * 4 */
    mov x2, x0
    lsl x2, x2, #2             /* multiply by 4 */

    /* Address of record = page + offset */
    add x3, x1, x2

    /* Load 3-byte count (stored little-endian) */
    ldrb w4, [x3]              /* byte 0 */
    ldrb w5, [x3, #1]          /* byte 1 */
    ldrb w6, [x3, #2]          /* byte 2 */

    /* Combine into 24-bit integer */
    orr w4, w4, w5, lsl #8
    orr w4, w4, w6, lsl #16

    /* Increment */
    add w4, w4, #1

    /* Split back into 3 bytes */
    and w5, w4, #0xFF
    lsr w6, w4, #8
    and w6, w6, #0xFF
    lsr w7, w4, #16
    and w7, w7, #0xFF

    /* Store back */
    strb w5, [x3]              /* byte 0 */
    strb w6, [x3, #1]          /* byte 1 */
    strb w7, [x3, #2]          /* byte 2 */

    /* exit */
    mov x16, #1                 /* sys_exit */
    mov x0, #0
    svc #0

.section __DATA,__data
page:
    .space 256                  /* page buffer */
