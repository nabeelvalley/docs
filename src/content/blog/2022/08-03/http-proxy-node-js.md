---
published: true
title: Localhost HTTP Proxy with Node.js
subtitle: 08 March 2022
---

---
published: true
title: Localhost HTTP Proxy with Node.js
subtitle: 08 March 2022
---

An localhost HTTP proxy is useful for debugging and can be easily defined using Node.js by installing `http-proxy`

```sh
yarn add http-proxy
```

And then adding the following to an `index.js` file:

`index.js`

```js
const httpProxy = require('http-proxy')

const target = 'http://my-target-website.com:1234'

httpProxy.createProxyServer({ target }).listen(8080)
```

Which will create a server that listens on `8080` and will proxy requests to the target
