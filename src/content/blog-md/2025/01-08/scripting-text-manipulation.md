---
title: Scripting Text Manipulation
description: An idea for automating changes to text files
subtitle: 01 August 2025
published: true
---

> This is kind of just a brain dump of some things that I think would be interesting to explore

So, I've been using [Zed](https://zed.dev) a bit recently and have particularly enjoyed how it's [MultiBuffers](https://zed.dev/docs/multibuffers) work. MultiBuffers basically allow you to simultaneously edit multiple files at once while also having things like syntax highlighting and language server support

I really _wanted_ to add Zed to my toolchain because of this feature but it doesn't quite seem to be a good fit in lots of other ways

That being said - I really want multi buffer editing now so naturally my mind has shifted to thinking about how building something like this that meshes well with my workflow could look

There are two levels that I could see something like this working on and are basically what I'd like to explore at some point, the ideas are basically:

## 1. Literally just implementing MultiBuffers

Yup. Basically have some kind of method that lets you do a search and open that using a utility that can the flush the changes back to the original files

Imagine I want to edit all usages of the word "hello", I could have a buffer that's opened in my code editor via `my-search 'hello' | my-edit | my-save` or something like that, where the result of the search command would give us something that looks like this:

```
--- start my/file/path1.txt:120-122
some context lines
hello world
some more context
--- end my/file/path1.txt:120-122

--- start my/file/path2.txt:10-12
some context lines
hello world
some more context
--- end my/file/path2.txt:120-10-12
```

Making any changes to that would then update the ranges in the underlying files. This is nice because we can possibly do something like apply a macro to all instances of the word `hello` across what looks like a single file. Which can then be saved an applied

> This could also be a simplified `git patch` view which is tweaked to make editing nice, the advantage of this is that applying this patch could be done just using git if it can be normalized back to a patch when saving

Now, there are still some challenges here that I'd still like to solve, like searching but getting the containing function instead of just some random range of files, which is why I think the search tool for producing these ranges also needs to be sufficiently smart

There are lots of other quality things that do come up, for example getting LSP support within these edit-blocks, but I think that's possibly doable. VSCode has something called [Embedded Programming Languages](https://code.visualstudio.com/api/language-extensions/embedded-languages) but if something like this could make it's way through to the Language Server Protocol at large there could be a really cool user experience. But anyways, that's not part of this solution

> Note that idea here isn't to solve this for any specific editor but rather to create a composable solution that can work with any text editor and provide a nice mechanism to efficiently enable multi file editing

## 2. A language for text manipulation

I've mentioned [macros](https://en.wikipedia.org/wiki/Macro_(computer_science)), in the context of code editors this typically refers to some kind of key you can press that triggers a predefined set of other keypresses (hopefully not recursively) that enables some relatively complex editing behavior. This is really powerful with tools like [Vim](https://www.vim.org),  [Emacs](https://www.gnu.org/software/emacs/) , or Helix which allow users to repeat certain sets of changes, for example I may want to tell the editor to **go to first word of line, change it to X, go to end of line, add semicolon** and then I'd record a macro which may be interpreted as `I<esc>wdiX<space><esc>A;<esc>` in Helix

> The sequence can look scary but remember that it's an artifact of what we did, and not something we set out to create from the start

Now, what if I wanted to create these sequences from scratch and have them applied to a file? Well, the Emacs people have solved this by the looks of it, there are two tools for doing it, namely:

1. [TXR](https://www.nongnu.org/txr/) which seems really complicated? IDK how this is even meant to be used
2. [elmacro](https://github.com/Silex/elmacro) which looks like it's got a really nice API for writing macros but seems to run inside of Emacs which isn't what I'm looking for

The elmacros API seems really nice, here's the snippet from the docs:

```emacs-lisp
(defun upcase-last-word ()
  (interactive)
  (move-end-of-line 1)
  (backward-word 1)
  (upcase-word 1)
  (move-beginning-of-line 1)
  (next-line 1 1))
```

I think this is a great example of a language for manipulating text

So my proposal is then - can we make something like this that can be run in isolation and has context awareness to some extent while still being generic enough to avoid language-specific things (like [AST based text transformers](/docs/javascript/typescript-ast))?

Basically take some file like this:

```html
<h1>hello world</h1>

<p>
  <span>hello bob</span>
</p>
```

And use a script which in psuedo code may look like this:

```
# assume the "cursor" is at the start of the file
for-each search `hello`
  # goes to 'world' or 'bob'
  go-to-next-word-start
  
  # selects 'world' or 'bob'
  select $id
    go-to-end-of-word
  end select

  # searches for the containing 'h1' or 'p' tag
  go-to (previous `<h1`) or (previous or `<p`)

  # writes some text using the previously selected text
  append `id="$id"`
end for-each
```

To turn it into this:

```html
<h1 id="world">hello world</h1>

<p id="bob">
  <span>hello bob</span>
</p>
```

This would allow us to define a macro for doing the manipulation above and could allow us to make mass changes to a single file

The code focus of this macro-style script would be that it's quick to write and modify, but doesn't have to scale since it's intended for on-the-fly, once-off modifications, much like how you'd use macros normally

> It could also be really cool to make it possible to extract this from a Vim/Helix macro which can then be re-run in isolation or over a bunch of files

## Bringing it together

So these two ideas seem quite different. One of them provides a method for editing many files at once in an interactive manner, and the other automates edits to a single file. I've proposed these two because I think that they've both got some interesting strengths

The first method for multi buffers allow us to do changes that may be more random or complex over multiple files and are great for where interventions are needed due to inconsistencies when doing large refactors

The second method allows us to automate predictable changes - the goal with this is to minimize the time needed to write a script for manipulating text files, which is often quite time consuming and difficult to understand. In doing so, it should make large changes more efficient and approachable for teams while lowering the barrier to entry overall

I think there's also room for composability between these two methods, and possibly even executing a script on a multi buffer using something like [Helix's `:pipe` command](https://docs.helix-editor.com/commands.html)

## Why?

Okay so sure, we can edit files in some weird ways "fast". So what?

My idea here is that this can be a neat way to automate large code changes. Especially if those changes are macro-able. And I think the extension of a general purpose language for working with these kinds of syntax-aware macros can be really powerful. It could also just be a neat find-and-replace tool which is always useful

Also, it just sounds kind of fun to build and seems like it would fit well into my current text editing workflow. So even if there aren't any other users there would at least be one - which I think is perfectly fine for small software

## but but but AI

No.