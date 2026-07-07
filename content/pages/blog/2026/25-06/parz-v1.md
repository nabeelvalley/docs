---
title: Parz v1 finally published!
description: Publishing my parser combinator library
feature: true
---

I've been writing a LOT of [Gleam](https://gleam.run/) recently. So it felt like it was probably time for me to get my [parser combinator library](/blog/2024/20-07/parser-combinators-and-gleam) (aka. [`parz`](https://parz.hexdocs.pm/index.html)) into a fully usable state

Since I wrote it back in 2024 (wow that long ago huh?) I hadn't really had a need for it. Recently I wanted to write some small parsers to help me with my site but the library was still missing one thing that would make it actually sorta useful - recursive parsing

The actual implementation isn't really difficult, it's basically just defining a combinator that delays actually calling a parser which then lets a parser reference itself, for example:

```gleam
/// Takes a thunk that will be lazily evaluated to a parser. This makes it
/// possible to define recursive parsers
pub fn lazy(
  thunk: fn() -> Parser(a),
) -> fn(String) -> Result(ParserState(a), String) {
  fn(state) { thunk()(state) }
}

// using it then looks something like this
fn group() {
  lazy(fn() {
    between(str("("), choice([constant(), group()]), str(")"))
    //                                    ^ we can reference ourself in here
  })
  |> map(Group)
}
```

However, doing this meant that all parsers would have to be made top-level functions since Gleam doesn't allow for recursion internally

I tried a few variations of the API that would have let me do something like this but they all ended up depending on some weird fallback behavior. Even then - you'd still have to resort to globals eventually if you depend on any function other than the one being defined - again, due to how local values and functions work in gleam

This isn't bad, per se, just not what I had in mind when I designed the API initially

But I'm fine with it now, it's only a little different to my ideal version but works well within the constraints of the language and I think parsers are pretty neat with it

Here's a full example of a parser for parsing simple paths using `parz`:

```gleam
import parz.{run}
import parz/combinators.{map, separator}
import parz/parsers.{regex, str}

type Path {
  Path(List(String))
}

// parsers are defined at the top level to ensure recursion is
// possible if needed
fn segment() {
  // a parser can be made with a pre-defined base parser from `parz/parsers`
  regex("\\w+")
}

// a more complex parser can be defined by combining other parsers from `parz/combinators`
fn parser() {
  separator(segment(), str("/")) |> map(Path)
}

pub fn main() {
  let result = "my/example/path" |> run(parser())
  // do something with the parsed output
}
```

I think that's not too shabby

As it stands right now, I'd like to add some more combinators and possibly faster non-regex based string parsers - but since this is mostly just a learning project I'm actually pretty happy it's reached this level of usability. I've even managed to implement a pseudo JSON parser using which is good enough for anything I'm likely to actually use it for

In conclusion, my little library has been promoted to v1, [go and check it out!](https://parz.hexdocs.pm/index.html)

And if you haven't already - definitely look at the [Gleam programming language](https://gleam.run/) - it's great!