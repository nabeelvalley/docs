---
title: Git Tricks with Tri and Difft
subtitle: 26 March 2026
published: true
---

> Assumed audience: Developers/technical people who use git and/or enjoy terminal UIs (TUIs)

So I finally got [`tri`](https://github.com/sftsrv/tri) running super fast which [I already talked about today](/blog/2026/26-03/bubbletea-commands) and I came across something mildly annoying but not all bad so thought it would be nice to write down

I use [`difft`](https://difftastic.wilfred.me.uk/introduction.html) for my [`git`](https://git-scm.com/) diffs. This works really nicely as it's got some syntax awareness and integrates really well into other tools I use such as [`lazygit`](https://github.com/jesseduffield/lazygit/tree/master)

Now, I'm a [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) follower so I build [my tools](https://github.com/sftsrv) to do the same - so naturally I wanted to use `difft` with `tri` - so, here's how to do that

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