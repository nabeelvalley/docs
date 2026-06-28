---
published: true
title: Highlight Specific Elements
description: Add a border around all HTML Elements that match a CSS Selector to aid in debugging
date: 2020-09-29
---

You can highlight all HTML elements which respond to a specific CSS selector with the following. This can be useful for debugging purposes:

```js
document
  .querySelectorAll(selector)
  .forEach((el) => (el.style.border = 'solid 2px red'))
```

For example, the following `[id]` selector will find all elements with an `id` attribute:

```js
document
  .querySelectorAll('[id]')
  .forEach((el) => (el.style.border = 'solid 2px red'))
```