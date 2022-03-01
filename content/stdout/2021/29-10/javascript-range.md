Something i often find myself needing is a way to create a range in javascript, similar to what python has

Here's a basic implementation of something that works like that:

```js
const range = (start, end, count, includeEnd = false) => {
  const space = (end - start) / (count - includeEnd)
  return new Array(count).fill(0).map((_,i) => start + (i * space))
}
```

The above will output something like:

```js
const withoutEnd = range(20, 21, 5)
// withoutEnd === [ 20, 20.2, 20.4, 20.6, 20.8 ]

const withEnd = range(20, 21, 5, true)
// withEnd === [ 20, 20.25, 20.5, 20.75, 21 ]
```
