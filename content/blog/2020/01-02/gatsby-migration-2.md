<details>
<summary>Contents</summary>

- [Introduction](#introduction)
- [Getting Ready](#getting-ready)
  - [Update Folder Structure](#update-folder-structure)
  - [Install Gatsby](#install-gatsby)
  - [Create Config Files](#create-config-files)
- [Page Setup](#page-setup)
  - [Fix the Blog Error Message](#fix-the-blog-error-message)
  - [Fix the Routes](#fix-the-routes)
  - [Fix the Layout](#fix-the-layout)
  - [Use the Layout](#use-the-layout)
  - [Fix the CSS](#fix-the-css)
- [Summary](#summary)

</details>

# Introduction

In the [last post](/blog/2020/21-01/gatsby-migration-1) we looked setting up an application with a few basic routes. These routes were all assigned to Components in the `src/pages` directory.

This post will be going throught the Gatsby Setup necessary in order to migrate our current site to Gatsby, we will be looking at the second step in the process that was outlined in the last post:

1. [Creating the initial React App](/blog/2020/21-01/gatsby-migration-1)
2. **Rendering the "Dumb" pages with Gatsby** (This post)
3. [Rendering the "Smart" page with Gatsby](/blog/2020/15-03/gatsby-migration-3)

# Getting Ready

In order to `Gatsbyify` the application, there are three steps that we will need to take before we can start updating our pages to work with the new system

1. Update folder structure
2. Install Gatsby
3. Create the necessary Gatsby Config files

## Update Folder Structure

Gatsby Builds are placed into the `public` directory. This currently is the output directory of a React build if we are using the standard React configuration

Before we do anything more we should rename our `public` directory to `static` as this is what Gatsby uses for static files, and then make a `git commit` before we add the `public` directory to our `.gitignore`

Now we need to add the following lines to the end of our `.gitignore` file so that we do not track the gatsby build files:

`.gitignore`

```sh
# gatsby
public
.cache
```

## Install Gatsby

To add Gataby to our project we need to add the `gatsby` package from `npm` as a dependency to our project. From the project's root directory run:

```
yarn add gatsby
```

Next we'll add/update the following commands in our `package.json` file so that we can start the Gatsby Dev Server as well as build the application

`package.json`

```json
"scripts": {
    "start": "gatsby develop",
    "build": "gatsby build",
    "clean": "gatsby clean",
    ...
},
```

## Create Config Files

In order to enable gatsby we need to add the `gatsby-config.js` file to our root directory, we can use the starter file with the following content, as it currently stands this doesn't do anything

`gatsby-config.js`

```js
module.exports = {
  plugins: []
}
```

Next we'll create an `html.js` file in the `src` directory with any relevant content from your `index.html` file if any of it has been updated. Also be sure to remove the `%PUBLIC_URL%` stuff from the file content

The `html.js` file needs to be a React Component with the following basic structure for a standard CRA app

`src/html.js`

```js
import React from "react"
import PropTypes from "prop-types"

export default function HTML(props) {
  return (
    <html {...props.htmlAttributes}>
      <head>
        <meta charSet="utf-8" />
        <link rel="shortcut icon" href="/favicon.png" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="theme-color" content="#ffffff" />

        <link rel="manifest" href="/manifest.json" />

        <title>React App</title>

        <script
          dangerouslySetInnerHTML={{
            __html: `
                        // Any scripts that need to be included in the HTML itself
                        // Like tracking code, etc.
                        console.log("Inline Javascript")
                    `
          }}
        ></script>

        {props.headComponents}
      </head>
      <body {...props.bodyAttributes}>
        {props.preBodyComponents}
        <div
          key={`body`}
          id="___gatsby"
          dangerouslySetInnerHTML={{ __html: props.body }}
        />
        {props.postBodyComponents}
      </body>
    </html>
  )
}

HTML.propTypes = {
  htmlAttributes: PropTypes.object,
  headComponents: PropTypes.array,
  bodyAttributes: PropTypes.object,
  preBodyComponents: PropTypes.array,
  body: PropTypes.string,
  postBodyComponents: PropTypes.array
}
```

You can add or remove any elements in that file as per your specific requirements but most of the time the above should be fine

Now that we have updated the `index.js` file delete the `static/index.html` file you can run the Gatsby Dev Server

```js
yarn clean
yarn start
```

Your application should now be running on `http://localhost:8000/`, if started correctly you should see the Gatsby Development 404 Page:

<details>
<summary>Development 404 Page</summary>

<h1>Gatsby.js development 404 page</h1>

There's not a page yet at /

<button>Preview custom 404 page</button>

Create a React.js component in your site directory at src/pages/index.js and this page will automatically refresh to show the new page component you created.

If you were trying to reach another page, perhaps you can find it below.

<h2>Pages (4)</h2>

Search:

<label>Search:<input type="text" id="search" placeholder="Search pages..." value=""></label><input type="submit" value="Submit">

- `/Blog/`
- `/Home/`
- `/NotFound/`
- `/Post/`

</details>

# Page Setup

From the Development 404 Page we can see that Gatsby has found our previously created pages - this is because Gatsby looks for pages in the `pages` directory, however when we click on a the links we will notice the following:

1. `Home` and `404` render correctly
2. `Blog` results in an error message
3. `Post` results in an error message (we will address this page in the next post)
4. Routes aren't aligned with our initial setup
5. Components no longer have the layout we setup in the `App.js` file

These are, for the most part, easy problems to solve

## Fix the Blog Error Message

If we look at the `Blog` page we will see that there is an issue with the Page render, this is because we need to change the `Link` components to be imported from `gatsby` instead of `react-router-dom` because with Gatsby we are no longer using the React Router

`Blog.js`

```js
import { Link } from "gatsby"
```

## Fix the Routes

We can also see that our routes are capitalized which is not what we want. Gatsby uses the file organization to do routing, so in order to correct our routes to align what we defined previously in our `App.js` we will first need to rename our files:

| Component | Route   | Old Name      | New Name   |
| --------- | ------- | ------------- | ---------- |
| Home      | `/`     | `Home.js`     | `index.js` |
| Blog      | `/blog` | `Blog.js`     | `blog.js`  |
| NotFound  | `/*`    | `NotFound.js` | `404.js`   |

> We're not going to handle the `Post` component for now because this uses a dynamic route which is something I'll cover in the next part of this series

You should stop and restart the Gatsby Dev server with:

```
yarn clean
yarn start
```

When the page loads up we should now see our `Home` content rendered on the `/` route

## Fix the Layout

When we were using the standard React Routing we made use of the `App` component to wrap our page routes as well as our navigation. We'll convert our `App.js` file into a component that we can use in our other pages

1. Remove the `Router` and `Switch`
2. Update the `Link`s to use `gatsby` instead of `react-router-dom`
3. Add the `children` input parameter
4. Render the `children` in the `main` section
5. Remove unused imports

`App.js`

```js
import React from "react"
import "./App.css"
import { Link } from "gatsby"

const App = ({ children }) => (
  <div className="App">
    <header>
      <nav>
        <h1>My Website Title</h1>
        <Link to="/">Home</Link>
        <Link to="/blog">Blog</Link>
      </nav>
    </header>
    <main>{children}</main>
  </div>
)

export default App
```

## Use the Layout

Now that we've essentially created a `Layout` component in the form of the `App` component we can use it to wrap the pages that we've exported. We can do this for the `Home` page like so:

`index.js`

```js
import React from "react"
import App from "../App"

const Home = () => (
  <App>
    <div className="Home">
      <h1>Home</h1>
      <p>This is the Home page</p>
    </div>
  </App>
)

export default Home
```

The same applies for the `blog` and `404` pages

<details>
<summary>Blog</summary>

`blog.js`

```js
import React from "react"
import { Link } from "gatsby"
import App from "../App"

const Blog = () => (
  <App>
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
  </App>
)

export default Blog
```

</details>

<details>
<summary>404</summary>

`404.js`


```js
import React from "react"
import App from "../App"

const NotFound = () => (
  <App>
    <div className="NotFound">
      <h1>404</h1>
      <p>Page Not Found</p>
    </div>
  </App>
)

export default NotFound
```

</details>

## Fix the CSS

Before we can use the `App` component we need to add the `gatsby-plugin-postcss` and `postcss-preset-env` plugins so that Gatsby knows how to interpret the default `create-react-app` method of importing our CSS into a component

Stop the Dev Server and install the required packages:

```
yarn add gatsby-plugin-postcss postcss-preset-env
```

We then need to update the `gatsby-config.js` file to use the plugin we just added:

`gatsby-config.js`

```js
module.exports = {
  plugins: [
    {
      resolve: `gatsby-plugin-postcss`,
      options: {
        postCssPlugins: [require(`postcss-preset-env`)({ stage: 0 })]
      }
    }
  ]
}
```

If you start the application now you'll notice that the font is not correct, this is because we specify the font styles in the `index.css` file. In order to fix this we need to import the `index.css` file into our application, in the default React application this is done via the `src/index.js` file, but since we don't use that to load up the application anymore we need to create another file to do that with Gatsby

In the root directory create a file called `gatsby-browser.js`, in this we just need to import the `index.css` file:

`gatsby-browser.js`

```js
import "./src/index.css"
```

You can now run the following commands and start up the application:

```
yarn clean
yarn start
```

Assuming everything went as planned the application should start up correctly and the styling from our `index.css` file will be correctly applied

# Summary

By now we have completed the first part of the migration process - converting our static pages to use Gatsby - by taking the following steps:

1. Updating our file structure to better align with Gatsby
2. Create the relevant Gatsby config files
3. Update our `Link` usage
4. Update our Routing
5. Use a shared layout component
6. Fixing the CSS to work with Gatsby

In the next part we'll look at how we can go about providing the data needed for our `Post` component using GraphQL and show our posts. We'll also look at how we can pre-process the data that we provide to our component so that we can enhance our content while improving our content creation process

> Nabeel Valley
