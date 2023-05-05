[[toc]]

In a new file, define the middleware using the following:

```js
const authenticate = (req, res, next) => {
  const auth = {login: process.env.BASIC_UN, password: process.env.BASIC_PW} 
  
  const b64auth = (req.headers.authorization || '').split(' ')[1] || ''
  const [login, password] = new Buffer(b64auth, 'base64').toString().split(':')

  // Verify login and password are set and correct
  if (login && password && login === auth.login && password === auth.password) {
    // Access granted...
    return next()
  } else {
    res.status(401).send('Authentication required.') // custom message    
  }
}

module.exports = authenticate
```

The middleware can then be used in an Express Endpoint or for all endponits using either:


1. For all endpoints

```js
const auth = require('./authorize.js')

app.use(auth)
```

2.  For a specific endpoint

```js
const auth = require('./authorize.js')

app.get('/secret-stuff', auth, secretStuffHandler)
```
