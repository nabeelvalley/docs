---
title: Javascript Proxy Object
subtitle: 11 December 2024
description: Basic introduction to proxies in Javascript/Typescript
---

Proxies allow us to wrap existing object and modify the behavior when interacting with them in some interesting ways. This post will take a look at a few things we can use them for

## Something to work with

For the sake of this example we'll be using Typescript. Let's create a reference object type that we will interact with - we're going to call this `MyApi` and it's defined simply as an object with a few methods on it:

```ts
interface MyApi {
  /**
   * Adds 2 numbers
   * @returns the result of addition
   */
  add: (a: number, b: number) => number;

  /**
   * Difference between 2 numbers
   * @returns the result of subtraction
   */
  subtract: (a: number, b: number) => number;

  /**
   * (secretly does some illegal stuff)
   */
  illegal: (a: number, b: number) => number;
}
```

## Initial implementation

We can implement a simple object that satisifies this APi as below:


```ts
const baseApi: MyApi = {
  add(a, b) {
    return a + b;
  },

  subtract(a, b) {
    return a - b;
  },

  illegal(a, b) {
    return a / b;
  },
};
```


## Log accesses

For this example we'll consider the `illegal` method as special. We'll want to track each time the `illegal` property is accessed. Using a `Proxy` we can wrap the `baseApi` and provide a `get` method that will handle property access and allow us to see what property of our object is being accessed

When `illegal` is accessed, we log out a message:

```ts
const logAccess = new Proxy<MyApi>(baseApi, {
  get(target, key: keyof MyApi) {
    if (key === "illegal") {
      console.log("Tried to access illegal method");
    }

    // return the property from the original object
    return target[key];
  },
});

logAccess.illegal(1, 2);
// logs out the message before calling the function
```

## Prevent illegal access

We can also do stuff like create a type of `WithoutIllegal` version of `MyApi` in which we remove the property from the type definition. Additionally, we can also make this throw an error if someone attempts to access it at runtime as can be seen below. This is very similar to the previous example but now we have a direct impact on the consumer

```ts
type WithoutIllegal<T> = Omit<T, "illegal">;

const police = new Proxy<WithoutIllegal<MyApi>>(baseApi, {
  get(target, key: keyof MyApi) {
    if (key === "illegal") {
      throw new Error("accessing illegal properties is a crime");
    }

    return target[key];
  },
});

try {
  // @ts-expect-error this is now an error since we say "illegal is not defined"
  police.illegal;

  // @ts-expect-error if we try to access it, it will throw
  police.illegal(1, 2);
} catch (err) {
  console.error("Got illegal access", err);
}
```

## Interact with other objects

During the proxying process, we can also do things like interact with objects that aren't defined within our base object itself:

```ts
const logs: any[][] = [];
const withLogs = new Proxy<MyApi>(baseApi, {
  get<K extends keyof MyApi>(target: MyApi, key: K) {
    const method = target[key];

    return (a: number, b: number) => {
      logs.push(["accessing", key, a, b]);

      const result = method(a, b);

      logs.push(["result", result]);

      return result;
    };
  },
});

withLogs.add(1, 2);
withLogs.subtract(1, 2);
withLogs.illegal(1, 2);

console.log(logs);
// [
//   [ 'accessing', 'add', 1, 2 ],
//   [ 'result', 3 ],
//   [ 'accessing', 'subtract', 1, 2 ],
//   [ 'result', -1 ],
//   [ 'accessing', 'illegal', 1, 2 ],
//   [ 'result', 0.5 ]
// ]
```

## Creating fake objects

We can also create an object in which _any_ properties can exist and have a specific value, for example an object that has this structure for any key given:

```ts
{
    myKey: "myKey"
}
```

This can be done like so:

```ts
const fake = new Proxy<Record<string, Record<string, string>>>(
  {},
  {
    get(target, property) {
      return {
        [property]: property,
      };
    },
  }
);

console.log(fake);
// {}

console.log(fake.name);
// { name: 'name' }

console.log(fake.age);
// { age: 'age' }

console.log(fake.somethingelse);
// { somethingelse: 'somethingelse' }
```

> It's also interesting to note that the `fake` object has no direct properties, and we cxan see that when we log it

## Recursive proxies

Proxies can also return other proxies. This allows us to proxy objects recursively. For example, given the following object:

```ts
const deepObject = {
  a: {
    b: {
      getC: () => ({
        c: (x: number, y: number) => ({
          answer: x + y,
        }),
      }),
    },
  },
};
```

We can create a proxy that tracks different actions, such as property acccess. Recursive proxies can be created by returning a new proxy at the levels that we care about. In the below example, we create a proxy for every property that we access as well as for the result of every function call:

```ts
const tracker: any[][] = [];
const createTracker = <T extends object>(obj: T, prefix: string = ""): T => {
  return new Proxy<T>(obj, {
    apply(target, thisArg, argArray) {
      tracker.push(["call", prefix, argArray]);

      const bound = (target as (...args: any[]) => any).bind(thisArg);
      const result = bound(...argArray);

      tracker.push(["return", prefix, result]);

      if (typeof result === "undefined") {
        return result;
      }

      // create a new proxy around the object that's returned from a function call
      return createTracker(result, prefix);
    },

    get(_, prop: keyof T & string) {
      const path = `${prefix}/${prop}`;

      tracker.push(["accessed", path]);
      const nxt = obj[prop];

      if (typeof nxt === "undefined") {
        return nxt;
      }

      // create a new proxy around the object that's being accessed
      return createTracker(nxt as object, path);
    },
  });
};

const tracked = createTracker(deepObject);

const result = tracked.a.b.getC().c(1, 2);

console.log({ result });
// { result: { answer: 3 } }

console.log(tracker);
// [
//   [ 'accessed', '/a' ],
//   [ 'accessed', '/a/b' ],
//   [ 'accessed', '/a/b/getC' ],
//   [ 'call', '/a/b/getC', [] ],
//   [ 'return', '/a/b/getC', { c: [Function: c] } ],
//   [ 'accessed', '/a/b/getC/c' ],
//   [ 'call', '/a/b/getC/c', [ 1, 2 ] ],
//   [ 'return', '/a/b/getC/c', { answer: 3 } ]
// ]
```

# References

> [MDN Proxy Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)