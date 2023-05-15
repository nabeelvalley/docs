---
published: true
title: Using React.memo for Controlling Component Rendering
subtitle: 16 August 2022
description: Using the react top-level API for debouncing and selectively rendering a component for better performance
---

---

title: Using React.memo for Controlling Component Rendering
subtitle: 16 August 2022
description: Using the react top-level API for debouncing and selectively rendering a component for better performance
published: true

---

# React Top Level API

The React library contains some functions at it's top level scope. Amongst these are the built-in hooks (like `useState`, `useCallback`, etc.) as well as some other functions for manipulating React Elements directly - which I've covered in a previous post on [The React Top Level API](../01-03/react-top-level-api.md)

# Component Rendering

By default, React will trigger a component render whenever there is a change to its `state` or `props`. `React.memo` allows us to take control of the `props` triggered render by giving us a way to look into the prop-change process

`React.memo` is a higher order component (HOC) that allows us to wrap a component and control whether or not it is updated/re-rendered by defining a function that tells react whether or not it's props are different - and effectively whether this should trigger a new render

Doing the above is useful for complex components that don't necessarily need to be rendered every time their props are changed

# API Definition

[The React Docs](https://reactjs.org/docs/react-api.html#reactmemo) give us the following example for the `React.memo` HOC:

```jsx
const MyComponent = (props) => {
  /* render using props */
}

const areEqual = (prevProps, nextProps) => {
  /*
  return true if passing nextProps to render would return
  the same result as passing prevProps to render,
  otherwise return false
  */
}

const MyComponentMemo = React.memo(MyComponent, areEqual)
```

The component `MyComponent` will be rendered whenever props are changed, however, using `React.memo` lets us define a function called `areEqual` that we can can use to tell `React.memo` whether or not the new props would render a different result to the old props

We can then use `MyComponentMemo` in place of `MyComponent` to take control of when the component is rendered

# Rendering On a Specific Type of Change

Say we have the specific component `TimeDisplay` which shows the time that's being passed into it from `App`:

```tsx
import './App.css'
import React, { useState, useEffect } from 'react'

interface TimeDisplayProps {
  time: number
}

const TimeDisplay: React.FC<TimeDisplayProps> = ({ time }) => {
  const display = new Date(time).toString()

  return <h1>{display}</h1>
}

export default function App() {
  const [time, setTime] = useState(Date.now())

  useEffect(() => {
    const handle = setInterval(() => {
      setTime(Date.now())
    }, 100)

    return () => {
      clearInterval(handle)
    }
  }, [])

  return (
    <main>
      <TimeDisplay time={time} />
    </main>
  )
}
```

The `TimeDisplay` component in our case only displays time to the second, so any millisecond-level changes don't matter to the component and so we can save on those renders by checking if the difference in `time` is similar to the previous render's `time`

Let's assume for our purpose that it's acceptable for the time to be delayed by about 5 seconds, we then can define a function called `areTimesWithinOneSecond` which compares the next render's props with the previous and returns if they are within 5 seconds of each other:

```tsx
const areTimesWithinFiveSeconds = (
  prev: TimeDisplayProps,
  next: TimeDisplayProps
): boolean => {
  const diff = next.time - prev.time

  return diff < 5000
}
```

We can use the above function in a `React.memo` to define a version of the `TimeDisplay` component which will prevent unnecessary renders:

```tsx
const TimeDisplayMemo = React.memo(TimeDisplay, areTimesWithinFiveSeconds)
```

And it can then be used as a drop-in replacement for the `TimeDisplay` component:

```tsx
export default function App() {
  const [time, setTime] = useState(Date.now())

  useEffect(() => {
    const handle = setInterval(() => {
      setTime(Date.now())
    }, 100)

    return () => {
      clearInterval(handle)
    }
  }, [])

  return (
    <main>
      <TimeDisplayMemo time={time} />
    </main>
  )
}
```

# Conclusion

From the above implementation we can see that it's possible to delay rendering of a component using `React.memo` if the component doesn't need to be re-rendered, hence improving performance by decreasing the number of renders react needs to carry out

# REPL

The REPL with the example above can seen below:

<iframe height="700px" width="100%" src="https://replit.com/@nabeelvalley/react-memo-demo?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

# References

- [The React Docs](https://reactjs.org/docs/react-api.html#reactmemo)
