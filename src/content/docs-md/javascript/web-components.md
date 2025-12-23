---
published: true
title: Web Components
subtitle: Notes on Web Components
---

[Basics from CSS Tricks](https://css-tricks.com/an-introduction-to-web-components/)

> Most code snippets used here are from the above series

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
  { title: 'Catch 22', author: 'Joseph Heller' },
]

// get the template
const fragment = document.getELementById('book-template')

// loop through data
books.forEach((book) => {
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
    button.addEventListener('click', (event) => alert(event))
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

Custom elements make use of lifecycle methods

The `constructor` is used to set up the basics of the element, and `connectedCallback` is used to add content to the element, set up event listeners or generally initialize the component

Typically an element's state isn based on the attributes that are present on the element, for example a custom attribute `open`. We can watch changes to attributes in the `attributeChangedCallback` which is called whenever an element's `observedAttributes` are changed

We can create a dialog component which makes use of the above

```js
class OneDialog extends HTMLElement {
  static get observedAttributes() {
    return ['open']
  }

  attributeChangedCallback(attrName, oldValue, newValue) {
    if (newValue !== oldValue) {
      this[attrName] = this.hasAttribute(attrName)
    }
  }

  connectedCallback() {
    const template = document.getElementById('one-dialog')
    const node = document.importNode(template.content, true)
    this.appendChild(node)
  }
}
```

The `attributeChangedCallback` helps us to keep our internal element state and the external attributes in sync by updating out internal state when the external attributes are changed

Additionally we can create a getter and setter for the `open` property and make use of those to update the state using the following code

```js
class OneDialog extends HTMLElement {
  static get boundAttributes() {
    return ['open']
  }

  attributeChangedCallback(attrName, oldValue, newValue) {
    this[attrName] = this.hasAttribute(attrName)
  }

  connectedCallback() {
    const template = document.getElementById('one-dialog')
    const node = document.importNode(template.content, true)
    this.appendChild(node)
  }

  get open() {
    return this.hasAttribute('open')
  }

  set open(isOpen) {
    if (isOpen) {
      this.setAttribute('open', true)
    } else {
      this.removeAttribute('open')
    }
  }
}
```

Using the above we can update the state based on the attribute as well as vice versa

Most elements will involve some boilerplate code to keep the element state in sync, we can instead encapsulate this functionality in an abstract class that we can extend for our custom elements, this will loop and allocate the respective attributes to the element state

```js
class AbstractClass extends HTMLElement {
  constructor() {
    super();
    // Check to see if observedAttributes are defined and has length
    if (this.constructor.observedAttributes && this.constructor.observedAttributes.length) {
      // Loop through the observed attributes
      this.constructor.observedAttributes.forEach(attribute => {
        // Dynamically define the property getter/setter
        Object.defineProperty(this, attribute, {
          get() { return this.getAttribute(attribute); },
          set(attrValue) {
            if (attrValue) {
              this.setAttribute(attribute, attrValue);
            } else {
              this.removeAttribute(attribute);
            }
          }
        }
      });
    }
  }
}

// Instead of extending HTMLElement directly, we can now extend our AbstractClass
class SomeElement extends AbstractClass { /** Omitted */ }

customElements.define('some-element', SomeElement);
```

Back to the dialog - we can add the ability for the dialog to show or hide itself by modifying it's classes and add and remove the relevant event listeners

We also have the `disconnectedCallback` lifecycle method that allows us to do the necessary cleanup for the component

```js
class OneDialog extends HTMLElement {
  static get observedAttributes() {
    return ['open']
  }

  constructor() {
    super()
    this.close = this.close.bind(this)
  }

  attributeChangedCallback(attrName, oldValue, newValue) {
    if (oldValue !== newValue) {
      this[attrName] = this.hasAttribute(attrName)
    }
  }

  connectedCallback() {
    const template = document.getElementById('dialog-template')
    const node = document.importNode(template.content, true)
    this.appendChild(node)

    this.querySelector('button').addEventListener('click', this.close)
    this.querySelector('.overlay').addEventListener('click', this.close)
    this.open = this.open
  }

  disconnectedCallback() {
    this.querySelector('button').removeEventListener('click', this.close)
    this.querySelector('.overlay').removeEventListener('click', this.close)
  }

  get open() {
    return this.hasAttribute('open')
  }

  set open(isOpen) {
    this.querySelector('.wrapper').classList.toggle('open', isOpen)
    this.querySelector('.wrapper').setAttribute('aria-hidden', !isOpen)
    if (isOpen) {
      this._wasFocused = document.activeElement
      this.setAttribute('open', '')
      document.addEventListener('keydown', this._watchEscape)
      this.focus()
      this.querySelector('button').focus()
    } else {
      this._wasFocused && this._wasFocused.focus && this._wasFocused.focus()
      this.removeAttribute('open')
      document.removeEventListener('keydown', this._watchEscape)
      this.close()
    }
  }

  close() {
    if (this.open !== false) {
      this.open = false
    }
    const closeEvent = new CustomEvent('dialog-closed')
    this.dispatchEvent(closeEvent)
  }

  _watchEscape(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }
}
```

While the above helps us to encapsulate functionality, it say's nothing of the stylings in the component which can still impact, and be impacted by the rest of the DOM

In order to do that we can make use of the Shadow DOM

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

```js
class OneDialog extends HTMLElement {
  constructor() {
    super()
    this.attachShadow({ mode: 'open' })
    this.close = this.close.bind(this)
  }
}
```

By calling `attachShadow` with `{mode: 'open'}` we tell the element to save a reference to the shadow root which can be accessed with `element.shadowRoot`

If we use `{mode: 'closed'}` we will additionally need to store a reference to the root itself. We can do this using a `WeakMap` which uses the shadow root as the `value` and the element as the `key`

```js
const shadowRoots = new WeakMap()

class ClosedRoot extends HTMLElement {
  constructor() {
    super()
    const shadowRoot = this.attachShadow({ mode: 'closed' })
    shadowRoots.set(this, shadowRoot)
  }

  connectedCallback() {
    const shadowRoot = shadowRoots.get(this)
    shadowRoot.innerHTML = `<h1>Hello from a closed shadow root!</h1>`
  }
}
```

Usually we would not use a shadow root that is closed, this is more for elements like `<audio>` that use the shadow DOM for it's implementation

The problem with using the shadow DOM is that the element needs to now interact with this instead of the light DOM. So the implementation needs to be updated as follows

```js
class OneDialog extends HTMLElement {
  constructor() {
    super()
    this.attachShadow({ mode: 'open' })
    this.close = this.close.bind(this)
  }

  connectedCallback() {
    const { shadowRoot } = this
    const template = document.getElementById('one-dialog')
    const node = document.importNode(template.content, true)
    shadowRoot.appendChild(node)

    shadowRoot.querySelector('button').addEventListener('click', this.close)
    shadowRoot.querySelector('.overlay').addEventListener('click', this.close)
    this.open = this.open
  }

  disconnectedCallback() {
    this.shadowRoot
      .querySelector('button')
      .removeEventListener('click', this.close)
    this.shadowRoot
      .querySelector('.overlay')
      .removeEventListener('click', this.close)
  }

  set open(isOpen) {
    const { shadowRoot } = this
    shadowRoot.querySelector('.wrapper').classList.toggle('open', isOpen)
    shadowRoot.querySelector('.wrapper').setAttribute('aria-hidden', !isOpen)
    if (isOpen) {
      this._wasFocused = document.activeElement
      this.setAttribute('open', '')
      document.addEventListener('keydown', this._watchEscape)
      this.focus()
      shadowRoot.querySelector('button').focus()
    } else {
      this._wasFocused && this._wasFocused.focus && this._wasFocused.focus()
      this.removeAttribute('open')
      document.removeEventListener('keydown', this._watchEscape)
    }
  }

  close() {
    this.open = false
  }

  _watchEscape(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }
}

customElements.define('one-dialog', OneDialog)
```

We can also render content using `<slot>`, where we can include named slot's in our light DOM, for example:

```html
<one-dialog>
  <span slot="heading">Hello world</span>
  <div>
    <p>Lorem ipsum dolor.</p>
  </div>
</one-dialog>
```

Which can then be rendered in it's respective pieces in our element with

```html
<h1 id="title"><slot name="heading"></slot></h1>
<div id="content" class="content">
  <slot></slot>
</div>
```

Furthermore, we can give the element a template (or different templates) by way of a new attribute for the element:

```js
get template() {
  return this.getAttribute('template');
}

set template(template) {
  if (template) {
    this.setAttribute('template', template);
  } else {
    this.removeAttribute('template');
  }
  this.render();
}
```

And then defining a render method to use that template with

```js
connectedCallback() {
  this.render();
}

render() {
  const { shadowRoot, template } = this;
  const templateNode = document.getElementById(template);
  shadowRoot.innerHTML = '';
  if (templateNode) {
    const content = document.importNode(templateNode.content, true);
    shadowRoot.appendChild(content);
  } else {
    shadowRoot.innerHTML = `<!-- template text -->`;
  }
  shadowRoot.querySelector('button').addEventListener('click', this.close);
  shadowRoot.querySelector('.overlay').addEventListener('click', this.close);
  this.open = this.open;
}
```

Lastly, you can use `attributeChangedCallback` to update the component when the template is changed

```js
static get observedAttributes() { return ['open', 'template']; }

attributeChangedCallback(attrName, oldValue, newValue) {
  if (newValue !== oldValue) {
    switch (attrName) {
      /** Boolean attributes */
      case 'open':
        this[attrName] = this.hasAttribute(attrName);
        break;
      /** Value attributes */
      case 'template':
        this[attrName] = newValue;
        break;
    }
  }
}
```

Currently the only reliable way to style components is with the `<style>` tag, these can however make use of `css variables` which pass through into the shadow DOM

### Proposed functionality

#### Constructible Stylesheets

This would allow stylesheets to be defined in JS and be applied on multiple nodes

```js
const everythingTomato = new CSSStyleSheet()
everythingTomato.replace('* { color: tomato; }')

document.adoptedStyleSheets = [everythingTomato]

class SomeCompoent extends HTMLElement {
  constructor() {
    super()
    this.adoptedStyleSheets = [everythingTomato]
  }

  connectedCallback() {
    this.shadowRoot.innerHTML = `<h1>CSS colors are fun</h1>`
  }
}
```

This could potentially be used for the proposed CSS modules for example:

```js
import styles './styles.css';

class SomeCompoent extends HTMLElement {
  constructor() {
    super();
    this.adoptedStyleSheets = [styles];
  }
}
```

#### Part and Theme

The `::part()` and `::theme()` selectors could allow you to expose elements of a component for styling

```js
class SomeOtherComponent extends HTMLElement {
  connectedCallback() {
    this.attachShadow({ mode: 'open' })
    this.shadowRoot.innerHTML = `
      <style>h1 { color: rebeccapurple; }</style>
      <h1>Web components are <span part="description">AWESOME</span></h1>
    `
  }
}

customElements.define('other-component', SomeOtherComponent)
```

```css
other-component::part(description) {
  color: tomato;
}
```

`::theme()` is similar to `::part()` but it allows elements to be styled from anywhere whereas the latter requires it to be specifically selected

## Tooling and Integration
