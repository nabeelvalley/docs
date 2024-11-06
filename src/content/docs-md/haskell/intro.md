---
title: Intro to Haskell
description: Haskell learning note
---

> Notes based on [Learn you a Haskell](https://learnyouahaskell.com/)

# Prerequisites

Setup a Haskell Environment as per the [Getting Started Docs](https://www.haskell.org/get-started) as well as install the Haskell extension for your editor

> This installation process is a little slow, but stay with it I guess. (it's still easier than the Ocaml install)

# Syntax Basics

To write the first bits of Haskell we can use the REPL which, once installed, can be accessed with the `ghci` command

Math can be done in a fairly normal fashion:

```haskell
gchi> 5 + 17
22

gchi> 5 * 42
210

gchi> 5 / 2
2.5
```

And booleans similarly:

```haskell
ghci> True && False
False

gchi> not False
True
```

And equality:

```haskell
ghci> 5 == 5
True

gchi> 5 == 10
False

gchi> 5 /= 10
True

gchi> "hello" /= "world"
True
```

All these basic operators are functions in Haskell that work using infix notation. We can also refer to them purely as a function by wrapping them in brackets, e.g. `(+)` or `(==)`

Functions can be called using the name of the function followed by the arguments, separated by spaces

```haskell
gchi> succ 5
6
```

Or with multiple arguments

```haskell
ghci> min 9 10
9
```

If a function takes two parameters we can call it using infix notation with backticks surrounding the function name, for example the `min` function:

```haskell
ghci> 9 `min` 10
9
```

## Functions

We can define our own functions using a syntax like:

```haskell title="double.hs"
doubleMe x = x + x
```

We can put that into a file, e.g. called `double.hs`, and load it into the REPL with `:l`:

```haskell
ghci> :l double
[1 of 2] Compiling Main             ( double.hs, interpreted )
Ok, one module loaded.
```

We can then use the function that was defined

```haskell
ghci> doubleMe 5
10
```

A function that takes multiple arguments can be defined by separating the arguments by a space

```haskell title="double.hs"
doubleMe x = x + x

doubleUs x y = doubleMe x + doubleMe y
```

In the above cases, Haskell is able to determine the types of our function as: `doubleUs:: Num a => a -> a -> a`

We can make a function that does some conditional stuff using then`if .. then .. else` expression

```haskell title="double.hs"
doubleSmall x =
  if x < 100
    then x * 2
    else x
```

> Note this is not whitespace sensitive

Functions that take no parameters are also called definitions or names, we can defined a function that is equal to some string value as follows:

```haskell
bobsName = "Bob Smith"
```

> Function names must start with a lowercase letter and can contain a `'`, e.g. `bob'sName = "BobSmith"`

## Lists

Lists store elements of the same type. Lists can be defined using `[]` with elements separated by commas

```haskell
myList = [1, 2, 3, 4]
```

They can also be concattenated with `++`

```haskell
biggerList = [1, 2, 3, 4] ++ [5, 6]
```

`++` can also be used with strings:

```haskell
"hello" ++ " " ++ "world"
```

When concatenating elements Haskell needs to traverse the entire list which can negatively impact performance. An alternative way of adding an item to a list is the the cons (`:`) operator:

```haskell
ghci> 1 : [2, 3, 4]
```

Elements can be accessed from a list using `!!`

```haskell
ghci> [1, 2, 3, 4] !! 2
3
```

Lists can also be compared. Comparison of lists are done item by item, for example a list

```haskell
ghci> [1,2,3] > [4,5,6]
False
ghci> [1,2,3] > [0,1,2]
True
```

Some functions for working with lists are:

- `head` - gets the first item
- `tail` - gets everything other than the first element
- `last` - gets the last item
- `init` - gets everything other than the last element
- `length` - gets the length of a list
- `null` - checks if the list is empty
- `reverse` - reverses a list
- `take` - takes a certain number of elements from a list
- `drop` - drops a certain number of elements from a list
- `minimum` - gets the smallest element of a list
- `maximum` - gets the largest element of a list
- `sum` - adds up items of a list
- `product` - multiplies all numbers in a list
- `elem` - checks if an element is in a list, usually called as an infix method since it's more readable that way
- `replicate` - produces a list by repeating some value a certain number of times

Calling `head`, `tail`, `last`, or `init` on an empty list will throw an error

## Ranges

Ranges allow us to define sequences of enumerable values. Ranges can be defined using a start and end value

```haskell
ghci> [1..10]
[1,2,3,4,5,6,7,8,9,10]

ghci> ['a'..'k']
"abcdefghijk"
```

They can even be defined using the first two values in the case where we want to use a step larger than 1 

```haskell 
ghci> [1,3..20]
[1,3,5,7,9,11,13,15,17,19]

ghci> ['a','d'..'z']
"adgjmpsvy"
```

Additionally, ranges can also be infinite by not specifying the end of the range. We can see the result of doing this by taking some elements from the range as below:

```haskell 
ghci> take 10 [1..]
[1,2,3,4,5,6,7,8,9,10]

ghci> take 30 ['a'..]
"abcdefghijklmnopqrstuvwxyz{|}~"
```

There are also a few useful functions for working with ranges such as:

- `cycle` - which repeats the elements of a given list to produce an infinite range
- `repeat` - creates an infinite range of a repeated value

## List Comprehensions

List comprehensions are like __Set Comprehensions__ in math and allow us to define some general sets using a set of predicates

A set comprehension follows the structure of `[ expression | variable <- values, predicate]`. This is more clear in practice:

```haskell
ghci> [x^3 - 1 | x <- [1..5]]
[0,7,26,63,124]

ghci> [x^3 - 1 | x <- [1..10], x `mod` 2 == 0]
[7,63,215,511,999]

ghci> [x^3 - 1 | x <- [1..10], x `mod` 2 /= 0]
[0,26,124,342,728]
```

These can also be used with multiple variables in order to produce permutations of a multi-variable expression 

```haskell 
ghci> [a ++ " " ++ b | a <- ["hello", "hi"], b <- ["world", "bob"]]
["hello world","hello bob","hi world","hi bob"]
```

## Tuples 

Tuples work pretty much the same as in other languages. A tuple lets us store multiple values together. Items in a tuple can be different types, we can use this as we'd expect

```haskell 
ghci> (1, 'a')
(1,'a')

ghci> [(1, 'a'), (2, 'b')]
[(1,'a'),(2,'b')]

ghci> [(x, y) | x <- [1..3], y <- ['a'..'c']]
[(1,'a'),(1,'b'),(1,'c'),(2,'a'),(2,'b'),(2,'c'),(3,'a'),(3,'b'),(3,'c')]
```

When a tuple has only two elements we refer to it as a `pair`. Pairs have some methods for working with them, namely:

- `fst` - gets the first item from a tuple 
- `snd` - gets the second item from a tuple 

It's not too difficult to implement these functions, an example implementation may look like so:

```haskell
fst' (x,_) = x

snd' (_,y) = y
```

And we can compare our usage with the base implementation

```haskell
ghci> fst' (1,2)
1
ghci> snd' (1,2)
2

ghci> fst (1,2)
1
ghci> snd (1,2)
2
```

Another nice function for working with tuples is `zip` which takes two lists and iterates over them and outputs a list of tuples 


```haskell
ghci> zip [1,2,3] ['a','b','c']
[(1,'a'),(2,'b'),(3,'c')]
```

# Types 

Haskell is statically typed. Thus far we haven't had to annotate the types of our functions since the language is pretty good at inferring the types of stuff 

We can use `:t` in the REPL to view the type of something

```haskell
ghci> :t 5
5 :: Num a => a

ghci> :t 'b'
'b' :: Char

ghci> :t "Hello"
"Hello" :: String
```

We can specify the types of a function by writing it above a function implementation, for example:

```haskell
doubleMe :: Int -> Int
doubleMe x = x + x
```

## Type Variables 

We can look at the types of some more complex values

```haskell
ghci> :t fst
fst :: (a, b) -> a

ghci> :t (+)
(+) :: Num a => a -> a -> a

ghci> :t (==)
(==) :: Eq a => a -> a -> Bool
```

In the above functions, we can also see that some functions make use of a type variable, these types are denoted by the lowercase character in the type signature as in `fst :: (a, b) -> a`.

We can also see that functions can specify a constraint on their type variables, for example `(+) :: Num a => a -> a -> a` constrains `a` to be of type `Num`. The constraint is denoted before the `=>` symbol in a type definition

Lastly, it's also important to note that functions don't differentiate between multiple inputs an outputs. So a function that takes multiple input just uses `->` to separate values, this is because functions can partially apply them which yields another functions


## Type Classes

A typeclass is like an interface that defines some kind of behavior. (They seem a bit like traits in Rust)

Some common typeclasses are:

- `Eq` - which makes something comparable with `==` or `/=`
- `Ord` - used for ordering, makes something comparable with `>`, `<`, or `==`. So implementation of `Ord` requires `Eq` as well
- `Show` - means that something can be printed using `show`
- `Read` - means that something can be read from a `String` into some type with the `read` function

The `read` function is interesting because it lets us read a value into multiple different types. In cases where this type cannot be inferred you can specify the type that something needs to be read into using `:: Type` which lets us provide a value to a type variable

```haskell 
ghci> read "7" :: Int
7

ghci> read "7" :: Float
7.0

ghci> read "[1,2,3]" :: [Float]
[1.0,2.0,3.0]
```

Additionally, we also have some number types:

- `Num` - the base number type
- `Int` - a bounded integer 
- `Integer` - a non-bounded integer 
- `Float` - a single precision, floating point number
- `Double` - a double precision, floating point number 
- `Enum` - an enumerable value, these can be used in ranges 

When working with numbers the `fromIntegral` function can be used to convert between number types, namely swapping between floating point and integer number types which is sometimes needed


