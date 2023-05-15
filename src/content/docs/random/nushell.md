---
published: true
title: Nushell
description: Nushell Commands and Usage
---

> [Nushell Docs](https://www.nushell.sh)

# About

Nushell makes use of command outputs as data that can be transformed, it makes use of pipes that connnect commands together in a functional-programming usage style

# Moving around the File System

Nushell provides commands for normal file-system related tasks which are similar to common commands

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
