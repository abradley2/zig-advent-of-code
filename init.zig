const std = @import("std");
const Io = std.Io;
const Dir = std.Io.Dir;
const Allocator = std.mem.Allocator;

fn exists(io: Io, dir: Dir, sub_path: []const u8) Dir.AccessError!bool {
    dir.access(io, sub_path, .{ .follow_symlinks = false }) catch |err| {
        if (err == error.FileNotFound) return false;
        return err;
    };

    return true;
}

const template =
    \\const std = @import("std");
    \\
    \\const input = @embedFile("input.txt");
    \\
    \\pub fn main(init: std.process.Init) !void {
    \\    _ = init;
    \\    std.debug.print("Input is: {s}\n", .{input});
    \\}
    \\
;

pub fn run(gpa: Allocator, io: Io) !void {
    _ = gpa;
    const cwd: Dir = .cwd();

    for (1..13) |day| {
        var path_buffer: [6]u8 = undefined;
        const day_path = try std.fmt.bufPrint(&path_buffer, "day_{d:0>2}", .{day});
        if (!try exists(io, cwd, day_path)) {
            try cwd.createDir(io, day_path, .default_dir);
        }

        const day_dir: Dir = try cwd.openDir(io, day_path, .{ .follow_symlinks = false });
        defer day_dir.close(io);
        if (!try exists(io, day_dir, "main.zig")) {
            try day_dir.writeFile(io, .{
                .sub_path = "main.zig",
                .data = template,
            });
        }
        if (!try exists(io, day_dir, "input.txt")) {
            try day_dir.writeFile(io, .{
                .sub_path = "input.txt",
                .data = "",
            });
        }
    }
}

pub fn main(init: std.process.Init) !void {
    try run(init.gpa, init.io);
}
