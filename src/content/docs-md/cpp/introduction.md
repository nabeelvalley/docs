---
published: true
title: Introduction to C++
subtitle: Basic Concepts in the C++ Programming Language
---

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

## Operators

The available mathematical operators are as follows

```
+ - * / % =+ -= ++ -- *= /=
== != > < >= <= && || !
```

### Conditional Operators

COnditional Operators in C++ (aka Ternary Operators) take three values, the first of which is a condition, and the second or third are evaluated based on the result of the condition

```cpp
int i = 1, j = 2;
cout << ( i > j ? i : j ) << " is greater." << endl;
```

## Flow Control

### If Statements

C++ makes use of boolean operators in order to build `if` statements

```cpp
char test = 'y';
if (test == 'y')
{
    out << "test is y" << endl;
}
```

If there is only a single statement we can leave out the curly brackets

```cpp
char test = 'y'
if (test == 'y')
    out << "test is y" << endl;
```

We can also use `else if` and `else`

```cpp
char test = 'y';
if (test == 'y')
{
    out << "test is y" << endl;
}
else if (test == 'n')
{
    out << "test is n" << endl;
}
else
{
    out << "test is something else" << endl;
}
```

### Switch Statements

We can use these when the case of complex `if-else` statements

```cpp
char test = 'y';
switch (test)
{
    case 'y':
        out << "test is y" << endl;
        break;
    case 'N':
        out << "test is N" << endl;
        break
    case 'n':
        out << "test is n" << endl;
        break;
    default:
        out << "test is something else" << endl;
        break
}
```

Switch operators support `intrisic` data types and `enums`

### For Loops

For loops look like this:

```cpp
int oldNumbers[] = {1,2,3,4,5};
for (int i = 0; i < 5; i++)
{
    int currentNumber = oldNumbers[i]
}
```

The loop is made of the general structure of:

```cpp
for (initialization; continueCondition; iterator)
{
    // stuff to do
}
```

### While Loops

While loops follow the traditional `C-type` syntax

```cpp
while (condition)
{
    // do some stuff
}
```

For example:

```cpp
int i {0};
while (i < 5)
{
    i ++;
    // do stuff
}
```

If the condition is not initally met, the loop will not run

### Do-While Loops

A `do-while` loop is like a `while` loop but the condition is checked at the end of the loop, and will hence always run at least once

```cpp
do
{
    // do some stuff
} while (condition);
```

> Note the semicolon at the end

## Functions

Functions are defined by Name, Return Type, and Arguments. Functions with the same Name and Return type but different numbers arguments are allowed, the compiler will figure out which one you are trying to use based on the number of arguments

The compiler must know about a function before it can be called

```cpp
int Sum(int x, int y)
{
    int sum {x + y}
    return sum
}
```

### Prototypes

A complete function signature/prototype consists of the following

- Storage class
- Return type
- Name
- Parameters

Function prototypes need to be defined in a header file, Header files are imported into source code files so that the compiler can ensure proper use of functions, etc.

The prototype does not consist of the function implementation code

A function prorotype is defined as follows

```cpp
int Sum(int x, int y);
```

By default data is passed to functions by value and not by reference

### Inline Functions

Inline functions are functions that are are essentially pieces of code that the compiler will inject into the place where it is being called instead of making a function call

This can be used to reduce some of the overhead that would be associated with using a normal function

These are better suited for small functions that are used frequeltly and make use of the `inline` keyword

```cpp
inline void swap(int & a, int & b)
{
    int temp = a;
    a = b;
    b = temp;
}
```

### Storage Classes and Scope

> "A storage class in the context of C++ variable declarations is a type specifier that governs the lifetime, linkage, and memory location of objects"

This means that it governs how long an object remains in memory, in what scopes it is visible and whether it should be located in a stack or heap

Some keywords that apply to storage classes are:

- `static`
- `extern`
- `thread_local`

If we do not state the function prototype on the file we try to use it we will get a **compiler** error, if we state the prototype but that function cannot be found we will get a **linker** error

The reason for this is because each individual file is compiled separately

In order to avoid declaring prototypes in each file, you can create a `header` file and define shared prototypes there, and include the header file, this can be done simply as follows

`Math.cpp`

```cpp
int AddTwo(int i)
{
    return i + 2;
}
```

`Utilities.h`

```cpp
int AddTwo(int i);
```

`Main.cpp`

```cpp
#include "Utilities.h"

int main()
{
    int i { addTwo(1) };
    return 0;
}
```

## Classes

### Definition

Classes are definitions for custom types and defines the behaviour and characteristics of a type

We can define a Rectangle with the `class` keyword

```cpp
class Rectangle
{
    public:
        int _width;
        int _height;
};
```

> Class definitions must end with a `;`

Members can be accessed with `dot` notation

### Initialization

We can create a new instance of a class using a few different methods

```cpp
void main()
{
    Rectangle aShape; // Uninitialized - don't do this

    myShape._width = 5;
    myShape._height = 3;

    Rectangle defaultShape{} // Default initialized

    Rectangle myRectangle {0, 0} // Specific initalized
}
```

> Uninitialized values will have junk data, don't do this

### Encapsulation

Encapsulation is used to describe accesibility of class members, this is used to restrict the way in which class data can be manipulated

Functions in a class have access to the instance of the class `this` which is a pointer. `this` is used to remove ambiguity betwen member variables and is not always necessary

We cannot directly access private members from outside of a class

A class can be defined in a header file or have some aspects of it's functionality (or all) be placed into separate `.cpp` files

`Rectangle.h`

```cpp
class Rectangle
{
public:
	int GetWidth() { return _width; }
	int GetHeight() { return _height; }

private:
	int _width;
	int _height;
};
```

### Constructors

Muliple constructors can be created with different parameters, the compiler will figure out which one to use for a specific instance based on the input arguments, we can see a lot of different examples [here](https://docs.microsoft.com/en-us/cpp/cpp/constructors-cpp?view=vs-2019)

```cpp
class Rectangle
{
public:
	Rectangle() : _width{ 1 }, _height{ 1 } {}
	Rectangle(int width, int height) : _width{ width }, _height{ height } {}

	int GetWidth() { return _width; }
	int GetHeight() { return _height; }

private:
	int _width;
	int _height;
};
```

If a default constructor is not define the compuler will provide an implicit `inline` instance

Additionally we can add default values for the properties of a class

```cpp
class Rectangle
{
public:
	Rectangle() : _width{ 1 }, _height{ 1 } {}
	Rectangle(int width, int height) : _width{ width }, _height{ height } {}

	int GetWidth() { return _width; }
	int GetHeight() { return _height; }

private:
	int _width{ 1 };
	int _height{ 1 };
};
```

We can also remove some parts of functionality away from our class definition into a `.cpp` file

`Rectangle.h`

```cpp
class Rectangle
{
public:
	Rectangle();
	Rectangle(int width, int height);

	int GetWidth();
	int GetHeight();

private:
	int _width{ 1 };
	int _height{ 1 };
};
```

`Rectangle.cpp`

```cpp
#include "Rectangle.h"

Rectangle::Rectangle() : _width{ 1 }, _height{ 1 } {}
Rectangle::Rectangle(int width, int height) : _width{ width }, _height{ height } {}

int Rectangle::GetWidth() { return _width; }
int Rectangle::GetHeight() { return _height; }
```

## Immutable Objects

We can create `const` objects but we need to also explicitly define member functions that will not modify the object as `const` as well

```cpp
int Rectangle::GetArea() const
{
    //implementation
}
```

And then create Rectangles and use the function as normal

```cpp
int main()
{
    const Rectangle myRectangle{};
    const area = myRectangle.GetArea();
}
```
