# Tasks

## install

```sh
gleam deps download
pnpm install
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

```nu
mask build
pnpm concurrently "mask watch:gleam" "mask watch:client" "mask serve"
```


## shoki

### test-default

Runs the static site generator using the default preset and outputs it to .test-out

```sh
gleam run -m shoki/preset/default -- --pages test/workspace/pages --static test/workspace/static --out .test-out
```
