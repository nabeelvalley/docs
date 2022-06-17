> These notes are based on working through [The Rust Programming Language Book](https://doc.rust-lang.org/book/title-page.html)

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
```

Using the functin now will give us an error:

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

