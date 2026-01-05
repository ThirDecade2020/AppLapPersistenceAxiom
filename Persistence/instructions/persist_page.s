.section __TEXT,__text
.globl _main

_main:
    /* open("../state/page0.bin", O_WRONLY) */
    mov x16, #5                  /* sys_open */
    adrp x0, file_path@PAGE
    add x0, x0, file_path@PAGEOFF
    mov x1, #0x1                 /* O_WRONLY */
    svc #0

    mov x19, x0                  /* save fd */

    /* write(fd, page, 256) */
    mov x16, #4                  /* sys_write */
    mov x0, x19
    adrp x1, page@PAGE
    add x1, x1, page@PAGEOFF
    mov x2, #256
    svc #0

    /* close(fd) */
    mov x16, #6                  /* sys_close */
    mov x0, x19
    svc #0

    /* exit */
    mov x16, #1                  /* sys_exit */
    mov x0, #0
    svc #0

.section __DATA,__data
file_path:
    .asciz "../state/page0.bin"

page:
    .space 256
