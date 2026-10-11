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

    switch (try readSolutionPart(args)) {
        .one => try solution.part_one(allocator, writer, input),
        .two => try solution.part_two(allocator, writer, input),
    }
    _ = try writer.write("\n");
    try writer.flush();
}

pub fn readSolutionPart(args: Args) error{
    InvalidSolutionPart,
    MissingSolutionPart,
}!SolutionPart {
    var args_iter = args.iterate();
    while (args_iter.next()) |arg| {
        if (std.mem.cutPrefix(u8, arg, "--part=")) |part| {
            if (std.mem.eql(u8, part, "1")) return .one;
            if (std.mem.eql(u8, part, "2")) return .two;
            return error.InvalidSolutionPart;
        }
    }
    return error.MissingSolutionPart;
}
