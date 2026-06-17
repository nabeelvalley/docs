---
published: true
title: Benchmarking
subtitle: Overview of some CLI tools for benchmarking
description: Overview of some CLI tools for benchmarking
---

# Hyperfine

[Hyperfine](https://github.com/sharkdp/hyperfine) is a command line benchmarking tool that's pretty straightforward. Using it looks like this:

```sh
hyperfine [...flags] <...commands>
```

> It can be used to benchmark any number of commands

## Basic Run

A simple benchmark of some commands can be seen below:

```sh
hyperfine 'npm install' 'yarn install' 'pnpm install'
```

## Warming Up

Warmup runs can be added using `--warmup <count` as follows:

```sh
hyperfine --warmup 3 'npm install' 'yarn install' 'pnpm install'
```

## Parameterized Run

The `-L` flag can be use to add a parameter, for example the above benchmark can also be done like so:

```sh
hyperfine -L pkg npm,yarn,pnpm '{pkg} install'
```


## Flags

It also has some flags, the following of which I think are useful:

- `--warmup <count>` the number of warmup iterations
- `-i`/`--ignore-failure` ignores errors
- `-s <shell>`/`--shell <shell>` sets the shell to use for running commands
- `-L <param> <comma separated values>`/`--parameter-list` provides a way to specify params
- `--parameter-scan <param> <from> <to> -D <diff>` makes it possible to provide a range for params
