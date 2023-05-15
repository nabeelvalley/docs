---
published: true
title: Functional Higher Order Components (HOCs) with Typescript
---

[[toc]]

An HOC in React is a component that wraps another component to provide additional props or functionality to the wrapped component

Here's a simple example of how we can create an HOC using Typescript:

The component below will provide an `isVisible` prop to a component which will alolow us to show or hide it selectively

```tsx
import React, { useState } from 'react';

interface VisibilityProps {
  isVisible?: boolean;
}

/**
 * HOC that adds an `isVisible` prop that stops a component from rendering if 
 * `isVisible===false`
 * @param WrappedComponent component to be selectively hidden
 * @returns null if `isVisible` is false
 */
export function withVisibility<P>(WrappedComponent: React.ComponentType<P>) {
  const VisibityControlled = (props: P & VisibilityProps) => {
    if (props.isVisible === false) {
      return null;
    }

    return <WrappedComponent {...props} />;
  };

  return VisibityControlled;
}
```