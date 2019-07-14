# Web Components

[Basics from CSS Tricks](https://css-tricks.com/an-introduction-to-web-components/)

## Introduction

Web components are custom HTML Elements which are built with Javascript and make use of the Shadow DOM to encapsulate CSS and JS and user-defined HTML templates

At present Web Components are available in most major browsers with polyfills for IE and Edge

## HTML Templates

HTML templates allow us to define reusable pieces of HTML that will not be rendered until used by a script

An template can be defined and used as follows

```html
<template id="book-template">
  <li><span class="title"></span> &mdash; <span class="author"></span></li>
</template>

<ul id="books"></ul>
```

We can then create instances of the element by using javascript to use the template HTML and insert it into the UL

```js
// some data to use
const books = [
  { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald' },
  { title: 'A Farewell to Arms', author: 'Ernest Hemingway' },
  { title: 'Catch 22', author: 'Joseph Heller' }
]

// get the template
const fragment = document.getELementById('book-template')

// loop through data
books.forEach(book => {
  // create an copy of the template
  const instance = document.importNode(fragment.content, true)

  // set the inner HTML for the different content sections
  instance.querySelector('.title').innerHTML = book.title
  instance.querySelector('.title').innerHTML = book.author

  // add the new instance to the books list
  document.getElementById('books').appendChild(instance)
})
```

The `importNode` function takes in a fragment content and a boolean that tells the browser whether or not to copy just the parent or all of it's subtree

Since templates are regulat HTML Elements, they can contain things like Javascript and CSS, for example:

```html
<template id="template">
  <script>
    const button = document.getElementById('click-me')
    button.addEventListener('click', event => alert(event))
  </script>
  <style>
    #click-me {
      all: unset;
      background: tomato;
      border: 0;
      border-radius: 4px;
      color: white;
      font-family: Helvetica;
      font-size: 1.5rem;
      padding: 0.5rem 1rem;
    }
  </style>
  <button id="click-me">Log click event</button>
</template>
```

The problem witht the above method is that the styles and functionality of the component can still impact the rest of the DOM once an instance/s are created

## Custom Elements

Custom elements are elements that can be defined by users. These elements must have a `-` in their names

This markup can be shared between different frameworks

A custom element can be defined with

```js
class HelloWorldComponent extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `<h1>Hello World</h1>`
  }
}

customElements.define('hello-world', HelloWorldComponent)
```

And can be used in HTML as follows

```html
<hello-world></hello-world>
```

All Custom Elements must extend `HTMLElement` in order to be registered by the browser

The `customElements` API allows us to create custom HTML tags that can be used on any document that has the class definition for the element

> > > > > > > > > > CONTINUE FROM HERE https://css-tricks.com/creating-a-custom-element-from-scratch/

## Shadow DOM

The Shadow DOM is an encapsulated section of the DOM which helps to isolate pieces of the DOM including any CSS

When targeting the shadow DOM we make use of `shadowRoot.querySelector` where `shadowRoot` is a reference to the shadow-element

A fragment of ShadowDOM can be created by making use of `attachShadow` and the `<slot></slot>` element to include the content from the outer document

```html
<div id="shadow-ref">Shadow Button Text</div>
<button id="button">Document Button Text</button>
```

```js
const shadowRoot = document
  .getElementById('shadow-ref')
  .attachShadow({ mode: 'open' })
shadowRoot.innerHTML = `<style>
button {
  background-color: blue;
}
</style>
<button id="button"><slot></slot> tomato</button>`
```

The above will render two buttons, the one in the shadow DOM will be blue, while the other will be unaffected by the CSS

> > > > > > > > > > SCROLL UP TO LINE 108
