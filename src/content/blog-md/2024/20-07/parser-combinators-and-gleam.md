---
title: Life, Gleam, and Parser Combinators
description: A short introduction to Parser Combinatros
subtitle: 20 July 2024
published: true
---

## Time

There's never enough time to do the things we want to do. Recently I find myself struggling with this. There are too few hours in a day, too few days in a week. Between work and trying to simply stay alive there aren't many hours left to do things you care about

For the past year or so I've made a consistent effort to take my camera with me everywhere. It's always either in my bag or in my hand. And I've taken a lot of pictures. The thing is, I feel that my photos have stagnated - they're no better than they were a year ago, and arguably worse than five years ago. I seem to have hit some kind of local maximum, the point where I put just enough effort to passable but not nearly enough time to do anything useful

As far as my photography goes, I'm planning to take fewer pictures, but spend a lot more time looking for ways to be better and create work that means more to me.

The other area of my life that's suffered due to poor time management is my technical learning. I've found programming to be an interesting lens through which to see the world, and different approaches and paradigms make that a constantly moving picture.

## Gleam

[Gleam](https://gleam.run/) is a functional programming language in the Erlang/Elixir ecosystem that compiles to code that can run on the Erlang VM and can also optionally target Javascript/Node

There are a lot of things I still want to learn about and a lot of things I want to do. A few months ago I tried learning the Gleam but between windows being a generally disagreeable operating system and a general lack of direction I never quite got anywhere with it. Throught the documentation the language seemed like a nice little thing to learn and looked like a good balance of the strictness I wanted from a functional language and the ease of learning.

Overall, I found it really easy to pick up Gleam - the syntax is very Javascripty and it's got a very similar type system to F# both in terms of how the syntax looks as well as how it works overall. The standard library is also pretty good and covered most things I had to do and provided some utilities for a lot of common things as well as had testing configured from the get-go which made this overall quite a pleasure to setup

I've also been interested in Parser Combinators and spent some time learning about them from [this YouTube Series by Low Byte Productions](https://www.youtube.com/playlist?list=PLP29wDx6QmW5yfO1LAgO8kU3aQEj8SIrU) as well as as some work by [Scott Wlaschin on F# for Fun and Profit](https://fsharpforfunandprofit.com/posts/understanding-parser-combinators/)

The series by Low Byte was pretty great but was done in Javascript and didn't really delve into some of the type complexities and behaviours that crop up when working with static types. It was on my second watch of Scott Wlaschin's talk where the behaviour of generics really clicked and allowed me to related things back to Gleam

As far as my actual experimentation goes I tried to use the kinds of parsers and combinators defined by the LowByte YouTube series while using the approach by Scott Wlaschin

Overall I think I learnt quite a bit, I spent a lot of time looking at the Gleam code and rewriting things to work more consistely with the type of data structure I wanted. One of the things I found a little annoying things I found is that recursive functions seem to be definable only at the top-level of a module which adds some ceremony around doing things that involve recursion

But anyways, all that aside, let's take a look at some parser things

## Parsers

### What is a Parser

In our context, a parser is simply a function that takes in some input, and tries to convert it into some meaningful pieces of data, further - a combinator is a function that takes one or more parsers and combines them into a new parser - get it? - combine = combinator.

So in our context, we can define a type for a parser as a function that takes a `String` and returns some result that tells use the part of the string which was matched and what was left over

Additionally, a parser can be either successful or unsuccessful, and we do that using the `Result` type that's built into Gleam:

```gleam
pub type ParserState(a) {
  ParserState(matched: a, remaining: String)
}

pub type Err =
  String

pub type Parser(a) =
  fn(String) -> Result(ParserState(a), Err)
```

### A Simple Parser

We can also see that we are using this `a` thing above, this is a generic type in Gleam. In our implementation we define that a parser just needs to return some kind of data as what was matched, but we don't particularly care what that is

For the sake of example, we can define a simple parser that matches a string exactly:

```gleam
fn starts_with_xx(input) {
  case string.starts_with(input, "xx") {
    False -> Error("Expected xx" <> " but found " <> input)
    True -> {
      let remaining = string.drop_left(input, string.length("xx"))
      Ok(ParserState("xx", remaining))
    }
  }
}
```

Above, we define a parser called `starts_with_xx` which will simply parse the characters `xx` in a string. Now, overall this isn't super useful and is pretty tedious if we need to do this each time we define a parser, so more generally we can define parsers using a function that takes some configuration and returns a parser

So an example of a function that takes in a `String` to match and returns a parser to us can be seen below:

```gleam
pub fn str(start) -> Parser(String) {
  fn(input) {
    case string.starts_with(input, start) {
      False -> Error("Expected " <> start <> " but found " <> input)
      True -> {
        let remaining = string.drop_left(input, string.length(start))
        Ok(ParserState(start, remaining))
      }
    }
  }
}
```

We can then redefine our above `starts_with_x` parser in terms of this one, like so:

```gleam
let starts_with_xx = str("x")
```

Running a parser we can see a bit about the type of data this returns:

```gleam
let parser = str("x")

let result = parser("xxY")
// Ok(ParserState("xx", "Y"))


let error = parser("Yxx")
// Error("Expected xx but found Yxx")
```

We can define other parsers using a similar style but this is the core of it, the above is very specifically a `Parser(String)` but these can be more generic as we'll see when we get to combinators

### A Simple Combinator

Combinators are used to combine parsers in interesing ways. A simple combinator is the `left` combinator which takes in two parsers and tries to parse them as a sequence, but will only keep the left-side of the parsed result.

We can define this parser as follows:

```gleam
pub fn left(l: Parser(a), r: Parser(b)) -> Parser(a) {
  fn(input) {
    case l(input) {
      Error(err) -> Error(err)
      Ok(okl) ->
        case r(okl.remaining) {
          Error(err) -> Error(err)
          Ok(okr) -> Ok(ParserState(okl.matched, okr.remaining))
        }
    }
  }
}
```

It's also interesting to note that we take a `Parser(a)` and `Parser(b)` but return a `Parser(a)`

We can define a parser using the `choice` combinator which would work as follows:

```gleam
let parser = choice(str("x"), str("y"))

let result = parser("xyz")
// Ok(ParserState("x", "z"))
```

The parser above effectively throws away the second match in the choice but moves our inputs to the end of the second parser

So far however we're just working with strings, it would be nice to parse something more complex. In order to facilitate this we're going to define a combinator called `map` which will allow us to transform the result of the parser for the case where it succeeds (is `Ok`)

```gleam
pub fn map(parser: Parser(a), transform) {
  fn(input) {
    case parser(input) {
      Error(err) -> Error(err)
      Ok(ok) -> Ok(ParserState(transform(ok.matched), ok.remaining))
    }
  }
}
```

In the above definition you can see that the `parser` is the first input to `map`. We're defining it like this because Gleam allows us to automatically pass the first argument as a result of a previous computation using the pipe operator which looks like `|>`

To do something meaningful with `map` we're going to define a small type called `Token` which will have a constructor called `TokenX` which we will just use to represent us matching the character `X`

```gleam
type Token {
  TokenX(matched: String)
}
```

We can then use the type we create along with the map operator to transform the result of the parsing to a more sophisticated data type:

```gleam
let parser =
  left(
    str("x")
      |> map(TokenX),
    str("y"),
  )

let result = parser("xyz")
// Ok(ParserState(TokenX("x"), "z"))
```

So that's pretty cool right?

### A More Complex Parser

Using the basic idea of a parser and a combinator, we can define a whole bunch of them as I have [in my Parz project on GitHub](https://github.com/sftsrv/parz) we can compose them to create a parser for a more complex data type, for example:

Say we have a little language that looks like this:

```
name:string;
age:number;
active:boolean;
```

We can define a little syntax tree that we want our output to match as follows:

```gleam
type Ast {
  Ast(List(Node))
}

type Node {
  Node(name: Identifier, kind: Kind)
}

type Kind {
  StringKind
  BooleanKind
  NumberKind
}

type Identifier {
  Identifier(name: String)
}

type NodePart {
  NodeKind(kind: Kind)
  NodeIdentifier(identifier: Identifier)
}
```

All of the above directly map to something within our syntax other than `NodePart` which is used as an intermediate type that allows us to search for `Kind` and `Identifier` in the same `choice` due to how Gleam generics work

Finally, we can define a parser using the library I made as follows:

```gleam
fn parser() {
  // Parse an identifier
  let identifier =
    letters()
    |> map(Identifier)

  // Parse the different node "kinds" that the language has
  let string_kind = str("string") |> map_token(StringKind)
  let number_kind = str("number") |> map_token(NumberKind)
  let boolean_kind = str("boolean") |> map_token(BooleanKind)

  let kind = choice([string_kind, number_kind, boolean_kind])

  // A node is defined as a sequence of (indeitifier, :)(kind, ;)
  let node =
    sequence([
      left(identifier, str(":") |> label_error(custom_error))
        |> map(NodeIdentifier),
      left(kind, str(";")) |> map(NodeKind),
    ])
    // Extract the identifier and kind from our mapping
    |> try_map(fn(ok) {
      case ok {
        [NodeIdentifier(i), NodeKind(k)] -> Ok(Node(i, k))
        _ -> Error("Failed to match identifier:kind")
      }
    })

  let whitespace = regex("\\s*")

  let parser = separator1(node, whitespace) |> map(Ast)

  parser
}
```

And we can use this to parse our initial input fragment which yields:

```gleam
let result = parser(input)
// ParserState(
//    Ast([
//      Node(Identifier("name"), StringKind),
//      Node(Identifier("age"), NumberKind),
//      Node(Identifier("active"), BooleanKind),
//    ]),
//    "",
//  )
```

That's about it. At a high level you should be able to build parsers using the concepts I've mentioned here. Combinators are extremely powerful and I think can work as a great introduction to to functional programming concepts

## The Library

Over the course of learning about parser combinators and the gleam language, I put together a little parsing library. It's probably extremely inefficient but was a fun little project and I think it was a useful learning excercise. My libray can be found [on GitHub](https://github.com/sftsrv/parz) but it's also published as a package that you can use on [Hex](https://hexdocs.pm/parz)

## References

My time was primarily spent between the following resources when working on this project

- [Gleam Documentation](https://gleam.run/documentation/)
- [Parser Combinators by Low Byte Productions on YouTube](https://www.youtube.com/playlist?list=PLP29wDx6QmW5yfO1LAgO8kU3aQEj8SIrU)
- [Parser Combinators by Scott Wlaschin on F# for Fun and Profit](https://fsharpforfunandprofit.com/posts/understanding-parser-combinators)

Also, if you just wan to learn to program in Gleam you can take a look on [Exercism](https://exercism.org/tracks/gleam)

Additonally, some more generally related information:

- [My notes on working with the Typescript AST](/docs/javascript/typescript-ast)