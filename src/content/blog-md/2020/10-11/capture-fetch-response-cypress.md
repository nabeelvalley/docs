---
published: true
title: Capture Fetch with Cypress
subtitle: 10 November 2020
description: Capture and Use Fetch Requests and Responses in Cypress
---

To capture the result of a `fetch` request with Cypress you will need to make use of `cy.route2`

# Setup

The `cy.route2` command needs to be enabled in your `cypress.json` file before usage, to do so add the following:

`cypress.json`

```json
{
  "experimentalNetworkStubbing": true
}
```

# Usage

Next, using the command to capture requests to a route looks a bit like this in a test:

```js
cy.route2('POST', '/do-stuff').as('data')
```

In the above you need to use the `cy.route2` function. In the above we're capturing `POST` requests to the `/do-stuff` endpoint. The object which contains the request and response data is stored in the `@data` which can be retreived and worked with like so:

```js
cy.wait('@data').then((data) => {
  // do stuff using the data object
  console.log(data)
})
```

The `cy.wait` function retreives the `data` object, we use the `.then` function with a callback function to do stuff with the fully resolved `data` object

Furthermore, the HTTP response from the `data` object can be parsed using `JSON.parse`, you can then also add assertions based on the response object. Adding this in, the above code would look more like this:

```js
cy.wait('@data').then((data) => {
  console.log(data)

  // parse the response body
  const res = JSON.parse(data.response.body)

  // assertions on the response
  assert.isTrue(res.success)
  assert.isNotNull(res.message)
})
```
