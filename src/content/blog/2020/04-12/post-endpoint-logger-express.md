---
published: true
title: Debug POSTs using an Express App
subtitle: 04 December 2020
description: Create an express.js app with an endpoint that logs and returns a request's JSON body
---

---
published: true
title: Debug POSTs using an Express App
subtitle: 04 December 2020
description: Create an express.js app with an endpoint that logs and returns a request's JSON body
---

Sometimes it's useful to have an endpoint that you can use to debug data that's being `POST`ed to an application

You can make use of the following `express.js` app to log your application's POST requests:

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/Express-POST-Logger?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

<details>
<summary>View Code</summary>

```js
const express = require('express')
const app = express()

// parse json
app.use(express.json())

// GET endpoint to check uptime
app.get('/', (req, res) => {
  res.json({ data: 'hello' })
})

// POST endpointthat logs request body
app.post('/', (req, res) => {
  console.log(req.body)
  res.json(req.body)
})

// listen for requests
const listener = app.listen(process.env.PORT, () => {
  console.log('listening on port ' + listener.address().port)
})
```

<detail>
