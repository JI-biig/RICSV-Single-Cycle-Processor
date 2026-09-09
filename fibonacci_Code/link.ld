MEMORY
{
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 256
}
SECTIONS
{
    . = ORIGIN(RAM);
    .text : { *(.text.start) *(.text*) } > RAM
    .data : { *(.data*) } > RAM
    .bss  : { *(.bss*) *(COMMON) } > RAM
    . = ALIGN(4);
    _stack_top = 252;   /* stay in-range, 4-byte aligned */
}