---
published: true
title: jq
description: Processing JSON with jq
---

> This page is just some random snippets for reference, you can also look at the [jq documentation](https://jqlang.org/)

Jq is a command line tool for processing JSON. `jq` takes JSON from `stdin` and lets you do stuff with it

# Basic Structure

The basic flow of working with `jq` is by piping something into it and passing a query, `jq` will then return the resulting JSON

```sh
cat package.json | jq ".dependencies"
```

The rest of this doc will just cover the actual `jq` syntax without talking about all the wrapping boilerplate

# Property Access

Accessing a single property can be done like so:

```jq
.scripts
```

Nested properties can also be accessed using this kind of syntax:

```jq
.scripts.build
```

# Piping Results

Piping results from one part of a query can be done with the `|`, for example we can also do nested property access like so:

```jq
.scripts | .build
```

# Mapping

When using an array, you can use the `map` function to transform each entry. Mapping can use results from previous objects and returns a resulting object:

```jq
.dependencies | to_entries | map({(.key): { name: .key, value: .value }})
```

# Object Entries

Getting the entries from an object can be done with the `to_entries` which returns an object with the shape `{key: K, value: V}`

```jq
.dependencies | to_entries | map([.key,.value])
```

However, if all you want are the `keys` you can use those respective functions. `keys` will give you the keys as an array:

```jq
.dependencies | keys
```

# Merging Objects

Merging objects together (like `Object.assign`) can be done with `add`

```jq
.dependencies | to_entries | map({(.key): { name: .key, value: .value }}) | add
```

# Arrays

Arrays can be accessed and indexed as you'd expect from the normal property syntax:

```jq
.dependencies | keys[0]
```

Or, split via a pipe

```jq
.dependencies | keys | .[0]
```

`keys` will return an array of the keys to us which is a normal JSON array, we can also get the length of this with the `length` function:

```jq
.dependencies | keys | length
```

Which will give us the length of the array

# Iterators

Arrays in `jq` can be accessed as a single array or as an iterator over values, iterators let us handle items one at a time or as a single array

Simply using `.[]` can turn something into an iterator, like so:

```jq
.dependencies | keys | .[]
```

Using `.[]` is the same as appending it to the previous value (similar to how property access works)

```jq
.dependencies | keys[]
```

Each of these will return an iterator over the array values, so if we do something like `length` after:

```jq
.dependencies | keys[] | length
```

We'll get the length of each element as a string, instead of the total length of the array

# References

- [jq Docs](https://jqlang.org/)
- [Navendu's jq Guide](https://navendu.me/posts/jq-interactive-guide/)