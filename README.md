# Zig Advent Of Code

After cloning this repo, initialize the project with `zig build init`
This will create folders day_01 to day_12 and empty input.txt files
```bash
zig build init
```

To run a specific day, run the `zig build` for that day's folder, and specify `--part=<1 or 2>`
```bash
# Run day 1, part 1
zig build day-01 -- --part=1

# Run day 12, part 2
zig build day-12 -- --part=2
```

There is a command to run tests for each day, by prefixing `test-` to the normal build command
```bash
zig build test-day-01
```

