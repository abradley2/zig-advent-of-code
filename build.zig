const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.addModule("lib", .{
        .root_source_file = b.path("lib/root.zig"),
        .target = target,
    });

    const init_exe = b.addExecutable(.{
        .name = "init",
        .root_module = b.createModule(.{
            .root_source_file = b.path("init.zig"),
            .optimize = optimize,
            .target = target,
        }),
    });

    const init_cmd = b.addRunArtifact(init_exe);
    const init_step = b.step("init", "initialize the project scaffolding");
    init_step.dependOn(&init_cmd.step);

    for (1..13) |day| {
        const day_name = b.fmt("day-{d:0>2}", .{day});
        const day_path = b.fmt("{s}/main.zig", .{day_name});
        const day_exe = b.addExecutable(.{
            .name = day_name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(day_path),
                .optimize = optimize,
                .target = target,
                .imports = &.{
                    .{ .name = "lib", .module = lib_mod },
                },
            }),
        });

        const run_day_step = b.step(day_name, b.fmt("Run {s}", .{day_name}));
        const run_day_cmd = b.addRunArtifact(day_exe);
        run_day_cmd.addPassthruArgs();
        run_day_step.dependOn(&init_cmd.step);
        run_day_step.dependOn(&run_day_cmd.step);

        const day_tests = b.addTest(.{
            .root_module = day_exe.root_module,
        });
        const run_day_tests = b.addRunArtifact(day_tests);
        const test_day_step = b.step(
            b.fmt("test-{s}", .{day_name}),
            b.fmt("Build and run tests for {s}", .{day_name}),
        );
        test_day_step.dependOn(&run_day_tests.step);
    }
}
