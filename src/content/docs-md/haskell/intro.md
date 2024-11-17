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

```hs
gchi> 5 + 17
22

gchi> 5 * 42
210

gchi> 5 / 2
2.5
```

And booleans similarly:

```hs
ghci> True && False
False

gchi> not False
True
```

And equality:

```hs
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

```hs
gchi> succ 5
6
```

Or with multiple arguments

```hs
ghci> min 9 10
9
```

If a function takes two parameters we can call it using infix notation with backticks surrounding the function name, for example the `min` function:

```hs
ghci> 9 `min` 10
9
```

## Functions

We can define our own functions using a syntax like:

```hs title="double.hs"
doubleMe x = x + x
```

We can put that into a file, e.g. called `double.hs`, and load it into the REPL with `:l`:

```hs
ghci> :l double
[1 of 2] Compiling Main             ( double.hs, interpreted )
Ok, one module loaded.
```

We can then use the function that was defined

```hs
ghci> doubleMe 5
10
```

A function that takes multiple arguments can be defined by separating the arguments by a space

```hs title="double.hs"
doubleMe x = x + x

doubleUs x y = doubleMe x + doubleMe y
```

In the above cases, Haskell is able to determine the types of our function as: `doubleUs:: Num a => a -> a -> a`

We can make a function that does some conditional stuff using then`if .. then .. else` expression

```hs title="double.hs"
doubleSmall x =
  if x < 100
    then x * 2
    else x
```

> Note this is not whitespace sensitive

Functions that take no parameters are also called definitions or names, we can defined a function that is equal to some string value as follows:

```hs
bobsName = "Bob Smith"
```

> Function names must start with a lowercase letter and can contain a `'`, e.g. `bob'sName = "BobSmith"`

## Lists

Lists store elements of the same type. Lists can be defined using `[]` with elements separated by commas

```hs
myList = [1, 2, 3, 4]
```

They can also be concattenated with `++`

```hs
biggerList = [1, 2, 3, 4] ++ [5, 6]
```

`++` can also be used with strings:

```hs
"hello" ++ " " ++ "world"
```

When concatenating elements Haskell needs to traverse the entire list which can negatively impact performance. An alternative way of adding an item to a list is the the cons (`:`) operator:

```hs
ghci> 1 : [2, 3, 4]
```

Elements can be accessed from a list using `!!`

```hs
ghci> [1, 2, 3, 4] !! 2
3
```

Lists can also be compared. Comparison of lists are done item by item, for example a list

```hs
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

```hs
ghci> [1..10]
[1,2,3,4,5,6,7,8,9,10]

ghci> ['a'..'k']
"abcdefghijk"
```

They can even be defined using the first two values in the case where we want to use a step larger than 1

```hs
ghci> [1,3..20]
[1,3,5,7,9,11,13,15,17,19]

ghci> ['a','d'..'z']
"adgjmpsvy"
```

Additionally, ranges can also be infinite by not specifying the end of the range. We can see the result of doing this by taking some elements from the range as below:

```hs
ghci> take 10 [1..]
[1,2,3,4,5,6,7,8,9,10]

ghci> take 30 ['a'..]
"abcdefghijklmnopqrstuvwxyz{|}~"
```

There are also a few useful functions for working with ranges such as:

- `cycle` - which repeats the elements of a given list to produce an infinite range
- `repeat` - creates an infinite range of a repeated value

## List Comprehensions

List comprehensions are like **Set Comprehensions** in math and allow us to define some general sets using a set of predicates

A set comprehension follows the structure of `[ expression | variable <- values, predicate]`. This is more clear in practice:

```hs
ghci> [x^3 - 1 | x <- [1..5]]
[0,7,26,63,124]

ghci> [x^3 - 1 | x <- [1..10], x `mod` 2 == 0]
[7,63,215,511,999]

ghci> [x^3 - 1 | x <- [1..10], x `mod` 2 /= 0]
[0,26,124,342,728]
```

These can also be used with multiple variables in order to produce permutations of a multi-variable expression

```hs
ghci> [a ++ " " ++ b | a <- ["hello", "hi"], b <- ["world", "bob"]]
["hello world","hello bob","hi world","hi bob"]
```

## Tuples

Tuples work pretty much the same as in other languages. A tuple lets us store multiple values together. Items in a tuple can be different types, we can use this as we'd expect

```hs
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

```hs
fst' (x,_) = x

snd' (_,y) = y
```

And we can compare our usage with the base implementation

```hs
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

```hs
ghci> zip [1,2,3] ['a','b','c']
[(1,'a'),(2,'b'),(3,'c')]
```

# Types

Haskell is statically typed. Thus far we haven't had to annotate the types of our functions since the language is pretty good at inferring the types of stuff

We can use `:t` in the REPL to view the type of something

```hs
ghci> :t 5
5 :: Num a => a

ghci> :t 'b'
'b' :: Char

ghci> :t "Hello"
"Hello" :: String
```

We can specify the types of a function by writing it above a function implementation, for example:

```hs
doubleMe :: Int -> Int
doubleMe x = x + x
```

## Type Variables

We can look at the types of some more complex values

```hs
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

```hs
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

# Functions

Functions in Haskell have some interesting functionality when compared to most other languages. The first of this is how we can define different implementations for functions using pattern matching

## Pattern Matching

Pattern matching when defining a function is done by essentially providing multiple implementations for a function that match to the same type signature but different concrete parameters. For example, the below function reacts differently depending on the `name` that is provided:

```hs
sayHi :: String -> String
sayHi "Bob" = "Good morning, sir!"
sayHi name = "Hello " ++ name
```

And when using this we can see how the inputs are handled:

```hs
ghci> sayHi "Jeff"
"Hello Jeff"

ghci> sayHi "Bob"
"Good morning, sir!"
```

We can use this idea to implement something like an implementation of the triangular number calculation that uses a but differentiating the recursive base case as a pattern

```hs
triangleNum :: (Integral a) => a -> a
triangleNum 0 = 0
triangleNum n = n + triangleNum (n - 1)
```

And we can use that to get the first 10 triangular numbers:

```hs
ghci> [triangleNum x | x <- [1..10]]
[1,3,6,10,15,21,28,36,45,55]
```

Pattern matching can also be done in more interesting ways, for example we can use it with tuples like so:

```hs
isFirstOne :: (Integral a, Integral b) => (a, b) -> String
isFirstOne (1, _) = "Yes"
isFirstOne (_, _) = "No"
```

And similarly for lists, for example:

```hs
tryFirstTwo :: [a] -> [a]
tryFirstTwo (x : y : xs) = [x, y]
tryFirstTwo (x : xs) = [x]
tryFirstTwo [] = []
```

When defining patterns, it's important to keep the most specific patterns first, since they are matched in order (the compiler will warn you if your order is incorrect so that's nice). Note that non-exhaustive patterns will be a runtime error so it's important to ensure that we handle these as well

Another nice benefit of pattern matching is that we can use it for destructuring elements, for example with a tuple

```hs
addPair :: (Num a) => (a, a) -> a
addPair (x, y) = x + y
```

## Guards

Guards allow us to branch based on a condition. They're very similar to `if/else` statements and are evaluated in order

A simple guard can check some conditions:

```hs
howBig num
  | num <= 0 = "Nothing really"
  | num < 1 = "Really small"
  | num >= 10 = "Wow that's a big number"
  | otherwise = "Nothing notable here"
```

## Where Bindings

Where bindings let us define local values within a function and can be done by using `where` with each binding on a different line:

```hs
f x = m * x + c
  where
    m = 10
    c = 20
```

These are also usually indented for readability

Where bindings can also pattern match just as we would when defining a function:

```hs
f x = m * x' + c
  where
    (m, c) = (10, 20)
    x' = sqrt x
```

## Let Expressions

These are very similar to where bindings but can be used anywhere and are expressions in themselves, the values in the `let` part are accessible in the `in` part

Otherwise, they work as you'd expect

```hs
f x =
    let
      m = 10
      c = 20
    in m * x + c
```

Or with pattern matching:

```hs
f x =
  let m = 10
      c = 20
      x' = sqrt x
   in m * x' + c
```

An important distinction is that let expressions can be used in any place where we may need an expression, and evaluate to the `in` part

```hs
f xs =
  [ let m = 10
        c = 20
     in m * x + c
    | x <- xs
  ]
```

You can even define functions in them, of course:

```hs
f xs =
  [ let f' x = 10 * x + 20
     in f' x
    | x <- xs
  ]
```

You can also use it in the predicate section of a list comprehension and do stuff with that:

```hs
f xs =
  [y | x <- xs, let y = 10 * x + 20, y > 30.0]
```

> This seems a bit syntax-dense to me, but I see why being able to refer to the value bound in the let expression could be useful

## Case Expression

Case expressions let us pattern match within a function and get the resulting expression. This is pretty much as you'd expect as well

```hs
nameOf c = case c of
  'a' -> "Alice"
  'b' -> "Bob"
  c -> [c]
```

Pattern matching in function definitions is actually just syntax sugar for case expressions so you can define the `name` function using a where binding with which would be the same as a case expression:

```hs
hi c = "Hi " ++ name c
  where
    name 'a' = "Alice"
    name 'b' = "Bob"
    name c = [c]
```

# Recursion

Recursion works as normal. A nice benefit we have in Haskell is that we can define the recursive base case as a pattern definition:

```hs
biggest [] = error "list is empty"
biggest [x] = x
biggest (x : xs)
  | x > rest = x
  | otherwise = rest
  where
    rest = biggest xs
```

We can also define infinitely recursive functions, for example:

```hs
ones = 1 : ones
```

And because Haskell supports infinite lists, we don't have to have an escape condition. This is useful and can be composed with other things, for example:

```hs
ghci> take 5 ones
[1,1,1,1,1]
```

And that just works as expected

```hs
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x : xs) =
  quicksort smaller ++ [x] ++ quicksort bigger
  where
    smaller = [a | a <- xs, a <= x]
    bigger = [a | a <- xs, a > x]
```

# Higher Order Functions

Functions that can take a function as parameters or return another function are called higher order functions

## Curried Functions

Every function in Haskell only takes a single parameter. Functions that look like they take multiple parameters are in fact functions that return functions that take the remaining parameters. We can call these curried functions

An example of this is the `max` function, it can be used in the following two equivalent manners:

```hs
ghci> max 1 2
2

ghci> (max 1) 2
2
```

This is because `max 1` returns a function that takes the second value. This idea lets us partially apply functions that require multiple parameters, for example:

```hs
triple :: a -> b -> c -> (a, b, c)
triple a b c = (a, b, c)

with1 :: b -> c -> (Integer, b, c)
with1 = triple 1

with12 :: c -> (Integer, Integer, c)
with12 = triple 1 2
```

In the above, we can see that the `with1` and `with2` are partially applied versions of the `triple` function in which `a` or `a` and `b` are provided

Infix functions can also be applied partially using sections - a section is done by surrounding the function with parenthesis and putting a parameter on one side. This means that we can also apply it differently depending on how we want to use it, for example:

```hs
divByTwo = (/ 2)

twoDivBy = (2 /)
```

It's clear when we use it how this works:

```hs
ghci> divByTwo 10
5.0

ghci> twoDivBy 10
0.2
```

## Higher Order Functions

We can define higher order functions as normal functions

```hs
applyTwice :: (t -> t) -> t -> t
applyTwice f x = f (f x)
```

We can then provide it with a function:

```hs
excited s = s ++ "!"
veryExcited = applyTwice excited
```

A very useful higher order function is `flip`, which is basically flips the arguments to a function:

```hs
flip f x y = f y x
```

## Maps and Filters

Two common higher order functions are `map` and `filter`

- `map` - applies a function to each value of a list
- `filter` - returns a list with only items that return true from a predicate function

These functions are defined in the standard library. A basic definition for them might look as follows:

```hs
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x : xs) = f x : map' f xs

filter' :: (a -> Bool) -> [a] -> [a]
filter' f (x : xs)
  | f x = x : filter' f xs
  | otherwise = filter' f xs
```

Or even using list comprehension:

```hs
map' f xs = [f x | x <- xs]

filter' f xs = [x | x <- xs, f x]
```

And using it as such:

```hs
ghci> map' (*2) [1,2,3,4]
[2,4,6,8]

ghci> filter' even [1,2,3,4]
[2,4]
```

As we can see from the implementation, this behavior can be done using list comprehension pretty much directly. The usage of each really just depends on what is more readable ina given scenario

Since Haskell is lazy, mapping or filtering lists multiple times still only iterates through the list once

## Lambdas

When working with higher order functions we often have a function that we'd just like to use once, to do this we can define a lambda which is an anonymous function. They are defined using the `\p1 p2 -> expression`

For example:

```hs
\x -> x + 5
```

Often we need to surround them in parenthesis since they will extend to the end of the line otherwise. Using it is done as follows:

```hs
ghci> map (\x -> x + 5) [1..5]
[6,7,8,9,10]
```

## Folds and Scans

When working with recursion we often run into an edge case with the empty list, this is a pretty common pattern called folding. Folds reduce a list to some single value

We can use the fold-left method `foldl` to implement a `sum` function:

```hs
sum' xs = foldl (\acc x -> acc + x) 0 xs
```

`foldl` takes a lambda to handle the accumulation, the initial value, and the array. Note that for the above case in which we're writing the `sum` function, it can be replaced more simply as:

```hs
sum' :: (Num a) => [a] -> a
sum' = foldl (+) 0
```

The same idea can be applied to the `elem` method:

```hs
elem' y = foldl (\acc x -> x == y || acc) False
```

Equally, you can use a fold-right which does the same but iterates from the right. Additionally, the lambda arguments are flipped around:

```hs
elem' y = foldr (\x acc -> x == y || acc) False
```

Folds are pretty powerful and can be used to implement lots of other standard library functions

A nice compositional example is how we can use these methods with `flip` to do something like reverse a list:

```hs
reverse' xs = foldl (flip (:)) [] xs
```

## Function Application

Function application is done using the `$` operator and is defined as such:

```hs
($) :: (a -> b) -> a -> b
```

The purpose of this is to reduce the precedence of function application. This means that instead of doing `e(f(g x))` we can do `e $ f $ g x`

So we can rewrite something like:

```hs
ghci> sum (filter (> 10) (21:[7..15]))
86
```

As

```hs
ghci> sum $ filter (> 10) $ 21:[7..15]
86
```

Thus, effectively reducing the precedence of function application

Additionally, this can also be used to apply a function dynamically, for example:

```hs
ghci> map ($ 10) [(1+), (2+), (3+)]
[11,12,13]
```

## Function Composition

Function composition is defined mathematically as `(f.g)(x) = f(g(x))`. In Haskell this is the same:

```hs
(.) :: (b -> c) -> (a -> b) -> a -> c
```

Using this, we can convert:

```hs
ghci> negate (abs (product [-1, 5, 4]))
-20
```

Into:

```fs
ghci> (negate . abs . product) [-1, 5, 4]
-20
```

Or using what we just learnt about the function application:

```hs
ghci> negate . abs . product $ [-1, 5, 4]
-20
```

This mechanism also makes it possible to write functions in a more point-free style, for example:

```hs
f :: (Num a) => [a] -> a
f = negate . abs . product
```

# Modules
