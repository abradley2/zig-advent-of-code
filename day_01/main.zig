const std = @import("std");
const lib = @import("lib");
const Allocator = std.mem.Allocator;

test "Part One" {
    var output_buffer: [1024]u8 = undefined;
    var output: std.Io.Writer = .fixed(&output_buffer);

    try partOne(std.testing.allocator, &output, "");
    try std.testing.expectEqualStrings("<expected>", output.buffered());
}

pub fn partOne(allocator: Allocator, output: *std.Io.Writer, input: []const u8) !void {
    _ = allocator;
    _ = input;
    try output.writeAll("Not Implemented");
}

test "Part Two" {
    var output_buffer: [1024]u8 = undefined;
    var output: std.Io.Writer = .fixed(&output_buffer);

    try partTwo(std.testing.allocator, &output, "");
    try std.testing.expectEqualStrings("<expected>", output.buffered());
}

pub fn partTwo(allocator: Allocator, output: *std.Io.Writer, input: []const u8) !void {
    _ = allocator;
    _ = input;
    _ = try output.writeAll("Not Implemented");
}

pub fn main(init: std.process.Init) !void {
    const solution: lib.Solution = .{ .part_one = partOne, .part_two = partTwo };
    try lib.solve(init.gpa, init.io, init.minimal.args, solution, @embedFile("input.txt"));
}
