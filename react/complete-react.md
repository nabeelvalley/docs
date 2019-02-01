# React with Redux

[Based on this vide series](https://www.youtube.com/watch?v=OxIDLw0M-m0&list=PL4cUxeGkcC9ij8CfkAY2RAGb-tmkNwQHG&index=1)

[GitHub Repo](https://github.com/iamshaunjp/react-redux-complete-playlist)

- [React with Redux](#react-with-redux)
  - [VSCode Extensions](#vscode-extensions)
  - [Intro](#intro)
    - [React](#react)
    - [Redux](#redux)
  - [How React Works](#how-react-works)
  - [Set Up React with CDN](#set-up-react-with-cdn)
  - [React Components](#react-components)
  - [Component State](#component-state)
  - [Click Events](#click-events)
  - [State and the THIS](#state-and-the-this)
  - [Update State](#update-state)
  - [Forms](#forms)

## VSCode Extensions

- ES7 React/Redux/GraphQL/React-Native snippets
- Sublime Babel
- React Chrome Dev Tools

## Intro

### React

React is a JS library created by Facebook and is used to create dynamic web apps

### Redux

Redux is a layer on top of React that helps to manage the state and data of an app

## How React Works

React is made up of components which are used for different parts of the application. React will take these components and render them into the DOM

React uses a Virtual DOM and renders the content into the Actual DOM based on that

When the state is updated React creates a new VD and compares it to the AD and renders based on the differences between the two

Components are made of JSX templates which can contain the UI state as well as functionality

## Set Up React with CDN

React can be included via CDN or with the *Create React App*

The CDN is good if we do not want to use React for an entire application but just a few specific places

We simply include the React scripts for react and the Babel script to allow us to use React in the browser as follows:

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script crossorigin src="https://unpkg.com/react@16/umd/react.production.min.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@16/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
    <title>Document</title>
</head>
<body>
    <div id="app"></div>
    <script></script>
</body>
</html>
```

## React Components

React components will take over a specific element in the DOM, we can create them within a script tag , a component is defined by a class which will extend `React.Component`

Any class based component must define a `render` method which will return the tempalate for an object in JSX

```jsx
class App extends React.Component {
    render(){
        return (
            <div>
                <h1>Hello World!</h1>
            </div>
        )
    }
}
```

JSX needs to only return a single root element. We also cannot use the word `class` as it is a reserver word in JS and hence we need to use `className` instead

In order to render a component we need to tell React to render our component, this is from the `readt-dom` script

the `ReactDOM.render` function takes a component and the DOM element we want to render the component into as follows

```js
ReactDOM.render(
    <App />,
    document.getElementById('app')
)
```

Within JSX we are also able to include Javascript dynamically within curly braces for example:

```jsx
class App extends React.Component {
    render(){
        return (
            <div>
                <h1>Hello World!</h1>
                <p>{ Math.random() * 10 }</p>
            </div>
        )
    }
}
```

## Component State

This describes the state of the Data and the UI in the application. Component state is simply a JS object

We make use of the state of the component to dynamically update the visual representation of the component

We can define and create component state in a few ways. The easiest is to define a state object which is a Javascript object that will contain the state data

State can be referenced as dynamic content inside of template

```jsx
class App extends React.Component {
    
    state = {
        name: 'John',
        age: 30
    }

    render(){
        return (
            <div>
                <h1>Hello World!</h1>
                <p>My name is { this.state.name }, I am { this.state.age }</p>
            </div>
        )
    }
}
```

State can also be defined in a `constructor`

## Click Events

We can attach event handlers to an element based on the event name on the JSX and link it to a function in the component to handle the function

Handlers are simply defined as functions in the class definition for an object

```jsx
class App extends React.Component {
    
    state = {
        name: 'John',
        age: 30
    }

    handleClick => (e) => {
        const event = Object.assign({}, e)
        console.log(event)
    }

    handleMouseOver(e){
        console.log(this)
    }

    handleCopy(e){
        console.log("User copied the text")
    }

    render(){
        return (
            <div>
                <h1>Hello World!</h1>
                <p>My name is { this.state.name }, I am { this.state.age }</p>
                <button onClick={ this.handleClick }>Click Me</button>
                <button onMouseOver={ this.handleMouseOver }>Hover  Me</button>
                <p onCopy={ this.handleCopy }>What we think, what we become</p>
            </div>
        )
    }
}
```

## State and the THIS

When accessing state inside of functions we cannot necessarily access the context `this` object which is determined by how and where the function is called. For example in the above code when we hover we will see the `this` as `undefined`

In the case of event handlers, we need to manually bind the `this` to our functions. Note that for the `render` method, React will automatically bind the context

There are a few different ways to bind context, using an Arrow function is the easiest way as they pass through the parent context as defined by ES6

We can do this for the `handleMouseOver` function as follows

```jsx
handleMouseOver = (e) => {
    console.log(this)
}
```

## Update State

In order to update state we use the `this.setState` function, **not by manually assigning the new value**

We can update the state by doing something simple like increasing the age when someone clicks on the `Click Me` button

```jsx
handleClick = (e) => {
    this.setState({age: this.state.age + 1})
}
```

## Forms

We can redefine the content of our `App` class to contain a simple form by replacing it with the following

```jsx
class App extends React.Component {
    
    state = {
        name: 'John',
        age: 30
    }

    render(){
        return (
            <div className="app-contnet">
                <h1>My name is { this.state.name }</h1>
                <form> 
                    <input type="text" />
                    <button>Submit</button>
                </form>
            </div>
        )
    }
}
```

We can then make use of event binding to enable stuff to happen when we interact with the form, for the `onSubmit` event handler in the `form` we capture the `enter` or `submit click` for the form

When a form is submitted by default the event is to submit and refresh the page, but we do not want that, so in the `handleSubmit` function we need to first prevent the default action and then add our own functionality

```jsx
handleSubmit = (e) => {
    e.preventDefault()
    console.log("Form submitted by", this.state.name)
}
```

We then bind this to the form `onSubmit` event and can be seen below


```jsx
class App extends React.Component {
    
    state = {
        name: 'John',
        age: 30
    }

    handleChange = (e) => {
        this.setState({name: e.target.value})
    }

    handleSubmit = (e) => {
        e.preventDefault()
        console.log("Form submitted by", this.state.name)
    }

    render(){
        return (
            <div className="app-contnet">
                <h1>My name is { this.state.name }</h1>
                <form onSubmit={ this.handleSubmit }> 
                    <input type="text" onChange={ this.handleChange } />
                    <button>Submit</button>
                </form>
            </div>
        )
    }
}

ReactDOM.render(
    <App />,
    document.getElementById('app')
)
```