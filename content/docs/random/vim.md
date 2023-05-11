[[toc]]

To start using Vim, first install it from [here](https://www.vim.org/download.php#pc)

> To get some quick tips and information you can use the Vim tutor application, this can be launched from CMD using the `vimtutor` command. For some reason this doesn't work right from Powershell

# Creating a file

1. From Powershell or CMD navigate to a directory in which you can create a new file, then run `vim filename.txt` to create a new file with the given name and open the file in the Vim Editor
2. Now that you have the file open you can move around using either your arrow keys or the `h,j,k,l` keys

# Basic Modes

Vim has two main modes, a viewing mode and an editing mode, to exit the editing mode you simply need to click the `esc` key. To enter the `edit` mode you have the following two options:

- `i` will allow you to insert text before the cursor
- `a` will allow you to append text after the cursor
- `A` will allow you to append text at the end of the line

# Save and Edit Files

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

# Operators and Motions

Commands in Vim consist of an operator and a motion, for example the `d$` command `d` is the delete operator and `$` is the motion. Some other motions are:

- `w` until before the next word
- `e` until the end of the current word
- `$` until the end of the line

Additionally, you can add a number before an operator to repeat it. e.g `2w` will move two words. By combining this with the command we can delete 2 words with `d2w` or `d3$` to delete three lines

> Since deleting an entire line is also a common task, you can delete entire lines with `dd`, so `3dd` can also be used to delete three lines

# Put

Use `p` to put previously deleted text after the cursor (this is sort of like cutting and pasting), you can use this with `dw` or `de` for word based deletions or `dd` and `d$` for line based deletions

# Replace

To replace a character wth another you can use `r` followed by the character you want to replace, for example `re` will replace the highligted character with an `e`, additionaly to replace multiple characters you can use `R`

# Change

To change until the end of a word use `ce`, this will allow you to overwrite the current word from the current current position. This operator works the same as when using the delete operator

# Moving Around

- `ctrl g` to see where in a file you currently are 
- `G` to move to the bottom of a file
- `gg` to move to the top of a file
- A line number followed by `G` to go to a line, e.g `12G` will take you to line 12

# Searching

To search you can use `/` followed by a search phrase and then click enter

- `n` to search in the same direction
- `N` to search in the opposite direction
- `?` to search in the backward direction
- `ctrl o` to go back to where you were before
- `ctrl i` to go forward
- `%` will search for a matching bracket,  `), ], }`
- `:noh` will clear the highlighting from the search results

# Substitution 

Substitution is done using the `:s` command, the structure of this command works like so:

- `:s/old/new` - replace the first occurence in the line
- `:s/old/new/g` - the `g` flag means to substitute in the line
- `s/old/new/gc` - the added `c` flag means to replace every occurence and ask for a confirmation each time
- `:#,#s/old/new/g` - to replace all the occurences withing a line range, e.g between line 1 and 10: `:1,10/old/new/g`

# Executing Shell Commands

From Vim, you can execte a command on the shell in which you've launched from using the `:!` followed by the command you want to execute

# Selecting Text

Aside from the normal edit and view modes we also have `visual` mode which allows you to read in/select a section of text

- You can use `v` to enter visual mode
- When in visual mode `:w` followed by a file name will write the selection to a file. Verify that you see `:'<,'>w Filename` because this will indicate you are in the correct mode
- To insert the contents of the written file you can use `:r` followed by the filename to insert the contents into your current file
- You can also use `x` to delete the highlighted text
- Using the above concept you can also read the output from a system command with `:r !` followed by your command, so to read the contents of your current directory into the file you can do `:r !ls`

# Inserting Lines

To insert and enter edit mode you can use `o` or `O`

- `o` will insert a line below your cursor
- `O` will insert a line above your cursor

# Copy and Paste

To copy and paste text you can use the yank operator, this is done using `y`

1. Start visual mode with `v`
2. `y` to copy the highlighted text
3. `p` to put the text

`y` also functions as an operator so you can use the normal functionality as with other Vim commands, like `yw` to copy a word

# Undo and Redo

- To undo use `u`
- To redo use `ctrl + r`

# Setting Options

Options/settings for Vim can be set using the `:set` command followed by the option name, some common options are:

- `ic` to ignore case when searching
- `hls` to set the incsearch option
- To ignore case for a single search you can use `/searchterm\c`
- `:nohlsearch` will clear the search highlighting

# Multiple Windows

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

And `ctrl + W r` to rotate the windows

# File Management

`:Explore` will open the file explorer from the current file's directory, from this view managing files can be done with the following commands:

- Navigation and searching in the context of the directory works as normal, `Enter` will open the file or directory
- `%` to create a file
- `d` to create a directory
- `R` to rename a file

In Normal mode, you can use the following:

- `Ctrl + o` to go to previous ("old") file
- `Ctrl + i` to go to next file

# Focusing Line

- `zz` will center the current line on the screen
- `zt` will move the current line to the top of the screen
- `zb` will move the current line to the bottom of the screen

You can also use the `so` setting for keeping this behaviour

- `set so=0` is the default and will not focus to scroll
- `set so=999` will keep your focus in the center 
- `set so=5` will keep 5 lines around your focus

# Opening a Terminal

You can open a terminal using the `:term` command, and you can exit terminal mode using `ctrl + \ ctrl + n`, thereafter using `:q` to close the terminal window

# Help

To get help you can use the `:help` command, to search for a specfic topic you can just add it after the help command like `:help nohlsearch`, you can then type `:q` to close the help menu

# Enabling Features

To enable Vim features you can make use of a startup script or a `vimrc` file

# Miscellaneous Options

- `:set number` to turn on line numbers
- `:syntax on` to turn on syntax highlighting