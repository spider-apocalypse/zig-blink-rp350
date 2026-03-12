MEMORY
{
    FLASH (rx)  : ORIGIN = 0x10000000, LENGTH = 4M
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 520K
}

SECTIONS
{
    .vector_table :
    {
        KEEP(*(.vector_table))
    } > FLASH

    .text :
    {
        *(.text*)
        *(.rodata*)
    } > FLASH

    .data :
    {
        *(.data*)
    } > RAM AT>FLASH

    .bss :
    {
        *(.bss*)
        *(COMMON)
    } > RAM

		__stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
