# Introduction

Next.js is framework for building single page applications using React, Next.js allows us to use a combination of SSR and Prerendering to build our applications based on the data requirements

> Notes from [Next.js Documentation](https://nextjs.org/learn/basics/getting-started). This is slightly different to the documentation because I am using a Typescript setup

# Setting Up

To set up a new Next.js application we will need install the relevant dependencies

```
mkdir web
cd web
yarn init -y
yarn add react react-dom next typescript @types/react @types/node
```

Then, add the following to your `package.json` file:

```json
"scripts": {
  "dev": "next",
  "build": "next build",
  "start": "next start"
}
```

Now, we can create the `pages/index.tsx` with the following function component:

`pages/index.tsx`

```tsx
import { NextPage } from "next"

const Index: NextPage = () => <h1>Hello world!</h1>

export default Index
```

And then run `yarn dev` to start the Dev server. You should be able the index page on `http://localhost:3000`

# Linking Pages

We can first create a new page `about.tsx` in the `pages` directory:

`about.tsx`

```tsx
import { NextPage } from "next"

const About: NextPage = () => <h1>About</h1>

export default About
```

We can then create a link from our `index` page to link to this using the `next/link` component. Modify the `index` page to do this like so:

`index.tsx`

```tsx
import { NextPage } from "next"
import Link from "next/link"

const Index: NextPage = () => (
  <>
    <h1>Hello world!</h1>
    <p>
      <Link href="/about">
        <a>About</a>
      </Link>
    </p>
  </>
)
export default Index
```

The `Link` is a wrapper component which only accepts an `href`, any other attributes needed for our link need to be included in the `a` component

# Shared Components

Like you would expect from when we use React on its own we can create shared components. Components are created in the `components` directory. We'll create a header and layout component and implement this on our pages

`Header.tsx`

```tsx
import Link from "next/link"
import { NextPage } from "next"

const Header = () => (
  <div>
    <Link href="/">
      <a>Home</a>
    </Link>
    <Link href="/about">
      <a>About</a>
    </Link>
  </div>
)

export default Header
```

We can then create a `Layout` component which works as a higher order component (HOC) to render the overall page layout given a Page Component:

`Layout.tsx`

```tsx
import Link from "next/link"
import { NextPage } from "next"
import Header from "./Header"

const Layout = ({ children }) => (
  <>
    <Header></Header>
    {children}
  </>
)

export default Header

export const withLayout = (Page: NextPage) => {
  return () => (
    <Layout>
      <Page />
    </Layout>
  )
}
```

We can then implement the `withLayout` function when exporting out relevant page components:

`index.tsx`

```tsx
export default withLayout(Index)
```

`about.tsx`

```tsx
export default withLayout(About)
```

# Dynamic Pages

## Query Params

We can create dynamic pages based on the data from the URL Query parameters a user has when visiting the page. We can update the `index` page to have a list of posts that we will link to:

`index.tsx`

```tsx
import { NextPage } from "next"
import Link from "next/link"
import { withLayout } from "../components/Layout"

const PostLink = ({ title }) => (
  <li>
    <Link href={`/post?title=${title}`}>
      <a>{title}</a>
    </Link>
  </li>
)

const Index: NextPage = () => (
  <>
    <h1>Hello world!</h1>
    <p>
      <Link href="/about">
        <a>About</a>
      </Link>
    </p>
    <ol>
      <PostLink title="First Post"></PostLink>
      <PostLink title="Second Post"></PostLink>
      <PostLink title="Third Post"></PostLink>
    </ol>
  </>
)

export default withLayout(Index)
```

We can then make use of the `useRouter` hook to retrieve this from a `post` page like so:

`post.tsx`

```tsx
import { NextPage } from "next"
import { useRouter } from "next/router"
import { withLayout } from "../components/Layout"

const Post: NextPage = () => {
  const router = useRouter()

  return <h1>Post: {router.query.title}</h1>
}
export default withLayout(Post)
```

## Route Params

Usually we may want to link to specific pages on our site and the above method of using query params for everything is not ideal, we can also set up dynamic urls such that a post's url will be something like `/post/post_id` for example. Next.js allows us to build our routes using our folder structure as well as a special syntax for the filenames. For example a page like above may be in file like `pages/post/[id].tsx`

We can update our `index` page to make use of this routing strategy by updating the `PostLink` to use an `id`:

`index.tsx`

```tsx
import { NextPage } from "next"
import Link from "next/link"
import { withLayout } from "../components/Layout"

const PostLink = ({ id }) => (
  <li>
    <Link href="/post/[id]" as={`/post/${id}`}>
      <a>{id}</a>
    </Link>
  </li>
)

const Index: NextPage = () => (
  <>
    <h1>Hello world!</h1>
    <p>
      <Link href="/about">
        <a>About</a>
      </Link>
    </p>
    <ol>
      <PostLink id="First-Post"></PostLink>
      <PostLink id="Second-Post"></PostLink>
      <PostLink id="Third-Post"></PostLink>
    </ol>
  </>
)

export default withLayout(Index)
```

The `href` is the link to the page as per our component setup, and the `as` is the url to show in the browser

`post/[id].tsx`

```tsx
import { NextPage } from "next"
import { useRouter } from "next/router"
import { withLayout } from "../../components/Layout"

const Post: NextPage = () => {
  const router = useRouter()

  return <h1>Post: {router.query.id}</h1>
}
export default withLayout(Post)
```

> Note how this is almost exactly like in the previous case where we used the query parameter to populate our page but now we use the `id`
