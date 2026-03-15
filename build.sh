#!/usr/bin/env bash
zig build $@
elf2uf2 -f 0xe48bff59 -i zig-out/bin/blink -o zig-out/bin/blink.uf2
