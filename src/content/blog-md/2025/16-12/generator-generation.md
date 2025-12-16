---
title: Generator Generation
published: false
subtitle: 16 December 2025
description: Converting callback based APIs into Async Generators
---

```ts
function sleep() {
  return new Promise((res) => setTimeout(res, 1000));
}

function withResolvers<T>() {
  let resolve: (v: T) => void = () => undefined;
  let reject: (error: unknown) => void = () => undefined;
  let done = false;

  const promise = new Promise<T>((res, rej) => {
    resolve = res;
    reject = rej;
  });

  return {
    promise,
    resolve(v: T) {
      resolve(v);
      done = true;
    },
    reject(err: unknown) {
      reject(err);
      done = true;
    },
    get done() {
      return done;
    },
  };
}

function createGenerator<T, R>() {
  let current = withResolvers<T>();
  let final = withResolvers<R>();

  const generator: AsyncGenerator<T, R> = {
    [Symbol.asyncIterator]() {
      return generator;
    },

    async return() {
      const value = await final.promise;

      return { done: true, value };
    },

    async next() {
      if (final.done) {
        const value = await final.promise;
        return {
          done: true,
          value,
        };
      }

      const value = await current.promise;
      return {
        done: false,
        value,
      };
    },
    throw(e) {
      throw e;
    },
  };

  const next = (value: T) => {
    current.resolve(value);
    if (!final.done) {
      current = withResolvers();
    }
  };

  const done = (result: R) => {
    final.resolve(result);
  };

  return {
    next,
    done,
    generator,
  };
}

function myCallbackFunction(
  onResult: (value: number) => void,
  onDone: () => void,
) {
  setTimeout(() => onResult(1), 1000);
  setTimeout(() => onResult(2), 2000);
  setTimeout(() => onResult(3), 3000);
  setTimeout(onDone, 4000);
}

async function main() {
  const { done, generator, next } = createGenerator<number, void>();

  myCallbackFunction(next, done);

  for await (const value of generator) {
    console.log(value);
  }
}

main();
```