const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .arm,
            .os_tag = .freestanding,
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
    exe.entry = .{ .symbol_name = "resetHandler" };

    b.installArtifact(exe);
}
