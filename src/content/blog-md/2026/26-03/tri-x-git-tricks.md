---
title: Git Tricks with Tri and Difft
subtitle: 26 March 2026
published: true
---

> Assumed audience: Developers/technical people who use git and/or enjoy terminal UIs (TUIs)

So I finally got [`tri`](https://github.com/sftsrv/tri) running super fast which [I already talked about today](/blog/2026/26-03/bubbletea-commands) and I came across something mildly annoying but not all bad so thought it would be nice to write down

I use [`difft`](https://difftastic.wilfred.me.uk/introduction.html) for my [`git`](https://git-scm.com/) diffs. This works really nicely as it's got some syntax awareness and integrates really well into other tools I use such as [`lazygit`](https://github.com/jesseduffield/lazygit/tree/master)

Now, I'm a [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) dude so I build [my tools](https://github.com/sftsrv) to do the same - so naturally I wanted to use `difft` with `tri` - so, here's how to do that

> The below examples are using [Nushell](https://www.nushell.sh/) so your shell's exact syntax may vary but the idea is the same

```sh
git diff HEAD --name-only | GIT_EXTERNAL_DIFF="difft --color=always --display=inline" tri --preview `git diff HEAD -- `
```

Okay, braindump definitely. Realistically, since I want `difft` to always behave like this, It's probably worth setting the environment variable elsewhere, but the steps are basically:

1. Use the `GIT_EXTERNAL_DIFF` environment variable to have the `difft` command, this causes git to use the entire command and not just execute the binary provided as with [`diff.external`](https://git-scm.com/docs/diff-config#Documentation/diff-config.txt-diffexternal), so I can provide the flags to format `difft` as desired
2. Then just use `tri` as normal

Assuming you've set step 1. within your shell, the command is more simply:

```sh
# step 1.
$env.GIT_EXTERNAL_DIFF = "difft --color=always --display=inline"

#step 2.
git diff HEAD --name-only | tri --preview `git diff HEAD -- `
```

Which is just the normal way that `tri` works so yay

And that's it okbye

> Update 14 April 2026

I've added this function to my nu config which basically do the above:

```nu
def "g diff tri" [range = "HEAD..master"] {
  git diff ($range) --name-only
  | GIT_EXTERNAL_DIFF="difft --color=always --display=inline" tri --preview $"git diff ($range) -- " --flat
}
```

> Update 04 May 2026

I've wanted to do more complex preview behavior with `tri` - particularly making it possible to generate custom commands. I've recently added support for that so it now makes for some really interesting stuff, like a command for example the below command which lets you browse the input files' history

Using it looks like this:

```nu
^find **/*.go | g log tri
```

And the definition is a bit messy, but not too complicated I hope:

```nu
# Expects a list of paths as an input
def "g log tri" [] {
  $in
  | lines
  | par-each {|p| git log --pretty=format:"%as %h %f" -- $p | str replace -m -a --regex ^ $"($p)/" }
  | to text
  | GIT_EXTERNAL_DIFF="difft --color=always --display=inline" tri --preview "git diff $4..$4^ -- $1" --pattern `^(.*)/((\d|-)+) (\w+)`
}
```

> This is also probably very inefficient. So be selective about the paths you provide since this does a log for all given paths and can be very slow on a large repository
