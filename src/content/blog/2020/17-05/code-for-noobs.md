---
published: true
title: Code for Noobs
subtitle: 17 May 2020
description: An introduction to programming and general programming concepts using JavaScript
---

So I've been meaning to write an introductory post about the basics of JavaScript for quite some time. A few weeks ago I managed to finally get something going on [this Twitter thread (@not_nabeel)](https://twitter.com/not_nabeel/status/1255743195557888000)

Let's get into it

## 0. What is Programming

Programming is our way of telling a computer to do things. This can be anything from checking our spelling to making trippy digital art

The basics of programming are the same in most languages and doesn't involve much math or binary (`0010101`) like a lot of people seem to think. Programming languages _usually_ make use of a very small subset of words and concepts of a normal human language like English

The language I'm going to be using is called `JavaScript` but many of these concepts are the same in most other programming languages

## 1. What is JavaScript?

JavaScript is the language used to add interactivity to a website but it can also be used to do pretty much anything you like. JavaScript runs in all modern web browsers and can be accessed through your browser's developer tools, but it can also be used on other devices using something like [@nodejs](https://twitter.com/nodejs)

For our purposes though, we don't need to worry too much about how that all works right now. To get started we'll be using tools like [@CodePen](https://twitter.com/CodePen), [@replit](https://twitter.com/replit) and [@glitch](https://twitter.com/glitch) which give you text editor and a place to run your code

> You'll see some code samples embeded in the

I'll be posting links to the code on these sites as I go along

## 2. Text Data

In a program, we can store different types of data (known as "data types")

When we store text we use a data type called `string`. In JavaScript a string is just text surrounded in either double quotes, single quotes, or `` `these things` `` (which are known as backticks):

```js
'i am text'
```

```js
'i am also text'
```

```js
;`me too.`
```

```js
;`unlike the others,
  i can b
multiple lines
lllooonnnggg
    and have random spaces`
```

## 3. Variables

If we want to keep our data for use at a later stage we need to give it a name, otherwise how do we know what data we're trying to use right? To give a piece of data (or text, in our case) a name we create a `variable`

We create a variable using `let` or `const` along with a variable name and the data that we want to give the name to :

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt3?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
// this code shouldn't do anything if you run it
// we are just creating some variables

let myText = 'Hello World'

const myOtherText = 'Bye World'
```

</details>

We use `let` for data whose data may change and `const` for data whose data won't you can remember this like: `const = constant`

> Note that it is also possible to use the keyword `var` to create a variable. This is something that is left over from older versions of JavaScript and can have some effects that are better to just avoid (if you're interested you can read [this article about how it impacts variable scope](https://medium.com/@josephcardillo/the-difference-between-function-and-block-scope-in-JavaScript-4296b2322abe) but it is a bit of a more challenging concept to understand)

When creating a variable, there are a few rules we need to follow:

1. Variable names **must not** contain spaces or stuff like `!@#%%^&\*()`, underscores and dollar signs are okay though
2. Variable names **must not** be a word the language has set aside for something else. e.g `const` or `let`
3. Variable names **must not** start with a number
4. Variable names **should be** descriptive. while names like "x" and "blah" are allowed, if they have no meaning in the context it's better to opt for something people will understand

## 4. Printing Data

Languages have ways we can show data to a user (or programmer). In JavaScript this is the "console.log" function. We'll discuss functions later on but for now know that when we give them data, and they do stuff

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt4?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
// print the data
console.log('Bob Smith') //prints -> Bob Smith

// print a variable
const jenny = 'Jenny Smith'
console.log(jenny) // prints -> Jenny Smith
```

</details>

## 5. Numbers

Numbers are another type of data in JavaScript, to store a number we can just write the number. using numbers we can also do things like getting fat or running from the po-lice

1. `-` is plus
2. `-` is minus
3. `*` is multiply
4. `/` is divide

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt5?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
const myWeight = 100
const food = 100 + 50

const myNewWeight = myWeight + food

console.log(myNewWeight) // print -> 250

const myWeightAfterRunnin = myWeight - myWeight * 0.2

console.log(myWeightAfterRunnin) // print -> 80
```

</details>

But, JavaScript lets us add do maths with anything. so maybe like - don't do this:

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt5-1?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
const dontDoThis = 'apple' * 'pineapple'

console.log(dontDoThis) // print -> NaN (Not a Number)
```

</details>

## 6. Arrays

Arrays are how we store a set of data. an array can have different data types in it, but usually, we want to be storing the same stuff in an array. we make an array by wrapping our items in `[ ]` and separating each item with a comma (`,`)

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt6?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>
  
```js
const myFriends = ["i", "don't", "have", "any"]

const thingsToRemember = ["uhmm", 42, 12, "idk, i guess i forgot"]

const multipleLines = [
"arrays don't have to be",
"on a single",
"line"
]

````

</details>


If we want to get a specific element in an array we can use the variable name with the index (position) of the element. the index starts at 0. we will get `undefined` (I'll explain this in a bit) if we try to get a value at an index that does not exist

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt6-1?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
  const myData = [
  "zeroeth index",
  "first index",
  "second index",
  "third index"
]

console.log(myData[0]) // print -> zeroeth index
console.log(myData[1]) // print -> first index
console.log(myData[2]) // print -> second index
console.log(myData[3]) // print -> third index

// indexes that do not exist in our array
console.log(myData[-1]) // print -> undefined
console.log(myData[100]) // print -> undefined
````

</details>

## 7. Booleans

So far we've looked at strings and numbers, we have an even more basic data type called a boolean. a boolean is a value that can either be true or false. when creating a variable for a boolean we do not wrap the value in quotes

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt7?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
var myTrueBool = true

var myFalseBool = false

console.log(myTrueBool)
console.log(myFalseBool)
```

</details>

## 8. Complex Data

If we want to store data that are more complex than the ones we've seen above, we can make use of "objects". use `{ }` around our data to group more basic data. these use `keys` as names for values in the object

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt8?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
const jenny = {
  id: 123,
  name: 'Jenny',
  surname: 'Smith',
  age: "idk, can't ask a woman that",
  favouriteBooks: [
    'To not kill a Mockingbird',
    'Why are books so voilent, yoh',
  ],
}

// we can get specific values using their keys
const jennyName = jenny.name
const jennyBooks = jenny.favouriteBooks
```

</details>

## 9. Undefined and Null

the values `undefined` and `null` have a special meaning.

- `undefined` is a representation for a variable that does not have a value
- `null` is a value of "nothing"

For example:

- What's wrong with chocolate? `null`
- What's a flobuir? `undefined`

## 10. Functions

Functions are a way we can group code for a specific set of instructions, usually with some end purpose. In JavaScript we define a function in one of two ways: using the word `function` or with the `fat arrow syntax`

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-pt10?lite=false" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
// using the "function" keyword
// this creates a variable called "myFunc1"
function myFunc() {
  const stuff = 'I am Function'
  console.log(stuff)
}

// we can also create the variable using
// "let" or "const" like we do for other variables
const myLetFunc = function () {
  const stuff = 'I am another Function'
  console.log(stuff)
}

// fat arrow function
const myFatFunc = () => {
  console.log('Phat Funk')
}

// single line fat-arrow functions don't need the {}
const mySingleLineFunct = () => console.log('single line')
```

</details>

To use a function we simply write the name of the function and then add `()` at the end, provided the function doesn't take any data (also known as `parameters`)

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-10-1?lite=false" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
const sayHello = function () {
  console.log('Hello')
}

// "call" the function
sayHello() // prints -> Hello

const sayBye = () => console.log('BYEE')

// "call" the function
sayBye() // prints -> BYEE
```

</details>

Remember earlier I said that functions take data and do stuff? For us to give a function data we need to tell it what variables to store that data as when we call it. We do this by having the data in the `()` when we create (or 'declare') our function

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-10-2?lite=false" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
function sayHello(name) {
  console.log('Hello ' + name)
}

// use the function
sayHello('Bob') // print -> Hello Bob

const sayBye = (name) => console.log('Bye ' + name)

//use the function
const name = 'Jenny'
sayBye(name) // print -> Bye Jenny
```

</details>

When computers are following our code they do so from the top down, so the first line is handled by the computer before the second. the second before the third, etc. functions are a way for us to reuse code that was written on a line higher up in our code. You may notice that we use the variable `name` in a lot of different places above. this uses `scope` and broadly means any variable name created in a function (or pretty much anywhere between `{ }`) is only available within that section

> Scope complicated, you can read more about it [here](https://scotch.io/tutorials/understanding-scope-in-JavaScript)

Functions can also take multiple parameters, this is done by listing the parameters between the () and separating them by commas. the order that we list them when we create our function is the same as the order we need to put them when using the function

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-10-3?lite=false" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
const sayBye = (firstName, lastName) => {
  console.log('Bye ' + firstName + ' ' + lastName)
}

// use the function
const jennyName = 'Jenny'
const jennySurname = 'Smith'
sayBye(jennyName, jennySurname) // print -> Bye Jenny Smith
```

</details>

Functions are also able to give us back a value after doing some stuff. They do this by using the `return` keyword which tells it what to give back. A function stops processing when it sees the keyword `return` - anything after it in a function is ignored

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/twitter-10-4?lite=false" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
  <summary>View Code</summary>

```js
const addNumbers = (num1, num2) => {
  const result = num1 + num2
  return result
}

const mySum = addNumbers(1, 2)

console.log(mySum) // print -> 3
```

</details>

## Summary

That's it for now, I'll definitely be updating this post/series as things are added

> Nabeel Valley
