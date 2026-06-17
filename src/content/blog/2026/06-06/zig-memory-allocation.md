---
title: Zig - Bus error at address and memory management
subtitle: 06 June 2026
description: Challenges with memory management in Zig
published: true
---

> Assumed audience: People learning the Zig programming language

Note that since Zig is in pretty active development this error message differs quite a bit between versions though the general idea should apply. For context though I'm using `zig v0.17.0-dev.690+c5a61e899` which is the latest `master` and is not yet a stable release

## Error

So I've been learning [Zig](https://ziglang.org/) since about yesterday and since then I've started writing a scripting language. During my test runs I kept running into this error:

```
Bus error at address 0x104f6fa5d
       /zig/bin/lib/compiler_rt.zig:663:14: 0x104f3b9c8 in memset (compiler_rt)
       /zig/zig/lib/std/mem/Allocator.zig:450:5: 0x104e46c93 in free__anon_10187 (test)
           @memset(bytes, undefined);
           ^
       /repo/src/root.zig:262:17: 0x104f2ff9b in deinit (test)
               gpa.free(self.content);
                       ^
       /repo/src/root.zig:281:26: 0x104f2dfff in test.Bus error at address repro (test)
           defer expected.deinit(gpa);
                                ^
       /zig/zig/lib/compiler/test_runner.zig:143:68: 0x104f0860b in mainServer (test)
                       const status: TestResults.Status = if (test_fn.func()) |v| s: {
                                                                          ^
       /zig/zig/lib/compiler/test_runner.zig:71:26: 0x104f08c87 in main (test)
               return mainServer(init) catch |err| panic("internal test runner failure: {t}", .{err});
                                ^
       /zig/zig/lib/std/start.zig:740:88: 0x104f06ad7 in callMain (test)
           if (fn_info.param_types[0].? == std.process.Init.Minimal) return wrapMain(root.main(.{
                                                                                              ^
       ???:?:?: 0x195fe5d53 in start (/usr/lib/dyld)
```

## Explanation

The message is quite cryptic: "Bus error at address" and just points to some call to `free` that I've made. I have no idea why that was the issue and assumed the issue was me messing around with my memory management

I reimplemented the solution and tried multiple fixes and couldn't get the bug to go away, so I started reading everything I could understand about Zig memory allocation and some different management strategies

The comment that led me to some insight was from [a question about invalid frees](https://ziggit.dev/t/panic-invalid-free-when-freeing-a-structs-allocated-memory/8280) where a commenter says "Invalid free means that you are trying to free data that was never allocated with that allocator." - really right in front my face. And then I though - hmm, where am I allocating memory that I am using a different allocator for. Well - nowhere.

But then I thought - what if I was trying to free something that I didn't allocate memory for - which led me to a string - which is a compile time constant, and so isn't allocated on the heap.

Turned out that the string I had to verify my implementation in my test code was being freed by implementation's cleanup code. The issue was the test. I know - incredibly silly

The takeaway however is - If you see the error above, make sure you're only freeing memory that you've allocated

## Reproduction

For the sake of completeness and having something more than just a big error dump - here's a reproduction I made:

Here's a small function that creates a struct called `Data` with a `content` property and a `deinit` method for freeing any associated memory.

```zig
const Data = struct {
    content: []const u8,

    fn deinit(self: *Data, gpa: Allocator) void {
				// just frees the content
        gpa.free(self.content);
    }
};

fn createData(gpa: Allocator, input: []const u8) !Data {
    var buf: std.ArrayList(u8) = .empty;

		// iterate through a string and add each character twice to a buffer
		// for funsies
    for (input) |c| {
        try buf.append(gpa, c);
        try buf.append(gpa, c);
    }

		// convert the ArrayList to a Slice.
		// this frees the ArrayList and returns a newly allocated []u8
		// whoever get's content needs to free it
		const content = try buf.toOwnedSlice(gpa);

		// create a data struct with the resulting content
		// this can be freed using the Data.deinit method
    return Data{ .content = content };
}
```

In my test, I had this:

```zig
test "Bus error at address repro" {
    const gpa = std.testing.allocator;

		// create an expected Data instance with content as a constant
    var expected = Data{ .content = "hheelllloo" };
		// this below deinit call is bad and was causing the above error
    defer expected.deinit(gpa); // <- this line should be removed
		// we don't need to free expected.content
		// trying to free this will lead to an error

		// create the actual Data instance
    var actual = try createData(gpa, "hello");
		// free the actual data using the Data.deinit function defined above
    defer actual.deinit(gpa);

    try std.testing.expectEqualDeep(expected, actual);
}
```

Removing the call to my struct's `deinit` method fixed the error

## Solution

In case you skipped to the end to find the answer, as I mentioned above - ensure that you're only freeing memory that you allocated directly - and double check and test structs that you're freeing.
