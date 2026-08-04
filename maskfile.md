# Tasks

## install

```sh
pnpm install
gleam deps download
cd codegen
gleam deps download
```

## build:client

```sh
pnpm tsc --noEmit
pnpm parcel build
```


## watch:client

```nu
watch client --debounce=1sec {try { mask build:client}}
```

## build:gleam

```sh
gleam run
```

## watch:gleam

```nu
watch src --debounce=10sec {try { mask build:gleam; mask build:client }}
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

## update-snapshots

```sh
gleam run -m birdie
```

## check:js

```sh
pnpm tsc --noEmit
```

## serve

```sh
pnpm serve out
```

## dev

```sh
mask build
pnpm concurrently "mask watch:gleam" "mask watch:client" "mask serve"
```

## test

```sh
gleam test
```

## snap

```sh
gleam run -m birdie
```
