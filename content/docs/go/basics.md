[[toc]]

- [YouTube Video](https://www.youtube.com/watch?v=SqrbIlUwR0U)
- [GitHub](https://github.com/bradtraversy/go_crash_course)

# Workspace

Go is very specific in the way we set up our folders by making use of a specific structure for our workspace folders

A workspace should have a `bin` and `src` folder in which our project code will reside, we typically use something like the following

```
go (workspace)
    - bin
    - src
        -github.com
            -username
                - project1
                    # project files
                - project2
                    # project files
    - pkg
```

We need to set the `GOPATH` environment variable to the folder in which we want our workspace to be

In my case I'm using `C:\repos\go`

Next make the necessary directories

# Install Package

Install a package with the `go get` command, for example the `aws` package:

```powershell
go get github.com/aws/aws-sdk-go/aws
```

# Hello World

Make a new project directory with a file called `main.go` with the following content

Go has a `main` function that needs to be created for every package and it will be run automatically. We also need to import `fmt` to print content to the screen. Also note that Go strings must have double quotes `"hello"` or we will get an error

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello World)
}
```

We can run this with the following command from the project dir

```powershell
go run main.go
```

# Build and Run

We can build binaries for an application with `go install` which can then be executed from the terminal

Build and run the package with the following command from the project directory

```powershell
go install
```

And then from the `bin` directory

```powershell
./01_hello.exe
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

Inside of a function we can declare variables using the assignment operator with the following 

```go
name := "John
```

## Multiple Assignments

We can do multiple assignments as follows

```go
name, age := "John", 15
```

# Packages

## Importing Packages

We can import multiple packages by declaring each package in the `import` statement on a different line

```go
import (
    "fmt"
    "math"
)
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

func (p Person) valueReceiver() string {
    return "Hello " + p.firstName
}

func (p *Person) pointerReceiver() {
    p.age++
}

func main() {
    person := Person(firstName: "John", lastName: "Smith", age: 25)
    person2 := Person("John", "Smith", 25)

    person.firstName // John

    person.valueReceiver() // Hello John
    person.pointerReceiver() // person.age = 26
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