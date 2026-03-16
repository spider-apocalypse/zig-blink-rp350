MEMORY
{
    FLASH (rx)  : ORIGIN = 0x10000000, LENGTH = 4M
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 520K
}

__stack_top = ORIGIN(RAM) + LENGTH(RAM);
SECTIONS
{

	.vector_table : {
        *(.vector_table)
	} > FLASH

	.boot_block : {
			KEEP(*(.boot_block))
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

}
