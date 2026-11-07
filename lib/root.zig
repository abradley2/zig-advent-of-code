const std = @import("std");
const Args = std.process.Args;
const Io = std.Io;
const Allocator = std.mem.Allocator;

pub const SolutionPart: type = enum {
    one,
    two,
};

pub const SolutionFn: type = fn (Allocator, *std.Io.Writer, []const u8) anyerror!void;

pub const Solution: type = struct {
    part_one: SolutionFn,
    part_two: SolutionFn,
};

pub fn solve(
    allocator: Allocator,
    io: Io,
    args: Args,
    solution: Solution,
    input: []const u8,
) !void {
    var output_buffer: [1_024]u8 = undefined;
    var stdout = std.Io.File.stdout().writer(io, &output_buffer);
    const writer = &stdout.interface;

    if (readSolutionPart(args, writer)) |solution_part|
        switch (solution_part) {
            .one => try solution.part_one(allocator, writer, input),
            .two => try solution.part_two(allocator, writer, input),
        };

    _ = try writer.write("\n");
    try writer.flush();
}

pub fn readSolutionPart(args: Args, writer: *Io.Writer) ?SolutionPart {
    var args_iter = args.iterate();
    while (args_iter.next()) |arg| {
        if (std.mem.cutPrefix(u8, arg, "--part=")) |part| {
            if (std.mem.eql(u8, part, "1")) return .one;
            if (std.mem.eql(u8, part, "2")) return .two;
            writer.print("'--part' must specify '1' or '2' but got: {s}\n", .{part}) catch {};
            return null;
        }
    }
    _ = writer.write("must specify --part=1 or --part=2\n") catch 0;
    return null;
}
