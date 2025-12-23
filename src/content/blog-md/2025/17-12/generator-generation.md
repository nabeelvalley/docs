---
title: Generator Generation
published: true
feature: true
subtitle: 17 December 2025
description: Converting callback based APIs into Async Generators in JavaScript/Typescript
---

So I was just going to write a short post about this handy function I made, but I thought it would be a nice opportunity to build a little bit more of an understanding around the topic of generators more broadly

Our end goal is going to be to define an abstraction that will allow us to convert any Callback-Based API into an Async Generator. Now, if those words don’t mean much to you, then welcome to the other side of JavaScript. If you’re just here for the magic function, however, feel free to skip to the end

## Promises

Before diving into the complexity of generators, we're going to quickly kick off with a little introduction to `Promises` and how they relate to `async/await` and callback code

Promises are used to make async code easier to work with and JavaScript has some nice syntax - like `async/await` that makes code using promises easier follow and understand. They're also the common way to represent async operations which is exactly what we're going to use them for

Before we can dive right into implementing our function for creating an `AsyncGenerator` from a callback based API, it's important to understand how we might go about wrapping a callback based API into a `Promise`

### Creating Promises from Callbacks

Often we end up in cases where we've got some code that is callback based - this is a function, for example `setTimeout`, that will invoke the rest of our code asynchronously when some task is done or event is received

A simple example of a callback based function is `setTimeout` which will resume the execution of our code after some specified amount of time:

```ts
setTimeout(() => {
  console.log('this runs after 1000ms')
}, 1000)
```

A common usecase is to convert this to a `Promise` so that consumers can work with this using `async` functions and `await`ing the relevant function call

The basic method for doing this consists of returning a `Promise` and handling the rejection or resolution within the callback. For example, we can create a promise-based version of `setTimeout` using this approach:

```ts
function sleep(timeout: number) {
  return new Promise((resolve, _reject) => {
    setTimeout(resolve, timeout)
  })
}
```

This promise will now resolve when `setTimeout` calls the `resolve` method that's been passed to it. This allows us to turn some callback based code like this:

```ts
setTimeout(() => {
  console.log('done')
}, 1000)
```

Into this:

```ts
await sleep(1000)
console.log('done')
```

Granted, this isn't a huge difference - the value of this comes from when we have multiple of these kinds of calls nested within each other. Callback code is notorious for its tendency towards chaos. My rule of thumb on this is basically "less indentation is easier to understand". And if we can avoid indentation and keep our code flat we can focus on the essential complexity of our application and not the cognitive load that comes with confusing scope, syntax, and callbacks

This is such a common problem in the JavaScript world, that Node.js even has a builtin function `node:util` called `promisify` that converts Node.js style callback functions into promise-based ones

### Async/Await

When working with promises, it's useful to define our methods using the `async` keyword, this allows us to work with a `Promise` using `await` and not have any callbacks

So we can have our function below, which can `await` the `sleep` function and it would be defined like so:

```ts
async function doWork(){
  await sleep(5000)
  console.log('fine, time to work now')
}
```

The `doWork` function returns `Promise`, this is because the `async` keyword is some syntax sugar for creating a `Promise`

### Promises vs Async

For the sake of understanding, all that the `async` keyword does allow us to remove the `Promise` construction from our function - `async` functions are simply functions that return a `Promise` - these are alternative syntax for the same thing - so, the following two functions are the same:

Using `async`:

```ts
async function getNumber() {
  return 5
}
```

Using an explict `Promise`:

```ts
function getNumber() {
  return new Promise((resolve) => resolve(5))
}
```

### Promise.withResolvers

Another pattern that often comes us is the need to reach into the `Promise` constructor and grab onto its `resolve` and `reject` methods and pass them around so that we can "remotely" compelete a `Promise`, as per MDN, the common pattern for doing this looks something like so:

```ts
function withResolvers<T>() {
  let resolve: (v: T) => void = () => {}
  let reject: (error: unknown) => void = () => {}

  new Promise<T>((res, rej) => {
    resolve = res
    reject = rej
  })

  return {
    resolve,
    reject,
  }
}
```

This method is also a recent addition to the `Promise` class via `Promise.withResolvers`, but for cases where it's not - the above should serve the equivalent purpose

Now that we've got an understanding of Promises, it's time to talk about Iterators and Generators

## Iterators and Generators

Iterators and generators enable iteration to work in JavaScript and are what lies behind objects that are iterable by way of a `for ... of` loop

### Iterator

An iterator is basically an object that will return a new value whenever its `next` method is called

A simple iterator can be defined as an object that has a `next` method that returns whether it's `done` or not.

```ts
function countToIterator(max: number): Iterator<number> {
  let value = 0

  const iterator: Iterator<number> = {
    next() {
      value++
      return {
        value,
        done: value === max,
      }
    },
  }

  return iterator
}
```

JavaScript uses the `Symbol.iterator` property to reference this object and therefore makes it possible for the language `for ... of` loop to iterate through this object. We can use the `countToIterator`'s returned `iterator` to define an `Iterable`

What a mouthful right?? - But the implementation is actually easier than the description:

```ts
function countTo(max: number): Iterable<number> {
  const iterator = countToIterator(max)

  return {
    [Symbol.iterator]() {
      return iterator
    },
  }
}
```

Once we've got this, we can use the `countTo` in a loop:

```ts
// counts from 1 to 5
for (const v of countTo(5)) {
  console.log('count', v)
}
```

Could this be an array? Maybe. Arrays are really just a special case of an iterator. More generally, iterators are cool because they don't have to have a fixed endpoint, or even a fixed list of values. For example, we can create a different iterator that counts until a random point by modifying how the `next` function works:

```ts
function randomlyStopCounting(): Iterable<number> {
  let value = 0

  const iterator: Iterator<number> = {
    next() {
      value++
      return {
        value,
        done: Math.random() > 0.8,
      }
    },
  }

  return {
    [Symbol.iterator]() {
      return iterator
    },
  }
}


for (const v of randomlyStopCounting()) {
  console.log('count', v)
}
```

This is used the same as above, but the point at which this will return isn't really known beforehand. This dynamic behavior can come from lots of different places and not just from `Math.random` and it can allow some really interesting behaviors

### Generators

Defining the above iterators is fun and all, but it's quite messy. The higher-order syntax for defining these kinds of iterators is using `Generators`

(I know, what's with all these words right??)

Okay, so generator functions are functions that return a special iterator called a `Generator`. If we weren't into the territory of weird syntax already - generators are defined using the `function*` keyword, and use the `yield` keyword to provide the next value. So we can rewrite our `countTo` function using a generator function and it would look like this:

```ts
function* countTo(max: number): Generator<number> {
  let value = 0

  while (value < max) {
    value++
    yield value
  }
}
```

That's actually way nicer to read right? When we `yield` a value the flow is delegated to the loop body, just like in the case of a normal iterator, which means the consumer can actually end the iteration early, like:

```ts
for (const v of countTo(5)) {
  console.log('count', v)
  if (v == 3) {
    break
  }
}
```

This also applies for the iterators above, I just find it so much more interesting in this case because there's no concept that someone is going to "call the `next` method again" which is so transparent in the iterator example above

### Async Generators

Now, we're taking one more step - what if I wanted to do some long running task between each `yield`? This could be anything from waiting for a `Promise` to resolve, or a network request, or some user event (oh wow - there's an idea for multi-step forms!)

Async Generators enable us to use promises in our iterators. Let's take a look at how we might define an async version of our `countTo` generator above:

```ts
async function* countToAsync(max: number): AsyncGenerator<number> {
  let value = 0

  while (value < max) {
    await sleep(1000)
    value++
    yield value
  }
}
```

Almost exactly the same right? Aside from the sneaky `async` keyword and the `await` in the loop, this is pretty similar to the sync version above. Using this also has a new little twist, can you spot it?:

```ts
for await (const v of countToAsync(5)) {
  console.log('async count', v)
}
```

Interesting right? We're now using a `for await ... of` loop. If you were to run this, you'd also notice that there's a little pause between each value being logged

## Unwrapping the Generator

Now that we've seen what the inside of an iterator looks like - it's time to open the box and see what generators have inside

Let's start with the sync version

### Inside a Sync Generator

So if we re-define our `countTo` generator without using the `function*` and `yield` syntax sugar, we'll see something like this:

```ts
function countTo(max: number): Generator<number> {
  let value = 0

  const generator: Generator<number> = {
    [Symbol.iterator]() {
      return generator
    },
    next() {
      value++
      return {
        value,
        done: value === max,
      }
    },
    return() {
      return undefined
    },
    throw(e) {
      throw e
    },
  }

  return generator
}
```

This looks **very** similar to an iterator - and that's because it is!

The `Generator` type inherits from the `Iterator` and needs an additional `return` and `throw` methods. The `return` method allows the generator to handle any cleanup once the consumer is done iterating. The `throw` allows any handling of errors and any other cleanup tasks

### Inside an Async Generator

The async version of the above is almost identical - but we just sprinkle the `async` keyword around to make the respective methods all return a `Promise` as this is what the `AsyncGenerator` requires:

```ts

function countToAsync(max: number): AsyncGenerator<number> {
  let value = 0

  const generator: AsyncGenerator<number> = {
    [Symbol.asyncIterator]() {
      return generator
    },
    async return() {
      return undefined
    },
    async next() {
      await sleep(1000)
      value++
      return {
        value,
        done: value === max,
      }
    },
    async throw(e) {
      throw e
    },
  }

  return generator
}

for await (const v of countToAsync(5)) {
  console.log('async count', v)
}
```

Just like when defining the Async Generator before, we're just calling `sleep` between each return value. We've also made the `return` and `throw` methods `async` as well

## Creating Generators from Callback Functions

Well, it's been a long way, but we finally have all the tools we need to turn a callback based method into an iterator. So far, we've been using `setTimeout` for our callbacks, but generators return multiple values. We're going to create a little modified version of `setInterval` for this so that we can play around

The version we'll define is called `countInterval` and will emit a new number until the given value and then stop, this looks like so:

```ts
function countInterval(
  max: number,
  onValue: (num: number) => void,
  onDone: () => void,
) {
  let value = 0
  const interval = setInterval(() => {
    if (value === max) {
      clearInterval(interval)
      onDone()
      return
    }

    value++
    onValue(value)
  }, 1000)
}

```

And the usage looks like this:

```ts
countInterval(
  5,
  (v) => console.log('count interval', v),
  () => console.log('count interval done'),
)
```

Assume for whatever reason that we want to be able to take functions like this and turn them into generators. In general, we can go about the process of manually defining a generator, but that's a little tedious and requires managing a lot of internal state. It would be nice if we could do this without having to manage the intricate details of a custom generator. We basically want to define `countInterval` such that it looks like this:

```ts
function countIntervalGenerator(max: number): AsyncGenerator<number> {}
```

For now, let's asume we've got a method called `createGenerator` that returns everything we need to hook up a generator and return it, this looks something like this:

```ts
function countIntervalGenerator(max: number): AsyncGenerator<number> {
  const { generator, next, done } = createGenerator<number>()

  countInterval(max, next, done)

  return generator
}
```

And our new generator can be used just as usual:

```ts
for await (const value of countIntervalGenerator(5)) {
  console.log('count interval generator', value)
}
```

Defining this wonderful `createGenerator` function combines what we've learnt about promises and generators to get this:

```ts
function createGenerator<T>() {
  let current = Promise.withResolvers<T>()
  let final = Promise.withResolvers<void>()

  const generator: AsyncGenerator<T> = {
    [Symbol.asyncIterator]() {
      return generator
    },

    async return() {
      const value = await final.promise

      return {
        done: true,
        value
      }
    },

    async next() {
      const value = await current.promise
      return {
        done: false,
        value,
      }
    },

    async throw(e) {
      throw e
    },
  }

  const next = (value: T) => {
    current.resolve(value)
    current = Promise.withResolvers()
  }

  const done = () => {
    final.resolve()
  }

  return {
    next,
    done,
    generator,
  }
}
```

This isn't doing anything that we haven't covered before. The only interesting bit (in my opinion) is how the `next` handler creates a new promise on each iteration - this implementation probably has some weirdness due to that so in practice you probably want to handle that edge case somewhat. This could maybe be done by updating the `next` function to take a parameter to indicate if it will emit a new value or not but in practice it's not always easy to figure that out - and in many cases you just don't know

That all being said, I think this implementation should make it clear how these pieces all fit together - there's a lot more detail that can be had in this discussion since each of these topics are fairly deep - but I hope this post was - if not useful - then at least interesting

## References and Further Reading

- [MDN: Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
- [MDN: Promise.withResolvers()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/withResolvers)
- [MDN: Iterators and generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_generators)
- [MDN: Iterator protocols](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)
- [MDN: yield*](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield*)
- [Node.js: util.promisify](https://nodejs.org/api/util.html#utilpromisifyoriginal)
