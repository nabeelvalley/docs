---
published: true
title: RxJS Basics
---

[[toc]]

> [From DesignCourse on Youtube](https://www.youtube.com/watch?v=PhggNGsSQyg) ([alt](https://coursetro.com/courses/25/A-Comprehensive-RxJS-Tutorial---Learn-ReactiveX-for-JavaScript-))

# Overview

- RxJS is an implementation of ReactiveX in js
- ReactiveX is a way of programming with observable streams

> "ReactiveX is a combination of the best ideas from the Observer pattern, the Iterator pattern, and functional programming" ~ [ReactiveX](http://reactivex.io)

# Installation

1. Create a new typescript static site project:

```
npx @nabeelvalley/project-init
```

And select `ts-static`

```
cd rxjs
```

2. Add `rxjs`

```
yarn add rxjs
```

3. Start the site

```
yarn start
```

# Importing RxJS

To import something from RxJS from the `index.ts` file you can use the following:

```ts
import { Observable } from 'rxjs'

console.log(Observable)
```

This should log the `Observable` object from RxJS


# Observables

> A stream is a series of events that are emitted over time. An observable provides a means to emit and respond to stream events

## Create an Observable

We can create an observable that emits `string` values with the following:

```ts
const observable = new Observable<string>((observer) => {
  observer.next("hello world") // emit a value
})
```

## Subscribe to an Observerble

However, we won't see events emitted unless we have `observers`, in order to get the value we need to define an observer by  with the `subscribe` method. In this case due to how the observable was defined the `value` will be of type `string`:

```ts
const observer = observable.subscribe((value) => {
  console.log(value)
})
```

## Observable Events

The events that we can respond to on an observable are `next`, `error`, and `complete`

We can additionally also handle errors and completion events by passing them into the subscribe as additional params:

```ts
const observable = new Observable<string>(observer => {
  observer.next('hello world')
  observer.next('what is the up')
  observer.error('i am error')
  observer.complete()
  // any methods called on the observer after complete will fire
  observer.next('will not send')
})

observable.subscribe(
  value => console.log(value), // handle next
  error => console.error(error), // handle error
  () => console.log('complete') // handle complete
)
```

## Unsubscribe

To unsubscribe you can use the `observer.unsubscribe` method:

```ts
const observable = new Observable<string>(observer => {
  observer.next('hello world')
  let count = 0
  setInterval(() => {
    count ++
    observer.next('tick ' + count )
  }, 1000)
})

const observer = observable.subscribe(
  value => console.log(value),
  error => console.error(error),
  () => console.log('complete')
)

setTimeout(() => {
  console.log('unsub')
  observer.unsubscribe()
}, 5000)
```

## Multiple Observers

We can create multiple observers simply by using the `observable.subscribe` method:

```ts
const observable = new Observable<string>(observer => {
  observer.next('hello world')
  let count = 0
  setInterval(() => {
    count ++
    observer.next('tick ' + count )
  }, 1000)
})

const observer1 = observable.subscribe(
  value => console.log('observer1', value),
  error => console.error('observer1', error),
  () => console.log('observer1 complete')
)

const observer2 = observable.subscribe(
  value => console.log('observer2', value),
)

setTimeout(() => {
  console.log('unsub')
  observer1.unsubscribe()
}, 5000)
```

## Child Subscriptions

If we want to create linked/child observers we can call the `observer.add` and `observer.remove` methods to add new observers instead of the `observable.subscribe` which will ensure that the child observers are unsubscribed when the parent is:

```ts
const observer = observable.subscribe(
  value => console.log('observer', value),
  error => console.error('observer', error),
  () => console.log('observer complete')
)

const childObserver = observable.subscribe(
  value => console.log('child', value)
)

// add a child observer
observer.add(childObserver)
```

In the below, the child will not unsubscribe as it's removed from the parent:

```
setTimeout(() => {
  // remove a child observer, this will not unsubscribe the child
  observer.remove(childObserver)
}, 3000)

setTimeout(() => {
  console.log('unsub')
  observer.unsubscribe()
}, 5000)
```

However, if we don't remove it, it will automatically 

## Hot or Cold 

A **cold** observable is an observable whose producer is only activated once a subscription has been created

For example, we can create a second observer after a second, this observer will receive all the messages from the start but they will come through a second delayed:

```ts
setTimeout(() => {
  console.log('unsub')
  const observerLate = observable.subscribe(value =>
    console.log('observerLate', value)
  )
}, 1000)
```

However, if we want our observer to get the latest updates and not receive older messages we can create a warm/hot observer by piping the `share` method when we define our observable, this will ensure that the obsever created above will reveive the latest messages only

```ts
const observable = new Observable<string>(observer => {
  observer.next('hello world')
  let count = 0
  setInterval(() => {
    count ++
    observer.next('tick ' + count )
  }, 1000)
}).pipe(share())
```

Now, the `observerLate` will only print out from `tick 2` instead of all the ticks

## From Event

You can create an observerble from DOM events by using the `fromEvent` function:

```ts
const observable = fromEvent(document, 'mousemove')
```

# Subjects 

A subject is simultaneously an observer and an observable which means we are able to send events using the subject and are also able to subscribe to the subject

```ts
import { Subject } from 'rxjs'

const subject = new Subject<string>()

const observer1 = subject.subscribe(
  value => console.log('observer1', value)
)

subject.next('first message')
```

So now we can add observers and send new messages like this:

```ts
const observer2 = subject.subscribe(
  value => console.log('observer2', value)
)

subject.next('second message')

observer2.unsubscribe()

subject.next('third message')
```

In the above, `observer2` will only react to the second message

There are four types of subjects:

### Normal Subject

A `Normal` subject will allow observers to only receive events received after it subscribed, this is what was used above as well:

```ts
import { Subject } from 'rxjs'

const subject = new Subject<string>()

const observer1 = subject.subscribe(
  value => console.log('observer1', value)
)

subject.next('first message')

const observer2 = subject.subscribe(
  value => console.log('observer2', value)
)

subject.next('second message')

observer2.unsubscribe()

subject.next('third message')
```

### Behaviour Subject

A `Behaviour` subject will allow observers to receive all events received after it subscribed as well as: 

  - An initial event for the first observer only
  - The last event fired before a new observer subscribes

```ts
import { BehaviorSubject } from 'rxjs'

const subject = new BehaviorSubject<string>('welcome observer1')

const observer1 = subject.subscribe(
  value => console.log('observer1', value)
)

subject.next('first message')
subject.next('second message')

const observer2 = subject.subscribe(
  value => console.log('observer2', value)
)

subject.next('third message')

observer2.unsubscribe()

subject.next('fourth message')
```

In the above, `observer1` gets the `welcome` event as well as the `first`, `second`, and `third` messages, and `observer2` gets the `second` and `third` messages only even though the `second` message was fired before `observer2` subscribed

### Replay Subject

A `Replay` subject allows you to specify a buffer of events that should be replayed to new subscribers

```ts
import { ReplaySubject } from 'rxjs'

const subject = new ReplaySubject<string>(2)

const observer1 = subject.subscribe(
  value => console.log('observer1', value)
)

subject.next('first message')
subject.next('second message')
subject.next('third message')

const observer2 = subject.subscribe(
  value => console.log('observer2', value)
)
  
subject.next('fourth message')

observer2.unsubscribe()

subject.next('fifth message')
```

So in the above, `observer2` will receive the `second`, `third`, and `fourth` messages only

Additionally a `Replay` subject can accept a second optional argument when constructing which is a buffer time in which the events should be replayed. Any events that happen outside of this timeframe will not be replayed

```ts
import { ReplaySubject } from 'rxjs'

const subject = new ReplaySubject<string>(20, 200)

let count = 0

setInterval(() => {
  count ++
  subject.next('tick ' + count)
}, 100)

const observer1 = subject.subscribe(
  value => console.log('observer1', value)
)

setTimeout(() => {
  const observer2 = subject.subscribe(
    value => console.log('observer2', value)
  )
}, 500)
```

In the above, `observer2` will receive ticks `4` and `5` even though it only starts listening at tick `6`. The observer receives a time-based buffer of messages - `200ms` in this case - and not a count-based one. The `20` provided to the `ReplaySubject` constructor is the max number of messages that should be bufferred

### Async Subject

The async subject only emits the last value and will only do so once the `complete` method has been called on the subject

