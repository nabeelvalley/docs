# Module 2 - State, Lifecycle and Event Handlers

[Based on this EdX course](https://courses.edx.org/courses/course-v1:Microsoft+DEV281x+1T2019/course/#block-v1:Microsoft+DEV281x+1T2019+type@chapter+block@8aeb17a4bc2d4ef7bba69a7c298f7f57)

- [Module 2 - State, Lifecycle and Event Handlers](#module-2---state-lifecycle-and-event-handlers)
  - [React Components](#react-components)
    - [Class Components](#class-components)
    - [State](#state)
      - [Previous State](#previous-state)
      - [Future State](#future-state)
      - [State is Immutable](#state-is-immutable)
  - [Lifecycle Methods](#lifecycle-methods)
    - [Mounting](#mounting)
    - [Updating](#updating)
    - [Unmounting](#unmounting)
  - [Event Handlers](#event-handlers)
  - [Passing State to Parents](#passing-state-to-parents)
  - [Demo App](#demo-app)

## React Components

### Class Components

React components can also be written as ES6 classes instead of functions. This can be done by extending the `React.Component` class

```jsx
class Welcome extends React.Component {
    render(){
        return <h1>Hello World!</h1>
    }
}

ReactDOM.render(
    <Welcome/>,
    document.getElementById("root")
)
```

As expected, we can also add props to these components as with functional components as follows

```jsx
class Welcome extends ReactComponent {
    render(){
        return <h1>Message: {this.props.message}</h1>
    }
}

ReactDOM.render(
    <Welcome message="Hello World!"/>,
    document.getElementById("root")
)
```

### State

The `constructor` is called before a React component is mounted and is used to set up the initial component state. It is important to call the `super(props)` function otherwise the constructor may not work correctly

```jsx
class Counter extends React.Component{
    constructor(props){
        super(props)
    }
    render(){
        return <div>Hello World!</h1>
    }
}
```

Initial state can be defined as well as updated using the `constructor` and `setState` functions respectively

```jsx
class Counter extends React.Component{
    constructor(props){
        super(props)
        //initial state set up
        this.state = {message:"Initial message"}
    }
    componentDidMount(){
        //updating state
        this.setState({message:"New message"})
    }
    render(){
        return <div>Message:{this.state.message}</div>
    }
}
```

#### Previous State

The `setState` will update the component when React reaches it in the update queue in order to be more efficient. The method updates the state asynchronously and has a `componentDidMount` method that is called when that happens, thereby allowing us to update a component based on previous state

We can use the `setState` function with a function that takes two inputs `prevState, props` in order to update the properties based on that function

```jsx
class Counter extends React.Component{
    constructor(props){
        super(props)
        //initial state set up
        this.state = {message:"Initial message"}
    }
    componentDidMount()
        //updating state
        this.setState((prevState, props) => {
            return {message: prevState.message + '!'}
        })
    }
    render(){
        return <div>Message:{this.state.message}</div>
    }
}
```

#### Future State

Since the state updates asynchronously, we cannot immediately use the new state after calling the `setState` function

```jsx
//this.state.count is originally 0
this.setState({count:42})
console.log(this.state.count)
//outputs 0 still
```

```jsx
//this.state.count is originally 0
this.setState({count:42}, () = {
    console.log(this.state.count)
    //outputs 42
})
```

#### State is Immutable

State is immutable and hence should not be manipulated directly. For example, we cannot do the following

```jsx
this.state.message = "New message"
```

## Lifecycle Methods

Each class component goes through a lifecycle which contains multiple phases and methods that can be defined

### Mounting

1. `constructor(props)` is called when a component is initialized. This is only called once
2. `componentWillMount()` is called just before a component mounts
3. `render()` is called when a component is rendered
4. `componentDidMount()` is called when a component has been mounted - we will typically make network requests in this phase

### Updating

These methods happen when a component's state changes

1. `componentWillReceiveProps(nextProps)` os called when a component has updated and is receiving new props
2. `shouldComponentUpdate(nextProps, nextState)` will decide whether a component should run the `componentWillUpdate`, `render()`, and `componentDidUpdate` functions and must return a `boolean`
3. `componentWillUpdate(nextProps, nextState)` is called when a component is about to be updated
4. `render()`
5. `componentDidUpdate(prevProps, prevState)` is called after a component has updated

### Unmounting

The `componentWillUNmount()` function is called just before a component is removed from the DOM and is used for any cleanup such as cancelling timers and network requests

## Event Handlers

Events are handled similar to the way they are handled in HTML, aside from the fact that they are defined in camelCase and use the `{}` instead of `""` when attaching them to an element

```jsx
<button onClick={clickHandler}>Click Here</button>
```

Event handlers are defined withing a Class component, this can be done as follows

```jsx
class Counter extends React.Component {
    constructor(props){
        super(props)
        this.state = {
            count: 0
        }
        this.clickHandler = this.clickHandler.bind(this)
    }
    clickHandler(){
        this.setState((prevState, props)=>{
            return {count: prevState.count + 1}
        })
    }
    render(){
        return <button onClick={this.clickHandler}>{this.state.count}</button>
    }
}

ReactDOM.render(
    <Counter/>,
    document.getElementById("root")
)
```

If we need access to the correct `this` for an event handler we need to `bind` the function, this can be done in two ways

From the `constructor` with as above

```jsx
this.clickHandler = this.clickHandler.bind(this)
```

Or with the `ES6` arrow function to pass forward the context

```jsx
<button onClick={{() => this.clickHandler()}} >{this.state.count}</button>
```

## Passing State to Parents

At times it may be necessary to pass state from a child to a parent in order to change some other state elsewhere (either in the parent or in siblings by way of the parent), this can be done by passing the event handler down to the children components through their props, such as can be seen in the `Button` class below which attaches the `clickHandler` function defined in the `App` class

The app below simply displays buttons and text below, and when a button is clicked the state of siblings as well as the button itself should be updated

```jsx
class Details extends React.Component {
    render(){
    return <h1>{this.props.details}</h1>
    }
}

class Button extends React.Component {
    render(){
        return (
            <button style={{color: this.props.active? 'red': 'blue'}} onClick={()=> {this.props.clickHandler(this.props.id,this.props.name)}}>
            {this.props.name}
            </button>
        )
    }
}

class App extends React.Component {
    constructor(props){
        super(props)
        this.state={
            activeArray:[0,0,0,0], 
            details:""
        }
        this.clickHandler=this.clickHandler.bind(this)
    }

    clickHandler(id,details){
        var arr = [0,0,0,0]
        arr[id] = 1
        this.setState({
            activeArray:arr, 
            details:details
        })
        console.log(id,details)
    }
    
    render(){
        return (
            <div>
                <Button id={0} active={this.state.activeArray[0]} clickHandler={this.clickHandler} name="bob"/>
                <Button id={1} active={this.state.activeArray[1]} clickHandler={this.clickHandler} name="joe"/>
                <Button id={2} active={this.state.activeArray[2]} clickHandler={this.clickHandler} name="tree"/>
                <Button id={3} active={this.state.activeArray[3]} clickHandler={this.clickHandler} name="four"/>
                <Details details={this.state.details}/>
            </div>
        )
    }
}

ReactDOM.render(
    <App/>,
    document.getElementById("root")
)
```

## Demo App

We can make a Demo App that makes use of all the above, the code can be found on [This CodePen](https://codepen.io/benjlin/pen/WOZwbV?editors=1011)