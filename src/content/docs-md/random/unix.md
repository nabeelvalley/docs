---
published: true
title: Unix Shell
description: Commands and shortcuts for using the unix based shells
---

## Searching

You can use `grep` to search in a file

```sh
grep "hello" ./hello.txt
```

This also works using a pipe:

```sh
cat hello.txt | grep hello
```

And it can take a regex using the `-e` flag:

```sh
cat hello.txt | grep -e `^hello`
```

`grep` can also be used to search recursively through a directory using the `-R` flag:

```sh
grep -R "hello" ./hello
```

And using a regex

```sh
grep -R ^hello
```

Or case inensitive with `-i` or for full words with `-w`

You can even search for something in the output of a command using a pipe (`|`)

```sh
echo "hello world" | grep "world"
```

## Text Manipulation

### Cutting Text (Cut)

You can cut some text on a per-line basis using `cut`. You can view the help for `cut` using:

```sh
man cut
```

Cut has 3 main modes, namely:

`-b` which lets you specify a byte position or byte range to keep

```sh
cat file.txt | cut -b 3   # take the third byte of each line
cat file.txt | cut -b 3-5 # take bytes 3-5 of each line
cat file.txt | cut -b 3-  # take bytes 3 to end of each line

cat file.txt | cut -b 1,5-7,9  # any mix of the above
```

`-c` which lets you specify a character position or character range to keep

```sh
cat file.txt | cut -c 3   # take the third character of each line
cat file.txt | cut -c 3-5 # take chars 1-5 of each line
cat file.txt | cut -c 3-  # take char 3 to end of each line

cat file.txt | cut -c 1,5-7,9  # any mix of the above
```

`-f` which allows for splitting on a field name using `-d` as the delimiter (default delimiter is `\t`)

```sh
cat file.txt | cut -f 1   # take the first column of each line using the default delimter

cat file.txt | cut -d "," -f 1   # take the first column of each line
cat file.txt | cut -d "," -f 2-4 # take chars 1-5 of each line
cat file.txt | cut -d "," -f 2-  # take char 3 to end of each line

cat file.txt | cut -d "," -f 1,5-7,9  # any mix of the above
```

### Stream Editing (Sed)

Sed enables stream editing using a specific set of commands

#### The `s` (substitute) command

> [The "s" Command (sed, a stream editor)](https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html)

The `s` command is the most commonoly used and runs a regex replacement and has the following structure:

```sh
sed `s/regexp/replacement/flags`
```

#### General Command Syntax

The syntax for some handy commands are:

- Substitute: `s/regexp/replacement/flags`
- Append text after a line: `a text`
- Insert text before a line: `i text`
- Change line to specific text: `c text`
- Delete until newline: `D`
- Print the current line: `n`
- Group many commands together: `{ cmd; cmd ... }`

Commands can also be prefixed with a number to make them run multiple times. Multiple commands can be separated with a `;` so commands can be tied together to do weird stuff like:

```sh
seq 20 | sed "n;s/./x/;"
```

> Also useful to take a look at the [Common Commands (sed, a stream editor)](https://www.gnu.org/software/sed/manual/html_node/Common-Commands.html) and the full [sed commands list (sed, a stream editor)](https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html)

## Processes

### List Processes

To kill a process you can first list running processes

```sh
lsof
```

To get the PID of a process you can use `lsof` along with `grep`, e.g. find a `node` process:

```sh
lsof | grep node
```

### Find A Process on a Current Port

E.g for a processs running on port `4001`

```sh
lsof -i:4001
```

You can also just get the port by adding `-t`:

```sh
lsof -t -t:4001
```

### Kill a Process by PID

You can kill a process using it's PID using:

```sh
kill 1234
```

Or with `-9` to force

```sh
kill -9 1234
```

### Kill a Process by Port

You can kill a process that's listening on a port by first getting the PID of the process with `lsof -t -i:<PORT NUMBER>` and pass it into the `kill` command, e.g. for port `4000`

```sh
kill $(lsof -t -i:4000)
```

### Jobs/Background Processes

Start a process, e.g. `ping`

```sh
ping google.com
```

The use `ctrl+z` to suspend the task into the background

You can now use the terminal and start other jobs

Once jobs are running you can use `jobs` to view runnning jobs:

```sh
jobs

## which outputs
[1]    suspended  ping google.com
[2]  - suspended  ping other.com
[3]  + suspended  ping hello.com
```

Jobs can be resumed using `fg` for the most recent job, or `fg %<JOB NUMBER>` to resume a specific job

For example, resuming the `ping hello.com` can be done with:

```sh
fg %3
```

### Navigating 

You can use `cd` to move to specific folders relatively

```sh
cd ../other-folder/my-folder
```

Or even from the user home directory by prefixing with `~`

```sh
cd ~/my-stuff
```

And you can use `-` to just swap back to the last directory

```sh
## before, in apps/stuff, now in apps/something-else
cd -
## after, now in apps/something-else
```

## Tail/Watch a file as it changes

You can get the tail of a file and watch it as it changes using:

```sh
tail -f ./path/to/file
```

## Copy to Clipboard

To copy contents to the clipboard you can simlpy pipe it to `pbcopy` like so:

```sh
cat hello.txt | pbcopy
```
