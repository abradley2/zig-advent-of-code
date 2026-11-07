# Zig Advent Of Code

Requires Zig 0.17.0. I recommend using [Anyzig](https://marler8997.github.io/anyzig/)

After cloning this repo, initialize the project with `zig build init`
This will create folders `day-01` to `day-12` and empty input.txt files
```bash
zig build init
```

To build and run a specific day, use its build step and specify `--part=<1 or 2>`.
This also installs that day's executable to `zig-out/bin/day-XX` in the project root.
```bash
# Run day 1, part 1
zig build run-day-01 -- --part=1

# Run day 12, part 2
zig build run-day-12 -- --part=2
```

To build and install all days without running them, use `zig build`. Then execute a day via the binary
```bash
./zig-out/bin/day-01 --part=1
```

There is a command to run tests for each day, by prefixing `test-` to the normal build command
```bash
zig build test-day-01
```

