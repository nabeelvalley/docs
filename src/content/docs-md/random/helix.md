---
title: Helix
description: Using the Helix Code Editor
---

> This is basically a summary of the `helix --tutor`

# Introduction

Helix uses `HJKL` for basic movement. `:w` is used to save, `:q` is used to quit. When doing these shortcuts helix will also show the command menu with some relevant docs or autocompletions

Something that differentiates Helix from Vim is that Helix is is based on the subject-verb pattern versus Vim that uses the verb-subject pattern for commands

# Basic Motions

> Most motions act on a selection

| Keybinding             | Description                                  |
| ---------------------- | -------------------------------------------- | 
| `%`                    | Select the entire file                       |
| `&`                    | Align multi-cursor selection                 |
| `.`                    | Repeat current line                          |
| `/`                    | Search                                       |
| `:q`                   | Quit                                         |
| `:w`                   | Write file                                   |
| `:wq`                  | Write and save                               |
| `;`                    | Collapse selections                          | 
| `<alt>;`               | Reverse selections                           | 
| `<alt>c`               | Add cursor above current                     |
| `<alt>s`               | Split selection lines into cursors           |
| `<space>p`             | Paste from system clipboard                  |
| `<space>y`             | Yank into system clipboard                   |
| `C`                    | Add cursor below current                     |
| `J`                    | Join lines together                          |
| `N`                    | Previous search result                       | 
| `U`                    | Redo                                         |
| `b` or `B`             | Move to beginning of current word or WORD    |
| `c`                    | Change current selection                     | 
| `d`                    | Delete the current character or selection    |
| `e` or `E`             | Move to end of current word or WORD          | 
| `f<char>`              | Find character                               |
| `i`                    | Enter insert mode, insert in front of cursor | 
| `n`                    | Next search result                           |
| `p`                    | Paste selection                              | 
| `r<ch>`                | Replace all selections with character        |
| `s`                    | Select matches in selection                  |
| `s` + regex            | Select using a regex                         |
| `t<char>`              | Select till character                        | 
| `u`                    | Undo                                         |
| `v`                    | Toggle select mode                           | 
| `w` or `W`             | Move to beginning of next word or WORD       | 
| `x`                    | Select a line                                |
| `y`                    | Yank (copy) selection                        | 
| `>` or `<`             | Indent or dedent line                        |
| `<ctrl>a` or `<ctrl>d` | Increment or decrement number                |
| `R`                    | Replace selection with yanked text           |
| `"<char>`              | Select a register                            |
| `Q`                    | Start or stop recording macro                |
| `q`                    | Play macro                                   |
| `*` (short for `"/y`)  | Put selection into search register (`/`)     |
| `<ctrl>s`              | Save current location to jumplist            |
| `<ctrl>o`              | Move forwards in jump list                   |
| `<ctrl>i`              | Go backwards in jump list                    |
| `(` or `)`             | Cycle primary selection back or forwards     |
| `<alt>,`               | Remove primary selection from multi select   |
| `<alt>)` or `<alt>(`   | Cycle the content of selections              |
| `~`                    | Switch case of all selected letters          |
| `<backtick>`           | Set all selected letters to lowercase        |
| `<alt><backtick>`      | Set all selected characters to uppercase     |
| `S`                    | Split selection on a regex                   |         
| `<ctrl>c`              | Toggle line comment                          |


# Repeating Motions

Motions can be repeated using a number followed by a motion, e.g `2w` moves 2 words forward


