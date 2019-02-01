# React with Redux

[Based on this vide series](https://www.youtube.com/watch?v=OxIDLw0M-m0&list=PL4cUxeGkcC9ij8CfkAY2RAGb-tmkNwQHG&index=1)

[GitHub Repo](https://github.com/iamshaunjp/react-redux-complete-playlist)

- [React with Redux](#react-with-redux)
  - [VSCode Extensions](#vscode-extensions)
  - [Intro](#intro)
    - [React](#react)
    - [Redux](#redux)
    - [How React Works](#how-react-works)
  - [React in the Browser](#react-in-the-browser)
    - [Set Up React with CDN](#set-up-react-with-cdn)
    - [React Components](#react-components)
    - [Component State](#component-state)
    - [Click Events](#click-events)
    - [State and the THIS](#state-and-the-this)
    - [Update State](#update-state)
    - [Forms](#forms)
  - [React CLI](#react-cli)
    - [Creating a React App](#creating-a-react-app)
    - [Single Page Apps](#single-page-apps)
    - [Root Component](#root-component)
    - [Props](#props)
    - [Lists](#lists)
    - [Component Types](#component-types)
    - [UI Components](#ui-components)

## VSCode Extensions

- ES7 React/Redux/GraphQL/React-Native snippets
- Sublime Babel
- React Chrome Dev Tools

## Intro

### React

React is a JS library created by Facebook and is used to create dynamic web apps

### Redux

Redux is a layer on top of React that helps to manage the state and data of an app

### How React Works

React is made up of components which are used for different parts of the application. React will take these components and render them into the DOM

React uses a Virtual DOM and renders the content into the Actual DOM based on that

When the state is updated React creates a new VD and compares it to the AD and renders based on the differences between the two

Components are made of JSX templates which can contain the UI state as well as functionality

## React in the Browser
### Set Up React with CDN

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

### React Components

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

### Component State

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

### Click Events

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

### State and the THIS

When accessing state inside of functions we cannot necessarily access the context `this` object which is determined by how and where the function is called. For example in the above code when we hover we will see the `this` as `undefined`

In the case of event handlers, we need to manually bind the `this` to our functions. Note that for the `render` method, React will automatically bind the context

There are a few different ways to bind context, using an Arrow function is the easiest way as they pass through the parent context as defined by ES6

We can do this for the `handleMouseOver` function as follows

```jsx
handleMouseOver = (e) => {
    console.log(this)
}
```

### Update State

In order to update state we use the `this.setState` function, **not by manually assigning the new value**

We can update the state by doing something simple like increasing the age when someone clicks on the `Click Me` button

```jsx
handleClick = (e) => {
    this.setState({age: this.state.age + 1})
}
```

### Forms

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

## React CLI

### Creating a React App

The Create React App is a CLI that allows us to use a development server, ES6 features, modularise code, and use build tools to optimize code for deployment

[Create React App CLI](https://reactjs.org/docs/create-a-new-react-app.html)

We can create a new app using `npx` which is part of `npm` and the following command

```bash
npx create-react-app netninja-app
```


We can then run the app as follows

```bash
cd netninja-app
yarn start
```

### Single Page Apps

Single page apps provide the user with a single page with which the user's inital request retrieves the `index.html` and thereafter the React Javascript intercepts the user's interactions with the application instead of the server

The `public/index.html` file is created with a `root` into which the application components can be injected. `create-react-app` creates an `App` class that will be rendered into the DOM. The `src/index.js` Exports the application and renders it in the HTML

Additionally there is a CSS and JS file for each component as well as a test file

### Root Component

A root component is the app that is rendered initially into which other components are rendered. In this case our `App` component is the Root component

We'll create some new components in the `src` file to build the other functionality into the app

Let's clean up the `src/App.js` file to be as follows

```jsx
import React, { Component } from 'react';

class App extends Component {
  render() {
    return (
      <div className="App">
        <h1>React App</h1>
        <p>Hello World!</p>
      </div>
    );
  }
}

export default App;
```

Take note of the imports at the top and the export at the bottom of the above codeblock 

> From this point the code will be included in my `ReactLearning` repo

### Props

Props allow us to pass data into components therefore making them more general and thereby more reusable

We pass this in within the template, this can be done as follows

```jsx
<Ninjas name="Ryu" age="25" belt="Black" />
```

And can then be accessed in a class based component with the `this.props` object

In order to split up the object, we can de-structure the props object as follows

```jsx
const { name, age, belt } = this.props
```

We can also, instead of passing a single value in - pass in a list of objects and cycle through those within a component

### Lists

We can iterate and render a list of objects, but we must be sure to include a unique key so that react can efficiently manage the DOM with lists of elements. This can be done with the following

```jsx
class Ninjas extends Component {
  render() {
    const { ninjas } = this.props;
    const ninjaList = ninjas.map(ninja => (
      <div className="ninja" key={ninja.id}>
        <div>Name: {ninja.name}</div>
        <div>Age: {ninja.age}</div>
        <div>Belt: {ninja.belt}</div>
      </div>
    ));
    return <div className="ninja-list">{ninjaList}</div>;
  }
}
```

### Component Types

We have multiple types of components such as Container components which are stateful and UI components which are stateless. These are also known as class-based and function-based components respectively

### UI Components

We can redefine the `Ninjas` component from above to be a Functional Component which also makes use of destructuring in the function input with the following code

```jsx
import React from "react";

const Ninjas = ({ninjas}) => {
  const ninjaList = ninjas.map(ninja => (
    <div className="ninja" key={ninja.id}>
      <div>Name: {ninja.name}</div>
      <div>Age: {ninja.age}</div>
      <div>Belt: {ninja.belt}</div>
    </div>
  ));
  return <div className="ninja-list">{ninjaList}</div>;
};

export default Ninjas;
```