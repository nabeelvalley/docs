---
title: Parameters, but only sometimes
description: Better handling of function generics with optional parameters in Typescript using overloads
subtitle: 16 August 2024
published: true
---

Ran into this question today and I thought it would be a nice little example to document:

I have the following function `doWork` that is generic:

```ts
function doWork<T>(data?: T): void {
  console.log(data);
}
```

This function can be called in any of the following ways:

```ts
// Works
doWork<string>('hello'); //  T is string, data is string
doWork(); // T is undefined, data is undefined
doWork(undefined); // T is undefined, data is undefined;

doWork<string>(); // T is string, data is undefined
```

In the above usage, we want to make it so that users of this function need to provide the `data` parameter when calling the function when the type is provided. Now, a simple solution could be to define our function as follows:

```ts
function doWork<T>(data: T): void;
```

The problem is that it's a bit ugly for cases where we want to allow `T` as `undefined`, because you now have to do this:

```ts
doWork(undefined)
```

So the issue here is that we only want to make the `data` parameter required when `T` is not `undefined`, there's a lot of funny stuff you can try using generics and other weird typescript notation, but simply defining the necessary overloads for our method works:

```ts
/**
 * This specifically handles the case where T is undefined
 */
function doWork<T extends undefined>(): void;
/**
 * The data param will be required since T is not undefined here
 */
function doWork<T>(data: T): void;
/**
 * This provideds an implementation that is the same as before while providing a
 * better interface for function users
 */
function doWork<T>(data?: T): void {
  console.log(data);
}
```

Now, having defined those function overloads, we can use the function and it works as expected:


```ts
// Works
doWork<string>('hello'); //  T is string, data is required
doWork(); // T is undefined, data parameter is not required
doWork(undefined); // T is undefined, specifying data is still okay

// Error: Type 'string' does not satisfy the constraint 'undefined'
doWork<string>(); // this overload is not valid
```

The added benefit of this method is that we can also write the doc comments for each implementation separately which can be a nice way for us to give additional context to consumers. It's kind of like having two specialized functions without the overhead of having to implement them independently