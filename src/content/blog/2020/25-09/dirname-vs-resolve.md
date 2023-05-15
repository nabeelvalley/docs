---
published: true
title: Node.js Dirname vs Resolve
subtitle: 25 September 2020
description: Working with paths using resolve and __dirname in Node.js
---

Node.js has a few methods by which we can get the directory in which we are currently executing, and get paths relative to it

# Get the Current Directory

## Process Directory

We can get the working directory from where we started the `node` script with:

```js
const processDir = process.cwd()
```

## File/Module Directory

And we can get the directory in which the currently executing file is in with:

```js
const fileDir = __dirname
```

# Get Path to a Target Location

To get an absolute path to a specific target file/directory we have a few methods

## Joining Paths

We can use the `path` module's `join` method to get a path given any path pieces you can go up or down a directory using the `../` notation

```js
const { join } = require('path')

const path1 = join(basePath, './downdir/myfile.txt')
const path2 = join(basePath, '../updir')
```

## Absolute Path from Process Directory

To get an absolute path from the process directory, you can use the `path` module's `resolve` function:

```js
const { resolve } = require('path')

const absPath = resolve('./downdir/myfile.txt')
```

> Like the `join` method you can also use the `../` notation to move up a directory

Using `resolve` is basically shorthand for using `join` with `process.cwd()`

```js
const absPath = join(process.cwd(), './downdir/myfile.txt')
```

## Absolute Path from File/Module Directory

If it makes more sense to get the path relative to the executing file, you can use a combination of `__dirname` and `join` like so:

```js
const { join } = require('path')

const absPath = join(__dirname, './downdir/myfile.txt')
```
