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

For example:

```sh
hyperfine --warmup 3 'npm install' 'yarn install' 'pnpm install'
```

It can be used to benchmark any number of commands. It also has a few flags, the following of which I think are useful:

- `--warmup <count>` the number of warmup iterations
- `-i`/`--ignore-failure` ignores errors
- `-s <shell>`/`--shell <shell>` sets the shell to use for running commands
