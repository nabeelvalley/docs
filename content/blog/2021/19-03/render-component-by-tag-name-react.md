[[toc]]

When using React it can sometimes be useful to render a standard HTML element given the element name dynamically as a prop

React allows us to do this provided we store the element name in a variable that starts with a capital letter, as JSX requires this to render a custom element

We can do something like this by defining a generic element in React which just takes in the name of the tag in addition to it's usual props and children, something like this:

```jsx
const GenericElement = ({ tagName:Tag, children, ...innerProps}) => 
  <Tag {...innerProps}> 
    {children}
  </Tag>
```

We can then render this element by calling the `GenericElement` with the `tagName` prop and then any children we'd like:

```jsx
<GenericElement tagName="h1">I am an h1</GenericElement>
```

Here's a short example using [Replit](https://replit.com/@nabeelvalley/render-by-element-name#src/App.jsx) for reference, all the important stuff is in the `src/App.jsx` file:

<iframe height="700px" width="100%" src="https://replit.com/@nabeelvalley/render-by-element-name?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>