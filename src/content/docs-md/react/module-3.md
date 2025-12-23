---
published: true
title: Lists and Forms
---

[Based on this EdX course](https://courses.edx.org/courses/course-v1:Microsoft+DEV281x+1T2019/course/#block-v1:Microsoft+DEV281x+1T2019+type@chapter+block@8aeb17a4bc2d4ef7bba69a7c298f7f57)

## Lists

We can render a list of react elements using a few different methods

### Loop

```jsx
var elements = []
var array = [1,2,3,4,5]

for (let i = 0, i < array.length; i++){
    elements.push(<li>{array[i]}</li>)
}

ReactDOM.render(
    <ol>{elements}</ol>,
    document.getElementById("root")
)
```

### Map

```jsx
var array = [
  { name: 'John', age: 5 },
  { name: 'Jeff', age: 6 },
  { name: 'Jenny', age: 7 },
]

var elements = array.map((el) => (
  <li>
    Name: {el.name}, Age: {el.age}
  </li>
))

ReactDOM.render(<ol>{elements}</ol>, document.getElementById('root'))
```

### Map in JSX

```jsx
var array = [
  { name: 'John', age: 5 },
  { name: 'Jeff', age: 6 },
  { name: 'Jenny', age: 7 },
]

ReactDOM.render(
  <ol>
    {array.map((el) => (
      <li>
        Name: {el.name}, Age: {el.age}
      </li>
    ))}
  </ol>,
  document.getElementById('root')
)
```

### Using Keys

We can also use unique keys to render items quicker with the following

```jsx
var array = [
  { id: 1, name: 'John', age: 5 },
  { id: 2, name: 'Jeff', age: 6 },
  { id: 3, name: 'Jenny', age: 7 },
]

ReactDOM.render(
  <ol>
    {array.map((el) => (
      <li key={el.id}>
        Name: {el.name}, Age: {el.age}
      </li>
    ))}
  </ol>,
  document.getElementById('root')
)
```

```jsx
var array = [
  { id: 1, name: 'John', age: 5 },
  { id: 2, name: 'Jeff', age: 6 },
  { id: 3, name: 'Jenny', age: 7 },
]

ReactDOM.render(
  <ol>
    {array.map((el, index) => (
      <li key={index}>
        Name: {el.name}, Age: {el.age}
      </li>
    ))}
  </ol>,
  document.getElementById('root')
)
```

### List Component

It can be useful to define a component that specifically renders lists as follows

```jsx
class ListItem extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <li key={this.props.index}>
        Name: {this.props.name}, Age: {this.props.age}
      </li>
    )
  }
}

class List extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <ol>
        {this.props.list.map((el, index) => (
          <ListItem index={index} name={el.name} age={el.age} />
        ))}
      </ol>
    )
  }
}

var array = [
  { id: 1, name: 'John', age: 5 },
  { id: 2, name: 'Jeff', age: 6 },
  { id: 3, name: 'Jenny', age: 7 },
]

ReactDOM.render(<List list={array} />, document.getElementById('root'))
```

## Controlled Components

HTML form elements can be modified from the DOM as well as from the code, we use React to manage the state of these with what's called _Controlled Components_

We tie the DOM state to the React state in order to more easily manage it

This is done with the following steps

1. When an input value is changed, call an event handler to update the value
2. Re-render the element with its new value

### Input Fields

```jsx
class ControlledText extends React.Component {
  constructor(props) {
    super(props)
    this.state = { value: '' }
    this.handleChange = this.handleChange.bind(this)
  }

  handleChange(event) {
    this.setState({ value: event.target.value })
  }

  render() {
    return (
      <input
        type="text"
        value={this.state.value}
        onChange={this.handleChange}
      />
    )
  }
}
```

### Checkboxes

```jsx
class ControlledCheckbox extends React.Component {
  constructor(props) {
    super(props)
    this.state = { value: '' }
    this.handleChange = this.handleChange.bind(this)
  }

  handleChange(event) {
    this.setState({ value: event.target.checked })
  }

  render() {
    ;<input
      type="checkbox"
      checked={this.state.checked}
      onChange={this.handleChange}
    />
  }
}
```

### Text Areas

```jsx
class ControlledText extends React.Component {
  constructor(props) {
    super(props)
    this.state = { value: '' }
    this.handleChange = this.handleChange.bind(this)
  }

  handleChange(event) {
    this.setState({ value: event.target.value })
  }

  render() {
    return (
      <textarea
        type="text"
        value={this.state.value}
        onChange={this.handleChange}
      />
    )
  }
}
```

### Selects

```jsx
class ControlledSelect extends React.Component {
  constructor(props) {
    super(props)
    this.state = { value: 0 }
  }

  handleChange(event) {
    this.setState({ value: even.target.value })
  }

  render() {
    return (
      <select value={this.state.value} onChange={this.handleChange}>
        <option value="0">Please select an option</option>
        <option value="1">One</option>
        <option value="2">Two</option>
        <option value="3">Three</option>
      </select>
    )
  }
}
```

Selects can also be dynamically generated as follows

```jsx
class ControlledSelect extends React.Component {
  constructor(props) {
    super(props)
    this.state = { value: 0 }
  }

  handleChange(event) {
    this.setState({ value: even.target.value })
  }

  render() {
    var options = ['Please select an option', 'One', 'Two', 'Three']
    return (
      <select value={this.state.value} onChange={this.handleChange}>
        options.map((option, index) => <option value={index}>{option}</option>)
      </select>
    )
  }
}
```

### Multiple Inputs

```jsx
class ControlledMultiple extends React.Component {
  constructor(props) {
    super(props)
    this.state = { value: 'apple' }
    this.handleChange = this.handleChange.bind(this)
  }
  handleChange(event) {
    this.setState({ [event.target.name]: event.target.value })
  }
  render() {
    var array = ['apple', 'banana', 'carrot', 'donuts']
    var options = array.map((item) => <option value={item}>{item}</option>)
    return (
      <form>
        <input
          name="inputName"
          type="input"
          value={this.state.inputName}
          onChange={this.handleChange}
        />
        <textarea
          name="textAreaName"
          type="text"
          value={this.state.textAreaName}
          onChange={this.handleChange}
        />

        <select
          name="selectName"
          value={this.state.selectName}
          onChange={this.handleChange}
        >
          {options}
        </select>
      </form>
    )
  }
}
```

### Tutorial

The Codepen for the Tutorial can be found [here](https://codepen.io/benjlin/pen/rwGKjW)
