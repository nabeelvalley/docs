---
published: true
title: Gatsby
subtitle: Getting Started with Gatsby.js
description: Getting Started with Gatsby.js
---

[[toc]]

# Introduction

Gatsby.js is a Static Site Generator that makes use of React and can plug into a headless CMS to generate a Static Site with SPA support and functionality

> I'm using the [Gatsby.js Tutorial](https://www.gatsbyjs.org/tutorial/) from the documentation

## Prerequisites

- Node.js
- Git
- Gatsby CLI
- Optional: Yarn

To install the Gatsby CLI you can use `npm`:

```
npm i -g gatsby-cli
```

Or if using `yarn`:

```
yarn global add gatsby-cli
```

To view the Gatsby help menu once installed:

```
gatsby --help
```

## Create New Site

To create a new Gatsby.js site run:

```
gatsby new gatsby-hello-world https://github.com/gatsbyjs/gatsby-starter-hello-world
```

Where `gatsby-hello-world` is the name of the new directory for the site and will clone from the Gatsby GtiHub template

Next `cd gatsby-hello-world` and run the following command to start development server you can use the `gatsby-cli`

```
gatsby develop
```

Or `npm`:

```
npm run develop
```

Or

```
yarn develop
```

You should then be able to launch the site on `http://localhost:8000/`

Looking at the initial site you should see the following files:

```
gatsby-hellp-world
│   .gitignore
│   .prettierignore
│   .prettierrc
│   gatsby-config.js
│   LICENSE
│   package.json
│   README.md
│   yarn.lock
│
├───src
│   └───pages
│           index.js
│
└───static
        favicon.ico
```

In the `index.js` file you will see a simple React Component that is exported:

```jsx
import React from "react"

export default () => <div>Hello world!</div>
```

Editing this will live update the page as you edit and save the file, this uses HMR in the background and will update you browse live

## Create a New Page

Gatsby organises pages similar to the way you would if you were using normal HTML instead. Inside of the `pages` directory you can create an `about.js` file with something like:

`pages/about.js`

```jsx
import React from "react"

export default () => <div>About Page</div>
```

And then we can add a link to this from the `home` component using the React `Link` component

`pages/index.js`

```jsx
import React from "react"
import { Link } from "gatsby"

export default () => (
  <div>
    <h1>Hello World</h1>
    <Link to="/about/">About</Link>
  </div>
)
```

Clicking on the `Link` on the `index.js` page will take you to the `about.js` page

## Build the Site

To build the initial site you can just run

```
gatsby build
```

Or

```
npm run build
```

Or

```
yarn build
```

You can then simply deploy the `public` directory using your preferred method

## Adding Styles

To add styles we first need to create a `src/styles/global.css` file, this will contain all the global CSS for our application - we can add some basic content to it to start off

`global.css`

```css
html,
body {
  margin: 0;
  padding: 0;
}

h1 {
  color: lightblue;
}
```

Next in the `src` project root directory create a file called `gatsby-browser.js`, this is one of a few standard files that Gatsby uses. In this file import the `global.css` file we just created with:

`gatsby-browser.js`

```js
import "./src/styles/global.css"
```

After adding this file you will need to restart the Gatsby development server

Now let's create a component called `Container`:

`src/components/container.js`

```js
import React from "react"
import containerStyles from "./container.module.css"

export default ({ children }) => (
  <div className={containerStyles.container}>{children}</div>
)
```

This file imports css file in the same directory called `container.module.css` which is a CSS Module which means that the styles will be scoped to this component. We also use `containerStyles.container` to apply the `.container` class to the main element

`container.module.css`

```css
.container {
  margin: 3rem auto;
  max-width: 600px;
}
```

We can then update the `index.js` page to use this container:

`index.js`

```js
import React from "react"
import { Link } from "gatsby"
import Container from "../components/container"

export default () => (
  <Container>
    <h1>Hello World</h1>
    <Link to="/about/">About</Link>
  </Container>
)
```

## Plugins

Using plugins in Gatsby involves three steps:

1. Installing the plugin. For example we can install the `typography` plugin with:

```
npm install --save gatsby-plugin-typography react-typography typography typography-theme-fairy-gates
```

Or

```
yarn add gatsby-plugin-typography react-typography typography typography-theme-fairy-gates
```

2. Configuring the plugin which is done using the gatsby-config.js` file and a configuration file for the relevant plugin

`gatsby-config.js`

```js
module.exports = {
  plugins: [
    {
      resolve: `gatsby-plugin-typography`,
      options: {
        pathToConfigModule: `src/utils/typography`
      }
    }
  ]
}
```

`src/utils/typography.js`

```js
import Typography from "typography"
import fairyGateTheme from "typography-theme-fairy-gates"

const typography = new Typography(fairyGateTheme)

export const { scale, rhythm, options } = typography
export default typography
```

If you inspect the output HTML now after running `gatsby develop` you should see some styles in the `head` which are as a result of the `typography` plugin, the generated styles will look like:

```html
<style id="typography.js">
  ...;
</style>
```

## Data

The Gatsby Data Layer is a feature of Gatsby that enables you to build sites using a variety of CMSs

For the purpose of Gatsby, Data is anything that lives outside of a React component

Gatsby primarily makes use of GraphQL to load data into components however there are other data sources that can be used as well as custom plugins that can be used or custom written for this purpose

### Common Site Metadata

The place for common site data, such as the site title is the `gatsby-config.js` file, we can put this in the `siteMetadata` object like so:

`gatsby-config.js`

```js
module.exports = {
    siteMetadata: {
        title: 'Site Title from Metadata'
    },
    ...
}
```

We can then query for the data by using the GraphQL query constant that we export on a Page Component which states the `data` required for the page itself

`index.js`

```js
import React from "react"
import { graphql } from "gatsby"
import Container from "../components/container"

export default ({ data }) => (
  <Container>
    <h1>Title: {data.site.siteMetadata.title}</h1>
  </Container>
)

export const query = graphql`
  query {
    site {
      siteMetadata {
        title
      }
    }
  }
`
```

Other components can make use of the `useStaticQuery` hook, we can import it from `gatsby`

Let's add the a simple static query for the `title` in the `container` component

`container.js`

```js
import { useStaticQuery, Link, graphql } from "gatsby"
```

We can then use this in our component

```js
import React from "react"
import { graphql } from "gatsby"
import containerStyles from "./container.module.css"
import { useStaticQuery } from "gatsby"

export default ({ children }) => {
  const data = useStaticQuery(
    graphql`
      query {
        site {
          siteMetadata {
            title
          }
        }
      }
    `
  )

  return (
    <div className={containerStyles.container}>
      <p>{data.site.siteMetadata.title}</p>
      {children}
    </div>
  )
}
```

## Source Plugins

Source plugins are how we pull data into our site, Gatsby comes with a tool called `GraphiQL` which can be accessed at `http://localhost:8000/___graphql` when the development server is running

We can write a query to get the `title` using the `GraphiQL` UI:

```
query TitleQuery {
  site {
    siteMetadata {
      title
    }
  }
}
```

### Filesystem Plugin

We can access data from the File System using the `gatsby-source-filesystem`

```
yarn add gatsby-source-filesystem
```

And then in the `gatsby-config.js` file:

```js
...
  plugins: [
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `src`,
        path: `${__dirname}/src/`,
      },
    },
...
```

If we restart the dev server we should see the `allFile` and `file` in the GraphiQL interface

We can then query for some data from the file system and log it to the console:

```js
import React from "react"
import { graphql } from "gatsby"
import Container from "../components/container"

export default ({ data }) =>
  console.log(data) || (
    <Container>
      <h1>Title: {data.site.siteMetadata.title}</h1>
    </Container>
  )

export const query = graphql`
  query {
    __typename
    allFile {
      edges {
        node {
          relativePath
          prettySize
          extension
          birthTime(fromNow: true)
        }
      }
    }
    site(siteMetadata: { title: {} }) {
      siteMetadata {
        title
      }
    }
  }
`
```

We can then build a simple table with the data:

```js
export default ({ data }) =>
  console.log(data) || (
    <Container>
      <h1>Title: {data.site.siteMetadata.title}</h1>
      <table>
        <thead>
          <tr>
            <th>relativePath</th>
            <th>prettySize</th>
            <th>extension</th>
            <th>birthTime</th>
          </tr>
        </thead>
        <tbody>
          {data.allFile.edges.map(({ node }, index) => (
            <tr key={index}>
              <td>{node.relativePath}</td>
              <td>{node.prettySize}</td>
              <td>{node.extension}</td>
              <td>{node.birthTime}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </Container>
  )
```

### Transformers

Transformers are used by Gatsby to transform the data that is read in, we can use the following transformer to transform markdown

```
yarn add gatsby-transformer-remark
```

`gatsby-config.js`

```js
...
plugins: [
    'gatsby-transformer-remark',
...
```

We can then use the `remark` plugin combined with the GraphQL query to get markdown content from files in our application

```
query AllMarkdownQuery {
  __typename
  allMarkdownRemark {
    edges {
      node {
        fileAbsolutePath
        frontmatter {
          title
          date
        }
        excerpt
        html
      }
    }
  }
}
```

In the above query the result will be the rendered `html` node along with any metadata, for example in the file below:

`src/pages/article-1.md`

```md
---
title: "Sweet Pandas Eating Sweets"
date: "2017-08-10"
---

Pandas are really sweet.

Here's a video of a panda eating sweets.

<iframe width="560" height="315" src="https://www.youtube.com/embed/4n0xNbfJLR8" frameborder="0" allowfullscreen></iframe>
```

We can then use the query from above to create a page that lists all the markdown content we have in the site:

`src/pages/blog.js`

```js
import React from "react"
import { graphql } from "gatsby"
import Container from "../components/container"

export default ({ data }) => {
  console.log(data)
  return (
    <Container>
      <div>
        <h1>Amazing Pandas Eating Things</h1>
        <h4>{data.allMarkdownRemark.totalCount} Posts</h4>
        {data.allMarkdownRemark.edges.map(({ node }) => (
          <div key={node.id}>
            <h3>
              {node.frontmatter.title} <span>— {node.frontmatter.date}</span>
            </h3>
            <p>{node.excerpt}</p>
          </div>
        ))}
      </div>
    </Container>
  )
}

export const query = graphql`
  query {
    allMarkdownRemark {
      totalCount
      edges {
        node {
          id
          frontmatter {
            title
            date(formatString: "DD MMMM, YYYY")
          }
          excerpt
        }
      }
    }
  }
`
```

## Create Pages Programatically

Using Gatsby we can create pages using the data output from a query

### Generate Page Slugs

We can make use of the `onCreateNode` and `createPages` API's that Gatsby exposes. To implement an API we need to export the function in the `gatsby-node.js` file

The `onCreateNode` function is run every time a new node is created or updated

We can add the following into the `gatsby-node.js` file and can see each node that has been created

`gatsby-node.js`

```js
exports.onCreateNode = ({ node }) => {
  console.log(node.internal.type)
}
```

We can then check when a node is the `MarkdownRemark` and use the `gatsby-source-filesystem` plugin to generate a slug for the file

```js
const { createFilePath } = require(`gatsby-source-filesystem`)

exports.onCreateNode = ({ node, getNode }) => {
  if (node.internal.type === `MarkdownRemark`) {
    slug = createFilePath({ node, getNode, basePath: `pages` })
    console.log(slug)
  }
}
```

Using the above, we can update a node with the `createNodeField` function which is part of the `actions` object that's passed into the `onCreateNode` field

```js
const { createFilePath } = require(`gatsby-source-filesystem`)

exports.onCreateNode = ({ node, getNode, actions }) => {
  const { createNodeField } = actions
  if (node.internal.type === `MarkdownRemark`) {
    const slug = createFilePath({ node, getNode, basePath: `pages` })
    createNodeField({
      node,
      name: `slug`,
      value: slug
    })
  }
}
```

We can then run the following query in the GraphiQL editor to see the slugs that were generated

```
query {
  allMarkdownRemark {
    edges {
      node {
        fields {
          slug
        }
      }
    }
  }
}
```

Gatsby uses the `createPages` API from plugins to create pages, we can additionally export the `createPages` function from our `gatsby-node.js` file. To create a page programatically we need to:

1. Query the data

`gatsby-node.js`

```js
...
exports.createPages = async ({ graphql, actions }) => {
  // **Note:** The graphql function call returns a Promise
  // see: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise for more info
  const result = await graphql(`
    query {
      allMarkdownRemark {
        edges {
          node {
            fields {
              slug
            }
          }
        }
      }
    }
  `)
  console.log(JSON.stringify(result, null, 4))
}
```

2. Map the query resilt to a page

We can first update the `createPages` function to set the slug route to resolve to a specific component, in this case the `src/templates/blog-post.js`

```js
const path = require(`path`)

...

exports.createPages = async ({ graphql, actions }) => {
    const { createPage } = actions
    const result = await graphql(`
    query {
      allMarkdownRemark {
        edges {
          node {
            fields {
              slug
            }
          }
        }
      }
    }
  `)
    result.data.allMarkdownRemark.edges.forEach(({ node }) => {
        createPage({
            path: node.fields.slug,
            component: path.resolve(`./src/templates/blog-post.js`),
            context: {
                // Data passed to context is available
                // in page queries as GraphQL variables.
                slug: node.fields.slug,
            },
        })
    })
}
```

We can then create the `src/templates/blog-post.js` file to render the new data:

```js
import React from "react"
import { graphql } from "gatsby"
import Container from "../components/container"

export default ({ data }) => {
  const post = data.markdownRemark
  return (
    <Container>
      <div>
        <h1>{post.frontmatter.title}</h1>
        <div dangerouslySetInnerHTML={{ __html: post.html }} />
      </div>
    </Container>
  )
}

export const query = graphql`
  query($slug: String!) {
    markdownRemark(fields: { slug: { eq: $slug } }) {
      html
      frontmatter {
        title
      }
    }
  }
`
```

You should be able to view any created pages by navigating to a random route on your site which should open the development server's 404 page which has a listing of the available pages

We can then also update the `blog.js` file to query for the slug and create a `Link` to the new page based on the `slug`

`blog.js`

```js
import React from "react"
import { graphql, Link } from "gatsby"
import Container from "../components/container"

export default ({ data }) => {
  console.log(data)
  return (
    <Container>
      <div>
        <h1>Amazing Pandas Eating Things</h1>
        <h4>{data.allMarkdownRemark.totalCount} Posts</h4>
        {data.allMarkdownRemark.edges.map(({ node }) => (
          <div key={node.id}>
            <h3>
              {node.frontmatter.title} <span>— {node.frontmatter.date}</span>
            </h3>
            <p>{node.excerpt}</p>
            <Link to={node.fields.slug}>Read More</Link>
          </div>
        ))}
      </div>
    </Container>
  )
}

export const query = graphql`
  query {
    allMarkdownRemark {
      totalCount
      edges {
        node {
          id
          frontmatter {
            title
            date(formatString: "DD MMMM, YYYY")
          }
          fields {
            slug
          }
          excerpt
        }
      }
    }
  }
`
```
