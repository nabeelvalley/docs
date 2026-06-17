---
title: Scan based regex composition
description: A simplified approach to complex text replacements
subtitle: 27 March 2025
published: true
---

Recently I needed a regex to camel-case some text, this sounds simple enough at first glance but since I had some very specific stylistic requirements it started to get more and more complex and the regex became pretty unwieldy 

A colleague suggested the following function to get the job done:

```js
const normalize = (str) => str.replace(/([a-z])([A-Z])/g,'$1-$2')
```

Now, this works on simple examples like:

```js
normalize("HelloWorld") // Hello-World
normalize("helloThereBob") // hello-There-Bob
```

But it fails on more complex cases such as when we have numbers or when a word is all caps (abbreviations/initialisms?) such as these

```js
normalize("URLParser") // URLParser, i want URL-Parser
normalize("Text1Parser") // Text1Parser, i want Text-1-Parser
normalize("MyURLExample1ForProgramX") // My-URLExample1For-Program-X, i want My-URL-Example-1-For-Program-X
```

After a lot of playing around I couldn't find a simple regex that let me do what I wanted. I did however like the idea of scanning across a string to make very specific, usually one or two character replacements. I liked the idea that different parts of the regex could be named and applied, using this idea - I thought we could have small regexes that do really simple things, such as:

```js
const replacement = `$1-$2`
const aB = /([a-z])([A-Z])/g // aB -> a-B
const ABc = /([A-Z])([A-Z][a-z])/g // A-Bc
const wd = /(\w)(\d)/g // a1 -> a-1
const dw = /(\d)(\w)/g // 1a -> 1-a
```

Now, these small scanners work at the 2-3 letter pattern size and let us perform surgical replacements, scanning across text and applying a replacement on small subsets of a string.

Something like looking for a pattern in `URLParser` for a set of smaller patterns like: `UR`, `RL`,`LP`, `Pa`, `ar`, `rs`, `se`, and `er`. 

This takes away the global concern of the regex and lets us think distinctly about the different subproblems. Applying these sub-solutions is also easy:

```js
const normalize = (str) => 
	str.replace(aB, replacement)
	   .replace(ABc, replacement)
	   .replace(wd, replacement)
	   .replace(dw, replacement)
```

Testing this with the examples that failed earlier we see the following result:

```js
normalize("HelloWorld") // Hello-World
normalize("URLParser") // URL-Parser
normalize("Text1Parser") // Text-1-Parser
normalize("MyURLExample1ForProgramX") // My-URL-Example-1-For-Program-X
```

And that's basically what I want.

The above solution shows us a general approach that can be used for building complex replacement structures. It is possible that it would be less efficient than a big complicated regex but I think where possible, this solution allows us to incrementally build and add functionality to regex-based solutions in a way that's much easier to understand and modify than one-shot regexes tend to be

> Lastly, a quick note - the name of this post can probably use some work, the closest thing to this pattern that I can find is [Composed Regex by Martin Fowler](https://martinfowler.com/bliki/ComposedRegex.html) which breaks regexes down into smaller parts in order to create a bigger regex
