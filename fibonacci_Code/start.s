.section .text.start
.global _start
_start:
    addi sp, x0, 252   # small immediate, no PC-relative math needed
    jal  ra, main