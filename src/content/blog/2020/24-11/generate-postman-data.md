---
published: true
title: Generate data for a Postman request
subtitle: 24 November 2020
description: Using Pre-Request Scripts and Environment variables to generate data in Postman
---

[[toc]]

When making requests with Postman to test an API it is often useful to have generated data, for example when creating users in a backend system you may want the ability to get custom user data

The method we will use to do this is by setting Postman environment variables in the Pre-request Script of a Postman request

Firstly, we can write some basic logging in the Pre-request script section on Postman and view the result in the Postman console:

```js
const name = "Nabeel"

console.log(`Hello ${name}`)
```

Additionally, postman gives us some functions to set and get environment variables, so we can set the name as an environment variable like so:

```js
const name = "Nabeel"

pm.environment.set('name', name)
```

And log it like so:

```js
console.log(pm.environment.get('name'))
```

Aditionally, we can make HTTP Requests using `pm.sendRequest` which then takes a callback for what we want to do after the request, we can use the `randomuser` api to get a user:

```js
pm.sendRequest('https://randomuser.me/api/', (err, res) => {
  const apiResponse = res.json()

  // do more stuff
})
```

Using this method, we can get some random user data and set it in the environment variables as follows:

```js
pm.sendRequest('https://randomuser.me/api/', (err, res) => {
  const apiResponse = res.json()

  const user = apiResponse.results[0]
  
  const email = user.email
  const firstName = user.name.first
  const lastName = user.name.last

  pm.environment.set('email', email)
  pm.environment.set('firstName', firstName)
  pm.environment.set('lastName', lastName)
})
```

We can then use this in our request body using Postman's `{\{}\}` syntax. If we were making a JSON request, our body would look something like this:


`POST: https://my-api.com/users`

```json
{
  "email": "{{email}}",
  "firstName": "{{firstName}}",
  "lastName": "{{lastName}}"
}
```

Postman will then populate the slots from the environment variables that we set automatically when making the request