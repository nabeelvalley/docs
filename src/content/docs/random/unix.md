---
title: Unix Shell
description: Commands and shortcuts for using the unix based shells
---

[[toc]]

# Searching

You can use `grep` to search in a file

```sh
grep "hello" ./hello.txt
```

Or recursively through a directory:

```sh
grep -R "hello" ./hello
```

And using a RegEx

```sh
grep -R ^hello
```

Or case inensitive with `-i` or for full words with `-w`

You can even search for something in the output of a command using a pipe (`|`)

```sh
echo "hello world" | grep "world"
```

# Processes

## List Processes

To kill a process you can first list running processes

```sh
lsof
```

To get the PID of a process you can use `lsof` along with `grep`, e.g. find a `node` process:

```sh
lsof | grep node
```


## Find A Process on a Current Port

E.g for a processs running on port `4001`

```sh
lsof -i:4001
```

You can also just get the port by adding `-t`:

```sh
lsof -t -t:4001
```

## Kill a Process by PID

You can kill a process using it's PID using:

```sh
kill 1234
```

Or with `-9` to force

```sh
kill -9 1234
```

## Kill a Process by Port

You can kill a process that's listening on a port by first getting the PID of the process with `lsof -t -i:<PORT NUMBER>` and pass it into the `kill` command, e.g. for port `4000`

```sh
kill $(lsof -t -i:4000)
```