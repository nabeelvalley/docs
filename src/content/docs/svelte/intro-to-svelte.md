---
published: true
title: Intro to Svelte
subtitle: Basic Info for Using Svelte
description: Basic Info for Using Svelte
---

---
published: true
title: Intro to Svelte
subtitle: Basic Info for Using Svelte
description: Basic Info for Using Svelte
---

# Introduction to Svelte

[Notes from this video](https://www.youtube.com/watch?v=Bfi96LUebXo)

> It's a compiler.

## Creating a new Project

To create a new project you can make use of `degit` which will allow you to create a project from a template. You can run this with `npx`:

```
npm degit sveltejs/template my-project-name
```

Then simply `cd` into your project directory and install dev-dependencies

```
cd my-project-name
npm i
```

You can then run the application with:

```
npm run dev
```

And view the application on your browser on `http://localhost:5000`

The project consists of the following:

- `package.json` for dependencies and scripts
- `public` for where any code that needs to go directly to the build output will live
- `src` folder contains the primary code files

In the `src/main.js` file there is an import which imports the `App` component and it states that the `App` component should be rendered into `document.body` with the `props: { name: 'world }`

`main.js`

```js
import App from './App.svelte'

const app = new App({
  target: document.body,
  props: {
    name: 'world',
  },
})

export default app
```

`App.svelte`

```html
<script>
  export let name
</script>

<style>
  h1 {
    color: purple;
  }
</style>

<h1>Hello {name}!</h1>
```

In the above component the `js` and `css` are scoped, the `{name}` is used to include expressions that we want to be evaluated

## Create a Component

Create a new componen by simply creating a `ComponentName.svelte`

`Card.svelte`

```html
<h2>Hey there</h2>
```

This can then be imported and used another component as follows:

```html
<script>
  import Card from './Card.svelte`
</script>

<Card />
```

We can get a component to retrieve inputs using the `export` keyword

```html
<script>
  export let text = 'Placeholder'
</script>

<h2>{text}</h2>
```

And we can pass this in from our `App` component with:

```html
<Card />

<Card text="Hello Jam" />
```

## Reactive Display

If we need to create computed property values we need to prefix that with the `$:` it will be automatically recalculated and updated in the template

```html
<script>
  export let text = 'Placeholder'

  $: newText = text + '!'
</script>

<h2>{newText}</h2>
```

If we would like to create some functionality that will enable a component to do some reactive stuff, or display based on the value of a specific component

```html
<script>
  let user = { loggedIn: false }

  function toggle() {
    user.loggedIn = !user.loggedIn
  }
</script>

{#if user.loggedIn}
<button on:click="{toggle}">Log In</button>
{/if} {#if !user.loggedIn}
<button on:click="{toggle}">Log Out</button>
{/if}
```

Clicking the button will then toggle the `loggedIn` state due to the `on:click` event and the `toggle` handler

You can create a component that iterates over a list of items using something like the following

```html
<script>
  let myList = [
    { id: 0, name: 'John' },
    { id: 1, name: 'Jenny' },
    { id: 2, name: 'James' },
  ]
</script>

<h1>My List</h1>

<ul>
  {#each myList as {id, name}}
  <li id="{id}">{name}</li>
  {/each}
</ul>
```

We can then just import and use the same as the above elements

## Input Binding

We can make use of input binding using the following method:

```html
<script>
  let name = 'John'
</script>

<input bind:value="{name}" />

<h1>Name is {name}</h1>
```
