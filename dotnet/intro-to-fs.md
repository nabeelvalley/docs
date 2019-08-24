# Introduction to F

- [Introduction to F](#introduction-to-f)
  - [Syntax](#syntax)
    - [Variables](#variables)
    - [Functions](#functions)
    - [Switch Statements](#switch-statements)
  - [Complex Data Types](#complex-data-types)
  - [Tuples](#tuples)
    - [Record Types](#record-types)
    - [Union Types](#union-types)
  - [Printing](#printing)
  - [Key Concepts](#key-concepts)
    - [Function Oriented](#function-oriented)
    - [Expressions over Statements](#expressions-over-statements)
    - [Algebraic Types](#algebraic-types)
    - [Flow Control with Matching](#flow-control-with-matching)
    - [Pattern Matching with Union Types](#pattern-matching-with-union-types)

> Foreword: When creating a new F# project from Visual Studio do not check the `Dockerfile` option, this will result in the following error when trying to run the application in some cases `A function labeled with the 'EntryPointAttribute' attribute must be the last declaration in the last file in the compilation sequence.`

F# is a functional language that runs in the .NET Core ecosystem. It's a weird language.

There are a few different styles that we can use to run F#, the simplest would be an F# script, which uses the `.fsx` extension

You can run F# code using Visual Studio and starting a new F# project, console app or even just by creating a new F# script file, if running a `.fsx` file you can highlight the code you want to run and clicking `alt+enter`

Alternatively you can run F# in Visual Studio Code using the same method as above with the`Ionide F# Language Support` extension

## Syntax

F# is whitespace sensitive and uses indentation to denote code blocks

F# makes use of implicit typing however you can explicitly state types as well

### Variables

Variables are immutable by default and are defined using the `let` keyword.

Also, ideally they _don't_ vary

```fs
let myInt = 5
let myFloat = 3.14
let myString = "hello"
```

Lists can be defined with square brackets and elements are separated with semicolons

```fs
let list1 = [2;3;4;5]
```

We can create a new list with a prepended item using `::` and a concatenated list with `@`

```fs
let list2 = 1 :: list1 // [1;2;3;4;5]
let list3 = [0;1] @ list1 //[0;1;2;3;4;5]
```

### Functions

Functions are defined with the `let` keyword as well and the parameters are written after the name

```fs
let add x y =
    x + y
```

The return value in the above function is the result of `x + y`

You can call the function using the following

```fs
add 1 6 // 7
```

A function can also be partially applied using the following

```fs
let add5 = add 5

add5 4 // 11
```

Which sets `x` as `5` and returns a function for `5 + y`

A function that returns only even numbers can be defined using the following function within a function and the `List.filter` function which takes in a `predicate` and a `list` as inputs

```fs
let evens list =
    let isEven x = x%2 = 0
    List.filter isEven list

evens [1;2;3;4;5;6;7;8] // [2;4;6;8]
```

We can write the above in the following form as well which returns a function that will filter out the even values in a list

```fs
let evenFilter =
    let isEven x = x%2 = 0
    List.filter isEven

evenFilter [1;2;3;4;5;6;7;8] // [2;4;6;8]
```

Parenthesis can be used to specify the order in which functions should be applied

```fs
let sumOfSquares list =
    let square x = x*x
    List.sum (List.map square list)

sumOfSquares [1..10]
```

Alternatively, if you want to pass the output from one function into another, you can also use pipes which are done using `|>`

```fs
let sumOfSquaresPiped list =
    let square x = x*x

    list |> List.map square |> List.sum

sumOfSquaresPiped [1..10]
```

Or over multiple lines with:

```fs
let sumOfSquaresPiped list =
    let square x = x*x

    list
    |> List.map square
    |> List.sum

sumOfSquaresPiped [1..10]
```

The `square` function can also be defined as a `lambda` or `anonymous function` using the `fun` keyword

```fs
let sumOfSquaresLambda list =
    list
    |> List.map (fun x -> x*x)
    |> List.sum

sumOfSquaresLambda [1..10]
```

### Switch Statements

Switch statements can be used with the `match ... with` keyword, `|` to separate comparators, and `->` for the resulting statement. An `_` is used to match anything (`default`)

```fs
let patternMatch x =
    match x with
    | "a" -> printfn "x is a"
    | "b" -> printfn "x is b"
    | _ -> printfn "x is something else"

patternMatch "a" // x is a
patternMatch "c" // x is something else
```

There is also the `Some` and `None` are like Nullable wrappers

```fs
let isInputNumber input =
    match input with
    | Some i -> printfn "input is an int: %d" i
    | None -> printfn "input is missing"

isInputNumber (Some 5)

isInputNumber None
```

## Complex Data Types

## Tuples

Tuples are sets of variables, they are separated by commas

```fs
let twoNums = 1,2
let threeStuff = false,"a",2
```

### Record Types

Record Types are defined with named fields separated by `;`

```fs
type Person = { First:string; Last:string }
let john = {First="John"; Last="Test"} // Person
```

### Union Types

Union Types have choices separated by `|'

```fs
type Temp =
    | DegreesC of float
    | DegreesF of int

let tempC = DegreesC 23.7
let tempF = DegreesF 64
```

Types can also be combined recursively such as:

```fs
type Employee =
    | Worker of Person
    | Manager of Employee list

let jeff = {First="Jeff"; Last="Smith"}

let workerJohn = Worker john
let workerJeff = Worker jeff

let johnny = Manager [workerJohn;workerJeff]
```

## Printing

Printing can be done using the `printf` and `printfn` functions which are similar to `Console.Write` and `Console.WriteLine` functions in `C#`

```fs
printfn "int: %i, float: %f, bool: %b" 1 2.0 true
printfn "string: %s, generic: %A" "Hello" [1;3;5]
printfn "tuple: %A, Person: %A, Temp: %A, Employee: %A, Manager: %A" threeStuff john tempC workerJeff johnny
```

## Key Concepts

F# has four key concepts that are used when aproaching problems

### Function Oriented

F# is a functional language and functions are `first-class` entities and can be used as any other value/variable

This enables you to write code using functional composition in order to build complex functions out of basic functions

### Expressions over Statements

F# prefers to make use of expressions instead of statements. Variables tend to be declared at the same time they are assigned and do not need to be 'set-up' for use, such as in the typical case of an `if-else` statement

### Algebraic Types

Types are based on the concept of `algebraic types` where compound types are built out of their composition with other types

In the case of the below you would be creating a `Product` type that is a combination of two strings, for example:

```fs
type Person = { First:string; Last:string }
```

Or a `Union` type that is a choice between two other types

```fs
type Temp =
    | DegreesC of float
    | DegreesF of int
```

### Flow Control with Matching

Instead of making use of `if ... else`, `switch ... case`, `for`, `while` among others like most languages, F# uses `patttern-matchin` using `match ... with` to handle much of the functionality of the above

An example of an `if-then` can be:

```fs
match myBool with
| true -> // do stuff
| false -> // do other stuff
```

A `switch`:

```fs
match myNum with
| 1 -> // some stuff
| 2 -> // some other stuff
| _ -> // other other stuff
```

`loops` are generally done using recursion like the following

```fs
match myList with
| [] -> // do something for the empty case
| first::rest ->
    // do something with the first element
    // recursively call the function
```

### Pattern Matching with Union Types

Union Types can also be used in matching and a function based on them can be used to correctly handle and apply the arguments, provided the return type is consistent

```fs
type Thing =
    | Cat of age:int * colour:string
    | Potato of isCooked:bool

let whatIsIt thing =
    match thing with
    | Cat (age, colour) -> printfn "This is a %s cat, it is %i years old" colour age
    | Potato isCooked ->
        let whatPotato = printfn "This is a %s potato"
        match isCooked with
        | true -> whatPotato "Cooked"
        | false -> whatPotato "Raw"

Cat(3,"white")
|> whatIsIt

Potato(true)
|> whatIsIt
```
