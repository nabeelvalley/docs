---
title: Helix
description: Using the Helix Code Editor
---

> This is basically a summary of the `helix --tutor`

## Introduction

Helix uses `HJKL` for basic movement. `:w` is used to save, `:q` is used to quit. When doing these shortcuts helix will also show the command menu with some relevant docs or autocompletions

Something that differentiates Helix from Vim is that Helix is is based on the subject-verb pattern versus Vim that uses the verb-subject pattern for commands

## Basic Motions

> Most motions act on a selection

| Keybinding               | Description                                  |
| ------------------------ | -------------------------------------------- |
| `%`                      | Select the entire file                       |
| `&`                      | Align multi-cursor selection                 |
| `.`                      | Repeat current line                          |
| `/`                      | Search                                       |
| `:q`                     | Quit                                         |
| `:w`                     | Write file                                   |
| `:wq`                    | Write and save                               |
| `;`                      | Collapse selections                          |
| `<alt>;`                 | Reverse selections                           |
| `<alt>c`                 | Add cursor above current                     |
| `<alt>s`                 | Split selection lines into cursors           |
| `<space>p`               | Paste from system clipboard                  |
| `<space>y`               | Yank into system clipboard                   |
| `C`                      | Add cursor below current                     |
| `J`                      | Join lines together                          |
| `N`                      | Previous search result                       |
| `U`                      | Redo                                         |
| `b` or `B`               | Move to beginning of current word or WORD    |
| `c`                      | Change current selection                     |
| `d`                      | Delete the current character or selection    |
| `e` or `E`               | Move to end of current word or WORD          |
| `f<char>`                | Find character                               |
| `i`                      | Enter insert mode, insert in front of cursor |
| `n`                      | Next search result                           |
| `p`                      | Paste selection                              |
| `r<ch>`                  | Replace all selections with character        |
| `s`                      | Select matches in selection                  |
| `s` + regex              | Select using a regex                         |
| `t<char>`                | Select till character                        |
| `u`                      | Undo                                         |
| `v`                      | Toggle select mode                           |
| `w` or `W`               | Move to beginning of next word or WORD       |
| `x`                      | Select a line                                |
| `y`                      | Yank (copy) selection                        |
| `>` or `<`               | Indent or dedent line                        |
| `<ctrl>a` or `<ctrl>d`   | Increment or decrement number                |
| `R`                      | Replace selection with yanked text           |
| `"<char>`                | Select a register                            |
| `Q`                      | Start or stop recording macro                |
| `q`                      | Play macro                                   |
| `*` (short for `"/y`)    | Put selection into search register (`/`)     |
| `<ctrl>s`                | Save current location to jumplist            |
| `<ctrl>o`                | Move forwards in jump list                   |
| `<ctrl>i`                | Go backwards in jump list                    |
| `(` or `)`               | Cycle primary selection back or forwards     |
| `<alt>,`                 | Remove primary selection from multi select   |
| `<alt>)` or `<alt>(`     | Cycle the content of selections              |
| `~`                      | Switch case of all selected letters          |
| `<backtick>`             | Set all selected letters to lowercase        |
| `<alt><backtick>`        | Set all selected characters to uppercase     |
| `S`                      | Split selection on a regex                   |
| `<ctrl>c`                | Toggle line comment                          |
| `mim` or `mi<delimiter>` | Select inside object or delimiter pair       |
| `mam` or `ma<delimiter>` | Select around object or delimiter pair       |
| `mdm` or `md<delimiter>` | Delete surrounding delimiter pair            |
| `ms<delimiter>`          | Add surrounding delimiter pair               |

## Repeating Motions

Motions can be repeated using a number followed by a motion, e.g `2w` moves 2 words forward

## Match Mode

Match model lets you select content around something such as brackets or other objects. This works by typing `m` in normal mode, from there you can follow the menus to select more specifically

## Shell Commands

Running shell commands from the terminal is possible using `:sh` followed by the command. You can also insert the path of the active file using `<Ctrl+r>%` to paste the data from register `%` which contains the current file path

So you can run a command with the given file like:

```
:sh command <Ctrl+r>%
```

Which will pass the current file to the shell command

## Pickers

> [Docs on Pickers](https://docs.helix-editor.com/master/pickers.html)

Pickers have a lot of neat functionality that's not immediately apparent

Firstly, launching a picker can be done with the appropriate command depending on the picker, such as `<space>+/` for global search

### Persist Picker State

The last picker can always be brought back with its state using `<space>'`

> The state will be reset if using a different picker so beware

### Picker Keybinds

> [Keybinding docs](https://docs.helix-editor.com/master/keymap.html#picker)

A list of some keybinds I find useful for pickers are:

| Keybinding         | Description                     |
| ------------------ | ------------------------------- |
| `tab`, `shift+tab` | Navigate entries                |
| `ctrl+t`           | Toggle preview                  |
| `enter`            | Open current item               |
| `ctrl+s`           | Open picker in vertical split   |
| `ctrl+v`           | Open picker in horizontal split |
| `esc`              | Close picker                    |

### Picker Search and Queries

> This section is definitely over-documented but I just read the docs on this so here's what I learnt

The default search uses fuzzy searching and supports column based queries

For example, consider the following picker contents (based on the diagnostics picker):

| severity | source | code  | path            | message          |
| -------- | ------ | ----- | --------------- | ---------------- |
| WARN     | ESLINT | err-1 | path/to/file.ts | Some error 1     |
| ERROR    | ESLINT | err-2 | path/to/file.ts | Some error 1     |
| WARN     | ESLINT | err-3 | path/to/file.ts | Some error 3     |
| WARN     | HARPER | err-3 | path/to/file.ts | Some error 3     |
| ERROR    | HARPER | err-4 | path/to/doc.txt | Some other error |

By default, just searching would filter on the `message`, for example

Search: `3`

| severity | source | code  | path            | message          |
| -------- | ------ | ----- | --------------- | ---------------- |
| WARN     | ESLINT | err-3 | path/to/file.ts | Some error 3     |
| WARN     | HARPER | err-3 | path/to/file.ts | Some error 3     |

We can also query using the name of the column followed by search related to that column, e.g.

> Note that you can just use the first few chars of the column name if it is unique in the table

Search `3 %source harper` or `3 %so harper` will both yield:

| severity | source | code  | path            | message          |
| -------- | ------ | ----- | --------------- | ---------------- |
| WARN     | ESLINT | err-3 | path/to/file.ts | Some error 3     |
| WARN     | HARPER | err-3 | path/to/file.ts | Some error 3     |

Or just using the column, like: `%source HARPER`:

| severity | source | code  | path            | message          |
| -------- | ------ | ----- | --------------- | ---------------- |
| WARN     | HARPER | err-3 | path/to/file.ts | Some error 3     |
| ERROR    | HARPER | err-4 | path/to/doc.txt | Some other error |

Or we can search for not-something `%source !harper` 

| severity | source | code  | path            | message          |
| -------- | ------ | ----- | --------------- | ---------------- |
| WARN     | ESLINT | err-1 | path/to/file.ts | Some error 1     |
| ERROR    | ESLINT | err-2 | path/to/file.ts | Some error 1     |
| WARN     | ESLINT | err-3 | path/to/file.ts | Some error 3     |

Or any combination of the above. I think you get the point
