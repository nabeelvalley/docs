# Introduction to Kotlin

> From [this Udacity course](https://classroom.udacity.com/courses/ud9011)

## About Kotlin

Kotlin is a statically typed languge developed by JetBrains that makes use of:

- Type inferrence
- Lambdas
- Corutines
- Properties

Kotlin is also officially supported for building Androind Apps

The language also differentiates between Nullable and NonNullable data as well as removing a lot of boilerplate code

Kotlin also can interoperate with Java bidirectionally

## Prerequisites

- A JAVA/Kotlin IDE such as IntelliJ IDEA or Android Studio if you're working on an Android App
- JDK 

> For some basic stuff you can use the [Kotlin Playground](https://play.kotlinlang.org/)

## Setting Up a Project

1. New Project
2. Kotlin > JVM | IDEA

From a toolbar you can go to `tools > kotlin > REPL`

## Hello World

A Hello World Program may look like the following:

```kotlin
fun printHello () {
   println ("Hello World")
}

printHello()
```

We can see that a function is defined with `fun` and the only other notable feature in the above code is the lack of semicolons at the end of the line

## Operators and Variables

| Operation | Name          | Function Representation |
| --------- | ------------- | ----------------------- |
| `n + m`   |Addition       | `n.plus(m)`             |
| `n - m`   |Subtraction    | `n.minus(m)`            |
| `n * m`   |Multiplication | `n.times(m)`            |
| `n / m`   |Division       | `n.div(m)`              |
| `n == m`  |Equals         | `n.equals(m)`           |
| `n != m`  |NotEquals      |                         |

Basic types have default operators and functions that can be overloaded as well as allows you to convert basic types automatically however numbers will not implicitly convert as this can cause problems and they must be explicitly cast

Kotlin has immutable and mutable variables

You can create an immutable variable with `val` and a mutable variable with `var`

```kotlin
var changeable = 0
changeable = 1

val unchangeable = 1
```
> Note that `val` only makes the reference immutable and not the properties of the object, so we can still call methods on that object

Although types are inferred we can state them explicitly as well:

```kotlin
val b: Byte = 1
```

> Regardless, types are static at compile time

By default variables cannot be null, this is to avoid null pointer exceptions, we can use the `?` in the type to state that a variable is nullable

```kotlin
val imNotNullable: int = null // will throw an errro
val imNullable: int? = null // will work fine
```

You can use the Not Null Assertion `!!` operator to throw the null exception if the result is null if you want to do your own null checking

```kotlin
myVal!!.functionThatDoesNotExist() // will throw
```

You can rather use the Elvis `?` operator to do null checking and defaulting

```kotlin
myVariable?.doThing() ?: 0
```

If `myVariable` is `null` then it will return `0` otherwise it will return the function result

## Strings

We can define strings using the `"..."` as normal, additionally we can use the `$` sign in a string to display a value inline

```kotlin
val fish = 12

"I have $fish fishies"
```

```kotlin
val cows = 12

"I have $(fish + cows) animals in total"
```

## Condition Checking

We can use `If-Else` as follows:

```kotlin
if (fish > 1)
    println("Good")
else
    println("Bad")
```

If we have multiple statements after the condition we can use braces:

```kotlin
if (fish > 1) {
    println("Statement 1")
    println("Statement 2")
}
else {   
    println("Statement 3")
    println("Statement 4")
}
```

Additionally we can also make use of ranges in our `If` conditions using the `..` notation:

```kotlin
if (fish in 1..20)
    println("Wow")
```

Kotlin also has switch statements, which make use of the `when` keyword:

```kotlin
when (fish) {
    0 -> println("No Fish")
    1 -> println("Eh")
    in 2..20 -> println("Great")
    else -> println("WOAH")
}
```

If we use a `when` without a value, it functions like an `If-Else` statement:

```kotlin
when {
    fish == 0 -> println("No Fish")
    fish == 1 -> println("Eh")
    fish in 2..20 -> println("Great")
    else -> println("WOAH")
}
```

## Data Collections

### Arrays

We can create an Array with 

```kotlin
val myArr = arrayOf("val1", "val2")
```

We can also mix the data types in the array with:

```kotlin
val myArr = arrayOf("val1", 2)
```

You can also loop over arrays while getting the index like the following:

```kotlin
for ((index, element) in myArr.withIndex()) {
    println("Index: $index, Element: $element")
}
```

### Ranges

You can also create ranges, we can use the following methods of creating a range:

```kotlin
val digits = 1..10
val reverse = 10 downTo 1
val stepped = 1..10, step 2
val mixed = 103 downTo 15 step 5
```

We can then make use of these in a for loop, for example:

```kotlin
for (i in 103 downTo 15 step 5) println(i)
```

Additionally we can also sort of create a sort of array of range values using the following:

```kotlin
val myData = Array(10){ 1000.0.pow(it) }
```

Which will result in a 10 item array with each element being `1000^index`

### Sequences

Kotlin also has a datatype known as a `Sequence` which is like a lazy list, the values in this are only evaluated when read and not calculated immediately when operated on

## Functions

### Main

The `main` function has all the main parts of a Kotlin function

```kotlin
fun main(args: Array<String>) {
    println("Hello, world!")
}
```

A function uses the `fun` keyword to define the function and the function arguments with their types are in the parenthesis

Every function has a return type, in the above the function does not return any value and hence returns `unit`

If a function returns a `unit` we do not need to state it explicitly

We can create a new Kotlin file in the `src` directory called `main.kt` with the above `main` function contents

The `main` function is the default entrypoint for a Kotlin application. Click the green run icon next to the line numbers on the left to run the function

### Defining and Using Functions

A function to return the day of the week as text can look something like:

```kotlin
fun getDayOfWeek (): String {
    val date = LocalDate.now()
    val day = date.dayOfWeek

    return when (day) {
        DayOfWeek.MONDAY ->
            "Monday"
        DayOfWeek.TUESDAY ->
            "Tuesday"
        DayOfWeek.WEDNESDAY ->
            "Wednesday"
        DayOfWeek.THURSDAY ->
            "Thursday"
        DayOfWeek.FRIDAY ->
            "Friday"
        DayOfWeek.SATURDAY ->
            "Saturday"
        DayOfWeek.SUNDAY ->
            "Sunday"
        else ->
            "Something else somehow"
    }
}
```
We can see the `Sting` return type written after the function signature, we can use this in our `main` function with:

```kotlin
fun main(args: Array<String>) {
    val day = getDayOfWeek()
    println("Today is $day")
}
```

We can run the main function with arguments as well using the Debug Configuration in IntelliJ 

From the above we can see that everything in Kotlin is a value, even the result of a `when` or `if` statement

### Default Values

Function params can also have a default value, for example:

```kotlin
fun addNumbers(x: Int = 0, y: Int = 2) : Int {
    return x + y
}
```


Aside from default params as values we can also make use of this by calling a function

```kotlin
fun addNumbers(x: Int = getInitValue(), y: Int = 2) {
    return x + y
}
```

When defining a function like the above we should avoid using expensive function calls as these are evaluated at call time

### Single Line Functions

Single expression functions like the above can also be defined like this:

```kotlin
fun addNumbers(x: Int = getInitValue(), y: Int = 2) : Int = x + y
```

In the case of a single expression return the type can be left out as it can be inferred

```kotlin
fun addNumbers(x: Int = getInitValue(), y: Int = 2) = x + y
```

We can then just use that like we would any other function

### Lambdas

A Lambda, also known as an anonymous function, and is an expression that makes a function. These can take arguments or not. The syntax is seen below:

```kotlin
val printHello= { println("Hello, World!") }
val addFive = { x: Int -> x + 5 }
val minusFive = { x: Int -> x - 5 }
val addAny = { x: Int, y: Int ->  x + y }
```

If we want to define a variable that holds a function we can state the type using the `(T) -> U` Syntax

```kotlin
val printHello: () -> Unit = { println("Hello, World!") }
val addFive: (Int) -> Int = { x: Int -> x + 5 }
val minusFive: (Int) -> Int = { x: Int -> x - 5 }
val addAny: (Int,Int) -> Int = { x: Int, y: Int ->  x + y }
```

Higher Order Functions are functions that can take other functions, for example we can create a function that takes another function as an operator:

```kotlin
fun operate(x: Int, operator: (Int) -> Int) = operator(x)

val addResult = operate(12, addFive)
val minusResult = operate(12, minusFive)
```

Functions can also return other functions, for example we can create a function that builds a generic adder:

```kotlin
fun buildAdder(additive: Int) : (Int) -> Int {
    val adder =  { x: Int -> x + additive }
    return adder
}

val addTwelve = buildAdder(12)
ans = addTwelve(10)
```

There are a lot of other cool things about functions and small syntactical changes that can be used when mixing them together but this should be relatively straightforward

