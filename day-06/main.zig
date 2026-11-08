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

pub fn partOne(_: Allocator, output: *std.Io.Writer, input: []const u8) !void {
    var solution: i64 = 0;
    var column: usize = 0;
    evaluate: while (true) : (column += 1) {
        var column_nums_buffer: [256]i64 = undefined;
        var column_nums: std.ArrayList(i64) = .initBuffer(column_nums_buffer[0..]);

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
            var line_output: i64 = 0;
            if (std.mem.eql(u8, column_content, "*")) {
                line_output = column_nums.items[0];
                for (column_nums.items[1..]) |v| line_output *= v;
                solution += line_output;
                continue :evaluate;
            }
            if (std.mem.eql(u8, column_content, "+")) {
                line_output = column_nums.items[0];
                for (column_nums.items[1..]) |v| line_output += v;
                solution += line_output;
                continue :evaluate;
            }
            const column_num: *i64 = try column_nums.addOneBounded();
            column_num.* = try std.fmt.parseInt(i64, column_content, 10);
        }
    }

    try output.print("{d}", .{solution});
}

test "Part Two" {
    var output_buffer: [1024]u8 = undefined;
    var output: std.Io.Writer = .fixed(&output_buffer);

    try partTwo(std.testing.allocator, &output, sample_input);
    try std.testing.expectEqualStrings("3263827", output.buffered());
}

const EvalType: type = enum(u2) {
    sum,
    prod,
};

pub fn partTwo(_: Allocator, output_writer: *std.Io.Writer, input: []const u8) !void {
    var output: i64 = 0;
    var current_column = std.mem.findScalar(u8, input, '\n').? - 1;

    var calc_inputs_buffer: [256]i64 = undefined;
    var calc_inputs: std.ArrayList(i64) = .initBuffer(calc_inputs_buffer[0..]);

    evaluate_column: while (true) : (current_column -= 1) {
        var column_content_buffer: [128]u8 = undefined;
        var column_content: std.ArrayList(u8) = .initBuffer(column_content_buffer[0..]);

        var eval_type: ?EvalType = null;
        var lines_iter = std.mem.splitScalar(u8, input, '\n');
        line_iter: while (lines_iter.next()) |line_content| {
            if (line_content.len == 0) continue;
            const column_content_char = line_content[@intCast(current_column)];

            if (column_content_char == ' ') continue :line_iter;

            if (column_content_char == '*') {
                eval_type = .prod;
                continue :line_iter;
            }

            if (column_content_char == '+') {
                eval_type = .sum;
                continue :line_iter;
            }

            try column_content.appendBounded(column_content_char);
        }

        if (column_content.items.len == 0) {
            continue :evaluate_column;
        }

        const calc_input = try calc_inputs.addOneBounded();
        calc_input.* = try std.fmt.parseInt(i64, column_content.items, 10);

        if (eval_type) |prod_or_sum| {
            eval_type = null;
            var column_output = calc_inputs.items[0];
            switch (prod_or_sum) {
                .prod => {
                    for (calc_inputs.items[1..]) |next_input| column_output *= next_input;
                },
                .sum => {
                    for (calc_inputs.items[1..]) |next_input| column_output += next_input;
                },
            }
            output += column_output;
            calc_inputs = .initBuffer(calc_inputs_buffer[0..]);
        }

        if (current_column == 0) {
            break :evaluate_column;
        }
    }

    try output_writer.print("{d}", .{output});
}

pub fn main(init: std.process.Init) !void {
    const solution: lib.Solution = .{ .part_one = partOne, .part_two = partTwo };
    try lib.solve(init.gpa, init.io, init.minimal.args, solution, @embedFile("input.txt"));
}
