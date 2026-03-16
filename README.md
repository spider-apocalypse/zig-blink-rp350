# Minimal Raspberry Pico 2 Bare Metal Code in Zig

As a complete beginner in both programming and embedded systems i found it
challenging to understand the basics required to run bare metal code
on a MCU. 

I'll leave this repo up in case it can help someone get started as well.

# The Pieces

## Build.zig

In `build.zig` the target must be very specific : cpu arch, os tag, cpu model,
and abi all must be set explicitly. 

For Raspberry Pico 2:
- cpu_arch is `thumb`, *not* `arm`
- os tag is freestanding
- cpu_model is set explicitly: `std.Target.arm.cpu.cortex_m33`
- abi is `eabi`

The linker script needs to be specified explicitly.

The executable entry point needs to be set to the vector table symbol when
using the minimal image def boot block from the RP2350 data sheet.

## Linker

The linker script specifies memory sections addresses and tables. 

The stack top is the end of RAM section

The binary should start with the vector table and contain the "magical" boot
block in the first 4kB of the executable. The `KEEP` instruction is necessary
to prevent the boot block from being optimized away since it's just a data
structure that does nothing from the compiler's PoV.

## Code

The minimal vector table is a data structure with a pointer to the top of the
stack and a pointer to the reset_handler.

The boot block is defined as described in RP2350 datasheet section 5.9.5.1.

The reset handler calls main and then runs an empty loop. 

Pointers to hardware registers should be tagged as volatile, which indicates to
the compiler they have side effects, so the compiler will then guarantee the
memory access happens in the right way and in the right order.

The delay loop needs an `asm volatile` trick to prevent the compiler from
optimizing the loop away in release compilation modes. If it's not used, the
compiler removes the delay, and then the main function blinks the LED so fast
that it just looks turned on.

The main function is the most simple part of this whole thing:
- `PAD25 = 0` is selecting an electrical configuration for PIN25 (which the
	onboard LED is tied to). The program doesn't work if this is not set. If i
	understand correctly, that is because setting APD25 to 0 disables internal
	resistors. So when it is not set, the resistors prevent current from reacing
	the LED.
- `GPIO25_CTRL = 5` is selecting the SIO function for pin 25
- `GPIO_OE_SET = (1 << 25)` enables SIO output for PIN 25

Then the main loop does `turn on > delay > turn off > delay` forever.
