OUTPUT_ARCH("riscv")

ENTRY(_boot)

MEMORY
{
    rom (rxi!wa) : ORIGIN = 0x20000000, LENGTH = 0x4000
    ram (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 0x4000
}



SECTIONS
{
    .text :
    {
        KEEP(*(._boot))
        *(.text*)
    } > rom

    .rodata :
    {
        *(.rodata*)
    } > rom

    .data : 
    {
        *(.data*)
    } > ram
    . = ALIGN(4);
}