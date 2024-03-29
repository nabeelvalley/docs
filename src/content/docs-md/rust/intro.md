---
published: true
title: Introduction
subtitle: 25 November 2021
description: Introduction to the Rust Programming Language
---

> These notes are based on working through [The Rust Programming Language Book](https://doc.rust-lang.org/book/title-page.html). It can also be accessed using `rustup docs --book`

# Getting Started

## Hello World

To create a hello-world program simply create a new folder with a file called `main.rs` which defines a `main` function with the following:

`main.rs`

```rs
fn main() {
    println!("hello world!");
}
```

You can then compile your code with:

```sh
rustc main.rs
```

Thereafter, run it with:

```sh
./main
```

A few things to note on the `main.rs` file above:

1. The `main` function is the entrypoint to the application
2. `println!` is a macro (which apparently we will learn about in chapter 19)
3. semicolons `;` are required at the end of each statement

## Cargo

Cargo is Rust's built-in package manager, to create a new project with Cargo use:

```sh
cargo new rust_intro
```

This should create a rust project in a `rust_intro` directory with the following structure:

```
│   .gitignore
│   Cargo.toml   // cargo config file
│
└───src
        main.rs  // program entrypoint
```

The `Cargo.toml` file looks something like this:

`Cargo.toml`

```toml
[package]
name = "rust_intro"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

You can now use cargo to build and run the application:

1. `cargo build` builds the application
2. `cargo run` builds and runs the application
3. `cargo check` checks that code compiles but does not create an output
4. `cargo fmt` formats source files
5. `cargo build --release` builds a release version of the application
6. `cargo doc --open` opens cargo docs for all crates in the current project

# A Basic Program

## Basic Program

Let's define a basic program below which takes an input from stdin, stores it in a variable, and prints it out to the stdout

`src/main.rs`

```rs
use std::io;

fn main() {
    println!("guess the number!");

    println!("please enter a number");

    let mut guess = String::new();

    io::stdin()
        .read_line(&mut guess)
        .expect("failed to read string");

    println!("your guess was: {}", guess);
}
```

In the above, we can see the import statement that imports `std::io`:

```rs
use std::io
```

Next, the `String::new()` creates a new `String` value that's assigned to a `mutable` variable named `guess`. We can either define mutable or immutable variables like so:

```rs
let a = 5;      // immutable
let mut b = 10; // mutable
```

`stdin().read_line` is a function that takes the input from stdin and appends it to the reference given to it. Like variables, references can also be mutable or immutable, when using a reference we can do either of the following:

```rs
&guess     // immutable
&mut guess // mutable
```

The `read_line` function returns an `io::Result`, in Rust, `Result` types are enumerations which are either `Ok` or `Err`. The `Result` type has an `expect` method defined which takes in the error message that will be thrown if there is an `Err`, otherwise it will return the `Ok` value

Leaving out the `expect` will result in a compiler warning but the program will still be able to run and compile

## Adding a Dependency

To add a dependency we need to add a new line to the `Cargo.toml` file with the dependency name and version. We'll need to add the `rand` dependency to generate a random number

`Cargo.toml`

```toml
[dependencies]
rand = "0.8.3"
```

Then, run `cargo build` to update dependencies and build the application. Next, you can use `cargo update`

## Generating a Random Number

To generate a random number we'll import `rand::Rng` and use it as follows:

```rs
let secret_number = rand::thread_rng().gen_range(1..101);
```

Even though we're not using the `Rng` import directly, it's required in scope for the other functions we are using. `Rng` is called a trait and this defines what methods/functions we can call from a crate

## Parsing Input to a Number

To parse the input to a number we can use the `parse` on strings like so:

```rs
let guess: u32 = guess.trim().parse().expect("please enter a number!");
```

Note that we're able to use the same `guess` variable as before, this is because rust allows us to shadow a previous variable declaration, this is useful when doing things like converting data types. So the code now looks like this:

```rs
let mut guess = String::new();

io::stdin()
    .read_line(&mut guess)
    .expect("failed to read string");

let guess: u32 = guess.trim().parse().expect("please enter a number!");
```

## Matching

The `match` expression is used for flow-control/pattern matching and allows us to do something or return a specific value based on the branch that the code matches.

We can use the `Ordering` enum for comparing the value of two numbers:

```rs
let result = guess.cmp(&secret_number);

match result {
    Ordering::Less => println!("guess is less than secret"),
    Ordering::Greater => println!("guess is greater than secret"),
    Ordering::Equal => println!("correct!"),
}
```

## Looping

To loop, we can use the `loop` flow-control structure:

```rs
loop {
    // do stuff
}
```

Lastly, we can break out of the loop using `break` or move to the next iteration with `continue`

Using the above two statements, we can update the `guess` definition using `match` and `continue`

```rs
let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue,
};
```

And when we compare the guess:

```rs
match result {
    Ordering::Less => println!("guess is less than secret"),
    Ordering::Greater => println!("guess is greater than secret"),
    Ordering::Equal => {
        println!("correct!");
        break;
    }
}
```

## Final Product

Combining all the stuff mentioned above, the final code should look something like this:

`main.rs`

```rs
use rand::Rng;
use std::cmp::Ordering;
use std::io;

fn main() {
    println!("guess the number!");

    let secret_number = rand::thread_rng().gen_range(1..101);

    println!("the secret number is: {}", secret_number);

    loop {
        println!("please enter a number");

        let mut guess = String::new();

        io::stdin()
            .read_line(&mut guess)
            .expect("failed to read string");

        println!("your guess was: {}", guess);

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        let result = guess.cmp(&secret_number);

        match result {
            Ordering::Less => println!("guess is less than secret"),
            Ordering::Greater => println!("guess is greater than secret"),
            Ordering::Equal => {
                println!("correct!");
                break;
            }
        }
    }

    println!("CONGRATULATIONS!!");
}
```

# Core Concepts

## Variables and Mutability

### Variables

By default variables are immutable, but the `mut` keyword lets us create a mutable variable as discussed above:

```rs
let a = 5;     // immutable

let mut b = 6; // mutable
b = 7;
```

### Constants

Rust also makes use of the concept of a constant which will always be the same for the lifetime of a program within their defined scope, and can be defined at any scope (including the global scope). By convention these are also capitalized:

```rs
const MAX_TIME_SECONDS = 5 * 60;
```

Constants can make use of a few simple operations when defining them but can't be anything that would need to be evaluated at runtime for example. This is a key distinction between a constant and an immutable variable

### Shadowing

Shadowing allows us to redeclare a variable with a specific scope and will shadow the previous declaration after it's new definition

```rs
let x = 5;         // x is 6

let x = x * 2;     // x is 10

{
    let x = x + 1; // x is 11
}

// x is 10
```

Shadowing is different to a mutable variable and is pretty much just a way for us to re-declare a variable and reuse an existing name within a scope. This is useful for cases where we're transforming a value in some way. Shadowing also allows us to change the type of a variable which is something that we can't do with a mutable variable

For example, the below will work with shadowing but not mutability:

```rs
let spaces = "    ";
let spaces = spaces.len();
```

## Data Types

Rust is a statically typed language. In most cases we don't need to explicitly define the type of a variable, however in cases where the compiler can't infer the type we do need to specify it, e.g. when parsing a string to a number:

```rs
let num: u32 = "52".parse().expect("Not a valid unsigned int");
```

We need to specify that the result of the parsing should be a `u32`, or if we want to use `i32`:

```rs
let num: i32 = "-23".parse().expect("Not a valid int");
```

### Scalar Types

Rust has 4 scalar types, namely;

- Integers
- Floating-point numbers
- Booleans
- Characters

#### Integers

An integer is a number without a fraction component. The available integer types are:

| length  | signed  | unsigned |
| ------- | ------- | -------- |
| 8 bit   | `i8`    | `u8`     |
| 16 bit  | `i16`   | `u16`    |
| 32 bit  | `i32`   | `u32`    |
| 64 bit  | `i64`   | `u64`    |
| 128 bit | `i128`  | `u128`   |
| arch    | `isize` | `usize`  |

The arch size uses 32 or 64 bits depending on if the system is a 32 or 64 bit one respectively

Additionally, number literals can use a type suffix as well as an `_` for separation, for example the below are all equal:

```rs
let a: u16 = 5000;
let a = 5000u16;

// using _ separator
let a: u16 = 5_000;
let a = 5_000u16;
```

#### Floats

Rust has two types of floats, `f32` for single-precision and `f64` for double-precision values. The default is `f64` which is about the same speed as `f32` on modern CPUs but with added precision

#### Operations

The following operations are supported for integer and float operations:

```rs
// addition
let sum = 5 + 10;

// subtraction
let difference = 95.5 - 4.3;

// multiplication
let product = 4 * 30;

// division
let quotient = 56.7 / 32.2;
let floored = 2 / 3; // Results in 0

// remainder
let remainder = 43 % 5;
```

#### Booleans

Booleans are defined in rust as either `true` or `false` using the `bool` type:

```rs
let t = true;
let f: bool = false;
```

#### Characters

Character types are defined using `char` values specified with single quotes `'` and store a Unicode scalar value which supports a bit more than ASCII

```rs
let c: char = 'z';
let z = 'Z';
let u = '😄';
```

### Compound Types

Compound types are used to group multiple values into a single type, Rust has two compound types:

- Tuple
- Array

#### Tuples

Tuples are groups of values. They have a fixed length once declared. Tuples can be defined as with or without an explicit type, for example:

```rs
let t1 = (500, 'H', 1.3);
let t2: (i32, char, f64) = (500, 'H', 1.3);
```

Tuples can also be destructured as you'd expect:

```rs
let tup = (1, 2, 'A');

let (o, t, a) = tup;
```

We can also access a specific index of a tuple using a `.` followed by the index:

```rs
let tup = (1, 2, 'A');

let o = tup.0;
let t = tup.1;
let a = tup.2;
```

#### Arrays

Arrays can hold a collection of the same type of value.

Arrays are also fixed-length once defined but other than that they're pretty much the same as in most other languages. When defining the type of an array we us the syntax of `[type; size]` though this can also usually be inferred

An example of defining an array can be seen below:

```rs
let a: [i32; 3] = [1,2,3];
let b = [1,2,3];
```

You can also create an array with the same value repeated using the following notation

```rs
let a = [3; 5];
let b = [3, 3, 3, 3, 3];
```

Accessing elements of an array can be done using `[]` notation:

```rs
let o = a[0];
let t = a[1];
let r = a[2];
```

Note that when accessing an array's elements outside of the valid range you will also get an `index our of bounds` error during runtime

## Functions

### Defining a Function

Functions are defined using the `fn` keyword along with `()` and `{}` for it's arguments and body respectively

```rs
fn my_function() {
    println!("do stuff");
}
```

And can be called as you would in other languages:

```rs
my_function();
```

### Parameters

Function parameters are defined using a name and type, like so:

```rs
fn print_sum(a: i32, b: i32) {
    let result = a + b;
    println!("sum: {}", result);
}
```

### Statements and Expressions

Functions may have multiple statements and can have an optional ending expression. Statements do not return values whereas expressions do

An example of an expression which can have a value is this scoped block:

```rs
let x = {
    let y = 5;
    y + 5  // <- note the lack of a ; here
};
```

In the above case, `x` will have the value of the last expression in the block, in this case `10`. As we've also seen above, expressions don't contain a `;`. Adding a `;` to an expression turns it into a statement

### Function Return Values

As we've discussed in the case of a block above, a block can evaluate to the ending expression of that block. So in the case of a function, we can return a value from a function by having it be the ending expression, however we must also state the return value of the function or it will not compile

A simple function that adds two numbers can be seen below:

```rs
fn add_nums(a: i32, b: i32) -> i32 {
    a + b
}
```

## Comments

Comments make use of `//` and is required at the start of each line a comment is on:

```rs
let a = 5; // comment after statement

// this is a
// multiline
// comment
```

## Control Flow

### If / Else

`if` statements will branch based on a `bool` expression. They can optionally contain multiple `else if` branches, and an `else` branch:

We can have only an `if` statement:

```rs
let number = 3;

if number > 5 {
    println!("greater than 5");
}
```

Or an `if` and `else`:

```rs
let number = 3;

if number > 5 {
    println!("greater than 5");
} else {
    println!("something else");
}
```

Or even multiple `else if` statements with an optional `else` branch

```rs
let number = 3;

if number > 5 {
    println!("greater than 5");
} else if number < 0 {
    println!("negative");
} else if number < 10 {
    println!("less than 10");
} else {
    println!("something else");
}
```

### Loops

#### `loop`

We can use the `loop` keyword to define a loop that we can escape by using the `break` keyword:

```rs
let mut count = 0;

loop {
    count = count + 1;

    println!("{}", count);

    if count > 5 {
        break;
    }
}
```

We can use the `continue` keyword as well to early-end an iteration like so:

```rs
let mut count = 0;

loop {
    count = count + 1;

    if count == 2 {
        continue;
    }

    println!("{}", count);

    if count > 5 {
        break;
    }
}
```

It's also possible to have loops inside of other looks. We can label a look as well and we can break out of any level of a look by using it's label:

```rs
let mut count_out = 0;

'outer: loop {
    count_out = count_out + 1;
    let mut count_in = 0;

    loop {
        count_in = count_in + 1;

        println!("{} {}", count_out, count_in);

        if count_in > 2 {
            break 'outer;
        }
    }
}
```

The above will log out:

```
1 1
1 2
1 3
```

Since we're breaking the `'outer` loop from inside of the inner loop

Loops can also break and return a value like so:

```rs
let mut count = 0;

let last = loop {
    count = count + 1;

    println!("{}", count);

    if count > 2 {
        break count;
    }
};
```

In the above we are able to set `last` to the value of the `count` when the loop breaks

#### `while`

We also have a `while` loop which will continue for as long as a specific condition is true

```rs
let mut count = 0;

while count < 3 {
    count = count + 1;

    println!("{}", count);
}
```

#### `for`

A `for` loop allows us to iterate through the elements in a collection, we can do this as:

```rs
let a = [1, 2, 3, 4, 5];

for element in a {
    println!("{}", element)
}
```

Additionally, it's also possible to use a `for` loop with a range instead of an array:

```rs
for element in 1..6 {
    println!("{}", element)
}
```

# Ownership

Ownership is a concept of Rust that enables it to be memory safe without the need for a garbage collector

Ownership is implemented as a set of rules that are checked during compile time and does not slow down the program while it runs

## Stack and Heap

Data stored on the stack must have a known, fixed size, data that has an unknown or changing size must be stored on the heap. The heap is less organized. Adding values to the heap is called `allocating`. When storing data on the heap we also store a reference to its address on the stack. We call this a `pointer`. When storing data to a stack we make use of `pushing`

Pushing to the stack is faster than allocating to the heap, and likewise for accessing data from the stack compared to the heap

When code calls a function, the values passed to the function as well as its variables are stored on the stack or heap. When the function is completed the values are popped off the stack

Ownership keeps track of what data is on the heap, reduces duplication, and cleans up unused data

## Ownership Rules

- Each value in Rust has a variable that's called its _owner_
- There can only be one owner at a time
- When an owner goes out of scope the value is dropped

## Variable Scope

We can see the scope of a variable `s` in a given block below:

```rs
// ❌ not in scope
{
    // ❌ not in scope
    let s = "hello"; // ✔️ in scope from this point onwards
    // ✔️ in scope
}
// ❌ not in scope
```

## The String Type

The types covered earlier are all fixed-size, but strings may have different, possibly unknown sizes

A general string is different to a string literal in that string literals are immutable. ASide from the string literal type Rust also has a `String` type

We can use the `String` type to construct a string from a literal like so:

```rs
let s = String::from("hello");
```

The type of `s` is now a `String` compared to a literal which is `&str`

As mentioned, `String`s can be mutable, which means we can add to it like so:

```rs
let mut s = String::from("hello");

s.push_str(" world");
```

## Memory and Allocation

In the case of a string literal the text contents ae known at compile time and is hardcoded into the executable. The `String` type can be mutable, which means that:

- Memory must be requested from the allocator during runtime
- Memory must be returned to the allocator when done being used

Rust does this by automatically returning memory once the variable that owns it is no longer in scope by calling a `drop` function

### Moving a Variable

When assigning and passing values around, we have two cases in Rust, for values which live on the stack:

```rs
let x = 5;
let y = x;
```

An assignment like the above creates 2 values of 5 and binds them to the variables `x` and `y`. This is done by creating a copy of `x` on the stack

However, when doing this with a value on the heap, both variables will reference the same value in memory:

```rs
let x = String::from("hello");
let y = x;
```

As far as memory returning goes, there is a potential problem in the above code, which is that if `x` goes out of scope and is dropped, the value for `y` would also be dropped - Rust gets around this by invalidating a the previous version of the value can't be used anymore. Which means doing the below will give us an error:

```rs
let x = String::from("hello");
let y = x;
println!("{}", x);
```

And this is the error:

```raw
borrow of moved value: `x`

value borrowed here after moverustc(E0382)
main.rs(2, 9): move occurs because `x` has type `std::string::String`, which does not implement the `Copy` trait
```

### Cloning a Variable

If we do want to create an actual deep copy of data from the heap, we can use the `clone` method. So on the `String` type this would look like:

```rs
let x = String::from("hello");
let y = x.clone();
```

Using this, both `x` and `y` will be dropped independent of one another

## Ownership and Functions

When passing a variable to a function the new function will take ownership of a variable, and unless we return ownership back to the caller the value will be dropped:

```rs
fn main() {
    let x = String::from("hello");
    take_ownership(x);

    println!("{}", x); // error
}

fn take_ownership(data: String) {
    println!("{}", data);
}
```

If we want to return ownership back to the caller's scope, we need to return it from the function like so:

```rs
fn main() {
    let x = String::from("hello");
    let x = return_ownership(x);

    println!("{}", x);
}

fn return_ownership(data: String) -> String {
    println!("{}", data);

    data
}
```

## References and Borrowing

The issue with ownership handling as discussed above is that it's often the case that we would want to use the variable that was passed to a function and that the caller may want to retain ownership of it

Because of this, Rust has a concept of _borrowing_ which is when we pass a variable by reference while allowing the original owner of a variable to remain the owner

We can pass a value by reference using `&` when defining and calling the function like so:

```rs
fn main() {
    let x = String::from("hello");
    borrows(&x);

    println!("{}", x);
}

fn borrows(data: &String) {
    println!("{}", data);
}
```

### Mutable References

By default, references are immutable and the callee can't modify it's value. If we want to make a reference mutable we make use of `&mut`

```rs
fn main() {
    let mut x = String::from("hello");
    modifies(&mut x);

    println!("{}", x); // hello world
}

fn modifies(data: &mut String) {
    println!("{}", data); // hello

    data.push_str(" world")
}
```

An important limitation to note is that the only one mutable reference to a variable can exist at a time, which means that the following will not compile:

```rs
let mut x = String::from("hello");
let x1 = &mut x;
let x2 = &mut x;

println!("{} {}", x1, x2);
```

The error we see is:

```
cannot borrow `x` as mutable more than once at a time

second mutable borrow occurs hererustc(E0499)
```

The restriction above ensures that mutation of a variable is controlled and helps prevent bugs like race conditions

Race conditions occur when the following behaviors occur:

- Two or more pointers access the same data at the same time
- At least one of the pointers is being used to write to the data
- There's no mechanism to synchronize access to the data

### Dangling References

In other languages with pointers it's possible to create a pointer that references a location in memory that may have been cleared. With Rust the compiler ensures that there are no dangling references. For example, the below function will not compile:

```rs
fn main() {
    let reference_to_nothing = dangle();
}

fn dangle() -> &String {
    let s = String::from("hello");

    &s
}
```

With the following error:

```
missing lifetime specifier

expected named lifetime parameter

...

= help: this function's return type contains a borrowed value, but there is no value for it to be borrowed from
```

What's happpening in the above code can be seen below:

```rs
fn main() {
    let reference_to_nothing = dangle();
}

fn dangle() -> &String { // dangle returns a reference to a String
    let s = String::from("hello"); // s is a new String

    &s // we return a reference to the String, s
} // Here, s goes out of scope, and is dropped. Its memory goes away.
  // Danger!
```

Since in the above code, `s` is created inside of the function it will go out of scope when the function is completed. This leads to the value for `s` being dropped which means that the result will be a reference to a value that is no longer valid

In order to avoid this, we need to return `s` so that we can pass ownership back to the caller

```rs
fn main() {
    let result = dangle();
}

fn dangle() -> String {
    let s = String::from("hello");

    s
}
```

Though the code is now valid, we stil get a warning because `result` is not used, however this will not prevent compilation and the above code will still run

### Rules of References

The following are the basic rules for working with references

- You can either have onme mutatble reference or any number of immuatable references to a variable simultaneously
- References must always be valid

## The Slice Type

The slice type is a reference to a sequence of elements in a collection instead of the collection itself. Since a slice is a kind of reference in itself it doesn't have ownership of the original collection

To understand the usecase for a slice type, take the following example of a function that needs to get the first word in a string

Since we don't want to create a copy of the string, we can maybe try something that lets us get the index of the space in the string

```rs
fn first_word(s: &String) -> usize {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    }

    return s.len()
}
```

Next, say we want to use the above function in our code:

```rs
fn main() {
    let mut s = String::from("Hello World");
    let result = first_word(&s);

    s.clear(); // clear the string

    // result is still defined but the value can't be used to access the string
    println!("the first word is: {}", result)
}
```

However, we may run into a problem where the position no longer can be used to index the input string

In order to mitigate this, we can make use of a Slice that references a part of this string

The syntax for slicing is to use a range within the brackets of a collection. So for a string:

```rs
let s = String::from("Hello World");

let hello = &s[0..5];
let world = &s[6..11];
```

In the above, since the `0` is the start and `11` is the end of the string, we can also leave these out of the range to automatically get the start and end parts of the collection

```rs
let hello = &s[..5];
let world = &s[6..];
```

The `hello` and `world` variables not contain a reference to the specific parts of the `String` without creating a new value

We can also use the following to refer to the full string:

```rs
let ref_s = &[..]
```

The type of `hello` can also be seen to be `&str` which is an immutable reference to a string

Using this, we can redefine the `first_word` function like this:

```rs
fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}
```

Using the function now will give us an error:

```
error[E0502]: cannot borrow `s` as mutable because it is also borrowed as immutable
 --> src\main.rs:5:5
  |
3 |     let result = first_word(&s);
  |                             -- immutable borrow occurs here
4 |
5 |     s.clear(); // clear the string
  |     ^^^^^^^^^ mutable borrow occurs here
...
8 |     println!("the first word is: {}", result)
  |                                       ------ immutable borrow later used here

For more information about this error, try `rustc --explain E0502`.
```

Something else to note is that string literals are stored as slices. If we try to use a string literal with our function like so:

```rs
fn main() {
    let s = "Hello World";
    let result = first_word(&s);

    println!("the first word is: {}", result)
}
```

We will get a `mismatched types` error:

```
error[E0308]: mismatched types
 --> src\main.rs:3:29
  |
3 |     let result = first_word(&s);
  |                             ^^ expected struct `String`, found `&str`
  |
  = note: expected reference `&String`
             found reference `&&str`
```

This is because our function requires `&String`, we can change our function instead to use `&str` which will work on string references as well as slices:

```rs
fn first_word(s: &str) -> &str { // take a slice
```

The above will work with refernecs to `String` and `str`

### Other Slice Types

Slices apply to general collections, so we can use it with an array like so:

```rs
let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];
// slice is type &[i32]
```

Slices can also be used by giving them a start element and a length, like so:

```rs
let slice = &a[2, 3];
```

## Summary

Ownership, borrowing, and slices help us ensure memory safety and control as we have seen above

# Structs

A struct is a data type used for packaging and naming related values.

Structs are similar to tuples in that they can hold multiple pieces of data

## Defining a Struct

We can define structs using the `struct` keyword:

```rs
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}
```

We can create a struct be defining a concrete instance like so:

```rs
fn main() {
    let user = User {
        active: true,
        username: String::from("bob"),
        email: String::from("bob@email.com"),
        sign_in_count: 1,
    };
}
```

Struct instances can also be mutable which will allow us to modify properties:

```rs
fn main() {
    let mut user = User {
        active: true,
        username: String::from("bob"),
        email: String::from("bob@email.com"),
        sign_in_count: 1,
    };

    user.email = String::from("bobnew@email.com");
}
```

We can also return structs from functions, as well as using the shorthand struct syntax:

```rs
fn create_user(email: String, username: String) -> User {
    User {
        username,
        email,
        active: true,
        sign_in_count: 1,
    }
}
```

We can also use the struct update syntax to create a new struct based on an existing one:

```rs
let user = create_user(email, username);

let inactive_user = User {
    active: false,
    sign_in_count: 2,
    ..user
}; // we can't refer to user anymore
```

It should also be noted that when creating a struct like this, we can no longer refer to values in the original `user` as this will give us an error:

```rs
let a = user.email; // moved error
```

This is because the value has been moved to the new struct

### Tuple Structs

Tuple structs can be defined using the following syntax:

```rs
struct Point(i32, i32, i32);
```

And can then be used like:

```rs
let origin = Point(0, 0, 0);
```

### Unit Type Structs

You can also define a struct that has no data (is unit) by using this syntax:

```rs
struct NothingReally;

fn main() {
    let not_much = NothingReally;
}
```

Unit structs are useful when we want to define a type that implements a trait or some other type but doesn't have any data on the type itself

### Printing Structs

In order to make a struct printable we can use a `Debug` attribute with a debugging print specifier of `{:?}` like this:

```rs
#[derive(Debug)]
struct Rectangle {
    length: u32,
    height: u32,
}

fn main() {
    let rect = Rectangle {
        height: 20,
        length: 10,
    };

    println!("This is a rectangle: {:?}", rect);
}
```

Also, instead of the `println!` macro, we can use `dbg!` like so:

```rs
dbg!(&rect);
```

The `dbg!` macro will also return ownership of the input, which means that we can use it while instantiating a `Rectangle` as well as when trying to view the entire data:`

```rs
fn main() {
    let rect = Rectangle {
        height: dbg!(2 * 10),
        length: 10,
    };

    dbg!(&rect);
}
```

And the output:

```rs
[src\main.rs:9] 2 * 10 = 20
[src\main.rs:13] &rect = Rectangle {
    length: 10,
    height: 20,
}
```

We can see that the value assigned to `height` is logged as well as assigned to the `rect` struct

## Method Syntax

Methods aan be added to structs using the `impl` block. Everything in this block is a part of the `Rectangle` struct

The first value passed to a struct method is always a reference to the struct itself. We can add an `area` method to the `Rectangle` struct like so:

```rs
impl Rectangle {
    fn area(&self) -> u32 {
        self.length * self.width
    }
}
```

And we can then use this method on our `rect` like so:

```rs
let a = rect.area();
```

Note that in the `area` function, `&self` is shorthand for `self: &Self` which is a reference to the current instance

We can also define methods that have the same name as a struct field, these methods can then return something different if called vs when accessed

```rs
impl Rectangle {
    fn width(&self) -> bool {
        self.width > 0
    }
}

fn main() {
    let rect = Rectangle {
        width: 20,
        length: 10,
    };

    if rect.width() { // call the width function
        println!("Rect has a width of {}", rect.width) // access width value
    }
}
```

### Multiple Parameters

We can give methods multiple parameters by defining them after `self`

```rs
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.length
    }

    fn add(&self, other: &Rectangle) -> u32 {
        self.area() + other.area()
    }
}

fn main() {
    let rect1 = Rectangle {
        width: 20,
        length: 10,
    };

    let rect2 = Rectangle {
        width: 20,
        length: 20,
    };

    let total_area = rect1.add(&rect2);
}
```

### Associated Functions

Functions defined in an `impl` block are called associated functions because they're associated with the type named in the `impl` block

We can also define associated functions that don't have `self` as their first param (and are therefore not methods) like so:

```rs
impl Rectangle {
    fn create(size: u32) -> Rectangle {
        Rectangle {
            length: size,
            width: size,
        }
    }
}
```

We can use these functions with the `::` syntax:

```rs
fn main() {
    let rect = Rectangle::create(20);
}
```

The above syntax tells us that the function is namespaced by the struct. This syntax is used for associated functions as well as namespaces created by modules

### Multiple Impl Blocks

Note that it is also allowed for us to have multiple `impl` blocks for a struct, though not necessary in the cases we've done here

# Enums and Pattern Matching

Enums in Rust are most like algebraic data types in functional languages like F#

## Defining an Enum

Enums can be defined using the `enum` keyword:

```rs
enum Person {
    Employee,
    Customer,
}
```

We can also associate a value with an enum like so:

```rs
enum Person {
    Employee(String),
    Customer(String),
}

fn main() {
    let bob = Person::Customer(String::from("bob"));
    let charlie = Person::Employee(String::from("charlie"));
}
```

We can further make it such that each of the enum values are of a different type

```rs
struct CustomerData {
    name: String,
}

struct EmployeeData {
    name: String,
    employee_number: u32,
}

enum Person {
    Employee(EmployeeData),
    Customer(CustomerData),
}

fn main() {
    let bob = Person::Customer(CustomerData {
        name: String::from("Bob"),
    });

    let charlie = Person::Employee(EmployeeData {
        employee_number: 1,
        name: String::from("Charlie"),
    });
}
```

Enums can also be defined with their data inline:

```rs
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
```

The `impl` keyword can also be used to define methods on enums like with structs:

```rs
impl Message {
    fn call(&self) {
        // do stuff
    }
}
```

### The Option Enum

The Option Enum defined in the standard library and is defined like so:

```rs
enum Option<T> {
    None,
    Some(T),
}
```

The `Option` enum is also included by default and can be used without specifying the namespace

Option types help us avoid null values and ensure that we correctly handle for when we do or don't have data

In general, in order to handle an `Option` value we need to ensure that we handle the `None` and `Some` values

## The Match Control Flow Construct

The `match` construct allows us to compare a value against a set of patterns and then execute based on that, it's used like this:

```rs
enum Answer {
    Yes,
    No,
}

fn is_yes(answer: Answer) -> bool {
    match answer {
        Answer::Yes => true,
        Answer::No => false,
    }
}
```

We can also have a more complex body for the match body:

```rs
fn is_yes(answer: Answer) -> bool {
    match answer {
        Answer::Yes => true,
        Answer::No => {
            println!("Oh No");
            false
        }
    }
}
```

We can also use patterns to handle the data from a match, for example:

```rs
enum Answer {
    Yes,
    No,
    Maybe(String),
}

fn is_yes(answer: Answer) -> bool {
    match answer {
        Answer::Yes => true,
        Answer::No => {
            println!("Oh No");
            false
        }
        Answer::Maybe(comment) => {
            println!("Comment: {}", comment);
            false
        }
    }
}
```

The `match` can also use an `_` to handle all other cases:

```rs
fn is_yes(answer: Answer) -> bool {
    match answer {
        Answer::Yes => true,
        _ => {
            println!("Oh No");
            false
        }
    }
}
```

Or, can also capture the value like this:

```rs
match answer {
    Answer::Yes => true,
    answer => {
        println!("Oh No");
        false
    }
}
```

If we would like to do nothing, we can also return unit:`

```rs
fn nothing(answer: Answer) -> () {
    match answer {
        Answer::Yes => {
            println!("Yes!");
        }
        _ => (),
    }
}
```

## If-Let Control Flow

In Rust, something that's commonly done is to do something based on a single pattern match, the previous example can be done like this using `if let` which is a little cleaner

```rs
fn nothing(answer: Answer) -> () {
    if let Answer::Yes = answer {
        println!("Yes!")
    }
}
```

We can also use `if let` with an else, for example in the below snippet we return a boolean value:

```rs
fn is_yes(answer: Answer) -> bool {
    if let Answer::Yes = answer {
        true
    } else {
        false
    }
}
```

# Packages, Crates, and Modules

As programs grow, there becomes a need to organize and separate code to make it easier to manage

- Packages: A cargo feature for building, testing, and sharing crates
- Crates: A tree of modules that produces a library or executable
- Modules and Use: Let you control organization, scope, and privacy
- Paths: A way of naming an item such as a struct, function, or module

## Packages and Crates

A package is one or more crate that provide a set of functionality. A package contains a `Cargo.toml` file that describes ho to build a crate

Crates can either be a binary or library. Binary crates must have a `main` which will run the binary

Libraries don't have a `main` and can't be executed

Cargo follows a convention that `src/main.rs` is a binary crate with the name of the package, and `src/lib.rs` is the library crate root

A package can have additional binary crates by placing them in the `src/bin` directory. Each file in here will be a separate binary crate

## Defining Modules to Control Scope and Privacy

- Starts from the crate root, either `src/main.rs` or `src/lib.rs`
- Modules are declared in the root file using the `mod` keyword. The compiler will look for the module in the following locations. For example, a module called `garden`
  - If using `mod garden` followed by curly brackets: inline directly following the declaration
  - If using `mod garden;` then in the file `src/garden.rs` or `src/garden/mod.rs`
- Submodules can be declared in other files and the compiler will follow the similar pattern as above, for example a module `vegetables` in the `garden` module:
  - `mod vegetables {...}` as inline
  - `mod vegetables;` as `src/garden/vegetables.rs` or `src/garden/vegetables/mod.rs`
- Paths can refer to code from a module. For example, a type `Carrot` in the `vegetables` submodule would be used with: `crate::garden::vegetables::Carrot` (as long as privacy rules allow it to be used)
- Modules are private by default, and can be made by adding `pub` when declaring the module, for example `pub mod vegetables`
- The `use` keyword allows us to create a shorthand for an item, for example doing `use crate::garden::vegetables::Carrot` we can just use `Carrot` in a file without the full path

We can create modules using `cargo new --lib <LIB NAME>`

The `src/lib.rs` and `src/main.rs` are called crate roots and things accessed relative to here are accessed by the `crate` module

## Referencing Items by Paths

Paths can ee referenced in one of two ways:

- An absolute path using `crate`
- A relative path using `self`, `super`, or an identifier in the current module

For example, referencing `add_to_waitlist` in the below file may look like this:

```rs
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```

Also note the `pub` keyword which allows us to access the relevant submodules and function

### Best Practices for Packages with a Binary and Library

When a package has a binary `src/main.rs` crate root and a `src/lib.rs` crate root, both crates will have the package name by default, in this case you should have the minimum necessary code in the `main.rs` to start the binary, while keeping the public API in the `lib.rs` good so that it can be used by other consumers easily. Like this, the binary crate uses the library crate and allows it to be a client of the library

### Relative Paths with Super

Modules can use the `super` path to access items from a higher level module:

```rs
fn deliver_order() {}

mod back_of_house {
    pub fn fix_incorrect_order() {
        cook_order();
        super::deliver_order();
    }

    fn cook_order() {}
}
```

## Bring Paths into Scope

We can bring paths into scope using the `use` keyword, this makes it easier to access an item from a higher level scope

For example, say we wanted to add a method `undo_order_fix` at the top level of our module file, and we need to us a method from the `back_of_house` module, we can do this like so:

```rs
fn deliver_order() {}

mod back_of_house {
    pub fn fix_incorrect_order() {
        cook_order();
        super::deliver_order();
    }

    fn cook_order() {}
}

use back_of_house::fix_incorrect_order;

pub fn undo_order_fix() {
    fix_incorrect_order();
}
```

Note that if we were to try to use the top-level `use` in another submodule this would not work and we would need to import it within the scope of that module

For example, the following will fail:

```rs
pub mod private_module {
    pub fn do_stuff() {
        fix_incorrect_order();
    }
}
```

But this will work:

```rs
pub mod private_module {
    use super::back_of_house::fix_incorrect_order;

    pub fn do_stuff() {
        fix_incorrect_order();
    }
}
```

### Idiomatic Paths

In the above examples, we're importing paths to functions and using them directly, however, this isn't the preferred way to do this in rust, it's instead preferred to keep the last-level of the path in order to identify that the path is part of another module. So for example, instead of the above use this instead:

```rs
pub mod private_module {
    use super::back_of_house;

    pub fn do_stuff() {
        back_of_house::fix_incorrect_order();
    }
}
```

The exception to this rule is when importing structs or enums into scope, we prefer to use the full name, for example:

```rs
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    map.insert(1, 2);
}
```

The exception to this is when bringing two items with the same name into scope:

```rs
use std::fmt;
use std::io;

fn function1() -> fmt::Result {
    // --snip--
}

fn function2() -> io::Result<()> {
    // --snip--
}
```

This is to ensure that we refer to the correct value

### Renaming Imports

In order to get around naming issues, we can also use `as` to rename a specific import - so the above example can be written like:

```rs
use std::fmt::Result;
use std::io::Result as IoResult;

fn function1() -> Result {
    // --snip--
}

fn function2() -> IoResult<()> {
    // --snip--
}
```

### Re-exporting Names

We can re-export an item with `pub use`, like so:

```rs
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
}
```

This is often useful to restructure the imports from a client perspective when our internal module organization is different than what we want to make the public API

### Nested Paths

When importing a lo of stuff from a similar path, you can join the imports together in a few ways

For modules under the same parent:

```rs
use std::cmp::Ordering;
use std::io;
```

Can become:

```rs
use std::{cmp::Ordering, io};
```

For using the top-level as well as some items under a path:

```rs
use std::io;
use std::io::Write;
```

Can become:

```rs
use std::io::{self, Write};
```

And for importing all items under a specific path using a glob:

```rs
use std::collections::*;
```

> Note that using globbing can make it difficult to identify where a specific item has been imported from

The Glob operator is often used when writing tests to bring a specific module into scope

# Common Collections

Collections allow us to store data that can grow and shrink in size

- Vectors store a variable number of values next to each other
- Strings are collections of characters
- Hash Maps allow us to store a value with a particular key association

## Vectors

Vectors allow us to store a list of a single data type.

### Creating a Vector

When creating a vector without initial items you need to provide a type annotation:

```rs
let a: Vec<i32> = Vec::new();
```

Or using `Vec::from` if we have an initial list of items

```rs
let c = Vec::from([1, 2, 3]);
```

The above can also be using the `vec!` macro

```rs
let b = vec![1, 2, 3];
```

### Updating Values

In order to update the values of a vector we must first define it as mutable, thereafter we can add items to it using the `push` method

```rs
let mut c: Vec<i32> = Vec::new();
c.push(1);
c.push(2);
c.push(3);
```

### Dropping a Vector Drops its Elements

When a vector gets dropped, all of it's contents are dropped - which means that if there are references to an element we will have a compiler error

```rs
{
    let v = vec![1, 2, 3, 4];

    // do stuff with v
} // <- v goes out of scope and is freed here
```

### Reading Elements

We can read elements using either `[]` notation or the `.get` method:

```rs
let mut d = vec![1, 2, 3, 4, 5];

let d1 = &d[1];
let d2 = d.get(2);
```

The difference int he two access methods above is that `d1` is an `&i32` whereas `d2` is an `Option<$i32>`

This is an important distinction since when running the code, the first reference will panic with index out of bounds

```
thread 'main' panicked at 'index out of bounds: the len is 5 but the index is 100', src\main.rs:12:15
note: run with `RUST_BACKTRACE=1` environment variable to display a backtraceerror: process didn't exit successfully: `target\debug\rust_intro.exe` (exit code: 101)
```

Note that as long as we have a borrowed, immutable reference to an item we can't also use the mutable reference to do stuff, for example we can't push an item into `d` while `d1` is still in scope:

```rs
let mut d = vec![1, 2, 3, 4, 5];

let d1 = &d[1];
let d2 = d.get(2);

d.push(6);
println!("The first element is: {}", d1);
```

The above will not compile with the following error:

```
error[E0502]: cannot borrow `d` as mutable because it is also borrowed as immutable
  --> src\main.rs:15:5
   |
12 |     let d1 = &d[1];
   |               - immutable borrow occurs here
...
15 |     d.push(6);
   |     ^^^^^^^^^ mutable borrow occurs here
16 |     println!("The first element is: {}", d1);
   |                                          -- immutable borrow later used here

For more information about this error, try `rustc --explain E0502`.
```

The reason for the above error is that vectors allocate items in memory next to one another, which means that adding a new element to a vector may result in the entire vector being reallocated, which would impact any existing references

### Looping over Elements

We can use a `for in` loop to iterate over elements in a vector, like so:

```rs
let e = vec![41, 62, 92];
for i in &e {
    println!("{}", i);
}
```

We can also use the `*` dereference operator to modify the elements in the vector:

```rs
let mut e = vec![41, 62, 92];
for i in &mut e {
    *i = *i + 10;
}
```

Which is equivalent to:

```rs
let mut e = vec![41, 62, 92];
for i in &mut e {
    *i += 10;
}
```

And will add 10 to each item in the list

### Using Enums to Store Multiple Types

Vectors can only store values that are the same type. In order to store multiple types of data we can store them as enums with specific values. For example, if we want to store a list of users

```rs
struct UserData {
    name: String,
    age: i32,
}

enum User {
    Data(UserData),
    Name(String),
}

fn main() {
    let mut users: Vec<User> = Vec::new();

    users.push(User::Data(UserData {
        name: String::from("Bob"),
        age: 32,
    }));

    users.push(User::Name(String::from("Jeff")));
}
```

### Remove the Last Element

We can use the `pop` method to remove the last element from the vector

```rs
let popped = users.pop();
```

## UTF-8 Encoded Text as Strings

The `String` type differs from `str` in that it is growable, mutable, and owned

### Creating a String

Strings are created using the `new` function:

```rs
let mut s = String::new();
```

When we have some initial data for the string, we can use the `.to_string` method:

```rs
let s = "hello".to_string();
```

An alternative to the above is:

```rs
let s = String::from("hello");
```

### Updating a String

We can use functions like `push_str` to add to a string:

```rs
let mut s = String::from("hello");

s.push_str(" world");
```

Strings can be updated by using concatenation (`+`) or the `format!` marco:

```rs
let s1 = String::from("hello");
let s2 = String::from(" world");
// concatenation requires an owned string first, other strings should be borrowed
let s3 = s1 + &s2;
// can no longer use `s1` from this point since it's ownership has moved to s3

println!("{}", s3);
```

If we want to create a new string from a concatenation of multiple other strings then we can use the `format!` marco:

```rs
let s1 = String::from("hello");
let s2 = String::from(" world");
let s3 = format!("{}-{}", s1, s2);

// s1, s2, s3 can all still be used since ownership is not given

println!("{}, {}, {}", s1, s2, s3);
```

### Indexing into Strings

Rust doesn't support string indexing. This is due to how `String` is implemented internally and that the resulting string value may not always be the expected value in the string

This is especially relevant with non-numeric characters - since rust supports all UTF-8 Characters, something that seems like a simple string may be encoded as a non-trivial sequence of characters

### Slicing Strings

Since indexing isn't a good idea in rust since the return value can be unexpected - it's usually more appropriate to create a slice:

```rs
let s1 = String::from("💻");
println!("{}", s1.len()); // len is 4
```

## Hash Maps

Hash maps store key-value pairs as `HashMap<K, V>`. This is bsically a map/object/dictionary and works like so:

### Importing

To use a hash map, we need to import it:

```rs
use std::collections::HashMap;
```

### Adding Items

```rs
let mut users = HashMap::new();

users.insert("bob@email.com", "Bob Smith");
users.insert("john@email.com", "John Smith");
```

We can also create items using a list of keys and a list of values along with the iterators and the collect method

```rs
let emails = vec!["bob@email.com", "john@email.com"];
let names = vec!["Bob Smith", "John Smith"];

let mut users: HashMap<_, _> = emails.into_iter().zip(names.into_iter()).collect();
```

The `zip` method gathers data into an iterator of tuples, and the `collect` method gathers data into different collection types. In our case, a `HashMap`

We specify `HashMap<_,_>` to tell the collect method that we want a hash map back and not someother kind of collection. We use the `_` because rust can still infer the type of the key and value

### Get a Value by Key

We can get a value by key using the `.entry` method

```rust
let mut users: HashMap<_, _> = ...
let bob = users.entry("bob@email.com");

println!("{:?}", bob);
```

> Note that `users` needs to be defined as mutable in order for the us to use the `.entry` method

### Update Item

We can update an item by just setting the key and value like when we added them initially:

```rust
users.insert("bob@email.com", "Bob's New Name");

let new_bob = users.entry("bob@email.com");
```

### Update Item if Exists

Another usecase is updating a value in a map only if the value does not exist, this can be done using the `.or_insert` method. We can see that here the entry for bob is not updated:

```rust
users.entry("bob@email.com").or_insert("Bob's New Name");

let new_bob = users.entry("bob@email.com");

println!("{:?}", new_bob);
```

# Error Handling

Rust uses the `Result<T,E>` type for recoverable errors, and `panic!` for errors that should stop execution

### Unrecoverable Errors with `panic!`

We can panic like so:

```rust
fn main() {
 panic!("at the disco");
}
```

We can also create a panic by doing something that yields an undefined behaviour:

```rust
let v = vec![1, 2, 3];
v[10];
```

Which will result in:

```
   Compiling my-project v0.1.0 (/home/runner/Rust-Playground)
    Finished dev [unoptimized + debuginfo] target(s) in 1.03s
     Running `target/debug/my-project`
thread 'main' panicked at 'index out of bounds: the len is 3 but the index is 10', src/main.rs:3:1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
exit status 101
```

## Recoverable Errors with Result

Usually if we encounter an error that we can handle, we should return a `Result`

The `Result` type is an enum defined in the standard library as follows:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

> The result type is always in scope, so it doesn't need to be imported

The `Result` type is usually used with a match expression, for example:

```rust
let file = File::open("./sample.txt");

let result = match file {
    Ok(f) => f,
    Err(e) => panic!("Error reading file: {:?}", e),
};
```

We can also do further specific checks on the type of the error based on the`Result` value

The shortcut to panic on error is the `.unwrap` method which can be used like so:

```rust
let file = File::open("./sample.txt");

let result = file.unwrap();
```

Or we can unwrap with a specific error message:

```rust
let file = File::open("./sample.txt");

let result = file.expect("Error reading file");
```

We can also choose to handle only `Ok` values by using the `?` operator, and then have the error automatically propagated like so:

```rust
use std::fs::File;
use std::io::Error;

fn read_file() -> Result<File, Error> {
    let file = File::open("./sample.txt")?;
    print!("{:?}", file);

    return Ok(file);
}

fn main() {
    let result = read_file().expect("Could not read file");
}
```

The `?` operator will do an early return in the result of an `Err` in the above case. The `?` operator can only be used for types that implement `FromResidual` like `Result` or `Option`

## When to Panic

Generally, we use `unwrap` or `expect` when prototyping or writing tests, but other than this it can be okay to use `.unwrap` in a case where the compiler thinks that we may have a `Result` but due to the specific circumstance we know that we won't have an error

An example of when we know that the data will definitely not be an error can be seen below:

```rust
fn main() {
    use std::net::IpAddr;

    let home: IpAddr = "127.0.0.1".parse().unwrap();
}
```

Otherwise it is advisable to panic when it's possible that code could end up in a bad state, for example if a user enters data in an incorrect format

# Generics, Traits, and Lifetimes

### Generic Functions

We can define generic functons using the following structure:

```rust
fn my_func<T>(input: T) -> T
```

For example, a function that finds the first vue in a slice would be defined like so:

```rust
fn first<T>(list: &[T]) -> T
```

### Generic Structs

We can use a generic in a struct like so:

```rust
struct Datum<X,Y> {
    x: X,
    y: Y,
}
```

### Generic Enums

Enums work the same as structs, for example the `Option` enum:

```rust
enum Option<T> {
    Some(T),
    None,
}
```

Or for the `Result` enum:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

### Method Definitions

methods can also be implemented on generic structs and enums, for example

```rust
struct Datum<X,Y> {
  x: X,
  y: Y,
}

impl<X,Y> Datum<X,Y> {
  fn get_x(self) -> X {
    self.x
  }
}
```

## Traits

A trait defines funcionality that a specific type can have and share with other types. This helps us define shared behaviour in an abstract way

We can use traits to enforce constriants on generics so that we can specify that it meets a specific requirement

### Defining a Trait

A trait can be defined usnig the `trait` keyword, for example, we can define a trait called `Identifier` with a `get_id` method:

```rust
pub trait Identifier {
  pub fn get_id(&self) -> String;
}
```

### Implement a Trait

We then create a type that implements this like so:

```rust
struct User {
  id: i32,
  name: String,
}

impl Identifier for User {
  fn get_id(&self) -> String {
    String::from(&self.id.to_string())
  }
}
```

### Default Implementations

Traits can also have a default implementation, for example we can have a `Validity` trait which looks like this:

```rust
pub trait Validity {
  pub fn is_valid(&self) -> bool {
    false
  }
}

impl Validity for User {
  fn is_valid(&self) -> bool {
    &self.id > &0
  }
}
```

### Traits as Parameters

We can specify a trait as a function parameter like so:

```rust
pub fn id(value: &impl Identifier) -> String {
  value.get_id()
}
```

The above is syntax sugar for a something known as a _trait bound_

```rust
pub fn id<T: Identifier>(value: &T) -> String {
  value.get_id()
}
```

We can also specify that a value needs to implement multiple traits, as well as nultiple different generics:

```rust
fn valid_id<T: Identifier + Validity, U: Validity>(value: &T, other: U) -> Option<String> {
    if value.is_valid() {
        Some(value.get_id())
    } else {
        None
    }
}
```

Trait bounds can also be speficied using the `where` clause when we have multiple bounds:

```rust
fn valid_id<T, U>(value: &T, other: U) -> Option<String>
where
    T: Identifier + Validity,
    U: Validity,
{
    if value.is_valid() {
        Some(value.get_id())
    } else {
        None
    }
}
```

### Conditional Trait Implementation

Traits can also be generically implemented for a generic, like so:

```rust
impl<T: Display> ToString for T {
    // --snip--
}
```

## Validate References with Lifetimes

Lifetimes are a kind of generic that ensures that a reference's data is valid for as long as we need them to be

### Prevent Dangling References

Lifetimes aim to prevent dangling references

If we try to run the below code we will have a compiler error:

```rs
fn main() {
    { // 'a
        let r;

        { // 'b
            let x = 5;
            r = &x;
        } // end 'b

        println!("r: {}", r);
    } // end 'a
}
```

This is because the reference to `x` doesn't live as long as `r` which is in the outer scope

In the above example, we would say that the lifetime of `r` is `'a` and the lifetime of `x` is `'b`. We can also see that the `'a` block extends beyond the `'b` block, so `'a` outlives `'b` and so `r` will not be able to reference `x` in the outer scope

Given the following function `longest`:

```rs
fn main() {
    let string1 = String::from("abcd");
    let string2 = "xyz";

    let result = longest(string1.as_str(), string2);
    println!("The longest string is {}", result);
}

fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

Rust will not be able to compile since it can't tell whether the returned value refers to `x` or `y`, and therefore can't tell which value the result refers to. In this case, when compiling we will get the following error:

```
   Compiling my-project v0.1.0 (/home/runner/Rust-Playground)
    Building [                             ] 0/1: my-project(bin)
error[E0106]: missing lifetime specifier
 --> src/main.rs:9:33
  |
9 | fn longest(x: &str, y: &str) -> &str {
  |               ----     ----     ^ expected named lifetime parameter
  |
  = help: this function's return type contains a borrowed value, but the signature does not say whether it is borrowed from `x` or `y`
help: consider introducing a named lifetime parameter
  |
9 | fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
  |           ++++     ++          ++          ++

    Building [                             ] 0/1: my-project(bin)
For more information about this error, try `rustc --explain E0106`.
    Building [                             ] 0/1: my-project(bin)
error: could not compile `my-project` due to previous error
exit status 101
```

In this context, the compuler is telling us that we need to specify the lifetime value and it shows us how we need to do that:

```rs
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

Using lifetime values helps the compiler identify issues more easily

The above also prevents us from using `result` outside of the `'b` scope since it's not valid due to the lifetime value:

```rs
fn main() {
    let string1 = String::from("long string is long");
    let result;

    {
        let string2 = String::from("xyz");
        result = longest(string1.as_str(), string2.as_str());
    }
    println!("The longest string is {}", result);
}
```

We'll get the following error:

```rs
   Compiling my-project v0.1.0 (/home/runner/Rust-Playground)
    Building [                             ] 0/1: my-project(bin)
error[E0597]: `string2` does not live long enough
 --> src/main.rs:7:44
  |
7 |         result = longest(string1.as_str(), string2.as_str());
  |                                            ^^^^^^^ borrowed value does not live long enough
8 |     }
  |     - `string2` dropped here while still borrowed
9 |     println!("The longest string is {}", result);
  |                                          ------ borrow later used here

    Building [                             ] 0/1: my-project(bin)
For more information about this error, try `rustc --explain E0597`.
    Building [                             ] 0/1: my-project(bin)
error: could not compile `my-project` due to previous error
exit status 101
```

This is because of the lifetime of the `result` value being longer than `'b`, and due to the lifetime constraing the value of `result` is only valid for the shortest lifetime parameter

Using the concept of lifetimes we can also specify a lifetime parameter that shows that the return type of a function is not dependant on a specific value, for example in the following function, we only care about the lifetime of `x`:

```rs
fn longest<'a>(x: &'a str, y: &str) -> &'a str {
    x
}
```

### Lifetimes in Structs

We can define structs to hold refernces, however if this is done then it becomes necessary to have a lifetime annotation to each reference in the struct's definition. Struct lifetime definitions look like so:

```rs
struct ImportantExcerpt<'a> {
    part: &'a str,
}
```

### Lifetime Elision

Often in rust we have cases where the compiler can identify a lifetime rule based on patterns in a function's body, in this case we don't necessarily need to specify the lifetime. The rules that the compiler uses to identify these are called _lifetime elision rules_

### Lifetimes on Method Definitions

Lifetimes on methods are specified like so:

```rs
impl<'a> ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }
}
```

By default, the lifetime of the result is always the same as the lifetime ofthe struct, which means that we don't need to specify it in the input or output values

### The Static Lifetime

The `'static` lifetime is a lifetime of a value that's stored in the program's inary and is always available. All string literals are `'static`

# Automated Tests

## How to Write Tests

### File Structure

A test file should contain tests in their own isolated module using the `#[cfg(test)]` attribute, and each test having the `#[test]` attribute on it. We usually also want our test to make use of code from a module we want to test, we can do this by using the `super:**` import which would be the module exported from the file we're in

### Writing Tests

In the `src/lib.rs` file add the following content implementing what was discussed above:

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn larger_can_hold_smaller() {
        let larger = Rectangle {
            width: 8,
            height: 7,
        };
        let smaller = Rectangle {
            width: 5,
            height: 1,
        };

        assert!(larger.can_hold(&smaller));
    }
}
```

In the above test, we can also see the `assert!` macro which will cause a panic if the test fails

The following are some of the other test macros we can use:

| Macro        | Use                                 |
| ------------ | ----------------------------------- |
| `assert!`    | Check that a boolean is `true`      |
| `assert_eq!` | Check that two values are equal     |
| `assert_neq` | Check that two values are not equal |

### Running Tests

To run tests, use `cargo test` which will automatically run all tests within the project using:

```sh
cargo run
```

### Testing for Panics

We can also state that a test should panic by using the `#[should_panic]` attribute on a specific test:

```rust
mod tests {
    use super::*;

    #[test]
    #[should_panic]
    fn greater_than_100() {
        Guess::new(200);
    }
}
```

In the above example it's also possible for us to specify the exact panic message for the test:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[should_panic(expected = "Guess value must be less than or equal to 100")]
    fn greater_than_100() {
        Guess::new(200);
    }
}
```

### Return `Result` from a Test

Instead of panicking we can also get a test to return a `Result`, for example:

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() -> Result<(), String> {
        if 2 + 2 == 4 {
            Ok(())
        } else {
            Err(String::from("two plus two does not equal four"))
        }
    }
}
```

## Controlling Test Runs

By default, the test runner will compile and run all tests in parallel, but we can control this more specifically

### Consecutive Test Runs

We can limit the number of threads to get tests to run sequentially

```sh
cargo test -- --test-threads=1
```

### Show Test Output

By default, any prints from within a test will not be shown, if we want to see these we can instead use:

```sh
cargo test -- --show-output
```

### Running Tests by Name

We can specify a set of tests to run like so:

```sh
cargo test <SEARCH>
```

So if we want to run all tests with the word `hello`:

```sh
cargo test hello
```

### Ignoring a Test Unless Specified

We can make the default test runner ignore a specific test with the `#[ignore]` attribute. The test runnner will then only run it if we specify that it should:

```sh
cargo test -- --ignored
```

## Conventions

### Unit Tests

Unit tests are usually contained in the same file as the code being tested in a module called `tests`

### Integration Tests

Integration tests are stored in a `tests` directory, cargo knows to find integration tests here

Additionally, for code we want to share between integration tests we can create a module in the `tests` directory and import it from there

# Functional Language Features

## Closures

Closures are anonymous functions that can capture their outer scope

### Defining Closures

Closures can be defined in the following ways:

```rust
// with type annotations
let add_one_v2 = |x: u32| -> u32 { x + 1 };

// with a multi line body
let add_one_v3 = |x| { x + 1 };

// with a single line body
let add_one_v4 = |x| x + 1  ;
```

### Capturing the Environment

A simple closure which immutably borrows `a` which is defined externally can be created and used like so:

```rust
fn main() {
    let a = "Hello";

    let c = || println!("{}", a);

    c();
}
```

### Borrowing Mutably

Closures can also make use of mutable borrows. For example, the below closure will add an item to a `Vec`:

```rust
fn main() {
    let mut a = Vec::new();
    let mut c = || a.push("Hello");

    c();

    println!("{:?}", a);
}
```

### Types of Closures

There are three traits that closures can implement, depending on which ones they have the compiler will enforce their usage in certain places:

- `FnOnce` - Can only be called once - Applies if it moves captured values out of its body
- `FnMut` - Does not move captured values out of its body but may mutate captured values. Can be called more than once
- `Fn` - Pure closures, don't move captured values or mutate them, can be called more than once

## Iterators

Iterators allow us to perform a sequence of operations over a sequence.

Iterators in Rust are lazy and are not computed until a method that consumes the iterator is called

### The Iterator Trait

All iterators implement the `Iterator` trait along with a `next` method and `Item` type:

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;

    // methods with default implementations elided
}
```

### Consuming Adaptors

Methods that call the `next` method are called _consuming adaptors_ because calling them uses up the iterator

These methods take ownership of the iterator which means that after they are called we can't use the iterator

Examples of this are the `sum` or `collect` methods

### Iterator Adaptors

Methods that transform the iterator are called _iterator adaptors_ and they turn the iterator from one type of iterator into another. These can be chainged in order to handle more complex iterator processes

Since iterator adaptors are lazy we need to call a consuming adaptor in order to evaluate a final values

Examples of this are the `map` or `filter` methods

## Example of Closures and Iterator

An example using iterators with closures can be seen below:

```rust
pub fn search<'a>(contents: &'a str, query: &str) -> Vec<&'a str> {
    let lines: Vec<&str> = contents
        .lines()
        .filter(|line| line.to_lowercase().contains(&query.to_lowercase()))
        .collect();

    return lines
}
```

# Smart Pointers

A pointer is a general concept for a varaible that contains an addres in memory

_Smart pointers_ act like pointers but have some additional functionality. Smart pointers also differ from references in that they usually own the data

Some smart pointers in the standard library include `String` and `Vec`

Smart pointers are implemented as structs that implement `Deref` and `Drop`. `Deref` allows smart pointer to behave like a reference, and `Drop` allows customization of code that gets run when a smart pointer goes out of scope

Some other smart pointers in the standard library include:

- `Box<T>` - allocating values on the heap
- `Rc<T>` - counting references to allow for multiple ownership
- `Ref<T>`, `RefMut<T>` - enforce borrowing rules ar runtime

## `Box<T>`

A box is the most straightforward smart pointer, it allows us to store data on the heap along with a pointer to the data on the heap

Boxes don't have a performance overhead and don't do lot - often used in the following situations:

- Types that's size can't be known at compile time but we want to use them in places that require an exact size
- Large amount of data that we want to transfer ownership of but don't want the data to be copied
- When you want to own a data but don't care about the specific type but rather a trait implementation

### Using `Box<T>` to Store Data on the Heap

Using the `Box::new` we can create a value that will be stored on the heap

```rs
fn main() {
    let b = Box::new(5);
    println!("b = {}", b);
}
```

Often it doesn't make sense to store simple values like `i32` on the heap, this is usually used for more complex data

### Recursive Types using Boxes

Recursive types are problematic since rust can't tell the size of the type at compile time. In order to help, we can `Box` a value in the recursive type

For example, take the type below which can be used to represent a person's reporting structure in a company

A `Person` can either be a `Boss` or an `Employee` with a manager who is either another `Employee` or a `Boss`

```rs
enum Person {
    Boss(String),
    Employee(String, Person),
}
```

Trying to compile the above will result in the following error:

```
error[E0072]: recursive type `Person` has infinite size
 --> .\main.rs:1:1
  |
1 | enum Person {
  | ^^^^^^^^^^^ recursive type has infinite size
2 |     Boss(String),
3 |     Employee(String, Person),
  |                      ------ recursive without indirection
  |
help: insert some indirection (e.g., a `Box`, `Rc`, or `&`) to make `Person` representable
  |
3 |     Employee(String, Box<Person>),
  |                      ++++      +

error: aborting due to previous error

For more information about this error, try `rustc --explain E0072`.
```

As per the compiler message, we can use a `Box` which will fix the unknown size issue since it's size is known at compile time:

```rs
enum Person {
  Boss(String),
  Employee(String, Box<Person>),
}
```

The code can then be used to represent an employee's reporting hierarchy:

```rs
#[derive(Debug)]
enum Person {
    Boss(String),
    Employee(String, Box<Person>),
}

fn main() {
    let reporting = Person::Employee(
        String::from("John"),
        Box::new(Person::Employee(
            String::from("Jack"),
            Box::new(Person::Boss(String::from("Jane"))),
        )),
    );

    println!("{:?}", reporting);
}

```

Which prints:

```
Employee("John", Employee("Jack", Boss("Jane")))
```

Boxes only provide indirection and heap allocation and don't do any other special functions
