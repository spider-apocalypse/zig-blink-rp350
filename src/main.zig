// const GPIO_OUT: *volatile usize = @ptrFromInt(0xd0000010);
// const GPIO_OE: *volatile usize = @ptrFromInt(0xd0000020);
// // const STACK_TOP = 0x20520000;
//
// const LED_PIN = 25;
//
// fn delay() void {
//     var i: u32 = 0;
//     while (i < 500000) : (i += 1) {}
// }
//
// pub export fn main() void {
//     GPIO_OE.* |= (1 << LED_PIN);
//
//     while (true) {
//         GPIO_OUT.* ^= (1 << LED_PIN);
//
//         delay();
//     }
// }
//

extern const __stack_top: anyopaque;

// export const vector_table linksection(".vector_table") = [2]*const fn () callconv(.c) void{
//     &__stack_top,
//     &resetHandler,
// };
export const vector_table linksection(".vector_table") = [2]*const anyopaque{
    &__stack_top,
    &resetHandler,
};

export fn resetHandler() callconv(.c) void {
    main();

    while (true) {}
}

const LED_PIN = 25;

const SIO_BASE: usize = 0xD0000000;
const GPIO_OUT_SET: *volatile u32 = @ptrFromInt(SIO_BASE + 0x18);
const GPIO_OUT_CLR: *volatile u32 = @ptrFromInt(SIO_BASE + 0x20);
const GPIO_OE_SET: *volatile u32 = @ptrFromInt(SIO_BASE + 0x38);

const IO_BANK0_BASE: usize = 0x40028000;
const GPIO25_CTRL: *volatile u32 = @ptrFromInt(IO_BANK0_BASE + 0x0CC);

fn delay() void {
    var i: u32 = 0;
    while (i < 5_000_000) : (i += 1) {}
}

export fn main() noreturn {

    // select SIO function for GPIO25
    GPIO25_CTRL.* = (5 & 0x1f) << 0;

    // enable output
    GPIO_OE_SET.* = 1 << LED_PIN;

    while (true) {

        // LED on
        GPIO_OUT_SET.* = 1 << LED_PIN;
        delay();

        // LED off
        GPIO_OUT_CLR.* = 1 << LED_PIN;
        delay();
    }
}
