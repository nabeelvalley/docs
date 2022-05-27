[[toc]]

# Introduction

Lately I've been a little concerned with my current SPA approach on my personal site as well as a few others. More specifically the high initial load time due to the calls to the backend to retrieve content

With the aim of solving this problem I've spent a lot of time looking at and playing with Static Site Generators.Foreword: they're all a lot more complicated than one would think

So for a static site the "static" content only changes so often, based on this we can generate page content with the data we're planning to load in - that's what we're going to try to do

Now we'll be starting off with a React app generated with `create-react-app` so that we can have a starting point for our Gatsby site as well as understanding how we can approach some of the challenges when switching over to a site generator like Gatsby

For the sake of completeness, this series will be broken into four posts covering the following:

1. **Creating the initial React App** (This post)
2. [Rendering the "Dumb" pages with Gatsby](/blog/2020/21-01/gatsby-migration-2)
3. [Rendering the "Smart" page with Gatsby](/blog/2020/15-03/gatsby-migration-3)

# The React App

First we're going to be starting off with a new React app that we will work on changing into a Gatsby one parts `2` and `3`, we'll then focus on using plugins to enhance our content in `4`

For this part we'll build a basic React app that has the following:

1. Two "hard-coded" pages and a 404 page
2. A dynamic page with an API call to retrieve data
3. Overall app layout with child routes for `1` - `3`

To get started, we'll create a fresh React App:

```
npx create-react-app gatsby-to-be
```

And add the `react-router`

```
yarn add react-router-dom
```

Running this command should set up the application, if you don't know much about React I'd suggest taking a look at [the documentation](https://create-react-app.dev/docs/getting-started)

Next `cd gatsby-to-be` and run `yarn start`, you should be able to visit the application in your browser at `http://localhost:3000/`

Looking at the generated files we have a `public` directory with some icons, an `index.html` file into which our React application will run once built, and a `src` directory that has the application code. The `index.js` file is what loads the application into the DOM and the `App.js` file which is the main component for our application

# Hard Coded Pages

We will create the following three hard-coded pages in the `src/pages` directory

These pages are just React components that we will assign Routes to.

The pages we are using are known as `functional` components because they are javascript functions that return JSX

If we intend to use JSX in a file we need to ensure that we import `React`. The other component we are importing is the `Link` component which is a lot like a normal HTML `a` tag but with some special functionality to make the client-side navigation work

`Blog.js`

```js
import React from "react"
import { Link } from "react-router-dom"

const Blog = () => (
  <div className="Blog">
    <h1>Blog</h1>
    <p>This is the Blog page</p>
    <div>
      <Link to="/blog/post-1">Post 1</Link>
    </div>
    <div>
      <Link to="/blog/post-2">Post 2</Link>
    </div>
  </div>
)

export default Blog
```

Additionally we have the `Home.js` and `NotFound.js` files which are similar to the `Blog.js` file we created

<details>
<summary>Home</summary>

`Home.js`

```js
import React from "react"

const Home = () => (
  <div className="Home">
    <h1>Home</h1>
    <p>This is the Home page</p>
  </div>
)

export default Home
```

</details>

<details>
<summary>Not Found</summary>

`NotFound.js`

```js
import React from "react"

const NotFound = () => (
  <div className="NotFound">
    <h1>404</h1>
    <p>Page Not Found</p>
  </div>
)

export default NotFound
```

</details>

# Dynamic Post Page

Next up we'll create a component that can render out content for a blog post. This will consist of a few `hooks` which are react functions that we can use to sort of control the data in a function

The `Post` component will:

1. Display a loading indicator initially
2. Figure out what post we're trying to render based on the URL
3. Retrieve a JSON file from the `public` directory based
4. Set the component state after reading the file
5. Display the content from the file in a JSX template

The `useState` hook is used to initialize the state the component, in this case using the `hasError` and `data` variables, as well as providing the functions necessary for updating those in the form of `setHasError` and `setData` respectively

We use `fetch` in the `useEffect` hook to retrieve the data from the `public` directory. The `useEffect` hook allows us to pass a function that will be called to update side effects. The second input, in our case `[]` is the array of objects that, when are changed, we want the hook to run - since we only want it to run once and don't care about any other state changes we pass in an empty array for this value

`Post.js`

```js
import React, { useEffect, useState } from "react"

const Post = ({ match }) => {
  const slug = match.params.slug

  const [hasError, setHasError] = useState(false)
  const [data, setData] = useState(null)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await fetch(`/posts/${slug}.json`)
        const json = await res.json()
        setData(json)
      } catch (error) {
        console.log(error.toString())
        setHasError(true)
      }
    }

    fetchData()
  }, [])

  return (
    <div className="Post">
      <p>
        This is the <code>{slug}</code> page
      </p>
      {data ? (
        <div className="content">
          <h1>{data.title}</h1>
          <p>{data.body}</p>
          <img src={data.image} alt="" />
        </div>
      ) : hasError ? (
        <div className="error">
          <h1>Error</h1>
          <p>{hasError}</p>
        </div>
      ) : (
        <p>Loading .. </p>
      )}
    </div>
  )
}

export default Post
```

In the above component we're making use of the following pattern to decide what to render conditionally:

1. If the data is loaded then show the data
2. Else if there is an error then show the error data
3. Otherwise show a loading message

The way we are rendering the `Post` component with a parameter for `match`. The `match` parameter will be passed in as a `prop` from the `Router` that we will configure next, this allows us to use the `slug` from the URL to retrieve the content for the page

The two data files we have to pull content from in the `public/posts` directory are `post-1.json` and `post-2.json`

<details>
<summary>Post 1 - JSON</summary>

`post-1.json`

```json
{
  "title": "Post 1",
  "body": "Hello world, how are you",
  "image": "/posts/1.jpg"
}
```

</details>

<details>
<summary>Post 2 - JSON</summary>

`post-2.json`

```json
{
  "title": "Post 2",
  "body": "Hello world, I am fine",
  "image": "/posts/2.jpg"
}
```

> The images `posts/1.jpg` and `posts/2.jpg` can also just be any images in that directory

</details>

# App Layout and Routes

Lastly, we'll specify our application layout with the relevant routes in the `App.js` file, referencing the components we have created, we do this using the `BrowserRouter`. When we switch the project over to a Gatsby one, the `App.js` file will be converted into our `Layout` component to wrap our different pages

We use the `Router` component and the page inside of it, this essentially handles Routing via the `Link` components. Next we have a `div` as a wrapper for our component as well as a `header`, `nav`, and `main` tags to organise the page

The `Route` component takes in the component that we would like to display for a given route, and the `Switch` helps us to ensure that only route is actively being fisplayed at a time. The `Switch` will navigate from the first to last `Route` and render the first one that matches the given `path`

Fow now, our `App.js` file is as follows:

```js
import React from "react"
import "./App.css"
import { BrowserRouter as Router, Link, Switch, Route } from "react-router-dom"
import Home from "./pages/Home"
import Blog from "./pages/Blog"
import Post from "./pages/Post"
import NotFound from "./pages/NotFound"

const App = () => (
  <Router>
    <div className="App">
      <header>
        <nav>
          <h1>My Website Title</h1>
          <Link to="/">Home</Link>
          <Link to="/blog">Blog</Link>
        </nav>
      </header>
      <main>
        <Switch>
          <Route exact path="/" component={Home}></Route>

          <Route exact path="/blog" component={Blog}></Route>

          <Route exact path="/blog/:slug" component={Post}></Route>

          <Route path="/*" component={NotFound}></Route>
        </Switch>
      </main>
    </div>
  </Router>
)

export default App
```

In the above component we can see that where we are rendering the `Post` component we have a parameter in the route called `slug`, this parameter will be passed in to the `Post` component as part of the `match` object

# Summary

We have built a fairly simple application that makes use of both static and data-based pages, we have also tied all of these together using the `App` component and a `Router` with the following routes:

1. `/` which will render the `Home` component
2. `/blog` which will render the `Blog` component
3. `/blog/:slug` which will render the `Post` component and retrieve the data based on the given `slug`
4. `/*` which will match any other routes and render the `NotFound` component

In the next post we're going to look at how to take what we have so far and transform this application into a Gatsby one, but for now it may be useful to think about what kind of steps we may need to take if we'd like to make this a static website based on the way our current routes work

> Nabeel Valley
