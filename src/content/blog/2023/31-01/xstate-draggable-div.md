---
published: true
title: Draggable Div with XState and React
subtitle: 31 January 2023
description: A simple example of using XState with UI Events to build interactivity
---

---
title: Draggable Div with XState and React
subtitle: 31 January 2023
description: A simple example of using XState with UI Events to build interactivity
published: true
---

# Why State Management

Recently I've been interested in understanding non-standard user interactions and about how different applications develop this functionality. A particularly good example for me has been looking into the codebase for [TLDraw](https://www.tldraw.com/) where I ran into state machines

Now, I've played around with a few state machine libraries and I'm fairly familiar with them and have implemented some fairly simple examples for working with multi-step forms and the like, but I haven't really used them in the specific context of designing state

The [State Designer Library](https://www.state-designer.com) mentions the idea of [Designing State](https://www.state-designer.com/designing-state) which suggests that the design of how the user interface should work and the implementation of it should be treated as independent, in order to do so, we should design the states that we would like to work with separately from the UI that implements the state

This provides us with a decent abstraction which should make things about state a lot less tangled and easier to reason about

## XState

State management libraries provide us with a set of abstractions and tools for designing state. There are a few that are commonly used, of which I'll be using [XState](https://xstate.js.org/) in this post. XState has pretty good TypeScript support as well as some great tooling for visualizing and designing state on [Stately](https://stately.ai)

# The Problem

For this post I've chosen to build a simple draggable div component that makes use of XState. The idea here was to get a feel for the library and see how it can be used to tackle problems around UI interaction

## Visualizing the State

Defining the state can be done using the XState visual editor that can be used in VSCode or Stately, this is useful because it lets you visualize different ways that the state can be represented in a relatively low-friction setting

The structure I've decided on for the representing my component's state can be seen below:

![XState Diagram of Draggable UI Component](/content/blog/2023/31-01/draggable-state-diagram.png)

## State Machine Code

The code for the above state machine, with some added type information, can be seen below:

`Draggable.machine.ts`

```ts
import { createMachine, assign } from 'xstate'

type Position = {
  x: number
  y: number
}

type Delta = {
  dx: number
  dy: number
}

type Focus = {
  focused: boolean
}

export const machine = createMachine(
  {
    schema: {
      context: {} as Position,
      events: {} as
        | { type: 'MOVE'; position: Delta }
        | { type: 'FOCUS' }
        | { type: 'BLUR' },
    },

    initial: 'inactive',
    states: {
      inactive: {
        on: {
          FOCUS: 'active',
        },
      },

      active: {
        on: {
          MOVE: {
            target: 'active',
            internal: true,
            actions: 'updatePosition',
          },
          BLUR: 'inactive',
        },
      },
    },
  },
  {
    actions: {
      updatePosition: assign((context, event) => ({
        x: event.position.dx + (context.x || 0),
        y: event.position.dy + (context.y || 0),
      })),
    },
  }
)
```

In the above, we can also see the following:

- An `initial` state that is `inactive` with an event of `FOCUS` which sets the state to `active`
- An `active` state that has an internal event of `MOVE` which will trigger the `updatePosition` action and an event of `BLUR` which sets the state to `inactive`
- There is a `context` that will store the coordinates of the dragged element
- An `actions` object which has an action called `updatePosition` which assigns the context to the new position

We can also see that in the schema the type of `events` is specified. This makes it so that XState can infer the type of `event` passed to the `updatePosition` function

## Attach the State to the UI

In order to move from one state to another we use the `send` method from XState

To use a state machine in React we use the `useMachine` hook from XState:

`Draggable.tsx`

```tsx
import { useMachine } from "@xstate/react";
import React from "react";
import { machine } from "./Draggable.machine";

interface DraggableProps {
  children: React.ReactNode;
}

export const Draggable = ({ children }: DraggableProps) => {
  const [current, send] = useMachine(machine);


  // rest of component
```

Next, we can use the `current` to figure out if we are in an active state so that we can do some styling based on that:

`Draggable.tsx`

```tsx
const isActive = current.matches('active')
```

And lastly we can hook up the UI Events to the state machine:

`Draggable.tsx`

```tsx
export const Draggable = ({ children }: DraggableProps) => {
  const [current, send] = useMachine(machine)

  const isActive = current.matches('active')

  return (
    <div style={{ position: 'relative' }}>
      <div
        onMouseDown={() => send('FOCUS')}
        onMouseUp={() => send('BLUR')}
        onMouseLeave={() => send('BLUR')}
        onMouseMove={(ev) => {
          send({
            type: 'MOVE',
            position: {
              dx: ev.movementX,
              dy: ev.movementY,
            },
          })
        }}
        style={{
          position: 'absolute',
          backgroundColor: isActive ? 'skyblue' : 'red',
          userSelect: 'none',
          top: current.context.y,
          left: current.context.x,
          padding: 20,
        }}
      >
        {children}
      </div>
    </div>
  )
}
```

The above will result in a draggable div like so:

[Repl.it link](https://replit.com/@nabeelvalley/DraggableDiv?v=1)

<iframe frameborder="0" width="100%" height="500px" src="https://replit.com/@nabeelvalley/DraggableDiv?embed=true"></iframe>

## Possible Improvements

If you play around with the above example you'll probably notice that it's not perfect. Though the states we've defined are correct,the complexity in mapping the UI events becomes apparent, as well as the various edge cases that may arise around how DOM events fire in response to user interaction

Though I don't aim to solve all of these points for the sake of the example, it's worth pointing out as a source of exploration. Some possible solutions that may help are things like changing where we listen to specific events, for example listening to the `mouseUp` events on only the wrapper and not the draggable component, or changing which specific events we're listening to

The idea is that the handling of the UI events is now separated from the actual state management which should make fixing interaction bugs simpler while also decoupling our state from any specific implementation of the UI

# Further Reading

For more information, you can take a look at the [XState Documentation](https://xstate.js.org/docs/) or the [XState YouTube Course](https://www.youtube.com/playlist?list=PLvWgkXBB3dd4ocSi17y1JmMmz7S5cV8vI)

In addition, I also have a more complex example using XState for building a [Todo App](https://replit.com/@nabeelvalley/XStateTodoApp)
