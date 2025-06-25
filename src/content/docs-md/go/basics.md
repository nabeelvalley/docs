---
published: true
title: Basics
subtitle: Notes on the GO Programming language
---

- [YouTube Video](https://www.youtube.com/watch?v=SqrbIlUwR0U)
- [GitHub](https://github.com/bradtraversy/go_crash_course)
- [Exercism's Go Track](https://exercism.org/tracks/go/concepts)

# Installation

Follow the installation on the [Go Docs](https://go.dev/doc/install) for your operating system

Once done with that, you will need to add `~/go/bin` to your `PATH`

# Hello World

First, create a new directory for your project. In it create a module to enable dependency tracking - you can do this with:

```sh
go mod init example/hello
```

Make a new project directory with a file called `main.go` with the following content

Go has a `main` function that needs to be created for every package and it will be run automatically. We also need to import `fmt` to print content to the screen. Also note that Go strings must have double quotes `"hello"` or we will get an error

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello World")
}
```

We can run this with the following command from the project dir

```sh
go run main.go
```

Or since it's a module, we can just do:

```sh
go run .
```

# Build and Run

We can build binaries for an application with `go install` which can then be executed from the terminal

The simplest way to build a program is using `go build` which will build it and output it in the current directory

For example, we can build and run it as follows:

```sh
go build

./hello
```

You can also install the package globally with:

```sh
go install
```

Which will add this to `~/go/bin` and can just be run using:

```sh
hello
```

# Variables and Data Types

Go has the following data types

- string
- bool
- int int8 int16 int32 int64
- uint uint8 uint16 uint32 uint64
- byte (uint8)
- rune (int32)
- float32 float64
- complex64 complex128

There are a few different ways to create variables, note that if we create a variable and do not use it we will get an error

## Var

```go
var name string = "John"
```

Or with a separate declaration and initialization:

```go
var age int

age = 5
```

## Type Inference

```go
var name = "John"
```

## Get Type

We can make use of the following function to get the type of a variable

```go
fmt.Printf("%T",name)
```

## Constants

We can define constants with the `const` keyword

```go
const name = "John"
```

## Global Variables

We can declare global variables by defining them outside of the main function

## Shorthand Method

Inside of a function we can declare variables using the assignment operator with the following without having to specify the type of `var` keyword

```go
name := "John
```

## Multiple Assignments

We can do multiple assignments as follows

```go
name, age := "John", 15
```

## Booleans

Booleans in Go a represented using a `bool` type and are either `true` or `false`

```go
var online = true

var active bool
```

> Booleans are implicily initialized as `false`

The boolean operators are:

- `&&` - and
- `||` - or
- `!` - not

## Numbers

Go has basic numeric types for representing integers and floating point values. 

Some of these are `int`, `float64`, and `uint` and conversion between types can be done using functions with the name of the respective type. For example:

```go
var x int = 5
var y = float64()
```

Go supports the normal numerical operations such as `+`, `-`, `*`, `/`, and `%`. Note that for integer division the number is truncated back to an `int`

> Numeric operations are only supported between numbers of the same type

## Strings

`string` is an immutable sequence of bytes and can be defined using double quotes:

```go
var str1 = "Hello"
str2 := "World"
```

Concatenation of strings can be done using `+` like so:

```go
str3 := str1 + " " + str2
```

The `strings` package also has many methods for working with strings:

```go
import "strings"

func caps(name string) {
    strings.ToUpper(name)
}
```

## String Formatting

String formatting can be done using the `fmt` package which can format strings using `fmt.Sprintf` like so:

```go
str := fmt.Sprintf("int %d, int %03d, float %.3f, string %s, props %+v", 5, 7, 1.5, "hello", myStruct)
// str == "int 5, int 007, float 1.500, string hello, props { Name "hello" }"
```

> Lots of other formatting options also exist for string formatting and can be found in the docs

# Packages

## Importing Packages

We can import multiple packages by declaring each package in the `import` statement on a different line

```go
import (
    "fmt"
    "math"
)
```

## Dependencies

We can add dependencies to our Go module by simply importing them in the code that needs it, for example:

```sh
import "rsc.io/quote"
```

And then Go can automatically add it to our `go.mod` with:

```sh
go mod tidy
```

## Creating Packages

Create a new folder and in it you can define the package name and some functions in it

```go
package mypackage

func myfunction() {
    ...
}
```

And then import the package by referring to its path in the import function

# Functions

Functions are defined with the `func` keyword, the function name, inputs, and return types and values

```go
func greet(name string) string {
    return "Hello " + name
}
```

> The convention is to start functions with an uppercase letter if they're public and lowercase if they're private

Functions can also have multiple input parameters. If these are of the same type the type can just be specified once:

```go
go canMessage(visible, online bool) bool {
    return visible && online
}
```

## Variadic Functions

A variadic function is a function that takes a variable number of arguments, this is done using `...` in the type of the function:

```go
func formatMany(format string, strs ...string) string {
	result := ""

	for _, str := range strs {
		result += " " + fmt.Sprintf(format, str)
	}

	return result
}

func main() {
	str := formatMany("Hello %s", "John", "Alice", "Bob")
	fmt.Println(str)
}
```

> The variadic parameter must be the last in the parameter list

A slice can also be passed into a variadic function using `...` after the name of the variable:

```go
func main() {
	names := []string{"John", "Alice", "Bob"}
	str := formatMany("Hello %s", names...)
}
```

# Arrays and Slices

In Go arrays are fixed length, and a slice is an array without a fixed size

## Arrays

Arrays are fixed in size and can be defined with

```go
var myArray [3]string

myArray[0] = "Hello"
myArray[2] = "Word"
```

Or with initial values

```go
myArr := [2]string{"Hello", "World"}
```

## Slices

A slice is essentially an array that does not have a fixed size

```go
mySlice := []string{"Hello", "World","!"}
```

We can also make slices by using the same notation as other languages

```go
newSlice := mySlice[2:5]
```

Elements can be added to a slice using the `append` function:

```go
mySlice := []int{1,2,3}
mySlice = append(mySlice, 4,5,6)
```

> Note that `append` is not a pure function and the original slice may be modified

# Conditionals

Conditionals do not require parenthesis, however they can be used

## If Else

```go
if x < y {
    ...
} else if x == y {
    ...
} else {
    ...
}
```

## Swtich/Case

```go
switch x {
    case: 5:
        ...
    case 10:
        ...
    default:
        ...
}
```

# Loops

There are two methods for building for loops

```go
i := 1
for i <= 01 {
    ...
    i++
}
```

```go
for i := 1; i <= 10; i++ {
    ...
}
```

# Maps

Maps are key-value pairs and can be defined and accessed with

```go
ages := make(map[string]int)

ages["Bob"] = 35
ages["John"] = 5
```

We can delete a value from a map with the `delete` function

```go
delete(emails, "Bob")
```

We can also declare a map with initial values

```go
emails := map[string]int{"Bob":35, "John":5}
```

# Range

Range is used for looping through values

```go
ids := []int{1,2,3}

for i, id := range ids{
    ...
}
```

If we are not using the `i` variable, we can use an `_` to receive any inputs that we will not use

```go
for _, id := range ids{
    ...
}
```

```go
emails := map[string]int{"Bob":35, "John":5}

for k, v := range emails {
    ...
}
```

# Pointers

A pointer allows us to point to the memory address of a specific value, we can get the pointer for a value with the `&` sign

```go
a := 5
b := &a
```

If we wan to get back from the pointer to the actual value we can do that with the `*` operator

```go
a == *b // true
a == *&a //true
```

We can modify the value of a pointer

```go
*b = 10
a == 10 // true
```

The reason to use pointers can be more efficient when passing values

# Closures

We can define anonymous functions to declare anonymous functions that can be used as closures

```go
func adder () func (int) int {
    sum := 0
    return func(x int) int {
        sum += x
        return sum
    }
}


func main() {
    sum := adder()
    for i:= 0; i < 10; i++ {
        fmt.Println(sum(i)) // 0 1 3 6 ...
    }
}
```

# Structs

Structs are like classes

Structs can contain values and functions, of which we can have value reveivers and pointer receivers. Value receivers just do calculations, Pointer Receivers modify data

```go
type Person struct {
    firstName string
    lastName string
    age int
}
```

Structs can be instantiated using all the property names or using the values provided in the struct order:

```go
person1 := Person{firstName: "John", lastName: "Smith", age: 25}

person2 := Person{"John", "Smith", 25}
```

## `new` struct

In Go we can also create an instance of a struct where each value has the default value using the `new` function:

```go
// possible but not recommended as the values are zero-initialized so relatively meaningless
person := new(Person)
```

## Methods

These are functions that can be called on a struct directly using a Receiver argument that is defined after the `func` keyword:

```go

func (p Person) myValueReceiver() string {
    return "Hello " + p.firstName
}

func (p *Person) myPointerReceiver() {
    p.age++
}
```

They can then be called using the syntax as seen below

```go
func main() {
    person := Person{firstName: "John", lastName: "Smith", age: 25}
    person2 := Person{"John", "Smith", 25}

    person.firstName // John

    person.myValueReceiver() // Hello John
    person.myPointerReceiver() // person.age = 26
}
```

# Interfaces

```go
type Shape interface {
    area() float64
}

type Circle struct {
    x, y, radius float64
}

type Rectangle struct {
    width, height float64
}

func (c Circle) area() float64 {
    return math.Pi * c.radius * c.radius
}

func (r Rectangle) area() float64 {
    return r.width * r.height
}

func getArea(s Shape) float64 {
    return s.area()
}
```

# Web

To work with HTTP requests we can use the`net/http` package which allows us to define a function to handle a specific route

```go
package main

import ("fmt"
        "net/http"
)

func main(){
    http.HandleFunc("/", index)
    fmt.Println("Server Starting")
    http.ListenAndServe(":3000", nil)
}

func index(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello World")
}
```

# Randomness

The `math/rand` package offers some utilities for generaating random numbers

Numbers generated by `math/rand` are not truly random and can be seeded before retreiving random numbers, like so:

```go
rand.Seed(time.Now().UnixNano())

num := rand
```

# JSON

Go has a builtin JSON library, it's pretty straightforward to use. It consists of defining the JSON properties of the struct you'd like to parse and then parsing it using a decoder

For example:

```go
import (
	"encoding/json"
	"fmt"
	"strings"
)

type MyData struct {
	Name string `json:"name"`
	Age  int    `json:"age"`
}

func main() {
	data := strings.NewReader("{\"name\": \"Bob\", \"age\": 25 }")

    // decoder needs an io.Reader
	decoder := json.NewDecoder(data)

	var output MyData
	err := decoder.Decode(&output)
    
	if err != nil {
		panic(err)
	}

	fmt.Printf("Decoded JSON: %+v", output)
	// Decoded JSON: {Name:Bob Age:25}
}
```