---
published: true
title: Introduction to C
subtitle: Basic Concepts in the C Programming Language
---

> Notes from [this YouTube Series](https://www.youtube.com/watch?v=CPjZKsUYSXg)

# Prerequisites

In order to write some C we need to have a few things set up

- To keep things simple just use a Linux computer, if you want to be fancy you can use WSL for Windows or a VSCode Remote Dev Linux Computer - same same
- Install a C Compiler - you can use [GCC](https://gcc.gnu.org/) and install it with:

```
sudo apt update
sudo apt install build-essential
```

Validate your installation with

```
gcc --version
```

If you'd like to use a VSCode Dev Container for that, here you go:

```dockerfile
FROM mcr.microsoft.com/vscode/devcontainers/base:0-ubuntu-18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get -y install --no-install-recommends\
  build-essential \
  # Clean up
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog
```

# Hello World

Let's create a file called `hello.c` with the following:

`hello.c`

```c
#include <stdio.h>

int main()
{
  printf("Hello, World!\n");

  return 0;
}
```

We can compile this file using `gcc hello.c` which will create an `a.out` file, and then run the file using `./a.out`

- The `main` function is the entrypoint and it should return an `int`, `0 = OK`.
- We use `#include <stdio.h>` so that we can use the Standard I.O. library, we need this so we can `printf`
- Each statement needs to end with a `;`

# Variables

To create variables you can use the following syntax will create an `int`:

```c
int x;
x = 7;

int y = 5;
```

If we want to do a type casting we use the `(mytype)` before the specific variable we want to case. If we are working with `int`s for a calculation, without casting the result will be an int:

```c
int x = 2;
int y = 3;

double z = y / x; // 1.0000
```

Versus using correct casting for at least one of the values we get the correct data type:

```c
int z = (double) y / x; // 1.500
```

## Variable Names

Variable names should be limited to:

- `A-z`
- `a-z`
- `0-9`
- `_`

And should not start with a number

# Printing

In order to print in C we can use the `printf` function. When printing we make use of a formatting string, such as `%i` to print an int or `%s` to print a string

```c
int x = 5;
printf("%i", x);
```

# Read Input

To read input we make use of the `scanf` function which will scan user input into a variable

```c
int radius

scanf("%i", &radius)
```

The `&` is the `address of` function, which will allow the function to modify the `radius` variable, here's an example of using `scanf`

```c
#include <stdio.h>

int main()
{
  int radius;

  printf("Please enter a radius for your circle\n");

  scanf("%i", &radius);

  double circumference = 3.14 * 2 * radius;

  printf("Your Curcumferance is: %f\n", circumference);

  return 0;
}
```

> In C if we make assign an `int` to a value that's actualy a `float` or `double` it gets truncated to an `int`

If we want to read the value into a string (`char[]` or array in general), we don't make use of the `&` operator:

```c
printf("Please enter your name: ");

char name[21];
scanf("%s", name); // note - there is no &

printf("Hello, %s!\n", name);
```

> When taking in a string like above we cannot receive spaces using `scanf`

# Comments

Commenting code can be dome using `//` for single line comments or `/* ..... */` for multi line comments

# Data Types

Some of the data types in C are:

- `int` - whole numbers
- `double` - double prevision decimal number, usually use this
- `float` - decimal number, use less memory, can explicitly define this with the `f` at the end of the number
- `char` - denoted by a single quote

Floating Point numbers are stored using scientific notation in memory. To define a value using scientific notation we can do this:

```c
int bigNum = 1.2e5;
double smallNum = 1.2e-2;

printf("bigNum: %i\nsmallNum: %f\n", bigNum, smallNum);
```

Arrays allow us to store groups of data and are identified using `[]`. The `string` data type in C is based on a `char[]` which use double quotes when defining. It needs to be noted that the string needs a termination character which is a `\0` (you don't have to type this yourself)

## Conversion Characters

For reading text into other data types we make use of conversion characters:

- `%i` - int
- `%c` - char
- `%s` - string
- `%f` - decimal
- `%e` - scientific notation
- `%g` - displays scientific or decimal based on the size of the exponent

We can use all of the above with the `printf` function, however when scanning in data we use`%lf` - double as scientific or decimal

## Char

> C uses the ASCII Character Set using `7` bits, `8` bits would be the extended character set

The `char` datatype stores characters (duh) and they are denoted by surrounding them in single quotes like: `'a'`

To create a new character we can do something like this:

```c
char myA = 'A';

printf("%c", myA);
```

We can also display the character as an `int` using `%i`:

```c
char myA = 'A';

printf("%c", myA);
```

> The range of `char` values is `0 - 127`

## Strings

A string is a sequence of characters and is denoted using `"..."`. To declare a string we make use of a `char[]` like so:

```c
char name[] = "Nabeel";
```

If we want to define a character array without knowing the number of characters needed in advance we need to state the length of the string. We need to make sure we give it one more character than we need as it needs a character to store the "string end" character

```c
char name[11]; // note this will only store 10 characters
```

## Boolean

Boolean data can be set using the `_Bool` data type

```c
_Bool isFalse = 0;
_Bool isTrue = 1; // we can use  any number other than `0` here
```

We can also enable the `true` and `false` keywords as well as the `bool` type by including `stdbool.h`

```c
#include <stdio.h>
#include <stdbool.h>

int main()
{
  bool isTrue = true;
  printf("%i\n", isTrue);

  return 0;
}
```

# Operators

Some of the basic operators in C are:

## Arithmetic

- `+` add
- `-` subtract
- `*` multiply
- `/` divide
- `&` modulus
- `++` increment
- `--` decrement

## Relational

- `==` equality
- `!=` inequality
- `>` greater that
- `<` less than
- `>=` greater than or equal
- `<=` less than or equal

## Logical

- `&&` and
- `||` or
- `!`

## Assignment

- `=` assign
- `+=` add and assign
- `-=` subtract and assign
- `*=` multiply and assign
- `/=` divide and assign
- `%=` mod and assign

> And then a bunch of bitwise ones that' I'll likely never use
