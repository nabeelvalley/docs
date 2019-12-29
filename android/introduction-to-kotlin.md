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

