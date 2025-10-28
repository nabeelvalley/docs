---
published: true
title: JJ
description: A Git-compatible version control system
---

> [jj](https://github.com/jj-vcs/jj) is a Git-compatible version control system. Another useful reference is [Steve's JJ tutorial](https://steveklabnik.github.io/jujutsu-tutorial/introduction/introduction.html) or [JJ for Everyone](https://jj-for-everyone.github.io/)

# Installation and Setup

`jj` supports Nushell, so naturally the configuration and installation is in (the jj installation docs)[https://jj-vcs.github.io/jj/v0.23.0/install-and-setup/#nushell] - this will give some really nice autocomplete for Nushell which is great

# Initializing

To init `jj` in a repo that's currently using git, use:

```sh
jj git init --colocate
```

# Status

All changes in `jj` are located in a working copy, these changes can be seen with:

```
> jj status

Working copy changes:
A jj.txt
Working copy  (@) : kwvkkoxy 53889ed8 (no description set)
Parent commit (@-): nlmkywks 2c0668f0 main | Add content for special notes
```

Additionally, the change history can also be seen with `jj log` and looks something like this:

```
> jj log

@  kwvkkoxy nabeel@email.com 2025-10-27 13:04:27 53889ed8
│  (no description set)
○  nlmkywks nabeel@email.com 2025-10-27 13:02:08 main git_head() 2c0668f0
│  Add content for special notes
○  mvvunzxz nabeel@email.com 2025-10-27 13:02:08 03f621ee
│  add initial notes
○  mwmtqrmv nabeel@email.com 2025-10-27 13:02:08 754fba48
│  (empty) initial commit
│ ○  yotxkrrt nabeel@email.com 2025-10-27 13:03:26 example-feature-2 8cf8df5c
│ │  file 2
│ ○  xwylmzso nabeel@email.com 2025-10-27 13:03:26 b626e378
│ │  Add content for special notes
│ ○  qzwwoopw nabeel@email.com 2025-10-27 13:03:26 30bc460f
│ │  add initial notes
│ ○  lvzvxwuo nabeel@email.com 2025-10-27 13:03:26 e265e2f2
├─╯  (empty) initial commit
│ ○  nzyvlzlt nabeel@email.com 2025-10-27 13:03:16 example-feature d6e7e087
│ │  some content
│ ○  ruvknzzw nabeel@email.com 2025-10-27 13:03:16 b959bbdb
│ │  Add content for special notes
│ ○  lylxkkts nabeel@email.com 2025-10-27 13:03:16 da0f7c98
│ │  add initial notes
│ ○  nxlklokt nabeel@email.com 2025-10-27 13:03:16 01643ac6
├─╯  (empty) initial commit
◆  zzzzzzzz root() 00000000
```

# Diff

You can also view the diff for changes relative to your current HEAD by using:

```sh
> jj diff
```

Diffs can also be done relative to other refs, for example relative to `main` like so:

```sh
> jj diff --from main@origin
```

> There are, of course, other flags that are supported to enable additional functionality

# Descriptions

We can add a decription to our working copy with `jj describe`

```sh
> jj describe -m "Some notes on JJ"
> jj status

Working copy changes:
A jj.txt
Working copy  (@) : kwvkkoxy 6dcc5582 Some notes on JJ
Parent commit (@-): nlmkywks 2c0668f0 main | Add content for special notes
```

# The Working Copy

`jj` changes are done in a working copy. We can also have multiple simultaneous working copies in JJ. JJ allow us to create a working copy with a description like so:

```sh
> jj new -m "Working copy description"
```

A working copy can also be created after or before a specific commit using `-a` or `-b` respectively

The working copy can be moved around using `jj edit` and referencing a commit we'd like to move this on top of:

```sh
> jj edit 
```

# Commits

> With `jj` you probably want to use bookmarks instead of commits

Commits can be created based on the current working copy and can be done with:

```sh
> jj commit
```

This will simply create a commit with all the files in the current working copy. If you'd like to partially include files you can use `jj commit -i` which allows for an interactive commit

# Bookmarks

## Creating Bookmarks

`jj` uses the idea of _bookmarks_ instead of _branches_. A bookmark is like a commit on a branch.

A bookmark can be created with:

```sh
> jj bookmark create <bookmark/branch name>
```

## Tracking Bookmarks

`jj` can track remote branches by using:

```sh
> jj bookmark track <bookmark-name>@<remote-name>
```

## Updating Bookmarks

> Take a look at [Steve's tutorial on this](https://steveklabnik.github.io/jujutsu-tutorial/sharing-code/updating-prs.html) for more details

Updating a bookmark is `jj`'s way of adding a commit to a branch. This is kinda weird but basically updates a commit to be the next branch

When working relative to a bookmark, you can make changes. After comitting those changes, you can update the current commit to be the new bookmark for that change like so:

```sh
> jj bookmark set <bookmark-name>
```

# Pushing Changes

`jj` allows for multiple different backends. Pushing to a `git` backend is done using:

```sh
> jj git push
```

> What this does under the hood is moves the bookmarks to around to maintain and push to git branches appropraiately

This command also  allows you to specify which bookmarks or commits you'd like to push using `-b` or `-c` respectively

# Restore a file

Restoring a file will reset the changes made to that file and can be done with:

```sh
> jj restore path/to/file.txt
```

# Conflict Resolution

`jj` has conflict resolution tooling builtin which can be accessed using `jj resolve` in the case of conflicts. Changes can be resolved using the resolution tool like so:

```sh
> jj resolve path/to/file.txt
```

Which will open a similar tool to the once used for interactive commits

# Basic Workflow

The bookmark concept can be a little tricky when working with git, basically here's a worflow that I find seems to work:

1. Just start doing some work
2. Branching is done with either:
    1. Use `jj bookmark create <bookmark>` to label your working area as a new branch (this is from your current location in the tree)
    2. Use `jj edit <bookmark/commit>` to select a commit to start working from, this is like branching from somewhere else
3. Use `jj describe` to set a description for your working area - this will become the commit message
4. Use `jj commit` to make a commit
5. You can then move the bookmark to it's new location with `jj bookmark set <bookmark> -r @-` (the `@-` refers to the parent commit/revision)
6. Use `jj git push -b <bookmark>` to push the bookmark
7. Go back to 1.

# Getting Commit Details

The `jj show` command can be used to get details about a commit or revision. It's also possible to refer to the working area using `@`, which means that information about the current working area can be fetched with:

```sh
> jj show @
```

Additionally, the `-T` param can be used with some commands, including the `jj show` command, to structure the output