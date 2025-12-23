---
published: true
title: Vim
subtitle: Introductory Vimming
---

To start using Vim, first install it from [here](https://www.vim.org/download.php#pc)

> To get some quick tips and information you can use the Vim tutor application, this can be launched from CMD using the `vimtutor` command. For some reason this doesn't work right from Powershell

## Creating a file

1. From Powershell or CMD navigate to a directory in which you can create a new file, then run `vim filename.txt` to create a new file with the given name and open the file in the Vim Editor
2. Now that you have the file open you can move around using either your arrow keys or the `h,j,k,l` keys

## Basic Modes

Vim has two main modes, a viewing mode and an editing mode, to exit the editing mode you simply need to click the `esc` key. To enter the `edit` mode you have the following two options:

- `i` will allow you to insert text before the cursor
- `a` will allow you to append text after the cursor
- `A` will allow you to append text at the end of the line

## Save and Edit Files

Next, once out of edit mode you can:

- `:w` to save changes
- `:wq` save changes and close
- `:q!` abandon changes and close

To open and continue editing a file you can again run `vim filename.txt`

To delete content from a file you have the following options:

- `x` to delete the current highlighted character
- `dw` to delete the currently highlighted word
- `d$` to delete until the end of the line

If you're editing and would like to go and do something else and then come back to edit the file, you can do the following:

1. `shift + z` to pause the editing session and put it in the background
2. `fg` to resume editing the file

## Operators and Motions

Commands in Vim consist of an operator and a motion, for example the `d$` command `d` is the delete operator and `$` is the motion. Some other motions are:

- `w` until before the next word
- `e` until the end of the current word
- `$` until the end of the line

Additionally, you can add a number before an operator to repeat it. e.g `2w` will move two words. By combining this with the command we can delete 2 words with `d2w` or `d3$` to delete three lines

> Since deleting an entire line is also a common task, you can delete entire lines with `dd`, so `3dd` can also be used to delete three lines

## Put

Use `p` to put previously deleted text after the cursor (this is sort of like cutting and pasting), you can use this with `dw` or `de` for word based deletions or `dd` and `d$` for line based deletions

## Replace

To replace a character wth another you can use `r` followed by the character you want to replace, for example `re` will replace the highligted character with an `e`, additionaly to replace multiple characters you can use `R`

### Regex Replacements

You can use the `%s` command to replace something using regex, for example `:%s/thingToReplace/myReplacement/` - this will only replace one usage per line. Adding the `g` flag as follows will do a replace for all usages in even a single line `:%s/thingToReplace/myReplacement/g` 

It is also possible to do a replacement over a visual selection. Instead of `%` you can use a visual selection and then type `:` which will autofill `'<,'>` in your command bar, typing `s/` will enter the same find and replace mode as before, so you can use a regex. The full command will look like so `:'<,>s/thingToReplace/myReplacement/`

Additionally, you can use regex capture groups in your replacements to do more complex things, this can be done by using the `\` to refer to a capture group, for example: `:%s/(thingToReplace)/\1InTheFuture/` will replace all instances of `thingToReplace` with `thingToReplaceInTheFuture`


## Change

To change until the end of a word use `ce`, this will allow you to overwrite the current word from the current current position. This operator works the same as when using the delete operator

## Moving Around

- `ctrl g` to see where in a file you currently are
- `G` to move to the bottom of a file
- `gg` to move to the top of a file
- A line number followed by `G` to go to a line, e.g `12G` will take you to line 12

## Searching

To search you can use `/` followed by a search phrase and then click enter

- `n` to search in the same direction
- `N` to search in the opposite direction
- `?` to search in the backward direction
- `ctrl o` to go back to where you were before
- `ctrl i` to go forward
- `%` will search for a matching bracket, `), ], }`
- `:noh` will clear the highlighting from the search results

## Substitution

Substitution is done using the `:s` command, the structure of this command works like so:

- `:s/old/new` - replace the first occurence in the line
- `:s/old/new/g` - the `g` flag means to substitute in the line
- `s/old/new/gc` - the added `c` flag means to replace every occurence and ask for a confirmation each time
- `:#,#s/old/new/g` - to replace all the occurences withing a line range, e.g between line 1 and 10: `:1,10/old/new/g`

## Executing Shell Commands

From Vim, you can execte a command on the shell in which you've launched from using the `:!` followed by the command you want to execute

## Selecting Text

Aside from the normal edit and view modes we also have `visual` mode which allows you to read in/select a section of text

- You can use `v` to enter visual mode
- When in visual mode `:w` followed by a file name will write the selection to a file. Verify that you see `:'<,'>w Filename` because this will indicate you are in the correct mode
- To insert the contents of the written file you can use `:r` followed by the filename to insert the contents into your current file
- You can also use `x` to delete the highlighted text
- Using the above concept you can also read the output from a system command with `:r !` followed by your command, so to read the contents of your current directory into the file you can do `:r !ls`

## Inserting Lines

To insert and enter edit mode you can use `o` or `O`

- `o` will insert a line below your cursor
- `O` will insert a line above your cursor

## Copy and Paste

To copy and paste text you can use the yank operator, this is done using `y`

1. Start visual mode with `v`
2. `y` to copy the highlighted text
3. `p` to put the text

`y` also functions as an operator so you can use the normal functionality as with other Vim commands, like `yw` to copy a word

## Undo and Redo

- To undo use `u`
- To redo use `ctrl + r`

## Setting Options

Options/settings for Vim can be set using the `:set` command followed by the option name, some common options are:

- `ic` to ignore case when searching
- `hls` to set the incsearch option
- To ignore case for a single search you can use `/searchterm\c`
- `:nohlsearch` will clear the search highlighting

## Multiple Windows

To split your screen into multiple windows you can use:

- `:sp` followed by the file path for a horizontal split
- `:vsp` followed by the filepath for a vertical split
- `ctrl + w` **twice** to toggle focus between windows
- `:wa` to save all windows
- `:wqa` to save all windows and quit
- `:qa` to quit all windows

Also for resizing windows you can make use of some of the following commands:

- `ctrl + W =` to make all windows equal sizes
- `:res n` to resize windows by `n`

And `ctrl + W r` to rotate the windows or `ctrl + W DIR` to move to the window in the `DIR` direction using `h`, `j`, `k`, `l`

## File Management

`:Explore` will open the file explorer from the current file's directory, from this view managing files can be done with the following commands:

- Navigation and searching in the context of the directory works as normal, `Enter` will open the file or directory
- `%` to create a file
- `d` to create a directory
- `R` to rename a file

In Normal mode, you can use the following:

- `Ctrl + o` to go to previous ("old") file
- `Ctrl + i` to go to next file

## Focusing Line

- `zz` will center the current line on the screen
- `zt` will move the current line to the top of the screen
- `zb` will move the current line to the bottom of the screen

You can also use the `so` setting for keeping this behaviour

- `set so=0` is the default and will not focus to scroll
- `set so=999` will keep your focus in the center
- `set so=5` will keep 5 lines around your focus

## Sliding Editor Up

You can slide the editor up by adding padding to the bottom of the current editor with `crtl+e` which is useful when editing a line towards to bottom of the screen

## Opening a Terminal

You can open a terminal using the `:term` command, and you can exit terminal mode using `ctrl + \ ctrl + n`, thereafter using `:q` to close the terminal window

## Help

To get help you can use the `:help` command, to search for a specfic topic you can just add it after the help command like `:help nohlsearch`, you can then type `:q` to close the help menu

## Enabling Features

To enable Vim features you can make use of a startup script or a `vimrc` file

## Miscellaneous Options

- `:set number` to turn on line numbers
- `:syntax on` to turn on syntax highlighting

## Macros

Macros are a simple way to record a sequence of keystrokes that can be reapplied.

### Recording a Macro

We do this by starting the macro recording with `q` and doing some steps. For example, if I want to delete the first word of each line I can do `0dw`, if I want to make that a macro I can decide what key to be the macro trigger, e.g. let's use `a`, I can record the macro into `a` using `qa0dwq`:

1. `q` to start recording the macro
2. `a` to set the key to use the macro
3. `0dw` delete the first word
4. `q` to end the macro recording

We can then use this macro by typing `@a` which uses the macro at `a`

### Do per line Macro

Often when using macros we're doing something across multiple lines, in this case it's handy to always start and end the macro using `0` to ensure we are always at the start of the line. For example, if we have a bunch of lines that we want to delete the first word from, we can use `0qadw0jq` which will do:

1. `0` to set us to the start of a line
2. `qa` to start recording a macro in `a`
3. `dw` to delete the first word (we are already at the start of the line)
4. `0` to move to the start of the line
5. `j` to move one line down
6. `q` to end the recording

We can the use the macro with `@a`, or we can use it multiple times, e.g on the next 5 lines using `5@a` which is:

1. `5` the number of times to repeat
2. `@a` the macro to execute

### Macro Counters

When doing something over a bunch of lines we don't necessarily want to do the exact same thing. An example of this is to write a list of numbers like:

```
1. Item 1
2. Item 2
3. Item 3
4. Item 4
5. Item 5
```

We can do this by using a macro that modified the line we just wrote. For example, we can first write the following: `1. Item 1`, then we can apply a macro from that line: `qa0yyp<ctrl-a>$<ctrl-a>0q` which does the following:

1. `qa` start recording into `a`
2. `0` move to start of line
3. `yyp` copy and paste current line
4. `<ctrl-a>` increment first number
5. `$` move to end of line
6. `<ctrl-a>` increment second number
7. `0` move to start of line
8. `q` stop recording

We can then use this macro as needed to implement a count

#### Using Put Range

> From [this Stackoverflow Question](https://vi.stackexchange.com/questions/12/how-can-i-generate-a-list-of-sequential-numbers-one-per-line)

As mentioned above, we often want to put numbers on a line and we can manipulate that however we want afterwards, we can use`:put =range(1,100)` to put values 1-100

Of different combinations of the `range` function like `range(1,10,2)` which puts every `2`nd number

### Marks

> [Vim wiki on using marks](https://vim.fandom.com/wiki/Using_marks)

We can add and re-visit locations in vim using marks. Creating a mark can be done with `m` followed by a letter for the mark. e.g. `ma` will add a mark `a`

We can view marks with `'` and go to a mark with `'` followed by the letter of the mark, e.g. `'a` to go to the `a` mark above


> Lowercase letters are single-file marks and capital letters are for marks that can be made across files. So `mA` can be navigated to from another file using `'A`

You can also use marks compositionally, e.g delete until a specific mark with `d'a` where `'a` refers to the mark

Lastly, marks can be deleted using `:delmarks` followed by the letter for the mark, e.g. `:delmarks a`