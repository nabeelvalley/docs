[[toc]]

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
import { NextPage } from "next"
import Header from "./Header"

const Layout = ({ children }) => (
  <>
    <Header></Header>
    {children}
  </>
)

export default Layout

export const withLayout = (Page: NextPage | NextPage<any>) => {
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

# Fetching Page Data

To fetch data we'll use `isomorphic-unfetch` which works on both the browser and on the client side. We need to add this to our application:

```
yarn add isomorphic-unfetch
```

Wherever we need to use this we can simply import it with:

```tsx
import fetch from "isomorphic-unfetch"
```

Next we'll create a basic page which displays the content from the `tvmaze` api so that we have something to render. Update the `Header` component to link to the `tv` page that we will create after

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
    <Link href="/tv">
      <a>TV</a>
    </Link>
  </div>
)

export default Header
```

We can then create a new `pages/tv.tsx` file with the following component:

`tv.tsx`

```tsx
import { NextPage } from "next"
import Layout, { withLayout } from "../components/Layout"
import fetch from "isomorphic-unfetch"

type ShowData = {
  id: string
  name: string
}

type TvResponse = {
  show: ShowData
}[]

type TvData = {
  data: ShowData[]
}

const Tv: NextPage<TvData> = props => {
  return (
    <Layout>
      <h1>TV</h1>
      <ul>
        {props.data?.map(show => (
          <li key={show.id}> {show.name} </li>
        ))}
      </ul>
    </Layout>
  )
}

export default Tv
```

> Note how in the above we make use of the `Layout` component as a normal component instead of the wrapper, this is because the `getInitialProps` function is only called directly from the page component and so this doesn't work if we use the `withLayout` function like we have above

Next, we will need to update our page's `getServerSideProps` function which is an `async` function that `NextPage`s use to fetch data on the server side, this is called by the framework to get the properties for the page when rendering

`tv.tsx`

```tsx
export const getServerSideProps: GetServerSideProps = async () => {
  const res = await fetch("https://api.tvmaze.com/search/shows?q=batman")
  const data = (await res.json()) as TvResponse

  console.log(`Show data fetched. Count: ${data.length}`)

  return {
    props: {
      data: data.map(el => el.show)
    }
  }
}
```

# Styling

For styling components `next.js` has a few different methods to style components, for the moment my preferred way of doing this is using CSS Modules. To create and use a module we need to do the following:

First create a Module for the component's CSS, this is just a normal CSS selector with the `.module.css` extension. This essentially scopes the CSS

`Header.module.css`

```css
.Header a {
  color: red;
}
```

Next, in our `tsx` we need to import the module like so:

`Header.tsx`

```tsx
import styles from "./Header.module.css"
```

Thereafter we can make use of the different classes exposed in our module by assigning the `className` attribute of a component to a a property of the imported `style`

```tsx
const Header = () => <div className={styles.Header}>...</div>
```

If instead of locally scoped styles we would like to use global styles we need to create a `pages/_app.tsx` file and import any stylesheets we need globally into that, the purpose for this all being in a single file is to avoid conflicting global styles

`_app.tsx`

```tsx
import "../styles.css"
import { AppProps } from "next/app"

const MyApp = ({ Component, pageProps }: AppProps) => {
  return <Component {...pageProps} />
}

export default MyApp
```

# API Routes

API Routes are found in the `pages/api` directory. These are simple functions which handle the relevant API Route

For a route without any parameter like the `api/data` route we can have:

`pages/api/data.tsx`

```tsx
import { NextApiRequest, NextApiResponse } from "next"

type Data = {
  name: string
}

export default (req: NextApiRequest, res: NextApiResponse<Data>) => {
  res.status(200).json({ name: "John Doe" })
}
```

Each API Endpoint has a request and response of `NextApiRequest` and `NextApiResponse` respectively

We can then consume this API on the client. To do this instead of using a simple `fetch` we'll use [SWR (Stale while Revalidate)](https://github.com/zeit/swr) which enables us to fetch data much more efficiently than if we were to make a normal HTTP request by using the cache to use temporary data

Install `swr` with:

```
yarn add  swr
```

Next, in our `pages/index.tsx` we need to define a `fetcher` function which will handle the fetching of data from the backend. This can be any asynchronous function which returns the data. We can also just pass in the `fetch` function to make a normal get request and take the response directly

```tsx
const fetcher = async (url: string) => {
  const res = await fetch(url)
  return (await res.json()) as { name: string }
}
```

This will then be used by the `useSWR` hook in our component like so:

```tsx
const { data, error } = useSWR("/api/data", fetcher)

let name = data?.name

if (!data) name = "Loading..."
if (error) name = "Failed to fetch data."
```

Putting this all together in our `index` page we end up with the following

`index.tsx`

```tsx
import { NextPage } from "next"
import Link from "next/link"
import { withLayout } from "../components/Layout"
import useSWR from "swr"

const fetcher = async (url: string) => {
  const res = await fetch(url)
  return (await res.json()) as { name: string }
}

const PostLink = ({ id }) => (
  <li>
    <Link href="/post/[id]" as={`/post/${id}`}>
      <a>{id}</a>
    </Link>
  </li>
)

const Index: NextPage = () => {
  const { data, error } = useSWR("/api/data", fetcher)

  let name = data?.name

  if (!data) name = "Loading..."
  if (error) name = "Failed to fetch data."

  return (
    <>
      <h1>Hello world!</h1>
      <h2>{name}</h2>
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
}

export default withLayout(Index)
```

# Run in Production

To run the application in production you simply need to build it with:

```
yarn build
```

And then start it with:

```
yarn start
```
