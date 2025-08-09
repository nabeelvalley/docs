---
title: week 31, year 2024 - webgpu and parsers
subtitle: 02 August 2024
---

# welcome

since this is my first post in this format i figured i should just say hey! this series will be a bit of a braindump for project updates and links to things i found this week

# what i'm working on

right now i'm the concept of a photo editing app that uses shaders for applying image effects, the initial concept seems to be promising but there's still a fair amount of work to be done before i can have anything even remotely usable

i also had an excuse to use git bisect in a new and interesting way and made some additions to [my git notes](https://nabeelvalley.co.za/docs/random/git#find-bad-commits-using-bisect) about using the `—first-parent` and `replay `functionality

# what i found

## `ts-parsec`

i've been pretty invested in parser combinators recently and have been playing around with the [ts-parsec library](https://github.com/microsoft/ts-parsec) and it's been a pretty fun time. for a general idea of what these things are all about you can take a look at [my blog post on parser combinators](https://nabeelvalley.co.za/blog/2024/20-07/parser-combinators-and-gleam/)

## `WebGPU`

[webgpu](https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API) is the "new" way to create shaders on the web and comes with a new javsacript API and a [new language called wgsl](https://www.w3.org/TR/WGSL/)

the api is a bit more complex than the one for webgl but still reasonably manageable if you take a read through the [webgpu fundamentals site](https://webgpufundamentals.org/)

additionally, i found a few great resources for using webgpu for image filters, namely work by [Alain Galvan](https://alain.xyz/blog/image-editor-effects) and [Maxim McNair](https://maximmcnair.com/#)
