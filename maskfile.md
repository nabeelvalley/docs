# Lox Tasks

## install

```sh
gleam deps download
pnpm install
```

## build:client

```sh
pnpm tsc --noEmit
pnpm parcel build client/index.ts --dist-dir out
```

## build:gleam

```sh
gleam run
```

## build

> Runs the JS and Gleam commands needed to build the website

```sh
mask build:gleam
mask build:client
```

## format

> Formats all files

```sh
pnpm prettier client --write
gleam format
```

## check:gleam

```sh
gleam build
gleam test
```
## check:js

```sh
pnpm tsc --noEmit
```

## dev

```nu
watch src { try { clear; gleam run } }
```
