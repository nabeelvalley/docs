---
published: true
title: Nuxt.js
subtitle: Getting Started with Nuxt.js
description: Getting Started with Nuxt.js
---

[[toc]]

# Introduction

Nuxt.js is server-side framework based on Vue, the content here is kind of from this [DesignCourse Video](https://www.youtube.com/watch?v=IkrbIFZz_IM) and [this video](https://www.youtube.com/watch?v=T4qLTXGvJ7k&t=1901s) but with TypeScript. The overall code from the video can be found [here](https://github.com/designcourse/nuxt-2-tutorial-project)

# Getting Started

To create a new app you can run:

```
yarn create nuxt-app my-app
```

You can then just retain the default options for the most part, at this point you will also be able to select TypeScript as the language

That will initialize a new Nuxt app in the `my-app` folder. You can then do the following to start the application:

```
cd my-app
yarn dev
```

# Generated Files

Once we have run the project creation we will see the following folders in our application:

- `assets`
- `components`
- `layouts`
- `middleware`
- `pages`
- `plugins`
- `static`
- `store`

We also have the `layouts/default.vue` which has our basic page layout:

```html
<template>
  <div>
    <nuxt />
  </div>
</template>
```

In here we can see the section which will render our `nuxt` component which is the root for our Nuxt application

# Creating a Layout

We'll create some partials for our layout in a `layout/partials` directory

For a basic layout we can create a nav section:

`partials/nav.vue`

```html
<template>
  <header>
    <nuxt-link to="/">NAVIGATION</nuxt-link>
    <nav>
      <ol>
        <ul>
          <nuxt-link to="/">Home</nuxt-link>
        </ul>
        <ul>
          <nuxt-link to="about">About</nuxt-link>
        </ul>
      </ol>
    </nav>
  </header>
</template>

<script lang="ts">
  import Vue from "vue"

  export default Vue.extend({})
</script>

<style>
  nav {
    background-color: red;
  }
</style>
```

Note how we make use of `nuxt-link` instead of the normal `a`. We also use `Vue.extend` so that we can allow typescript to infer the type correctly

Next, we can import and use the `Nav` component in our default layout like so:

`layout/default.vue`

```html
<template>
  <div>
    <nav />
    <nuxt />
  </div>
</template>

<script lang="ts">
  import Vue from "vue"
  import Nav from "./partials/nav.vue"

  export default Vue.extend({
    components: {
      Nav,
    },
  })
</script>
```

## Including Global Resources

To include external resources or do anything that we would normally do in our `head` element in HTML, we can do via the `nuxt.config.js` file. For example if we would like to add a link to a font we can do so by adding a `link` to our head

`nuxt.config.js`

```js
...
head: {
  title: process.env.npm_package_name || '',
  meta: [
    { charset: 'utf-8' },
    { name: 'viewport', content: 'width=device-width, initial-scale=1' },
    { hid: 'description', name: 'description', content: process.env.npm_package_description || '' }
  ],
  link: [
    { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
    {rel: 'stylesheet', href: 'MY_FONT_URL'}
  ]
},
...
```

If we would like to include a `css` file we have locally we can also do this in the same config file by referencing the path like `@assets/styles/main.css`

# Pages

Nuxt makes use of file based routing, based on this our main page for our site will be located in the `pages/index.vue` file. We can clean up the unecessary content in this file and just leave the following:

```html
<template>
  <div>
    <h1>Home</h1>
  </div>
</template>

<script lang="ts">
  import Vue from "vue"

  export default Vue.extend({})
</script>

<style></style>
```

Each `page` component will essentially be rendered into the `nuxt` element. We can create another page for `about` and include some content that's similar to above. This file will be called `pages/about.vue`

Once we have the `about` page we should be able to click on our links and view the different pages

## Page Metadata

If we would like to provide some metadata we can export a `head` function from our component in which we specify some metadata. We need to do this in the component's `script` tag:

`pages/about.vue`

```ts
import Vue from "vue"

export default Vue.extend({
  head() {
    return {
      title: "The About Page",
      meta: [{ name: "description", content: "this is about the about page" }],
    }
  },
})
```

Note that if we intend to use our metadata like we do above we need to be sure to remove the relevant meta from out `nuxt.config.js` as well

## Router Transitions

Nuxt also has built-in router transitions, these make use of the `page-enter-active` and `page-leave-active` classes to apply the transitions. We can update our `layout/default.vue` file with an animation to apply it

`layout/default.vue`

```html
<template>
  <div>
    <nav />
    <nuxt />
  </div>
</template>

<script lang="ts">
  import Vue from "vue"
  import Nav from "./partials/nav.vue"

  export default Vue.extend({
    components: {
      Nav,
    },
  })
</script>

<style scoped>
  .page-enter-active {
    animation: bounce-in 0.8s;
  }
  .page-leave-active {
    animation: bounce-out 0.5s;
  }
  @keyframes bounce-in {
    0% {
      transform: scale(0.9);
      opacity: 0;
    }
    100% {
      transform: scale(1);
      opacity: 1;
    }
  }
  @keyframes bounce-out {
    0% {
      transform: scale(1);
      opacity: 1;
    }
    100% {
      transform: scale(0.9);
      opacity: 0;
    }
  }
</style>
```

We can also apply transitions to specific elements on a page by exporting a `transition` property with the name of the transition, and including the CSS for an animation. If we create a transition like `transition: 'floop'`, we will need to have the CSS transitions defined like aboe but using the class names `floop-enter-active` and `floop-leave-active` so they can be applied

# Retrieve Data

We can retrieve data on the client or on the server using the `fetch` method on a component

When using `fetch` in Nuxt we need to take note of the following:

1. Set the initial data with the `data` function or `data` property
2. Set `fetchOnServer` to `true` to allow for server side fetching if on the server
3. We can optionally set the `fetchDelay` to delay the fetch on the client, e.g. to prevent flashing. If we want everything to load immediately then don't set this
4. Use `isomorphic-fetch` to allow for consistent fetching on both the client and server
5. Set the relevant data in the `fetch` function

The code for our component will look like so:

`pages/index.vue`

```ts
import Vue from "vue"
import isoFetch from "isomorphic-unfetch"

type ShowData = {
  id: string
  name: string
}

type TvResponse = {
  show: ShowData
}[]

type TvData = {
  shows: ShowData[]
}

export default Vue.extend({
  data() {
    return {
      shows: [],
    } as TvData
  },
  async fetch() {
    const res = await isoFetch("https://api.tvmaze.com/search/shows?q=batman")
    const data = (await res.json()) as TvResponse

    this.shows = data.map((el) => el.show)

    console.log(`Show data fetched. Count: ${this.shows.length}`)
  },
  fetchOnServer: true,
  fetchDelay: 1000,
})
```

By using the `fetch` method for the component we get the ability to view the current state of the `fetch` when on the client, we can use the `$fetchState` values for `$fetchState.error`, `fetchState.pending`, and `$fetchState.timestamp` for the status of the fetch. We can also call the hook from a component using the `$fetch` function in a template

> Make sure the data model in your `data` function aligns with the populated data on the `fetch` function otherwise the SSR will not kick in and it will render on the client

We can render the component with the awareness of the `fetch` state like so:

`pages/index.vue`

```html
<template>
  <div>
    <h1>Home</h1>
    <div v-if="$fetchState.pending">Loading . . .</div>
    <div v-else-if="$fetchState.error">{{ $fetchState.error }}</div>
    <div v-else>
      <ol>
        <li v-for="show of shows" :key="show.id">{{ show.name }}</li>
      </ol>
    </div>
  </div>
</template>
```

# Build and Run To build and run the final application just do:

```
yarn build
yarn start
```
