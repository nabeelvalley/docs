---
published: true
title: React with Redux Basics
---

[[toc]]

[Based on this video series](https://www.youtube.com/watch?v=OxIDLw0M-m0&list=PL4cUxeGkcC9ij8CfkAY2RAGb-tmkNwQHG&index=1)

[GitHub Repo](https://github.com/iamshaunjp/react-redux-complete-playlist)

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

React can be included via CDN or with the _Create React App_

The CDN is good if we do not want to use React for an entire application but just a few specific places

We simply include the React scripts for react and the Babel script to allow us to use React in the browser as follows:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <script
      crossorigin
      src="https://unpkg.com/react@16/umd/react.production.min.js"
    ></script>
    <script
      crossorigin
      src="https://unpkg.com/react-dom@16/umd/react-dom.production.min.js"
    ></script>
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
  render() {
    return (
      <div>
        <h1>Hello World!</h1>
      </div>
    );
  }
}
```

JSX needs to only return a single root element. We also cannot use the word `class` as it is a reserver word in JS and hence we need to use `className` instead

In order to render a component we need to tell React to render our component, this is from the `readt-dom` script

the `ReactDOM.render` function takes a component and the DOM element we want to render the component into as follows

```js
ReactDOM.render(<App />, document.getElementById("app"));
```

Within JSX we are also able to include Javascript dynamically within curly braces for example:

```jsx
class App extends React.Component {
  render() {
    return (
      <div>
        <h1>Hello World!</h1>
        <p>{Math.random() * 10}</p>
      </div>
    );
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
    name: "John",
    age: 30
  };

  render() {
    return (
      <div>
        <h1>Hello World!</h1>
        <p>
          My name is {this.state.name}, I am {this.state.age}
        </p>
      </div>
    );
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
handleMouseOver = e => {
  console.log(this);
};
```

### Update State

In order to update state we use the `this.setState` function, **not by manually assigning the new value**

We can update the state by doing something simple like increasing the age when someone clicks on the `Click Me` button

```jsx
handleClick = e => {
  this.setState({ age: this.state.age + 1 });
};
```

### Forms

We can redefine the content of our `App` class to contain a simple form by replacing it with the following

```jsx
class App extends React.Component {
  state = {
    name: "John",
    age: 30
  };

  render() {
    return (
      <div className="app-contnet">
        <h1>My name is {this.state.name}</h1>
        <form>
          <input type="text" />
          <button>Submit</button>
        </form>
      </div>
    );
  }
}
```

We can then make use of event binding to enable stuff to happen when we interact with the form, for the `onSubmit` event handler in the `form` we capture the `enter` or `submit click` for the form

When a form is submitted by default the event is to submit and refresh the page, but we do not want that, so in the `handleSubmit` function we need to first prevent the default action and then add our own functionality

```jsx
handleSubmit = e => {
  e.preventDefault();
  console.log("Form submitted by", this.state.name);
};
```

We then bind this to the form `onSubmit` event and can be seen below

```jsx
class App extends React.Component {
  state = {
    name: "John",
    age: 30
  };

  handleChange = e => {
    this.setState({ name: e.target.value });
  };

  handleSubmit = e => {
    e.preventDefault();
    console.log("Form submitted by", this.state.name);
  };

  render() {
    return (
      <div className="app-contnet">
        <h1>My name is {this.state.name}</h1>
        <form onSubmit={this.handleSubmit}>
          <input type="text" onChange={this.handleChange} />
          <button>Submit</button>
        </form>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("app"));
```

> It is important to note that React makes use of two input types: 'controlled' and 'uncontrolled'. In order to make an input 'controlled' you need to ensure that the value is initialized - e.g. if `value={name}` you need to be sure that upon initialization, `name` is defined and not null. If you're assigning `state` in the `constructor` note that you will be overwriting state that is defined at a class level

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
import React, { Component } from "react";

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
const { name, age, belt } = this.props;
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

const Ninjas = ({ ninjas }) => {
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

### Conditional Output

In order to display conditional output we can simply use an if-else or terenary operator in order to create the desired output, we can see this being done when we do the array mapping over the Ninja list below

#### If-Else

```jsx
const Ninjas = ({ ninjas }) => {
  const ninjaList = ninjas.map(ninja => {
    if (ninja.age > 31) {
      return (
        <div className="ninja" key={ninja.id}>
          <div>Name: {ninja.name}</div>
          <div>Age: {ninja.age}</div>
          <div>Belt: {ninja.belt}</div>
        </div>
      );
    } else {
      return null;
    }
  });
  return <div className="ninja-list">{ninjaList}</div>;
};
```

#### Terenary

```jsx
const Ninjas = ({ ninjas }) => {
  const ninjaList = ninjas.map(ninja => {
    return ninja.age > 31 ? (
      <div className="ninja" key={ninja.id}>
        <div>Name: {ninja.name}</div>
        <div>Age: {ninja.age}</div>
        <div>Belt: {ninja.belt}</div>
      </div>
    ) : null;
  });
  return <div className="ninja-list">{ninjaList}</div>;
};
```

### Forms

We'll create a new form for adding Ninjas to the list, then update the state inside of the `Ninjas` component with the new Ninja

Crete a new file for the form called `AddNinja.js`, because we need to control the state of the form, it will need to be class-based

The `onChange` function will update the state each time we update the form, in order to do this we first need to define a state object and a `handleChange` event in which we can take the correct state property

```jsx
import React, { Component } from "react";

class AddNinja extends Component {
  state = {
    name: null,
    age: null,
    belt: null
  };

  handleChange = e => {
    this.setState({
      [e.target.id]: e.target.value
    });
  };

  handleSubmit = e => {
    e.preventDefault();
    console.log(this.state);
  };

  render() {
    return (
      <div>
        <form onSubmit={this.handleSubmit}>
          <label htmlFor="name">Name:</label>
          <input type="text" id="name" onChange={this.handleChange} />
          <label htmlFor="Age">Age:</label>
          <input type="text" id="age" onChange={this.handleChange} />
          <label htmlFor="belt">Belt:</label>
          <input type="text" id="belt" onChange={this.handleChange} />
          <button>Submit</button>
        </form>
      </div>
    );
  }
}

export default AddNinja;
```

We will then need to add this to the App by including it in the `app.js` `Render()`

We can now update the state of the form, but we are still not adding the new ninja to the App State

In the `App` class, create a new function to handle the `addNinja` event which we will then be able to pass into the child component and then call that function from the child in which we will

```jsx
addNinja = ninja => {
  ninja.id = Math.random();
  let ninjas = [...this.state.ninjas, ninja];
  this.setState({
    ninjas: ninjas
  });
};
```

Pass the `addNinja` function as a prop to the `AddNinja` component as follows

```jsx
<AddNinja addNinja={this.addNinja} />
```

And we will update the `handleSubmit` function in the `AddNinja` class to be

```jsx
handleSubmit = e => {
  e.preventDefault();
  this.props.addNinja(this.state);
};
```

Next up we will add the functionality to delete a ninja by creating a function in the parent called `deleteNinja` and adding a delete button on the child from which we will call the delete function

We will wrap the function on the child in an anonymous function in order to prevent it from being called as soon as the button is instantiated. adding this button to the `Ninjas` component should result in the following:

```jsx
const Ninjas = ({ ninjas, deleteNinja }) => {
  const ninjaList = ninjas.map(ninja => {
    return ninja.age > 31 ? (
      <div className="ninja" key={ninja.id}>
        <div>Name: {ninja.name}</div>
        <div>Age: {ninja.age}</div>
        <div>Belt: {ninja.belt}</div>
        <button
          onClick={() => {
            deleteNinja(ninja.id);
          }}
        >
          Delete
        </button>
      </div>
    ) : null;
  });
  return <div className="ninja-list">{ninjaList}</div>;
};
```

Next, from the `App` component, define the `deleteNinja` function and pass it in as a prop to the `Ninjas` component

In the `deleteNinja` function, we will use a non-destructiver filter function to remove the ninja with the selected ID

```jsx
deleteNinja = id => {
  let ninjas = this.state.ninjas.filter(ninja => ninja.id !== id);
  this.setState({
    ninjas: ninjas
  });
};
```

### CSS

There are a few different ways to include CSS in react

1. CSS file for each component
2. Index.css
3. CSS modules

The React build tool will add vendor prefixes automatically for us

To include CSS in a component we simply import the CSS file

> With every method other than CSS modules, the styles will be applied everywhere

### Lifecycle Methods

React Components have a bunch of different lifecycle methods, the only one that needs to be provided by us is the `render` method, I have a list and explanation of these [here](/docs/react/module-2)

## ToDo App

For a somewhat nicer version of this take a look at the ToDo app which makes use of the same concepts here but additionally uses `materialize.css` to make it a bit nicer

`index.html`

```html
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"
/>
```

`App.js`

```jsx
import React, { Component } from "react";
import Todos from "./Todos";
import AddTodo from "./AddForm";

class App extends Component {
  state = {
    todos: [
      { id: 0, content: "buy some milk" },
      { id: 1, content: "play mario kart" }
    ]
  };

  deleteTodo = id => {
    const todos = this.state.todos.filter(todo => todo.id !== id);
    this.setState({ todos: todos });
  };

  addTodo = todo => {
    todo.id = this.state.todos.length;
    const todos = [...this.state.todos, todo];
    this.setState({
      todos: todos
    });
  };

  render() {
    return (
      <div className="todo-app container">
        <h1 className="center blue-text">Todo's</h1>
        <Todos todos={this.state.todos} deleteTodo={this.deleteTodo} />
        <AddTodo addTodo={this.addTodo} />
      </div>
    );
  }
}

export default App;
```

`Todos.js`

```jsx
import React from "react";

const Todos = ({ todos, deleteTodo }) => {
  const todoList =
    todos.length > 0 ? (
      todos.map(todo => (
        <div
          className="collection-item"
          key={todo.id}
          onClick={() => deleteTodo(todo.id)}
        >
          <span>{todo.content}</span>
        </div>
      ))
    ) : (
      <p className="center">You have no todos</p>
    );

  return <div className="todos collection">{todoList}</div>;
};

export default Todos;
```

`AddForm.js`

```jsx
import React, { Component } from "react";

class AddTodo extends Component {
  state = {
    content: ""
  };

  handleChange = e => {
    this.setState({
      content: e.target.value
    });
  };

  handleSubmit = e => {
    e.preventDefault();
    this.props.addTodo(this.state);
    this.setState({
      content: ""
    });
  };

  render() {
    return (
      <div>
        <form onSubmit={this.handleSubmit}>
          <label>Add new todo:</label>
          <input
            type="text"
            onChange={this.handleChange}
            value={this.state.content}
          />
        </form>
      </div>
    );
  }
}

export default AddTodo;
```

## React Router

The React Router will essentially disply specific components in response to specific route requests, the React Router will intercept requests

For this application we will be using `create-react-app` once again with `materialize.css`

### Intialize App

```bash
npx create-react-app poketimes
```

### Add CSS

Add the `materialize.css` stylesheet to the `index.html`

```html
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"
/>
```

### Create Pages

Before we can route to pagess it would be useful to first have some. Create the following files in a `src/components` directory with their respective contents

`components/About.js`

```jsx
import React from "react";

const About = () => (
  <div className="container">
    <h4 className="center">About</h4>
    <p>
      Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quos et
      asperiores libero tempora commodi, non accusantium sit ea eum? Beatae
      ipsum quod amet soluta aliquid quae nobis fugiat incidunt obcaecati.
    </p>
  </div>
);

export default About;
```

`components/Contact.js`

```jsx
import React from "react";

const Contact = () => (
  <div className="container">
    <h4 className="center">Contact</h4>
    <p>
      Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quos et
      asperiores libero tempora commodi, non accusantium sit ea eum? Beatae
      ipsum quod amet soluta aliquid quae nobis fugiat incidunt obcaecati.
    </p>
  </div>
);

export default Contact;
```

`components/Home.js`

```jsx
import React from "react";

const Home = () => (
  <div className="container home">
    <h4 className="center">Home</h4>
    <p>
      Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quos et
      asperiores libero tempora commodi, non accusantium sit ea eum? Beatae
      ipsum quod amet soluta aliquid quae nobis fugiat incidunt obcaecati.
    </p>
  </div>
);

export default Home;
```

### Create Navbar

Now add a navbar which will just link to the different pages we just created

`components/Navbar.js`

```jsx
import React from "react";

const Navbar = () => {
  return (
    <nav className="nav-wrapper red darken-3">
      <div className="container">
        <a href="/" className="brand-logo">
          Poketimes
        </a>
        <ul className="right">
          <li>
            <a href="/">Home</a>
          </li>
          <li>
            <a href="/about">About</a>
          </li>
          <li>
            <a href="/contact">Contact</a>
          </li>
        </ul>
      </div>
    </nav>
  );
};

export default Navbar;
```

Add the Navbar to the `App` template as follows

```jsx
import React, { Component } from "react";
import Navbar from "./components/Navbar";

class App extends Component {
  render() {
    return (
      <div className="App">
        <Navbar />
      </div>
    );
  }
}

export default App;
```

### Add React Router Package

Add the React Router to the application by installing the package and then including it in the application by doing the following

```bash
yarn add react-router-dom
```

Then import the `BrowserRouter` and and `Route` include the applcation inside the `BrowserRouter` Component and the respective Route content in the `Route`

`App.js`

```jsx
import React, { Component } from "react";
import { BrowserRouter, Route } from "react-router-dom";
import Navbar from "./components/Navbar";
import Home from "./components/Home";
import About from "./components/About";
import Contact from "./components/Contact";

class App extends Component {
  render() {
    return (
      <BrowserRouter>
        <div className="App">
          <Navbar />
          <Route exact path="/" component={Home} />
          <Route path="/contact" component={Contact} />
          <Route path="/about" component={About} />
        </div>
      </BrowserRouter>
    );
  }
}

export default App;
```

Make note of the `exact` on the `Home` route, this insures that the `About` and `Contact` pages are not viewed as subsets of the `Home` route.

Also we will notice that when navigating the page is reloaded, this is because we are using `href` in our `Navbar` anchor tags which results in the browser trying to make a server request. Instead we will make use of the `Link` from the `react-router-dom` as follows

```jsx
import React from "react";
import { Link, NavLink } from "react-router-dom";

const Navbar = () => {
  return (
    <nav className="nav-wrapper red darken-3">
      <div className="container">
        <a href="/" className="brand-logo">
          Poketimes
        </a>
        <ul className="right">
          <li>
            <Link exact to="/">
              Home
            </Link>
          </li>
          <li>
            <Link to="/about">About</Link>
          </li>
          <li>
            <Link to="/contact">Contact</Link>
          </li>
        </ul>
      </div>
    </nav>
  );
};

export default Navbar;
```

We can also use `NavLink` insead, this will but this will render the `active` class when we are on a specific route - this is pretty much the same as when using `Link`

```jsx
import React from "react";
import { Link, NavLink } from "react-router-dom";

const Navbar = () => {
  return (
    <nav className="nav-wrapper red darken-3">
      <div className="container">
        <a href="/" className="brand-logo">
          Poketimes
        </a>
        <ul className="right">
          <li>
            <NavLink exact to="/">
              Home
            </NavLink>
          </li>
          <li>
            <NavLink to="/about">About</NavLink>
          </li>
          <li>
            <NavLink to="/contact">Contact</NavLink>
          </li>
        </ul>
      </div>
    </nav>
  );
};

export default Navbar;
```

### Redirect Users

The React Router will pass Router Information into the `props` of our component when it renders the component - this will give us route parameters that we can work with among other things

The `props` object as an example, scan be seen below

```js
{
  match: { path: "/contact", url: "/contact", isExact: true, params: {} },
  location: { pathname: "/contact", search: "", hash: "", key: "gb517b" },
  history: {
    length: 50,
    action: "POP",
    location: { pathname: "/contact", search: "", hash: "", key: "gb517b" }
  }
}
```

Along with the above, the `props` also contain a `history` object which has a `push` function with which we can add programmatic redirects

However, we will note that the `Navbar` component does not automatically get the Router information injected into the props as it is not associated with a route - however we can wrap it with a higher order component with the following code

`Navbar.js`

```jsx
import {withRouter} from 'react-router-dom'
...
export default withRouter(Navbar)
```

To create an automatic redirect to the `About` page from the `Navbar` we can update the `Navbar.js` with the following

```jsx
import React from "react";
import { NavLink, withRouter } from "react-router-dom";

const Navbar = props => {
  setTimeout(() => {
    props.history.push("/about");
  }, 2000);
  return <nav className="nav-wrapper red darken-3">...</nav>;
};

export default withRouter(Navbar);
```

Be sure to remove the `setTimeout` after you have tested the rerouting as we do not need this

```jsx
import React from "react";
import { NavLink, withRouter } from "react-router-dom";

const Navbar = props => {
  return <nav className="nav-wrapper red darken-3">...</nav>;
};

export default withRouter(Navbar);
```

### Higher Order Components

HOCs are functions that add functionality to components, such as the `withRouter` function

Create a new file `hoc/Rainbow.js` that will randomize the colour of the text in a component

The HOC should return a function which returns the original component, we can do this as follows

```jsx
import React from 'react'

const Rainbow = WrappedComponent => {
  const colours = ['red', 'pink', 'orange', 'blue', 'green', 'yellow']
  const randomColour = colours[Math.floor(Math.random() * 5)]
  const className = randomColour + '-text'

  return props => (
    <div className={className}>
      <WrappedComponent {...props} />
    </div>
  )
}

export default Rainbow
```

### Axios

We can get some dummy data for our application from the [`jsonplaceholder` site](https://jsonplaceholder.typicode.com/), we can also create a fake [JSON Server here](https://my-json-server.typicode.com/)

Axios is an HTTP library which can be installed as follows

```bash
yarn add axios
```

We typically get data and render it with the `componentDidMount` lifecycle hook on the `Home` component by updating the code as follows as follows

```jsx
import React, { Component } from 'react'
import axios from 'axios'

class Home extends Component {
  state = {
    posts: []
  }

  componentDidMount() {
    axios.get('https://jsonplaceholder.typicode.com/posts').then(res => {
      console.log(res)
      this.setState({
        posts: res.data.slice(0, 10)
      })
    })
  }

  render = () => {
    const { posts } = this.state

    const postList = posts.length ? (
      posts.map(post => (
        <div className="post card" key={post.id}>
          <div className="card-content">
            <span className="card-title">{post.title}</span>
            <p>{post.body}</p>
          </div>
        </div>
      ))
    ) : (
      <div className="center">No posts yet</div>
    )

    return (
      <div className="container home">
        <h4 className="center">Home</h4>
        {postList}
      </div>
    )
  }
}

export default Home
```

### Route Parameters

We can set up sub-routes based on components, we can create a component to render a single post with the following, taking careful note of the sub-component routing in the `Home.js` for the `Post` component file and the usage of the params in the `Post.js` file

`Home.js`
```jsx
import React, { Component } from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'
import Navbar from './components/Navbar'
import Home from './components/Home'
import About from './components/About'
import Contact from './components/Contact'
import Post from './components/Post'

class App extends Component {
  render() {
    return (
      <BrowserRouter>
        <div className="App">
          <Navbar />
          <Switch>
            <Route exact path="/" component={Home} />
            <Route path="/contact" component={Contact} />
            <Route path="/about" component={About} />
            <Route path="/:post_id" component={Post} />
          </Switch>
        </div>
      </BrowserRouter>
    )
  }
}

export default App

```

Note that the usage of the `Switch` above is to take care of the fact that `/contact` and `/about` can be viewed as `/:post_id` where the `post_id` is `contact` and `about` respectively - the `Switch` component will ensure that only one route at a time can be matched

Next we render the Post on the `/:post_id` page with the following

```jsx
import React, { Component } from 'react'
import axios from 'axios'

class Post extends Component {
  state = {
    post: null
  }

  componentDidMount() {
    const id = this.props.match.params.post_id
    axios.get(`https://jsonplaceholder.typicode.com/posts/${id}`).then(res => {
      this.setState({ post: res.data })
    })
  }

  render() {
    const post = this.state.post ? (
      <div className="post">
        <h4 className="center">{this.state.post.title}</h4>
        <p>{this.state.post.body}</p>
      </div>
    ) : (
      <div className="center">Loading post...</div>
    )

    return <div className="container">{post}</div>
  }
}

export default Post
```

### Render Images

We can render images by importing them into the component in which we waant to use them and reference the import without needing the source to the actual file

`Home.js`
```jsx
import Pokeball from '../pokeball.png'
...
posts.map(post => (
    <div className="post card" key={post.id}>
      <img src={Pokeball} alt="A pokeball"/>
      <div className="card-content">
        <Link to={`/${post.id}`}><span className="card-title">{post.title}</span></Link>
        <p>{post.body}</p>
      </div>
    </div>
  ))
```

## Redux

Redux is a library that is essentially a centralized state store which makes it easier for us to manage state on different components that use the same information

1. A component dispatches an action that describes the change that we want to make, with an optional payload
2. The Reducer updates the state of the central state
3. Component subscribes to changes and receives them as props

### Using Redux in HTML

We can import Redux, and Babel into the HTML document, and start working with the basics within that app

### Create a Store

When creating a store we need to intialize state and give the store a reducer, this can be seen below

```jsx
const { createStore } = Redux;

const initState = {
  todos: [],
  posts: []
}

function myreducer(state = initState, action){
  console.log(action, state)
}

const store = createStore(myreducer)
```

### Dispatch Action

When editing data we create an action which will be dispatched, this is an object with `type` and `props`

```jsx
const todoAction = {
  type: 'ADD_TODO',
  todo: 'buy milk'
}

store.dispatch(todoAction)
```

We would siomply use the `dispatch` from a component to update state


### Update State

In order to interact with our state we will make use of the Reducer and manipulate the state based on `action.type`. The reducer needs to then return the state update

```jsx
function myreducer(state = initState, action){
  if (action.type == 'ADD_TODO){
    return {
      ...state,
      todos: [...state.todos, action.todo]
    }
  }
}
```

Note that the above will overwrite the state, hence the `...state` portion

### Subscribe to Changes

In order to subscribe, we need to create a listener for store changes and react to those changes

```jsx
store.subscribe(() => {
  console.log('state updated')
  store.getState()
})
```

The final state of our JS will be as follows

```jsx
const { createStore } = Redux;

const initState = {
  todos: [],
  posts: []
}

function myreducer(state = initState, action){
  if (action.type == 'ADD_TODO){
    return {
      ...state,
      todos: [...state.todos, action.todo]
    }
  }
}

store.subscribe(() => {
  console.log('state updated')
  store.getState()
})

const store = createStore(myreducer)

const todoAction = {
  type: 'ADD_TODO',
  todo: 'buy milk'
}

store.dispatch(todoAction)
```

### Install Redux

We need to add `redux` and `react-redux` to the project with the following code

```bash
yarn add redux react-redux
```

### Initialize Reducer

Create a `src/reducers/rootReducer.js` with a simple reducer defined and some simple state just for initialization

```jsx
const initState = {
  posts: [
    {
      id: 1,
      title: 'Hello World 1',
      body: 'das  as das d asd asd sd asd  asd sd sd'
    },
    {
      id: 2,
      title: 'Hello World 2',
      body: 'das  as das d asd asd sd asd  asd sd sd'
    },
    {
      id: 3,
      title: 'Hello World 3',
      body: 'das  as das d asd asd sd asd  asd sd sd'
    }
  ]
}

const rootReducer = (state = initState, action) => {
  return state
}

export default rootReducer

```

### Create Store

Thereafter we will create a store, we generally do this in the `index.js` file, in our case updating it with the following


```jsx
import { createStore } from 'redux'
import { Provider } from 'react-redux'
import rootReducer from './reducers/rootReducer';

const store = createStore(rootReducer)

ReactDOM.render(<Provider store={store}><App /></Provider>, 
```

### Update Data

In Order to update our components, we will make use of an HOC, in this case using `connect` from `react-redux`, we need to update the `Home.js` file as well as the `rootReducer.js`

Note that the `connect` function returns an HOC which will in turn take in our component. The `connect` function requires an input function which will map our component `props` to our redux `state`

`rootReducer.js`
```jsx
const initState = {
  posts: []
}

const rootReducer = (state=initState, action) =>{
  return state
}

export default rootReducer
```

`Home.js`
```jsx
import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import Pokeball from '../pokeball.png'
import { connect } from 'react-redux'

class Home extends Component {
  render() {
    const { posts } = this.props

    const postList = posts.length ? (
      posts.map(post => (
        <div className="post card" key={post.id}>
          <img src={Pokeball} alt="A pokeball"/>
          <div className="card-content">
            <Link to={`/${post.id}`}><span className="card-title">{post.title}</span></Link>
            <p>{post.body}</p>
          </div>
        </div>
      ))
    ) : (
      <div className="center">No posts yet</div>
    )

    return (
      <div className="container home">
        <h4 className="center">Home</h4>
        {postList}
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    posts: state.posts
  }
}

export default connect(mapStateToProps)(Home)
```

### Render Post from Redux

Now we need to connect the `Post` component to Redux, this can essentially be done in the same way as the `Home` component above

```jsx
import React, { Component } from 'react'
import { connect } from 'react-redux'

class Post extends Component {
  render() {
    const post = this.props.post ? (
      <div className="post">
        <h4 className="center">{this.props.post.title}</h4>
        <p>{this.props.post.body}</p>
      </div>
    ) : (
      <div className="center">Loading post...</div>
    )

    return <div className="container">{post}</div>
  }
}

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.match.params.post_id
  return {
    post: state.posts.find(post => post.id == id)
  }
}

export default connect(mapStateToProps)(Post)
```

### Update State

To update state we need to dispatch an action, and when that has changed the relevant components will be updated

We need to define a `mapDispatchToProps` function on the component, this can be done on the `Post` component as follows

```jsx
import React, { Component } from 'react'
import { connect } from 'react-redux'

class Post extends Component {
  
  handleClick = () => {
    this.props.deletePost(this.props.post.id)    
    this.props.history.push('/')
  }
  
  render() {
    const post = this.props.post ? (
      ...
          <button className="btn grey" onClick={this.handleClick}>
            Delete Post
          </button>
      ...
      ) : (
      <div className="center">Loading post...</div>
    )

    return <div className="container">{post}</div>
  }
}

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.match.params.post_id
  return {
    post: state.posts.find(post => post.id === +id)
  }
}

const mapDispatchToProps = dispatch => {
  return {
    deletePost: id => dispatch({type: 'DELETE_POST', id: id})
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Post)
```

As well as providing the delete functionality on the `rootReducer` as follows

```jsx
const rootReducer = (state = initState, action) => {
  console.log(action)
  if (action.type === 'DELETE_POST') {
    const newPosts = state.posts.filter(post => post.id !== action.id)
    return {
      ...state,
      posts: newPosts
    }
  }
  return state
}
```

### Action Creators

Action creators are functions we can use to more easily dispatch actions by simply calling a function

Create a file `src/actions/postActions.js` with a single function defined

```jsx
export const deletePost = id => {
  return {
    type: 'DELETE_POST',
    id: id
  }
}
```

And then simply update the `Posts/mapDispatchToProp` function to be as follows

```jsx
const mapDispatchToProps = dispatch => {
  return {
    deletePost: id => dispatch(deletePost(id))
  }
}
```
