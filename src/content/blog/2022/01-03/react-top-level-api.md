---
published: true
title: React Top Level API
subtitle: 01 March 2022
description: Building complex react components using the React top-level API and TypeScript
---

> For a reference on the React Top-Level API you can take a look at [the React Docs](https://reactjs.org/docs/react-api.html)

[[toc]]

# Introduction

React allows us to do lots of different things using concepts like composition and higher order components. Most of the time these methods are good enough for us to do what we want, however there are some cases where these methods can prove to be insufficient such as when building complex library components or components that need to allow for dynamic composition or do runtime modification of things like child component props, etc.

For the above purposes we can make use of the React Top-Level API. For the purpose of this writeup I'll be making use of the parts of this API that allow us to modify a component's children and modify their props as well as how they're rendered

# Our Goal

For the purpose of this doc I'll be using the React API to get to do the following:

1. Show the count of children (`Items`) passed to a component (`Wrapper`)
2. Render each child in a sub-wrapper `ItemWrapper`
3. Modify the props of the children by adding a `position` prop

When this is done, we want to render a component that results in the following markup:

```tsx
<Wrapper>
  <Count />
  <ItemWrapper>
    <Item name="" position=""/>
  </ItemWrapper>
  <ItemWrapper>
    <Item name="" position=""/>
  </ItemWrapper>
  <ItemWrapper>
    <Item name="" position=""/>
  </ItemWrapper>
</Wrapper>
```

But a consumer can be used like:

```tsx
<Wrapper>
  <Item name="">
  <Item name="">
  <Item name="">
</Wrapper>
```


# Using `React.Children` to work with a component's `children`

The `React.Children` API (see [docs](https://reactjs.org/docs/react-api.html#reactchildren)) provides us with some utilities for traversing the children passed to a component

Before we can do any of the following, we need to define the structure of an item. Our `Item` component is defined as follows:

```tsx
interface ItemProps { name: string; position?: number; }

const Item: React.FC<ItemProps> = ({ name, position }) => 
  <div>{name}, {position}</div>
```

## Use `React.Children.count` to get the count

The `React.Children.count` function counts the number of child nodes passed to a React component,
we can use it like so:

```tsx
const count = React.Children.count(children)
```

For our example, let's start off by creating a `Count` component that simply takes a `count` prop and displays some text:

```tsx
interface CountProps { count: number; }

const Count: React.FC<CountProps> = ({ count }) => <p>Total: {count}</p>
```

Next, we can define our `Wrapper` which will take `children` and pass the `count` to our `Count` component:

```tsx
const Wrapper: React.FC = ({ children }) => {
  const count = React.Children.count(children)

  return <div>
    <Count count={count}  />
  </div>
}
```

## Use `React.Children.map` to wrap each child

Next, the `React.Children.map` function allows us to map over the children of an element and do stuff with it, for example:

```tsx
const items = React.Children.map(children, (child) => {
  return <ItemWrapper>{child}</ItemWrapper>
})
```

Based on the above, we can define an `ItemWrapper` as so:

```tsx
const ItemWrapper: React.FC = ({ children }) => 
  <li style={{
    backgroundColor: 'lightgrey',
    padding: '10px',
    margin: '20px'
  }} >{children}</li>
```

And we can update the `Wrapper` to make use of `React.children.map`:

```tsx
const Wrapper: React.FC = ({ children }) => {
  const count = React.Children.count(children)

  const items = React.Children.map(children, (child) => {
    return <ItemWrapper>{child}</ItemWrapper>
  })

  return <div>
    <Count count={count}  />
    <ul>{items}</ul>
  </div>
}
```

# Use `React.cloneElement` to change child props

Lastly, we want to append a `position` prop to the `Item`. To do this we can make use of the `React.cloneElement` function which allows us to clone an element and modify the props of it. Using this function looks like so:

```tsx
const childProps = child.props
const newProps = {...child.props, position: index}

const newChild = React.cloneElement(child, newProps)
```

Integrating this into the `React.Children.map` function above will result in our `Wrapper` looking like so:

```tsx
const Wrapper: React.FC = ({ children }) => {
  const count = React.Children.count(children)

  const items = React.Children.map(children, (child, index) => {
    const childProps = child.props
    const newProps = {...child.props, position: index}
    
    const newChild = React.cloneElement(child, newProps)
    
    return <ItemWrapper>{newChild}</ItemWrapper>
  })

  return <div>
    <Count count={count}  />
    <ul>{items}</ul>
  </div>
}
```

# Use `React.isValidElement`

We've completed most of what's needed, however if for some reason our `child` is not a valid react element our component may still crash. To get around this we can use the `React.isValidElement` function

We can update our `map` function above to return `null` if the element is not value:

```tsx
const items = React.Children.map(children, (child, index) => {
  if (!React.isValidElement(child)) return null

  const childProps = child.props
  const newProps = {...child.props, position: index}
  
  const newChild = React.cloneElement(child, newProps)
  
  return <ItemWrapper>{newChild}</ItemWrapper>
})
```

Which results in our `Wrapper` now being:

```tsx
const Wrapper: React.FC = ({ children }) => {
  const count = React.Children.count(children)
  const items = React.Children.map(children, (child, index) => {
    if (!React.isValidElement(child)) return null
    
    const childProps = child.props
    const newProps = {...child.props, position: index}
    
    const newChild = React.cloneElement(child, newProps)
    
    return <ItemWrapper>{newChild}</ItemWrapper>
  })

  return <div>
    <Count count={count}  />
    <ul>{items}</ul>
  </div>
}
```

# The Result

Lastly, we'll render the above using the `App` component, the API for the above components should be composable as we outlined initially. The `App` component will now look like so:

```tsx
const App: React.FC = () => {
  return (
    <Wrapper>
      <Item name="Apple" />
      <Item name="Banana" />
      <Item name="Chocolate" />
    </Wrapper>
  )
}
```

And the rendered HTML:

```html
<div>
  <p>Total: 3</p>
  <ul>
    <li style="background-color: lightgrey; padding: 10px; margin: 20px;">
      <div>Apple, 0</div>
    </li>
    <li style="background-color: lightgrey; padding: 10px; margin: 20px;">
      <div>Banana, 1</div>
    </li>
    <li style="background-color: lightgrey; padding: 10px; margin: 20px;">
      <div>Chocolate, 2</div>
    </li>
  </ul>
</div>
```

<div>
  <p>Total: 3</p>
  <ul>
    <li style="background-color: lightgrey; padding: 10px; margin: 20px;">
      <div>Apple, 0</div>
    </li>
    <li style="background-color: lightgrey; padding: 10px; margin: 20px;">
      <div>Banana, 1</div>
    </li>
    <li style="background-color: lightgrey; padding: 10px; margin: 20px;">
      <div>Chocolate, 2</div>
    </li>
  </ul>
</div>

And lastly, if you'd like to interact with the code from this sample you can see it in [this Repl](https://replit.com/@nabeelvalley/ReactTopLevelAPIExample#src/App.tsx)

<iframe height="700px" width="100%" src="https://replit.com/@nabeelvalley/ReactTopLevelAPIExample?lite=true#src/App.tsx" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>