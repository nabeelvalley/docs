---
title: Editing Text in-stream
description: A small helper to more easily edit files mid-stream
published: true
date: 2026-06-02
---

I've recently been finding [`sed`](https://www.gnu.org/software/sed/) really handy but sometimes I want to edit something bigger in-stream - maybe just to make some small manual fixes before dumping dumping a string out to some other command. I've been using `pbcopy` a lot for this kind of thing but I wanted a neater way to do it, and here's my solution

```sh
# Edit file in stream by writing to a file, opening the editor and printing back to stdout
# 
# File will be stored in a temp file in the current directory and deleted once edit is complete
#
# Example edit
#  > bat package.json | f edit-stream json | save updated.json
# 
def "f edit-stream" [
  # extension to use when writing the file. Useful to get syntax highlighting
  ext: string = "txt",
  # prefix to be used for tempfile
  prefix: string = "ed-",
  # if the temp file should be retained after editing
  --keep,
  ] {
  let f = $"($prefix)(date now | format date '%+').($ext)"

  $in | save $f
  nu -c $"($env.EDITOR) ($f)"

  if not $keep {
    bat $f
  }
}

alias fed = f edit-stream
```

> This is a [Nushell](https://www.nushell.sh/) function which makes it possible to do just that, and in practice could look something like this:

```sh
bat package.json # open a file using `bat`
| f edit-stream json # open the file in the configured $EDITOR
| save updated.json # save this to some other output
```

By default this also uses [`bat`](https://github.com/sharkdp/bat) to print the output to give syntax highlighting to users but will also pass the plain text on if being passed to another command