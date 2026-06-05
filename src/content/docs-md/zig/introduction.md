---
title: Introduction to Zig
description: Some basics for writing code in Zig
---

## The Main Function

Zig functions are private by default. Making a function public can be done using `pub`

A `main` function must be public and looks like this:

```zig
pub fn main() void {
  // do stuff
}
```

## Imports

Imports are done using the `@import` built-in function. The Zig standard library can be imported using the `@import` function as such:

```zig
const std = @import("std");
```

## Variables

Zig uses `const` to define constants and `var` to variables. These declarations can also have types associated with them though these can also be inferred for constants:

```zig
var a: u8 = 50;
const b: u8 = 50;
const c = -11;
```

## Arrays

Arrays have a fixed length which can either be declared or inferred. Declaring an array inline looks like this:

```zig
var data: [3]u32 = [3]u32{ 1, 2, 3 };
```

Inferring the type and the size can be done like so:

```zig
var data = [_]u32{ 1, 2, 3 };
```

Accessing a value from an array can be done using index notation:

```zig
const x = data[1];
data[2] = x;
```

Arrays can be concatenated using `++`:

```zig
const a = [_]u8{ 1, 2 };
const b = [_]u8{ 3, 4 };

const c = a ++ b;
```

> `++` is a `comptime` operator and runs during compilation

Declaring an array without assigning any values can be done using `undefined`:

```zig
var data: [3]u8 = undefined;
```

## Strings

Zig stores strings as an array of bytes. Strings are denoted using double quotes (`"`)

```zig
const str = "hello";
const h = str[0];
```

The `++` operator can also be used to concatenate strings

```zig
const result = "hello" ++ " " ++ "world";
```

Multiline strings can also be defined. These use `\\` at the start of each line with no surrounding quotes:

```zig
const multiline =
  \\First line of string
  \\Second line of string
;
```

## If/Else

If/else statements in Zig work as you'd expect:


```zig
const a = 10;

if (a > 5) {
    std.debug.print("is big\n", .{});
} else {
    std.debug.print("is small\n", .{});
}
```

Zig also has If/else expressions which can be used like so:

```zig
const a = 10;
const price = if (a > 5) "high" else "low";
```

## While Loops

The syntax for a while loop is also pretty normal looking:

```zig
var a = 10;
while (a > 5) {
  a -= 1;
}
```

Loops also have an optional "continue expression" which is run at the end of the loop or whenever a `continue` is invoked:

```zig
var a = 5;
while (a < 10) : (a += 1) {
  std.debug.print("{}\n", .{a})
}
```

Or:

```zig
var a = 5;
while (a < 10) : (a += 1) {
  // this will not print but will run the continue expression
  if (a == 7) continue;
  std.debug.print("{}\n", .{a})
}
```

Zig also has `break` statements that exit the loop immediately, for example:

```zig
var a = 5;
while (a < 10) : (a += 1) {
  // this will exit the loop
  if (a == 7) break;
  std.debug.print("{}\n", .{a})
}
```

## For Loops

For loops iterate over arrays and have the following structure:

```zig
const arr = [_]{ 1, 2, 3 };

for (arr) |item| {
  // do stuff with item
}
```

Additionally, they also support the ability to use a provided indexer:

```zig
const arr = [_]{ 1, 2, 3 };

for (arr, 0..) |item, i| {
  // do stuff with item and index
}
```

### Functions

Functions are defined using the `fn` keyword along with a return type:

```zig
fn doThing() u8 {
  return 10;
}
```

Functions can also take parameters:

```zig
fn times2(n: u8) u16 {
  return n * 2;
}
```

## Errors

Errors are values in Zig. Defining a set of errors can be done like so:

```zig
const MyCustomError = error {
  MyErrorA,
  MyErrorB,
  MyErrorC,
};
```

A function can return an error as a normal value like so:

```zig
fn myError(n: u8) MyCustomError {
  if (n == 0) return MyCustomError.MyErrorA;
  if (n == 1) return MyCustomError.MyErrorB;

  return MyCustomError.MyErrorC;
}
```

And then be handled by comparing the values:

```zig
const result = myError(x);

if (x == MyCustomError.MyErrorA) {
  // do stuff
}
```

Additionally, values can also be a type of an "error union" in which they can represent a value or an error:

```zig
// this can hold an error or a number
const myValue: MyCustomError!u8 = 5;
```

We can define a function that returns an error union like:

```zig
fn doThing(n: u8) MyCustomError!u8 {
  if (n == 0) return MyCustomError.MyErrorA;

  return n;
}
```

And we can use it with a `catch` to provide a fallback value:

```zig
// result will be 0 if doThing returns an error
const result: u8 = doThing(x) catch 0;
```

`catch` also can capture the error and do something with it:

```zig
const result: u8 = doThing(x) catch |err| {
  if (err == MyCustomError.MyErrorA) {
    return 10;
  }

  return 0;
}
```

Zig also has `try`:

```zig
const result = try doThing();
```

Which is basically shorthand for the following:

```zig
const result = doThing() catch |err| return err;
```

> Zig can also infer an error by leaving out the type of error and specifying the `!resultType` but this isn't recommended for any function other than `main` which can return `void` or fail `fn main() !void`

## Defer

The `defer` keyword will run some code after a block exits:

```zig
pub fn main() void {
  // this will get run last
  defer std.debug.print("End of function\n", .{});

  std.debug.print("Start of function\n', .{});
}
```

> Note that if there are multiple defers

There is also `errdefer` which runs if a block exits with an error:

```zig
errdefer cleanup();
const result = try doThing();
```

## Switch

Switch statements must be exhaustive or have an `else` branch. This looks like so:

```zig
pub fn doThing(num: u8) u8 {
    switch (num) {
        1 => return 'a',
        2 => return 'b',
        3 => return 'c',
        4 => return 'd',
        else => return 'x',
    }
}
```

Switches can also be used as an expression, like so:

```zig
pub fn doThing(num: u8) u8 {
    const result = switch (num) {
        1 => 'a',
        2 => 'b',
        3 => 'c',
        4 => 'd',
        else => 'x',
    };

    return result;
}
```

## Unreachable

Zig also has an `unreachable` statement that lets us tell the compiler that a branch should never be executed and that hitting it would be an error:

```zig
// num is only ever 1 or 2
const result = switch (num) {
    1 => 'a',
    2 => 'b',
    else => unreachable,
};
```

## If/Else/Error

When working with errors, it's also possible to use an error-handling version of an if statement that looks like so:

```zig
if (valOrErr) |val| {
  // do things with val
} else |err| {
  // do things with err
}
```

This can also be combined with a switch to handle specific types of errors:

```zig
if (valOrErr) |val| {
  // do things with val
} else |err| switch (err) {
  MyCustomError.MyErrorA => {
    // handle error
  },
  MyCustomError.MyErrorB => {
    // handle error
  },
}
```

## Enums

Enums are values that can be one of a specific list. Defining an enum looks like so:

```zig
const MyEnum = enum {
  valA,
  valB,
  valC,
};
```

Enums are just numbers and so we can assign actual values to them as well:

```zig
const MyEnum = enum {
  valA = 1,
  valB = 3,
  valC = 5,
};
```

> Enums can be converted to integers using `@intFromEnum(x)`

## Structs

The syntax to define a struct looks like so:
```zig
const MyStruct = struct {
  enu: MyEnum,
  val: u8,
};
```

Creating an instance of a struct can be done using the following syntax:

```zig
const thing =  MyStruct {
  .enu = MyEnum.ValA,
  .val = 10,
};
```

Structs properties can also accessed and modified:

```zig
var thing =  MyStruct {
  .enu = MyEnum.ValA,
  .val = 10,
};

thing.val = 20;
```

## Pointers

You can create a pointer to a value can be created with `&` and pointers can be dereferenced with `name.*` The type of a pointer for `type` is `*type`:

```zig
var a: u8 = 1;
const a_ptr: *u8 = &a;

const b: u8 = a_ptr.*;
```

> You can make `const` pointers to `var` values but you cannot make `var` pointers to `const` values

Zig also lets you define constant pointers which can point at constants or variables:

```zig
var a: u8 = 1;
const a_ptr: *const u8 = &a;

const b: u8 = 1;
const b_prt: *const u8 = &b;
```

Pointers let us pass values by reference, for example updating the passed variable:


```zig
fn update(x: *u8, val: u8) void {
 x.* = val;
}
```

Note that if we've got a pointer to a struct we can still access the members directly without having to dereference first: `x.inner` instead of `x.*.inner`

## Optionals

Optional values may have data or `null` and are typed using the `?`:

```zig
var data: ?u8 = 10;
```

Optional values can be defaulted using `orelse`:

```zig
var definitely_data: u8 = data orelse 0;
```

This can also be used to do things like early return or break a loop:

```zig
var definitely_data: u8 = data orelse return false;
// continue using definitely_data
```

It's also possible to define optional values on structs using the `?`:

```zig
const MyStruct = struct {
  required: u8,
  optional: ?u8,
};
```

Another shorthand is using `.?` to mean `orelse unreachable`:

```zig
const x: ?u8 = 5;
const y: u8 = x orelse unreachable;
```

## Methods

Structs can have methods on them. If the first argument is an instance of the struct of a pointer to one then it can be namespaced by the instance instead of being namespaced by the struct

```zig
const MyStruct = struct {
    required: u8,
    optional: ?u8,

    // this can be any name you want, self is fine:
    pub fn bigRequired(self: *MyStruct) u8 {
        return self.required * 2;
    }
};
```


## Non-Values

Zig has different indicators for non-values:

1. `undefined` - not yet a value
2. `null` - explicitly non-value
3. `errors` - no value because there was an error
4. `void` - type stating there will never be a value

## References

- [Ziglings](https://codeberg.org/ziglings/exercises)
- [Introduction to Zig by Pedro Duarte Faria](https://pedropark99.github.io/zig-book/)
- [Exercism's Zig Track](https://exercism.org/tracks/zig)
