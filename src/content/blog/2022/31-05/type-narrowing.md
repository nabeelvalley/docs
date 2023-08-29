---
published: true
title: Type Narrowing in Typescript
subtitle: 31 May 2022
description: Using Type Narrowing for better handling of dynamic variables in typescript
---

Type Narrowing allows us create conditions under which an object of one type can be used as if it is of another type. We usually use this in conjunction with union types to allow us to specify different handling of the types based on the resulting value

## Using `typeof`

We can use the `typeof` keyword in javascript to find out whether what type an object is. This is useful if we have an object that can take on different structures, for example

```ts
type Data = string[]
type GetData = Data | (() => Data)
```

In the above example, we have a type called `GetData` which can be either some data or a function to get data. Using this, we can can create a function which fetches data like so:

```ts
const fetchData = (getData: GetData): Data => {
  if (typeof getData === 'function') {
    return getData()
  }

  return getData
}
```

## Using `in`

Javascript also has the `in` operator which can be used to infer types by us checking a property of an object

```ts
type SimpleData = {
  name: string
}

type ComplexData = {
  name: {
    first: string
    last: string
  }
  isComplex: true
}

type AnyData = SimpleData | ComplexData
```

We can then use the `in` operator to check the existence of a property of an object by using it along with a key that we expect to be in one object but not another

```ts
const getComplexName = (data: AnyData): string => {
  // isComplex is the name of the key that we expect in `ComplexData` but not `SimpleData`
  if ('isComplex' in data) {
    return [data.name.first, data.name.last].join(' ')
  }

  return data.name
}
```

## Using `is`

We can use the typescript `is` keyword to specify that the return of a boolean means that a variable satisfies a specific condition

For example, we can create a function that basically does what the `in` operator in the above function does:

```ts
const isComplex = (data: AnyData): data is ComplexData => {
  return (data as ComplexData).isComplex
}
```

This can be used in place of the `in` check in the above example like so:

```ts
const getComplexName2 = (data: AnyData): string => {
  // isComplex is the name of the key that we expect in `ComplexData` but not `SimpleData`
  if (isComplex(data)) {
    return [data.name.first, data.name.last].join(' ')
  }

  return data.name
}
```

## References

- [My TS Notes](/docs/javascript/typescript-basics)
- [MDN The `in` operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/in)
- [MDN The `typeof` operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/typeof)
- [TS Docs on Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)
