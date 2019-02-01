# Module 1 - JSX and React Components

[Based on this EdX course](https://courses.edx.org/courses/course-v1:Microsoft+DEV281x+1T2019/course/#block-v1:Microsoft+DEV281x+1T2019+type@chapter+block@8aeb17a4bc2d4ef7bba69a7c298f7f57)

- [Module 1 - JSX and React Components](#module-1---jsx-and-react-components)
  - [Setting Up ReactJs](#setting-up-reactjs)
  - [What is ReactJs](#what-is-reactjs)
  - [React Elements](#react-elements)
  - [JSX](#jsx)
    - [Embed JS](#embed-js)
    - [Element Attributes](#element-attributes)
    - [Empty Tags](#empty-tags)
    - [Style Objects](#style-objects)
    - [Nested Elements](#nested-elements)
  - [React Components](#react-components)
    - [Functional Components](#functional-components)
      - [Component Properties](#component-properties)
    - [Component Composition](#component-composition)
    - [Conditional Rendering](#conditional-rendering)

## Setting Up ReactJs

To add react to an HTML file we include the following scripts in the head

```html
<!DOCTYPE html>
<html>
  <head>
       <meta charset="UTF-8">
       <script src="https://unpkg.com/react@15/dist/react.min.js"></script>
       <script src="https://unpkg.com/react-dom@15/dist/react-dom.min.js"></script>
       <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.24.0/babel.js"></script>

  </head>
  <body>
  
  </body>
</html>
```

And in the body we can add a script to render an element as follows

```html
<body>
    <div id="root"></div>
    <script type="text/babel">
        ReactDOM.render(
            <div>Hello World</div>,
            document.getElementById("root")
        )
    </script>

</body>
```

We can also create a ReactJs CodePen by including the above scripts and using the Babel Javascript Preprocessor


## What is ReactJs

React is a library that generates the view layer of an application based on its state. These applications are made from React Components which describe the properties and state of UI components

React makes use of a Virtual DOM and when component states are updated the React Library calculates the most efficient way to update the actual DOM

This turns out to be much faster than re-rendering the entire DOM

## React Elements

React Elements are Objects that represent a DOM node and are written in `JSX`. React elements are different to React components

React elements need to be rendered by the `ReactDOM.render()` method, this can be done as follows

```html
<div id="root"></div>
```

```jsx
var element = <h1>Hello World!</h1>
ReactDOM.render(
    element,
    document.getElementById("root")
)
```

Once the DOM is rendered, it will remain the same until the render method is called again

```jsx
var num = 0
function updateNum(){
    ReactDOM.render(
        <div>{num++}</div>,
        document.getElementById("root")
    )
}

setInterval(updateNum, 100)
```

## JSX

JSX is a syntax extension on Javascript that allows React Elements to be written in JS with HTML tags

We can see the difference between using JSX and just JS below

```jsx
var element = <h1>Hello World!</h1>
```

```js
var element = React.createElement(
    'h1',
    null,
    'Hello World!'
)
```

### Embed JS

Furthermore we can embed javascript expressions inside of elements using curly brackets

```jsx
var str = "World!"
var element = <h1>Hello {str}</h1>
```

```jsx
var item = {
    name: "Cheese",
    price: 5
}

var element = <p>{item.name} : R{item.price}</p>
```

```jsx
var length = 20
var width = 10

function calculateArea(x,y){
    return x * y
}

var element = <div>The Area is: {calculateArea(length,width)}</div>
```

### Element Attributes

We can also use JSX for element attributes

```jsx
var element = <button className ="deleteButton"> Delete </button>
var element = <img src ={product.imageURL}></img>
```

Note that the `"   "` in JSX indicates a string literal. Do not use this to pass in JS attributes

### Empty Tags

JSX can simply be used with self closing tags as well

```jsx
var element = <input className ="nameInput"/>
```

### Style Objects

As well as to define styles for an element

```jsx
var styleObject = {
    backgroundColor: 'red',
    color:'blue',
    fontSize: 25,
    width: 100
}

var element = <input style = {styleObject}/>
```

We can even define an element styles using the curly braces for the style object

```jsx
var element = <input style = {{width:200,height:100}}/>
```

### Nested Elements

Elements can be nested within other elements, however these need to be wrapped in a single parent element

```jsx
   var element = (
       <div>
            <div>Hello World</div>
            <div>Hello World</div>
        </div>
    )
```

It is also recommended to surround these with parenthesis in order to avoid semicolon insertion

Also note that certain attributes are named differently in React, for example `class` is called `className`

## React Components

React components are reusable components

React has two types of components, namely Functional and Class

### Functional Components

Functional components are just functions that output React Elements, by convention the first letter is capitalized and can be created by referencing the component name

```jsx
function HelloWorld(){
    return <h1>Hello World!</h1>
}

var element = <HelloWorld/>

ReactDOM.render(
    <HelloWorld/>,
    document.getElementById("root")
)
```

#### Component Properties

Functional components can also have properties such as

```jsx
function HelloWorld(props){
    return <h1>Message: {props.message}</h1>
}

ReactDOM.render(
    <HelloWorld message="Hello World!"/>,
    document.getElementById("root")
)
```

Properties can be any type of javascript object, such as:

```jsx
function HelloWorld(props){
    return <h1>Value: {props.numberArray[props.index]} </h1>
}

ReactDOM.render(
    <HelloWorld index = "3" numberArray={[1,2,3,4,5]}/>,
    document.getElementById("root")
)
```

Anything passed through `props` will be accessible

### Component Composition

Functional components can include other components inside of them, such as in the following example which will output a list of shopping items

```jsx
 function ShoppingTitle(props){
    return (
        <div>
            <h1>{props.title}</h1>
            <h2>Total Number of Items: {props.numItems}</h2>
        </div>
    ) 
}
function ListItem(props){
    return <li>{props.item}</li>
}

function ShoppingList(props){
    return (
        <div>
            <h3>{props.header}</h3>
            <ol>
                <ListItem item = {props.items[0]}/>
                <ListItem item = {props.items[1]}/>
                <ListItem item = {props.items[2]}/>
            </ol>
        </div>
    )
}

function ShoppingApp(props){
    return (
        <div>
            <ShoppingTitle title = "My Shopping List" numItems = "9"/>
            <ShoppingList header = "Food" items = {[ "Apple","Bread","Cheese"]}/>
            <ShoppingList header = "Clothes" items = {[ "Shirt","Pants","Hat"]}/>
            <ShoppingList header = "Supplies" items = {[ "Pen","Paper","Glue"]}/>
        </div>
    )
}

ReactDOM.render(
    <ShoppingApp/>,
    document.getElementById("root")
) 
```

### Conditional Rendering

We can render components based on conditional information by simply using `if-else` statements or a `conditional operator` inline

```jsx
function Feature(props){
    if(props.active) {
        return <h1>Active</h1>
    } else {
        return <h1>Inactive</h1>
    }
}
```

```jsx
function Feature(props){
    return <h1>{props.active? "Active":"Inactive"}</h1>
}
```

We can also completely prevent rendering by returning `null` or with the `&&` operator

```jsx
function Feature(props){
    if(props.active){
        return <h1>{props.message}</h1>
    } else {
        return null
    }
}
```

```jsx
function Feature(props){
    return (
        props.active && <h1>{props.message}</h1>
    )
}
```