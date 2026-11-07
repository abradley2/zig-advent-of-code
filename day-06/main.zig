const std = @import("std");
const lib = @import("lib");
const Allocator = std.mem.Allocator;

const sample_input =
    \\123 328  51 64 
    \\ 45 64  387 23 
    \\  6 98  215 314
    \\*   +   *   +  
;

test "Part One" {
    var output_buffer: [1024]u8 = undefined;
    var output: std.Io.Writer = .fixed(&output_buffer);

    try partOne(std.testing.allocator, &output, sample_input);
    try std.testing.expectEqualStrings("4277556", output.buffered());
}

pub fn partOne(allocator: Allocator, output: *std.Io.Writer, input: []const u8) !void {
    _ = allocator;
    var column: usize = 0;
    evaluate: while (true) : (column += 1) {
        var column_num_buffer: [256]i64 = undefined;

        var lines_iter = std.mem.splitScalar(u8, input, '\n');
        while (lines_iter.next()) |line_content| {
            var columns_iter = std.mem.splitScalar(u8, line_content, ' ');
            const column_content = ret: {
                var column_index: usize = 0;
                while (columns_iter.next()) |column_content| {
                    if (column_content.len > 0) column_index += 1 else continue;
                    if (column_index > column) break :ret column_content;
                }
                break :evaluate;
            };
            if (std.mem.eql(u8, column_content, "*")) {}
            if (std.mem.eql(u8, column_content, "+")) {}
        }
    }

    try output.print("Not Implemented", .{});
}

test "Part Two" {
    var output_buffer: [1024]u8 = undefined;
    var output: std.Io.Writer = .fixed(&output_buffer);

    try partTwo(std.testing.allocator, &output, "");
    // try std.testing.expectEqualStrings("<expected>", output.buffered());
}

pub fn partTwo(allocator: Allocator, output: *std.Io.Writer, input: []const u8) !void {
    _ = allocator;
    _ = input;
    try output.print("Not Implemented", .{});
}

pub fn main(init: std.process.Init) !void {
    const solution: lib.Solution = .{ .part_one = partOne, .part_two = partTwo };
    try lib.solve(init.gpa, init.io, init.minimal.args, solution, @embedFile("input.txt"));
}
