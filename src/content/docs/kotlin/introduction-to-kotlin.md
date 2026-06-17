---
published: true
title: Kotlin Basics
subtitle: Introduction to the Kotlin language and basic concepts
description: Introduction to the Kotlin language and basic concepts
---

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

### Operators

| Operation | Name           | Function Representation |
| --------- | -------------- | ----------------------- |
| `n + m`   | Addition       | `n.plus(m)`             |
| `n - m`   | Subtraction    | `n.minus(m)`            |
| `n * m`   | Multiplication | `n.times(m)`            |
| `n / m`   | Division       | `n.div(m)`              |
| `n == m`  | Equals         | `n.equals(m)`           |
| `n != m`  | NotEquals      |                         |

Basic types have default operators and functions that can be overloaded as well as allows you to convert basic types automatically however numbers will not implicitly convert as this can cause problems and they must be explicitly cast

### Variables

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

### Constants

We can create constants using `const val` at a top level and classes declared using `object` because these are evaluated at compile time

Constants can be created at the top level of a file with:

```kotlin
const CONSTANT1= 1
```

Or as `object` singleton properties

```kotlin
object Constants {
    const val CONSTANT2 = 2
}
```

Or wrapped in a `companion object` within a class

```kotlin
class MyClass {
    companion object {
        const val CONSTANT3 = 3
    }
}
```

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

## Conditions

### If-Else

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

### Switch / When

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

### Lists

We can create lists using:

```kotlin
val myList = listOf("val1", "val2")
```

If we want the list to be mutable, we can do this using:

```kotlin
val myMutableList = mutableListOf("val1", "val2")
```

> Similar constructor functions exist for other collection types with the concept of mutable and immutable collection types

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

### Maps

Maps are essentially key-value pairs that make use of `pairs` (see later)

We can create a Map of some data with `mapOf`

```kotlin
val colours = mapOf(
    "sky" to "blue",
    "fire" to "red",
    "grass" to "green"
)
```

We can then access the elements of the map with:

```kotlin
colours.get("sky")
colours["sky"]
```

If we want to retrieve a value and provide a default value if the key does not exist we can use `getOrElse` with a default value as a lambda

```kotlin
colours.getOrElse("sad") { "no colour found" }
```

Maps are immutable by default, we can make a mutable map with `mutableMapOf`

### Pairs

Pairs allow us to define a pair of data that are mapped to each other in some way, these can also be chained

We can create aa pair with the `to` keyword

```kotlin
val pair = "val1" to "val2"
```

This results in the pair `(val1, val2)`, we can access the first and second elements with `pair.first` and `pair.second`

We can chain them as well, which is the equivalent of wrapping them in parenthesis

```kotlin
val chained = "val1" to "val2" to "val3"
```

This is equal to:

```kotlin
val chained = ("val1" to "val2") to "val3"
```

Which yields a pair within a pair `((val1, val2), val3)`. We can also destructure these the same as we would with a `data` object

These are useful for returning multiple pieces of data from a function and destructuring it on the receiving end

> You also have triples that can be created with `Triple(el1, el2, el3)`

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

### Higher Order Functions

Higher Order Functions are functions that can take other functions, an example of this is the built-in `with` function. We can create a function that takes another function as an operator, we usually use `block` to reference the function we are receiving:

```kotlin
fun operate(x: Int, block: (Int) -> Int) = blobk(x)

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

We can make use for the above idea to create the HOCs as extension functions

```kotlin
fun operate (
    additive: Int, block: Int.() -> Int
) {
    int.block()
}
```

Some other built-in HOC's are `run` which runs a lambda and returns the result and `apply` which calls a function on an object and returns the updated object, and `let` which is used for chaingin functions and getting their results

```kotlin
val newHouse = House(isFancy = true)
        .apply {
            garages = 2
            extend(4, 1)
        }

print("${ newHouse.price } ${ newHouse.size } ${ newHouse.garages }")

val priceWithTax = newHouse
        .let { it.price }
        .let { it * 1.2 }

```

You can see that `apply` is really useful for initializing an object and `let` is useful for essentially summarizing an object or doing some operations with it

### Inlines

Every time we call a lambda Kotlin creates a new lambda object instance, there can be a lot of overhead to create the function instance. We can instead use `inline` to tell the compiler to inline a function call where it is used (similar to C++)

We can define an inline function by simply adding the `inline` keyword before `fun`:

```kotlin
inline fun addStuff(x: Int, y: Int): Int {
    return x + y
}
```

## Single Abstract Method (SAM)

SAMs are essentially interfaces with a single methods on them

In Kotlin we can pass lambdas to Java functions that require SAMs

## OOP

### Create a Class

We typically organize classes into packages. `Right Click on src > New Package` then you can fill in the package name. Thereafter create a new Kotlin file in the package directory

You can define a new class with the `class` keyword. A class name typically defines the class name. A function does not need to have a body to be valid:

```kotlin
package Functionality

class House
```

We can add properties to the `House` class with:

```kotlin
package Functionality

class House {
    val size = 1200
    val rooms = 3
    val garages = 2
}
```

Using this means that the properties in our class are constants

We can then create an instance of a house and read its properties with:

```kotlin
val house = House()
val size = house.size
```

Kotlin automatically creates getters and setters for properties

To make properties changeable we can change `val` to `var`

We can also create a custom getter like so:

```kotlin
val price : Int
    get() = size + rooms + garages
```

By default everything is public

We can also create a default constructor which will set the initial values in the parenthesis of the class declaration

```kotlin
class House (
    val size: Int = 1200,
    val rooms: Int = 3,
    val garages: Int = 2
) {
    val price : Int
        get() = size + rooms + garages
}
```

Additional constructors can be created as well using the `constructor` keyword in the class, such as this one:

```kotlin
class House (
    var size: Int = 1200,
    var rooms: Int = 3,
    var garages: Int = 2
) {
    val price : Int
        get() = size + rooms + garages

    constructor(kind: Int): this() {
        size = kind * 3
        rooms = kind * 2
        garages = kind
    }
}
```

The new constructor must make a call a constructor with `this()`, we can also set the parameters like so:

```kotlin
class House (
    val size: Int = 1200,
    val rooms: Int = 3,
    val garages: Int = 2
) {
    val price : Int
        get() = size + rooms + garages

    constructor(kind: Int): this(
        kind * 3,
        kind * 2,
        kind
    )
}
```

We can also place logic for a default constructor in the `init` block, for example:

```kotlin
class House (
    val rooms: Int = 3,
    val garages: Int = 2,
    isFancy: Boolean
) {
    val size: Int
    init {
        size = if (isFancy) rooms * 1000
               else rooms * 500
    }

    val price : Int
        get() = size + rooms + garages

    constructor(kind: Int): this(
        kind * 3,
        kind * 2,
        false
    )
}
```

We can have multiple `init` blocks they are executed in the order they are defined in the class

```kotlin
class MyClass {
    init {
        println("I run before any properties are initiailzed")
    }

    val size = 12

    init {
        println("I run after size is initialized")
    }

    val height = 14

    init {
        println("I'll run last")
    }
}
```

> In Kotlin we typically try to avoid using multiple constructors, if we need to do something like that we will create a helper function outside our class that we can use to set up a constructor

### Inheritence

The default class inherits from `Any`, however to inherit from a class we use the word `open` to say that a class or property can be inherited or overriden

```kotlin
open class House (...) {
    ...

    open val price : Int
        get() = size + rooms + garages

    ...
}

```

We can create a new class called `FancyHouse` like:

```kotlin
class FancyHouse(
    val pools: Int = 1,
    rooms: Int,
    garages: Int
): House(rooms, garages, isFancy = true) {
    override val price: Int
        get() = (size + rooms + garages + pools) * 2
}
```

### Interfaces

Kotlin allows us two forms of inheritence: Interfaces and Abstracts. Interfaces cannot have a constructor or any logic

Interfaces use the `interface` keyword and can essentially only define the signatures for the different properties

```kotlin
interface ICanRenovate {
    var rooms: Int
    var garages: Int
    fun extend(roomsToAdd: Int, garagesToAdd: Int)
}
```

Next we can inherit from the `ICanRenovate` class in our `House` class. this requires us to set implementations for the `rooms`, `garages`, and `extend` properties and add `ICanRenovate` after the constructor params

```kotlin
open class House (
    override var rooms: Int = 3,
    override var garages: Int = 2,
    isFancy: Boolean
): ICanRenovate {
    val size: Int
    init {
        size = if (isFancy) rooms * 1000
               else rooms * 500
    }

    override fun extend(roomsToAdd: Int, garagesToAdd: Int) {
        rooms += roomsToAdd
        garages += garagesToAdd
    }

    open val price : Int
        get() = size + rooms + garages

    constructor(kind: Int): this(
        kind * 3,
        kind * 2,
        false
    )
}
```

### Abstract

We can add an abstract class for some predefined functionality, let's create one called `Livable` with a population

```kotlin
abstract class Livable() {
    abstract val population: Int
}
```

The `abstract` keyword for the `population` property allows it to be overriden when inherited

We can then update our `House` class to include this with:

```kotlin
open class House (
    override var rooms: Int = 3,
    override var garages: Int = 2,
    isFancy: Boolean
): Livable(), ICanRenovate {
    override val population: Int = 4
    ...
}
```

The house class now has the `population` property as well as a result of the inheritance

### Using Inherited Classes

We can specify the inherited classes as parameters to functions where we would like to use some specific functionality, for example in a function where we want to use the `extend` function we can just ask for `ICanRenovate`

```kotlin
fun extendItem(item: ICanRenovate) = item.extend(1, 1)
```

Kotlin also allows you to define preset classes that can be delegated for inheritence which allows us to implement certain functionality in an instance that can be reused

### Singletons

We can create a class that can only have a single instance with the `object` keyword -> AKA singleton

We can create an Interface called `IHasColour` with a `colour` property

```kotlin
interface IHasColour {
    val colour: String
}
```

An object called `HouseColour` can then implement that interface and set the implementation for it

```kotlin
object HouseColour: IHasColour {
    override val colour: String = "Beige"
}
```

We can then update a class to implement this functionality using the `Interface by Singleton` structure in the definition

```kotlin
open class House (
    ...
): Livable(), ICanRenovate, IHasColour by HouseColour {
    ...
}
```

Interface delegation allows us to use composition to plug in select functionality and should be considered for the kinds of usecases that we would use abstract classes for in other languages

### Data Classes

Often we have classes that are defined just for storing data, we can use a `data` class in Kotlin for doing that

```kotlin
data class Address(val number: Int, val street: String)
```

The `data` class has an automatic `toString` and `equals` method for proper equality checking as well as the `copy` method which can copy objects

We can also decompose the values from the class using the following syntax:

```kotlin
val postal = Address(24, "Fun Street")
val ( postalNumber, postalStreet ) = postal
```

> The number of values in the decomposition must match the number of properties and are defined based on the order they are in the class

### Enums

In Kotlin Enums are defined using the `enum` keyword and they can haver properties and methods

```kotlin
enum class Suburb {
    SUB_1,
    SUB_2,
    SUB_3
}
```

### Sealed Class

A sealed class is a class that can only be used within the same file. These classes are static at compile time as well as all its references this means that the compiler can do additional safety checking that wouldn't otherwise be possible

## Extenstion Methods

Extension methods are functions that extend functionality of a class without modifying the class itself. Inside of the function `this` refers to the current object instance

We can declare the function using the dot notation for a function name. For example we can create an extension of `String` with:

```kotlin
fun String.hasSpaces(): Boolean {
    return this.find { it == ' ' } != null
}

"Hello World".hasSpaces() // true
```

We can also leave out the `this` if there is no ambiguity in the scope, as well as make this a single line

```kotlin
fun String.hasSpaces() = find { it == ' ' } != null
```

These functions don't have access to private members and are based on only on private members

Extension functions can also be used on getters and setters for properties, for example:

```kotlin
val String.isApple: Boolean
    get() = this == "Apple"
```

### Generic Classes

Kotlin also allows us to create generics using a similar notation to other languages, such as `MyClass<T>` which is a generic Class of `T`, we can also do the same for function arguments

```kotlin
class MyClass<T>(val propKey: String, val propVal: T)
```

We can create an instance of the class with:

```kotlin
val myData = MyClass<Int>("hello", 12)
```

Additionally we can also create Generic Function with:

```kotlin
fun <T> printAndReturn(data: T): T {
    println(data)
    return data
}
```

And the function can be called with either an inferred or explicit type:

```kotlin
printAndReturn("hello")
printAndReturn<String>("hello")
```

By default T is nullable, if we want to be non-nullable we can specify it with the `Any` type:

```kotlin
class MyClass<T: Any>(val propKey: String, val propVal: T: Any)
```

We can alternatively specify a base class to use as well, for example say we have a class `MyClass` that other elemens have extended, we can do something more like:

```kotlin
class MyNewClass<T: MyClass>(
    val propKey: String, val propVal: T: MyClass
)
```

We can also define `in` which can only be passed into something and `out` types which can only be returned as a result of a function or passed into a constructor.

```kotlin
class MyNewClass<in T: MyClass>( ... )
```

We can also define an `out` type using the same kind of notation

> The IDE should point out when these are needed though

Sometimes you may need to tell the compiler that a type is a real type, this does something with the runtime that I don't completely understand but essentially you need to use `inline` before the function and `reified` before the types if you want to access the types themselves:

```kotlin
inline fun <reified T: MyClass> isTypeValid(data: MyClass)
    = data is T
```

We can use generics for extension methods as well

## Annotations

Annotations are used by the compiler and many are supplied with the language itself and are generally used when interoperating with Java

Annotations come before the thing that is annotated

Below we can see a class definition for the most basic annotation. It doesn't do much other than be annotated

```kotlin
annotation class ImAnnotated

@ImAnnotated
class MyClass
```

If an annotation is targeting a property we can specify if it is only allowed to be used on getters or setters

```kotlin
annotation class ImAnnotated

@Target(AnnotationTarget.PROPERTY_GETTER)
annotation class OnGet

@Target(AnnotationTarget.PROPERTY_SETTER)
annotation class OnSet

@ImAnnotated
class MyClass {
    @get: OnGet
    val data1: Int = 0

    @set: OnSet
    var data2: Int = 0
}
```

## Labelled Breaks

These allow us to break out of a loop in a more controlled manner by breaking out to the block outside of the label, they are defined with `@labelName`

```kotlin
mainLoop@for (i in 1..100) {
    for (j in 1..10) {
        if (i > 10) break@mainLoop
        else println("i: $i, j: $j")
    }
}
```

The code above will run until `i > 10` and then completely exit both for loops, normally we would do something like this with two breaks for example to break out of each loop individually
