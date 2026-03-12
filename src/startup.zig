const STACK_TOP = 0x20520000;

export const vector_table linksection(".vector_table") = [_]usize{
    STACK_TOP,
    @ptrToInt(resetHandler),
};

extern fn main() void;

export fn resetHandler() callconv(.c) void {
    main();

    while (true) {}
}
