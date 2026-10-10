const std = @import("std");

const input = @embedFile("input.txt");

pub fn main(init: std.process.Init) !void {
    _ = init;
    std.debug.print("Input is: {s}\n", .{input});
}
