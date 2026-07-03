# Tasks

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
pnpm concurrently "mask watch:gleam" "mask watch:client" "mask serve"
```

