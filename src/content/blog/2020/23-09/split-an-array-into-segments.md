[[toc]]

It can sometimes be useful to split an array into a separated set of rows or columns, such as when trying to separate elements into buckets while maintaing order.

For example, given the following `input`:

```js
const input = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

With the desired `output` array as follows, in which we split elements into different rows, while maintaing a top-down/left-right ordering:

```js
const output = [
  [1, 4, 7, 10],
  [2, 5, 8],
  [3, 6, 9],
]
```

We can accomplish this using a function like so:

```js
const transform = (arr, segments) =>
  [...new Array(segments)].map((_, outerPos) =>
    input.filter((el, innerPos) => innerPos % segments === outerPos)
  )
```

Which can then be used with:

```js
const rows = 3
const transformedData = transform(input, rows)
```
