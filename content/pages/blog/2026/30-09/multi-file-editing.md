---
title: Multi File Editing - An Update
description: Progress on building a workflow for scripting file changes
published: true
---

A while ago I wrote about some ideas I had around [scripting text manipulation](/blog/2025/01-08/scripting-text-manipulation) where I mentioned a few ideas, namely:

1. A text-based implementation of [Zed's MultiBuffers](https://zed.dev/docs/multibuffers)
2. A programming language for text manipulation that looks something like [Macros](https://en.wikipedia.org/wiki/Macro_(computer_science))

The final solution I had in mind was to make something composable that could make it really nice to apply huge chunks of changes to many files in a structured way

While at some point I'd like to get to the text manipulation language I see in my head, today I'd like to present some small, solutions I've been working on that enable some of the composition I had in mind

## `touchup`

First off, this is a really simple tool. It's similar to the [in-stream editor](/blog/2026/02-06/in-stream-text-editor) I hacked together previously but you know - less hacky. It's also fully standalone and doesn't depend on Nushell - and more usefully - it exposes a programmable API in Go

I've called it `touchup` and it can be installed using `go install github.com/sftsrv/touchup` and is used like so:

```sh
first-command | touchup | second-command
```

> You can also use the `--ext` flag with `touchup` to provide a file extension so your editor automatically does some syntax highlighting for you

It's a pipe that lets you interact with the output from one command before passing it to the next. This is useful for quickly inspecting some data or doing a manual edit before handing over control


It can also be imported and used in a Go program like so:

```go
import (
	touchup "github.com/sftsrv/touchup/pkg"
)

// get the user's preferred text editor from $EDITOR
editor, err := touchup.GetDefaultEditor()

// pass some content to the editor, and use the result
result, err := touchup.EditFile(editor, "prefix", "ext", content)
```

## `mex`

The next bit of the composition is `mex`. This is a program that extracts content from search tools like [`grep`](https://www.gnu.org/software/grep/manual/grep.html) and [`ripgrep`](https://ripgrep.dev/), lets you edit all those search results in a single file, and commits your edits to disk

It can be installed with `go install github.com/sftsrv/mex` and is used like so:

First, perform a search using something like `grep -r -n -H my-search` (`-n` for line numbers, `-H` for file names)

Then you can pipe those results to `mex` in a few ways depending on what you're trying to do:


1. Using `mex edit` you can directly edit and then apply all the changes automatically:

```sh
grep -r -n -H my-search | mex edit
```

2. Using `mex gen` to generate a changeset:

```sh
grep -r -n -H my-search >> changes.md
```

Edit `changes.md` however you want, then use `mex apply` to write them to disk:

```sh
cat changes.md | mex apply
```

3. A spicy version of the above workflow, is to use `touchup` explicitly to edit the files:

> Not that you'd ever need to actually do this since `mex edit` does this already, but just for fun, here you go

```sh
grep -r -n -H my-search | mex gen | touchup --ext md | mex apply
```

## Future

Yup. I'm still working towards my pie in the sky. And of course, I'll drop and update once it's done
