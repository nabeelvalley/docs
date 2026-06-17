---
title: Typescript debugging without an IDE
description: Debug Node.js code using your browser's dev tools
subtitle: 18 June 2025
published: true
---

I generally steer clear of IDEs. Their overall slowness and clunkyness makes using them a hassle. There is however one place they execel - debugging. 

Recently I've been looking into how to get Node.js to debug some JS and TS code and this proved to be relatively simple

## A JS file

Debugging a Javascript app is actually pretty straightforward, you can use `node inspect` followed by the file to debug. So this just looks like so:

```sh
node inspect my-file.js
```

Runnning the above with a `debugger;` statement in your code will stop at the breakpoint and you can debug from there

You can then open your browser at `chrome://inspect` and select `inspect` on the process you'd like to debug

## A TS File

Typescript requires you to have a few things installed. I'm going to assume that TypeScript is already installed in the project you're working in. Additionally, you need to install `ts-node` into your project - this can be done using whatever package manager you're currently using

You will also need to ensure that you have `sourceMap` enabled in your `tsconfig.json` file in order to have a bit of a decent debugging experience:


```json title="tsconfig.json"
{
  "compilerOptions": {
	// ... other stuff
    "sourceMap": true
  }
}
```

Next, you can use `node inspect` with the `ts-loader` like so:

```sh
node inspect -r ts-node/register my-file.ts
```

The process then is pretty much the same as for the Javascript file debugging above. You can use `debugger;` statements to add breakpoints, and you can open the debugger at `chrome://inspect`