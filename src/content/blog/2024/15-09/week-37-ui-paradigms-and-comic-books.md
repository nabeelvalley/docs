---
title: week 37, year 2024 - ui paradigms and comic books
subtitle: 15 September 2024
---

between doomscrolling and visiting [FOAM](https://www.foam.org/?gad_source=1&gclid=Cj0KCQjwi5q3BhCiARIsAJCfuZkTCodlHCRjT5oZANFRotVr8C131p7Ad5DIjty3-1DrBP9PqkiXSPcaAkJmEALw_wcB) there was barely any time to put something together but here we go

# what i found

i spent a decent amount of time comparing different ways of doing the same things. recently i've been thinking about ui state management, but first - some art

## mœbius

mœbius is the pseudonym of [Jean Henri Gaston Giraud](https://en.wikipedia.org/wiki/Jean_Giraud) who was a french cartoonist. i've found [his work](https://www.iamag.co/the-art-of-moebius/) fascinating for quite some time. the level of detail packed into each frame is astonishing

## state management

ui state is always something where there are an infinite number of solutions, each with their own drawbacks or drawfronts (of course that's the opposite right?)

### reactive programming

something old to get us started. i think reactive programming (using things like RxJS or hand-rolled equivalents) give us a good starting point for managing state and [this gist by André Staltz](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754) looks like a nice intro to the topic

### signals

i came across a library called [S.js](https://github.com/adamhaile/S) which is one of the earlier signal implementations around and works with a jsx based framework called [surplus](https://github.com/adamhaile/surplus). both of which are made by Adam Haile and last updated about 6 years ago (so probably don't pitch this during standup on monday)

if you're looking for a more modern implementation of signals, your favourite framework probably has something: [angular](https://angular.dev/guide/signals) - and [a bunch of other stuff](https://github.com/preactjs/signals)

### state machines

when talking about state management i always like to put [xstate](https://xstate.js.org/) on the table since it's a really handy library with some great developer experience and tooling built in. [i wrote a little intro](https://nabeelvalley.co.za/blog/2023/31-01/xstate-draggable-div/) a while back if you'd like to get a feel for the library as well

### strictness

something more obscure. i find the approach of [elm](https://elm-lang.org/) for ui quite interesting and is outlined in [the elm architecture](https://guide.elm-lang.org/architecture/). i first came across it in [the elmish book](https://zaid-ajaj.github.io/the-elmish-book/#/) which presents this method for building interfaces using [f#](https://fsharp.org/) and [fable](https://fable.io/) which is compiler that turns f# into javascript.
