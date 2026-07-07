---
published: true
title: CORS with Express
---

There are two parts to making a response, the request and the response

We need to handle `CORS` on each end

## Browser

In the browser, we can make cross-origin requests using `fetch` with `mode:no-cors` which will make an opaque response which has some limitations

```js
var res = await fetch('https://my-other-url.com/hello-world', {
  mode: 'use-cors',
})
console.log(res) //  {type: "opaque", url: "", redirected: false, status: 0, ok: false, …}
```

Now, sure that's great and all when using a 3rd party API, however as mentioned there are limitations to the response object that is received. We can compare this to a API that has CORS enabled

```js
var res = await fetch('https://my-other-url.com/hello-world')
console.log(res) // {type: "basic", url: "https://my-other-url.com/hello-world/", redirected: false, status: 200, ok: true, …}
```

Note that this response has a lot more data included

## Node.js

When using `express` we simply need to set the response header to enable CORS. We can do this using a simple middlewear, in this case a simple function which takes in an array of origins (or even a single origin) and returns a `cors` middlewear function

`cors.js`

```js
const useCors = (origins = '*') => {
  const cors = (req, res, next) => {
    res.set('Access-Control-Allow-Origin', origins)
    next()
  }

  return cors
}

module.exports = useCors
```

In our main express file we can use this in one of two ways

We can either choose to allow all origins by default `*`

`server.js`

```js
const express = require('express')
const app = express()

const cors = require('./cors.js')

app.use(cors())

// ... normal express stuff
```

Or only allow specific origins:

```js
const express = require('express')
const app = express()

const cors = require('./cors.js')

app.use(cors(['*.my-website.com', '*.glitch.com']))

// ... normal express stuff
```
