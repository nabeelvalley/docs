<details>
<summary>Contents</summary>

- [Introduction](#introduction)
- [Setting Up](#setting-up)
- [Gatsby Plugins](#gatsby-plugins)
  - [Reading the File Metadata](#reading-the-file-metadata)
  - [Processing the Files](#processing-the-files)
- [Create Pages](#create-pages)
  - [Setting Up](#setting-up-1)
  - [Create Pages Dynamically](#create-pages-dynamically)
  - [Render the Page Data](#render-the-page-data)
- [Summary](#summary)

</details>

# Introduction

So far we've created the initial react application as with a few routes for our `Home`, `Blog`, and `404` pages. In this post we'll look at how we can set up our `Post` component to render our pages dynamically based on the JSON data we have. We'll also extend this so that we can have some more content in a markdown file that we'll parse and add to our Gatsby data  

1. [Creating the initial React App](../21-01/gatsby-migration-1)
2. [Rendering the "Dumb" pages with Gatsby](../01-02/gatsby-migration-2)
3. **Rendering the "Smart" page with Gatsby** (This post)

# Setting Up

We're going to make our data a little more complex by creating two additional markdown files in our `static/posts` directory to enable us to have more content with each post

Create the following markdown files in the application and align the names with our `post-1.json` and `post-2.json` files:

1. `static/posts/post-1.md`
2. `static/posts/post-2.md`


# Gatsby Plugins

To read the data from our files we're going to do the following:

1. Use the `gatsby-source-filesystem` to read our files into the Gatsby Data Layer
2. Define our own plugin that can read the file content, parse the markdown, and add it into the data layer

## Reading the File Metadata

To read our file data we will need to first install the `gatsby-source-filesystem` plugin. Plugins in Gatsby enable us to ingest or transform data in our application. We then make use of GraphQL to query the data from the relevant component

Install the `gatsby-source-filesystem` plugin with:

```
yarn add gatsby-source-filesystem
```

And then add the plugin configuration to the `gatsby-node.js` file into the `plugins` array:

`gatsby-node.js`

```js
{
    resolve: `gatsby-source-filesystem`,
    options: {
        name: `content`,
        path: `${__dirname}/static/posts`,
    },
}
```

This will read all the data from our `posts` directory into the filesystem. We can now start the application back up with `yarn start` and navigate to `http://localhost:8000/__graphql` in our browser to view the GraphQL data. We should be able to see the GraphiQL interface

From the GraphiQL interface run the following query to see the data from the files in our directory:

```graphql
query PostData {
  allFile {
    nodes {
      name
      extension
      absolutePath
    }
  }
}
```

This should yield the following JSON with our file meta data in it:

```json
{
  "data": {
    "allFile": {
      "nodes": [
        {
          "name": "post-1",
          "extension": "json",
          "absolutePath": "C:/repos/cra-to-gatsby/static/posts/post-1.json"
        },
        {
          "name": "1",
          "extension": "jpg",
          "absolutePath": "C:/repos/cra-to-gatsby/static/posts/1.jpg"
        },
        {
          "name": "post-1",
          "extension": "md",
          "absolutePath": "C:/repos/cra-to-gatsby/static/posts/post-1.md"
        },
        // file 2 data
      ]
    }
  }
}
```

## Processing the Files

Now that we have our metadata for each file in the file system, we're going to create a plugin that will allow us to read the file data and add it the GraphQL data layer

In order to do this, create a `plugins` directory in the root folder. Inside of the plugins directory create a folder and folder for our plugin. 

Create a new folder in the `plugins` directory with another folder called `gatsby-transformer-postdata`

From this directory run the following commands to initialize and link the yarn package:

`plugins/gatsby-transformer-postdata`

```
yarn init -y
yarn link
```

We'll also add the `showdown` package which will allow us to convert the markdown into the HTML so we can render it with our `Post` component

```
yarn add showdown
```

And then create an `gatsby-node.js` file in this directory with the following content:


`/plugins/gatsby-transformer-postdata/gatsby-node.js`

```js
const fs = require('fs')
const crypto = require('crypto')
const showdown = require('showdown')

exports.onCreateNode = async ({ node, getNode, actions }) => {

    const { createNodeField, createNode } = actions

    // we'll process the node data here
}
```

This exposes the `onCreateNode` Gatsby API for our plugin. This is what Gatsby calls when creating nodes and we will be able to hook into this to create new nodes with all the data for each respective post based on the created file nodes

From the `onCreateNode` function we'll do the following to create the new nodes:

1. Check if it is a markdown node
2. Check if the JSON file exists
3. Read file content
4. Parse the metadata into an object
5. Convert the markdown to HTML
6. Get the name of the node
7. Define the data for our node
8. Create the new node using the `createNode` function


`gatsby-transformer-postdata/gatsby-node.js`

```js
const fs = require('fs')
const crypto = require('crypto')
const showdown = require('showdown')

exports.onCreateNode = async ({node, actions, loadNodeContent}) => {

    const { createNodeField, createNode } = actions
    
    // 1. Check if it is a markdown node
    if (node.internal.mediaType == 'text/markdown') {   

        const jsonFilePath = `${node.absolutePath.slice(0, -3)}.json`

        console.log(jsonFilePath)
        
        // 2. Check if the JSON file exists
        if (fs.existsSync(jsonFilePath)) {
            
            // 3. Read file content
            const markdownFilePath = node.absolutePath
            const markdownContent = fs.readFileSync(markdownFilePath, 'utf8')
            const jsonContent = fs.readFileSync(jsonFilePath, 'utf8')

            // 4. Parse the metadata into an object
            const metaData = JSON.parse(jsonContent)

            // 5. Convert the markdown to HTML
            const converter = new showdown.Converter()
            const html = converter.makeHtml(markdownContent)
            
            // 6. Get the name of the node
            const name = node.name
            
            // 7. Define the data for our node
            const nodeData = {
                name,
                html,
                metaData,
                slug: `/blog/${name}`
            }

            // 8. Create the new node using the `createNode` function
            const newNode = {
                // Node data
                ...nodeData,

                // Required fields.
                id: `RenderedMarkdownPost-${name}`,
                children: [],
                internal: {
                    type: `RenderedMarkdownPost`,
                    contentDigest: crypto
                        .createHash(`md5`)
                        .update(JSON.stringify(nodeData))
                        .digest(`hex`),
                }
            }

            createNode(newNode)
        }
    }
}
```

From the root directory you can clean and rerun the application:

```
yarn clean
yarn start
```

Now, reload the GraphiQL at `http://localhost:8000/__graphql` and run the following query to extract the data we just pushed into the node:

```graphql
query AllPostData {
  allRenderedMarkdownPost {
    nodes {
      html
      name
      slug
      metaData {
        body
        image
        title
      }
    }
  }
}
```

This should give us the relevant post data:

```json
{
  "data": {
    "allRenderedMarkdownPost": {
      "nodes": [
        {
          "html": "<p>Hello here is some content for Post 1</p>\n<ol>\n<li>Hello</li>\n<li>World</li>\n</ol>",
          "name": "post-1",
          "slug": "/blog/post-1",
          "metaData": {
            "body": "Hello world, how are you",
            "image": "/posts/1.jpg",
            "title": "Post 1"
          }
        },
        {
          "html": "<p>Hello here is some content for Post 2</p>\n<ol>\n<li>Hello</li>\n<li>World</li>\n</ol>",
          "name": "post-2",
          "slug": "/blog/post-2",
          "metaData": {
            "body": "Hello world, I am fine",
            "image": "/posts/2.jpg",
            "title": "Post 2"
          }
        }
      ]
    }
  }
}
```

# Create Pages

Now that we've got all our data for the pages in one place we can use the `onCreatePages` API to create our posts, and the `Post` component to render the pages

## Setting Up

Before we really do anything we need to rename the `Blog.js` file to `blog.js` as well as create the `src/components` directory and move the `Post.js` file into it, you may need to restart your application again using `yarn start`

## Create Pages Dynamically 

In our site root create a `gatsby-node.js` file which exposes an `onCreatePages` function:

`gatsby-node.js`

```js
const path = require('path')

exports.createPages = async ({ graphql, actions }) => {
    const { createPage } = actions
    
}
```

From this function we need to do the following:

1. Query for the PostData using the `graphql` function
2. Create a page for each `renderedMarkdownPost`

`gatsby-node.js`

```js
const path = require('path')

exports.createPages = async ({ graphql, actions }) => {
    
    const { createPage } = actions

    // 1. Query for the PostData using the `graphql` function
    const result = await graphql(`
    query AllPostData {
        allRenderedMarkdownPost {
          nodes {
            html
            name
            slug
            metaData {
              body
              image
              title
            }
          }
        }
      }
  `)

    result.data.allRenderedMarkdownPost.nodes.forEach(node => {
        // 2. Create a page for each `renderedMarkdownPost`
        createPage({
            path: node.slug,
            component: path.resolve(`./src/components/Post.js`),
            context: node,
        })
    })
}
```

## Render the Page Data

From the Post component we need to:

1. Export the `query` for the data
2. Get the data for the Post
3. Render the data

`components/post.js`

```js
import { graphql } from 'gatsby'
import App from '../App'

const Post = ({ data }) => {

    // 2. Get the data for the Post
    const postData = data.renderedMarkdownPost

    // 3. Render the data
    return <App>
        <div className="Post">
            <p>This is the <code>{postData.slug}</code> page</p>
            <h1>{postData.metaData.title}</h1>
            <div className="markdown" dangerouslySetInnerHTML={{ __html: postData.html }}></div>
        </div>
    </App>
}

export default Post

// 1. Export the `query` for the data
export const query = graphql`
query PostData($slug: String!) {
    renderedMarkdownPost(slug: {eq: $slug}) {
      html
      name
      slug
      metaData {
        body
        image
        title
      }
    }
  }
`
```

From the `Post` component above we use the `slug` to determine which page to render, we also set the HTML content for the `markdown` element above using the HTML we generated. We also now have our pages dynamically created based on the data in our `static` directory

You can also see that we have significantly reduced the complexity in the `Post` component now that we don't need to handle the data fetching from the component

If you look at the site now you should be able to navigate through all the pages as you'd expect to be able to


# Summary

By now we have completed the the entire migration process - converting our static and dynamic pages to use Gatsby. In order to bring the dynamic page generation functionality to our site we've done the following:

1. Used the `gatsby-source-filesystem` plugin to read our file data
2. Created a local plugin to get the data for each post and convert the markdown to HTML
3. Use the `onCreatePages` API to dynamically create pages based on the post data
4. Update the `Post` component to render from the data supplied by the `graphql` query

And that's about it, through this series we've covered most of the basics on building a Gatsby site and handling a few scenarios for processing data using plugins and rendering content using Gatsby's available APIs

> Nabeel Valley

