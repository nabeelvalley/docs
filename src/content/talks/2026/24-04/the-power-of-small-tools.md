---
title: "* > +"
subtitle: 24 April 2024
description: the multiplicative power of small tools
published: false
---

> Run this presentation using:

```sh
http get raw.githubusercontent.com/nabeelvalley/docs/blob/master/src/content/talks/2026/24-04/the-power-of-small-tools.md |
  sed '1,/^--- presenterm-start/d' |
  save presentation.md

presenterm presentation.md
```

--- presenterm-start

---
options:
  end_slide_shorthand: true
---

# * > +, Or, the multiplicative power of small tools

> A mindset for working more efficiently

---

## Ideas First

The first bit of this is all a bit abstract

> Try to be open and onto the ideas without questioning them too right now, we'll get to that later

---

## A (less-technical) Unix Philosophy

An emergent set of principles within the Unix ecosystem[^1]

According to it, programs should:

1. Do one thing. Do it well
2. Work well together
3. Fail early and allow for iteration
4. Be small, disposable, and substitute unskilled labor

---

### 1. Do One Thing. Do It Well.

> They do something without using the word "and"

- Small tools
- Something that's good at one thing is better than something that's terrible at many things
- We should be able to write them quickly
- Pragmatically, there is a concept of "complete"

---

### 2. Work Well Together

> Composition unlocks productivity

- Open standards
- Shared input and output
- "File over app"[^2]

---

### 3. Fail Early and Iterate

- Design solutions to be used quickly
- Learn from your mistakes
- Don't over-engineer solutions
- It's okay to throw things away

---

### 4. Disposable Software

- Avoid repetitive work at all costs
- Write code, throw it away when you're done
- You will save more time in the long terms

--- 

## Practically Speaking

> How can I make my work more efficient?

---

## 1. Identify Accidental Complexity

- Things that aren't the work you're trying to do
- Things that you do often that can be automated
- Things that are slow
- Things that aren't compatible with other things

---

### The Work Around Your Work

- The work around your work, e.g.:
  - Finding documentation
  - Managing your task board

---

### Things that You Do Frequently

- Writing documentation
- Keeping dependencies up to date
- Creating git branches with a specific format

---

### Things that Are Slow

- Code reviews?
- Email responses?
- Azure DevOps probably?
- Your IDE probably lol
- Like this really gets so specific to you

---

### Things that Don't Play Well Together

- Proprietary applications
- Proprietary formats
- User interfaces in general

---

### It's a Numbers Game

- Small solutions can be stitched together to solve big problems

---

## The Terminal

> It is a means, not an end

Shell commands are:

- Fast
- Repeatable
- Composable

UI's are generally none of these things

---

### 1. Fast

> If your problems are small enough, the solutions become trivial

- You can probably write some code to solve this quickly
- Someone else has probably written some code to solve this quickly
- They're straight up faster than a UI based equivalent

---

### 2. Repeatable

- You only pay the cost of doing it the first time
- If you've done it once, it's a few up-arrow-clicks to do it again
- Code makes fewer mistakes

---

### 3. Composable

> In your shell, this is just a pipe (`|`)

- Small tools are greater than the sum of their parts
- Big tools can't anticipate every possible use case

---

## Let's Write Code

---

### Example

> We have a weekly team presentation we want to assign a section to each team member

---

## References

[^1]: [Wikipedia - Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy)
[^2]: [Steph Ango - File over app](https://stephango.com/file-over-app)
