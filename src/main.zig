extern const __stack_top: anyopaque;

export const vector_table linksection(".vector_table") = [2]*const anyopaque{
    &__stack_top,
    &resetHandler,
};

export const boot_block linksection(".boot_block") = [5]u32{
    0xFFFFDED3, //magic number
    0x10210142, //flags
    0x000001FF,
    0x00000000, //Zero
    0xAB123579,
};

export fn resetHandler() callconv(.c) void {
    main();

    while (true) {}
}

const LED_PIN = 25;

const PAD25: *volatile u32 = @ptrFromInt(0x40038068);
const SIO_BASE: u32 = 0xD0000000;
const GPIO_OUT_SET: *volatile u32 = @ptrFromInt(SIO_BASE + 0x18);
const GPIO_OUT_CLR: *volatile u32 = @ptrFromInt(SIO_BASE + 0x20);
const GPIO_OE_SET: *volatile u32 = @ptrFromInt(SIO_BASE + 0x38);

const IO_BANK0_BASE: u32 = 0x40028000;
const GPIO25_CTRL: *volatile u32 = @ptrFromInt(IO_BANK0_BASE + 0x0CC);

fn delay() void {
    var i: u32 = 0;
    while (i < 5_000_000) : (i += 1) {}
}

export fn main() noreturn {

    // select SIO function for GPIO25
    PAD25.* = 0;
    GPIO25_CTRL.* = 5;

    // enable output
    GPIO_OE_SET.* = (1 << 25);

    while (true) {

        // LED on
        GPIO_OUT_SET.* = (1 << 25);
        delay();

        // LED off
        GPIO_OUT_CLR.* = (1 << 25);
        delay();
    }
}
