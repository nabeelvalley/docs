# Introduction to C++

[Based on this EdX Course](https://courses.edx.org/courses/course-v1:Microsoft+DEV210x+1T2019a/course/)

## Basic Structure

A C++ program has a specific structure in terms of how it's written

```cpp
#include <iostream>

int main()
{
    std::cout << "Hello World!";
    return 0;
}
```

We can import libraries using the `#include` preprocessor directive, in this case `iostream` that allows input and output to things like the console window

Each program must have a method main in this case which returns an `int`

C++ makes use of curly braces for containing code blocks as well as semicolons to denote the end of a statement

The `std::` part indicates that `cout` is part of the `std` namespace

Lastly, we can return values from a method using the `return` statement

## Compilation

C++ code needs to be compiled. This is preprocessed > compiled > linked. The compiler checks the syntax, etc.

Once the compiler has completed its tasks the linker is involved in taking all the object files and linking them together into an executable

## Language overview

### Formatting

C++ is case sensitive and consits of a few different additional elements

- Preprocessor directives
- Using directives
- Function headers have a return type, name, and params
- Function bodies contain statements
- Comments
- A return statement at the end of functions
- Curly braces to block things together

> The compiler ignores whitespace for the most part with some exceptions such as `if` statements

### Statements

C++ makes use of a variety of different statements, such as

- Declarations
- Assignments
- Preprocessor directives
- Comments
- Function declarations
- Executable statements (note the `hello world` above)

### Types

C++ has lot of different data types built in - non-standard types start with an `_`

C++ is strongly typed,it has some built in types as well as user-defined types. We can also change types with by casting data from one type into another

Doing something like assigning an `int` to a `float` will lead to truncation

Assigning a `non-bool` to a `bool` will lead to pretty much anything besides `0`

## Variables

You can create a variable using the following syntacxes in which a variable is initialised and defined

```cpp
int myVar = 0;
int myOtherVar{0};
```

### Constants

Constants are named memory locations and their value does not change during runtime. They must be assigned values when initialised

```cpp
const int i { 1 };
int const j { 2 };
const int k = 3;
int const l = 4;
```

### Casting

We can cast variables from one data type to another. Sometimes these may lead to a loss of data and other times not

```cpp
int myInt = 12;
long myLong;
myLong = myInt;
```

We can also explicitly cast variables using any of the following methods

```cpp
long myLong = (long) myInt;
long myLong = long(myInt);
long myLong = static_cast<long>(myInt);
```

Beware the integer division, we can use something like the `auto` type which will automatically detect the type, but the data is still strongly typed

```cpp
auto = 3 / 2; // int
auto j = 3.0 / 2; //double
```

## Arrays

C++ provides support for complex data types, referred to as compound data types as they usually store more than one piece of data

Arrays in C++ need to be defined using the type and size of the array, or by initializing the array or some of its elements

```cpp
int myArray[10];
int myArray[] = {0,1,2,3,4,5,6,7,8,9};
int myArray[10] = {1,2,3}; //initialize some values
```

We can access a value in an array using `[]` syntax

```
int newNum = myArray[2];
```

> Arrays are 0-indexed as usual

In C++ an array is simply a pointer to a memory location and accessing an index that is not in the range of the array will return some random value - the next value in memory

## For Loops

For loops look like this:

```cpp
int oldNumbers[] = {1,2,3,4,5};
for (int i = 0; i < 5; i++)
{
    int currentNumber = oldNumbers[i]
}
```

That's about all I'm going to say about for-loops for now

## Strings

Strings are an array of characters, a string must end with the `\0` (`null`) character in order to tell the compiler where it ends

```cpp
char myString[6] = {'H','e','l','l','o','\0'};
```

A `char` array must always be one character longer than necessary in order to store the `\0`

Practically though you can also define an array using a string literal

```cpp
char myString[] = "Hello";
```

Using the above method the compiler will infer the length of the string, note that if explicitly defining the length you must leave space for the `\0` character

```cpp
char myString[6] = "12345";
```

There is also a string class which can be used, this will need to be referenced in the header file and can be used as follows

```cpp
using namespace std;

string myString = "Hello";
std::string newString = "Bye";
```

## Structures

Structs allow us to store more complex information as a compound data type. They are known as user-defined types

```cpp
struct person
{
    string name;
    string surname;
    int age;
};
```

We can then make use of the `struct` in a couple of different ways

```cpp
person john = {"John", "Smith", 20};
person jenny;

jenny.name = "Jenny";
jenny.surname = "Smith";
jenny.age = 23;

cout << john.name << endl;
```

As seen above, properties can be accessed or assigned using the dot notation

## Unions

Unions are like structs but can only data in one of it's fields at a time

```cpp
union particle
{
    int position;
    int speed;
};

particle myParticle;
myParticle.position = 5;
myParticle.speed = 10; // the position no longer has a value
```

Unions are useful for working with memory-limited devices

## Enumerables

Enums are a means of creating symbolic constants, by default these values will start at 0 but we can define them to start at a different number

```cpp
enum Day {Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday};
```

> Sunday == 0, Monday == 1, etc.

Or we can start at 1 and have each day be the human number

```cpp
enum Day {Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday};

Day sadDay = Monday; // 2
```
