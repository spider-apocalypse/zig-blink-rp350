const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .thumb,
            .os_tag = .freestanding,
            .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m33 },
        },
    });

    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "blink",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.setLinkerScript(b.path("linker.ld"));
    exe.entry = .{ .symbol_name = "vector_table" };

    b.installArtifact(exe);
}
