---
published: true
title: Nushell
description: Nushell Commands and Usage
---

> [Nushell Docs](https://www.nushell.sh)

# About

Nushell makes use of command outputs as data that can be transformed, it makes use of pipes that connnect commands together in a functional-programming usage style

# Thinking in Nu

Nushell works with results using pipes, this is similar to `>` in bash but isn't exactly the same

## Immutability

Variables are immutable, however values can be shadowed, so I can create a shadowing `x` based on a previous `x` like so:

```sh
let x = $x + 1
```

## Scoping

Nushell uses scoped environmments in blocks, so a command can use a value within its scope like so:

```sh
ls | each { |it|
    cd $it.name
    make
}
```

# Fundamentals

### Types of Data

The `describe` command returns the type of a variable

```sh
42 | describe
```

### Conversions

The `into` command can convert variable types

```sh
"-5" | into int
```

```sh
"1.2" | into decimal
```

### Strings

Strings can be created as:

1. Double quotes: `"hello world"`
2. Single quotes: `'hello: "world"'`
3. Interpolated: `$"my number = (40 + 2)"`
4. Bare: `hello`

### Bools

Booleans are simply `true` and `false`

### Dates

Dates can be in the following formats:

- `2022-02-02`
- `2022-02-02T14:30:00`
- `2022-02-02T14:30:00+05:00`

### Durations

Nushell has the following durations:

- `ns` nanosecond
- `us` microsecond
- `ms` millisecond
- `sec` second
- `min` minute
- `hr` hour
- `day` day
- `wk` week

And can be used like so:

```sh
3.14day
```

Or in calculations

```sh
30day / 1sec
```

### Ranges

Ranges can be done as `1..3` for example, by default the end is inclusive, ranges can also be open ended `..2` or `2..`

### Records

Records hold key-value pairs, and may or may not have commas between entry names:

```sh
{name: john age: 5}
```

> A record is the same as a single row of a table

Records can be iterated over by transposing them into a table:

```sh
{name: john age: 5} | transpose key value
```

And accessing properties can be done like:

```sh
{name: john age: 5}.age
```

Or

```sh
{name: john age: 5}."age"
```

### Lists

Lists are ordered sequences of data and use `[]` with optional `,` separators. The below will create alist of strings

```sh
[sam fred george]
```

> A list is the same as a single column table

Indexing lists can be done with a `.` as with records:

```sh
[sam fred george].1
```

Or using ranges:

```sh
[sam fred george] | range 0..1
```

### Tables

Tables can be created with the following syntax:

```sh
[[column1, column2]; [Value1, Value2] [Value3, Value4]]
```

Tables can also be created from json

```sh
[{name: sam, rank: 10}, {name: bob, rank: 7}]
```

> Internally tables are just a list of records

### Blocks

Blocks of code are denoted using `{}`, for example:

```sh
each { |it| print $it }
```

## Loading Data

### Open Files

Files can be opened with the `open` command:

```sh
open package.json
```

Nu will parse the file if it can and will return data and not just a plain string

If a file extension isn't what the type usually has, we can still parse the file, we just ned to tell nu that it's a specific format, so we can do this like so:

```sh
open Cargo.lock | from toml
```

### Manipulating Strings

String data can be manipulated using things like the `lines` command which will split each line into a row:

```sh
open people.txt | lines
```

And we can further apply the `split` command on the column to split it by some specific character:

```sh
open people.txt | lines | split column ";"
```

Additionally, we can use `trim`:

```sh
open people.txt | lines | split column ";" | str trim
```

And lastly, we can transform it into a table with formal column names with some additional properties on the `split` command:

```sh
open people.txt | lines | split column "|" first_name last_name job | str trim
```

### Fetch Urls

We can also fetch remote files which will then also be converted into data like so:

```sh
fetch https://blog.rust-lang.org/feed.xml
```

# Cheatsheet

## Moving around the File System

Nushell provides commands for normal file-system related tasks which are similar to common commands such as:

```sh
./hello/world # will cd to the directory
```

## Listing Files

```sh
ls
```

Or listing a specific file type

```sh
ls *.md
```

Or even globs

```sh
ls **/*.md
```

## Globs

You can also use the `glob` method directly to find files recursively:

```sh
glob **/*.png
```

> The `glob` method returns a list of strings versus the `ls` method which returns a list of file objects


### Stopping All Docker Containers

The Docker CLI outputs data that's nicely structured for working with the NuShell table structure.

We can kill all containers by parsing the data into a table and stopping them individually

```sh
docker container ls | from ssv | select "CONTAINER ID" | each { |i| docker container stop $i."CONTAINER ID" } 
```

## Config

Some utils from my current `config.nu`, primarily for working with Git

```nu
alias gch = git checkout
alias gcb = git checkout -b
alias glg = git log --graph
alias ga = git add
alias gp = git push
alias gf = git fetch
alias gl = git pull
alias gcm = git commit -m
alias gprune = git remote prune origin

alias conf = code $nu.config-path
alias env = code $nu.env-path

# Deletes all branches other than the current branch
def gclean [] {
  git branch 
  | lines 
  | filter {|l| $l | str contains -n "*"} 
  | each {|b| $b | str trim} 
  | each {|b| git branch -d $b}
}

def 'gclean D' [] {
  git branch 
  | lines 
  | filter {|l| $l | str contains -n "*"} 
  | each {|b| $b | str trim} 
  | each {|b| git branch -D $b}
}

def gmaster [] {
  let branch = git rev-parse --abbrev-ref HEAD
  git checkout master
  git pull
  git checkout $branch
  git merge master
}

def dev [repo:string] {
  code $"~/repos/$repo"
}

# Search for a string or regex using `rg -i`
def search [
    regex:string, # regex or string to search on 
    -i # Run the search as case insensitive
  ] {
  if $i {
    rg -i $regex
  } else {
    rg $regex
  }
}
```
## Watch Mode

> [watch command docs](https://www.nushell.sh/commands/docs/watch.html)

Nushell has builtin support for watching files and running a comand when they change

You can do this using the `watch` command:

```sh
watch /some/path { echo "things have changed" }
watch /some/path {|op, path, new_path| echo "things have changed" }
watch /some/path --glob=**/*.json { echo "things have changed" }
```

## Notifiy

A little script that's also useful to have is this one that will notify you when a task completes. It's a handy way to be notified when a long running task completes

> This uses AppleScript as per [the example on stackexchange](https://apple.stackexchange.com/questions/57412/how-can-i-trigger-a-notification-center-notification-from-an-applescript-or-shel) so it will only work on MacOS. I'm sure there's a similar way to accomplish this on other operating systems

```sh
def "notify" [title: string = "Task Complete"] {
  print $in

  let $command = 'display notification "' + $title + '" with title "Shell Process Complete" sound name "Frog"'
  osascript -e $command
}
```

You can include the above in your nushell config and use it as follows:

```sh
my-command long-task | notify "My Long Task is Completed"
```

It will also handle printing the output from the task being run

# The `$in` Param and Closures

Nushell functions can also use an implicit input parameter, this can be used when defining a function, for example:

```sh
def example[] {
  echo $in 
}
```

Which can then be used as 

```sh
"Hello World!" | example
```

Additionally, note that `example "Hello World!"` will not work since `$in` params cannot be passed positionally and can only be used part of a pipeline

It's also possible to use `$in` when we epect a closure which lets us leave out the parameter definition, for example, we can run `ls` in all subdirectories of an input like so:

```sh
# Using a normal closure
ls | each { |f| ls $f.name }

# Using `$in`
ls | each { ls $in.name }
```

The `{ ls $in.name }` is the same as a closure like `{|f| ls $f.name }` so it's a bit easier to type in this scenario as well.

## Parsing

The `parse` function can be used to read some string into a usable data structure, take the following file for example:

```
john smith, age: 24
jack smith, age: 54
```

The parse command lets us structure that using:

```
open data.txt | lines | parse "{name} {surname}, age: {age}"

╭───┬──────┬─────────┬─────╮
│ # │ name │ surname │ age │
├───┼──────┼─────────┼─────┤
│ 0 │ john │ smith   │ 24  │
│ 1 │ jack │ smith   │ 54  │
╰───┴──────┴─────────┴─────╯
```

## Detecting Columns

In simple cases instead of parsing some text you can also use `detect columns`. For example using a file like this:

```
Name       Age
Bob Smith  25
Jack Smith 82
```

We can use `detect columns` to automatically parse the simple structure for us:

```
open data.txt | detect columns

╭───┬──────┬─────╮
│ # │ Name │ Age │
├───┼──────┼─────┤
│ 0 │ Bob  │ 25  │
│ 1 │ Jack │ 82  │
╰───┴──────┴─────╯
````

If our table doesn't have headers we can still use `detect columns --no-headers` to prevent it trying to use the first row as a header:

```
 git status --porcelain | detect columns --no-headers

╭───┬─────────┬──────────╮
│ # │ column0 │ column1  │
├───┼─────────┼──────────┤
│ 0 │ A       │ data.txt │
╰───┴─────────┴──────────╯
```

We can combine this with a `rename` to improve this structure of our output table:

```
git status --porcelain | detect columns --no-headers | rename status file

╭───┬────────┬──────────╮
│ # │ status │   file   │
├───┼────────┼──────────┤
│ 0 │ A      │ data.txt │
╰───┴────────┴──────────╯
```

## Input

You can take in user input using the `input` function, this allows for dynamic imput. This is handy for doing a search over some list, for example composing it with the above:

```sh
open data.txt | lines | parse "{name} {surname}, age: {age}" | input list 'Search for User' --fuzzy 
```

## Closures

Nushell does something quite interesting with closures. Since everything is immutable it's possible to do environment-changing operations in a somewhat contained way.

For example, I can `do` some stuff like moving to a different folder, but I will not be affected outside of the closure

```sh
# in the `root` folder
do { cd ./my-child | ls } # within the closure i am inside of the `my-child` folder
# back to the `root` folder
```

Or  I can `cd` into each folder and `ls` each of them, while remaining in my parent folder.

```sh
# in the `root` folder
ls | where type == dir | each { cd $in.name | ls }
# back to the `root` folder
```


## Parallel

Due to the isolation that closures afford us, we can also run these in parallel, nushell has parallel methods of some commands, e.g. the `each` command, which can be used with `par-each`:

```sh
ls | where type == dir | par-each { cd $in.name | ls }
```

This works the same but is much faster for large/complex tasks

## Timer

Nushell also has a `timeit` command that can be used to time the execution of any block, for example:

```sh
timeit { ls | each { print $in.name } }
```

## Passing Multiple Strings

Nushell supports a spread-type operator for passing a list from input into a space-separated command kind of like xargs:

```sh
 ls *.json | get name | yarn prettier --write ...$in
```

> The `...$in` spreads the input stream into a space-separated list
