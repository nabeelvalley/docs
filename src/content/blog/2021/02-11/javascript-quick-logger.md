---
published: true
title: Logging Aliases for Javascript
subtitle: 02 November 2021
description: Console and file-based logging alias for Javascript
---

I often find myself writing a function to `JSON.stringify` some data to log in either a pretty or flat structure

It's just more of a convenience method, and it's pretty much the same as doing `console.log(JSON.stringify(data))` and looks like this:

```ts
const _ = (data: any, pretty: boolean = false) => {
  return console.log(JSON.stringify(data, null, pretty ? 2 : 0))
}
```

And then, when I need to log something:

```ts
_(myData)
```

Or, if I want to pretty print the JSON

```ts
_(myData, true)
```
