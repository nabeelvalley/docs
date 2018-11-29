# Basic Modules

## Installing Prerequisites

### Installing NodeJs

Install the necessary version of [Node](https://nodejs.org/en/download/) Node v8+ and NPM v5+

Confirm that node is installed

```text
node -v
npm -v
```

Also installing a node server globally

```text
npm i -g node-static
```

### Installing MongoDb

Install Mongo from the [Download page](https://www.mongodb.com/download-center)

Confirm that MongoDb is installed

```text
mongod --version
```

## How start a Node REPL environment

Can run standard javascript with

```text
node
```

Alternatively, we can use eval with

```text
node -e "<javascript code>"
```

To run a node script we use

```text
node file.js
```

This can be an absolute or releative path to the file

## NodeJs Globals

We are providded with some additional objects and keywords on top of javascript

* `global`
* `process`
* `module.exports` or `exports`

## Global

Any first level `global` property is available without the keywords Some poperties of the global object are as follows:

* `process`
* `require`
* `module`
* `console`
* `__dirname`
* `__filename`

## Processes

Every Node.js script is a process

We can interact with the process by:

* `env` Enviromnent variables
* `argv` Command-line arguments
* `exit()` Terminate the current process

### Process exit codes can be specified

```javascript
// process failed
process.exit(1);

// process exited successfully
process.exit(0);

// process failed with custom exit code 
process.exit(code)
```

## Import and Export Modules

### module.exports

Global property to allow a script to export something for other modules to use

```javascript
module.exports = function(numbersToSum) {
  let sum = 0, 
    i = 0, 
    l = numbersToSum.length;
    while (i < l) {
        sum += numbersToSum[i++]
    }
    return sum
}
```

### require

require\(\) is a path to a file, or a name. This will import the necessary files that we need to read. JSON files can be imported directly as an object.

```javascript
const sum = require('./utility.js')
```

require can be used to import many types of modules as such:

```javascript
const filesystem = require('fs') // core module
const express = require('express') // npm module
const server = require('./boot/server.js') // server.js file with a relative path down the tree
const server = require('../boot/server.js') // server.js file with a relative path up the tree
const server = require('/var/www/app/boot/server.js') // server.js file with an absolute path 
const server = require('./boot/server') // file if there's the server.js file
const routes = require('../routes') // index.js inside routes folder if there's no routes.js file
const databaseConfigs = require('./configs/database.json') // JSON file
```

## Core Modules

Node has a lot of preinstalled modules, the main ones are as follows:

* fs: module to work with the file system, files and folders
* path: module to parse file system paths across platforms
* querystring: module to parse query string data
* net: module to work with networking for various protocols
* stream: module to work with data streams
* events: module to implement event emitters \(Node observer pattern\)
* child\_process: module to spawn external processes
* os: module to access OS-level information including platform, number of CPUs, memory, uptime, etc.
* url: module to parse URLs
* http: module to make requests \(client\) and accept requests \(server\)
* https: module to do the same as http only for HTTPS
* util: various utilities including promosify which turns any standard Node core method into a promise-base API
* assert: module to perform assertion based testing
* crypto: module to encrypt and hash information

### fs

Handles file system operations

* fs.readFile\(\) reads files asynchronously
* fs.readFileSync\(\) reads files synchronously
* fs.writeFile\(\) writes files asynchronously
* fs.writeFileSync\(\) writes files synchronously

### Reading a File

```javascript
const fs = require('fs')
const path = require('path')
fs.readFile(path.join(__dirname, '/data/customers.csv'), {encoding: 'utf-8'}, function (error, data) {
  if (error) return console.error(error)
  console.log(data)
})
```

### Writing to a file

```javascript
const fs = require('fs')
fs.writeFile('message.txt', 'Hello World!', function (error) {
  if (error) return console.error(error)
  console.log('Writing is done.')
})
```

### path

Can join a path relativley as:

```javascript
const path = require('path')
const server = require(path.join('app', 'server.js'))
```

Or absoltely as:

```javascript
const path = require('path')
const server = require(path.join(__dirname, 'app', 'server.js'))
```

## Event emitters

We can create an EventEmitter with `events` and using this we can create, listen and trigger events

### Single trigger

```javascript
const EventEmitter = require('events')

class Job extends EventEmitter {}
job = new Job()

job.on('done', function(timeDone){
  console.log('Job was pronounced done at', timeDone)
})

job.emit('done', new Date())
job.removeAllListeners()  // remove  all observers
```

Output `Job was pronounced done at ____________`

### Mutiple triggers

```javascript
const EventEmitter = require('events')

class Emitter extends EventEmitter {}
emitter = new Emitter()

emitter.on('knock', function() {
  console.log('Who's there?')
})

emitter.on('knock', function() {
  console.log('Go away!')
})

emitter.emit('knock')
emitter.emit('knock')
```

Output

```text
Who's there?
Go away!
Who's there?
Go away!
```

### Single Execution of Handler

```javascript
const EventEmitter = require('events')

class Emitter extends EventEmitter {}
emitter = new Emitter()

emitter.once('knock', function() {
  console.log('Who's there?')
})


emitter.emit('knock')
emitter.emit('knock')
```

Output `Who's there?`

## Modular events

We can use the observer pattern to modularize code. This allows us to customize modular behaviour without modifying the module.

`jobs.js`

```javascript
const EventEmitter = require('events')
class Job extends EventEmitter {
  constructor(ops) {
    super(ops)
    this.on('start', ()=>{
      this.process()
    })
  }
  process() {
     setTimeout(()=>{
      // Emulate the delay of the job - async!
      this.emit('done', { completedOn: new Date() })
    }, 700)
  }
}

module.exports = Job
```

`main.js`

```javascript
var Job = require('./job.js')
var job = new Job()

job.on('done', function(details){
  console.log('Weekly email job was completed at',
    details.completedOn)
})

job.emit('start')
```

## HTTP Client

### Get

#### Request and Response

Making an HTTP Request using http from NodeJs Core. Will receive data in chunks as follows `http-get-no-buff`

```javascript
const http = require('http')
const url = 'http://nodeprogram.com'
http.get(url, (response) => {
  response.on('data', (chunk) => { 
    console.log(chunk.toString('utf8'))
  })
  response.on('end', () => {
    console.log('response has ended')
  })
}).on('error', (error) => {
  console.error(`Got error: ${error.message}`)
})
```

Alternatively, the data can be aded to a buffer until the response is complete as below `http-get.js`

```javascript
const http = require('http')
const url = 'http://nodeprogram.com'
http.get(url, (response) => {
  let rawData = ''
  response.on('data', (chunk) => { 
    rawData += chunk
  })
  response.on('end', () => {
    console.log(rawData)
  })
}).on('error', (error) => {
  console.error(`Got error: ${error.message}`)
})
```

#### Processing JSON

In order to get JSON the full response is needed, after which we parse the json to a response object

`http-json-get.js`

```javascript
const https = require('https')
const url = 'https://gist.githubusercontent.com/azat-co/a3b93807d89fd5f98ba7829f0557e266/raw/43adc16c256ec52264c2d0bc0251369faf02a3e2/gistfile1.txt'
https.get(url, (response) => {
  let rawData = ''
  response.on('data', (chunk) => { 
    rawData += chunk 
  })
  response.on('end', () => {
    try {
      const parsedData = JSON.parse(rawData)
      console.log(parsedData)
    } catch (e) {
      console.error(e.message)
    }
  })
}).on('error', (error) => {
  console.error(`Got error: ${error.message}`)
})
```

### Post

To do a post we require a little but more information to be configured as such:

`http-post.js`

```javascript
const http = require('http')
const postData = JSON.stringify({ foo: 'bar' })

const options = {
  hostname: 'mockbin.com',
  port: 80,
  path: '/request?foo=bar&foo=baz',
  method: 'POST',
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Content-Length': Buffer.byteLength(postData)
  }
}

const req = http.request(options, (res) => {
  res.on('data', (chunk) => {
    console.log(`BODY: ${chunk}`)
  })
  res.on('end', () => {
    console.log('No more data in response.')
  })
})

req.on('error', (e) => {
  console.error(`problem with request: ${e.message}`)
})

req.write(postData)
req.end()
```

## HTTP Server

We can use `node http-server.js` to run the server, we can also use `node-dev` to run the server and refresh on filechange.

`http-server.js`

```javascript
const http = require('http')
const port = 3000
http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'})
  res.end('Hello World\n')
}).listen(port)

console.log(`Server running at http://localhost:${port}/`)
```

`http.createServer` creates a server with a callback function which contains a response handler code

`res.writeHead(200, {'Content-Type': 'text/plain'})` sets the right status code and headers

`res.end()` event handler for when response is complete

`listen()` specifies the port on which the server is listening

## Processing a request

We can process an incoming request by reading the request properties with the following:

`httP-server-request-processing.js`

```text
const http = require('http')
const port = 3000
http.createServer((request, response) => {
  console.log(request.headers)
  console.log(request.method)
  console.log(request.statusCode)
  console.log(request.url)
  if (request.method == 'POST') {
    let buff = ''
    request.on('data', function (chunk) {
      buff += chunk  
    })
    request.on('end', function () {
      console.log(`Body: ${buff}`)
      response.end('\nAccepted body\n')
    })
  } else {
    response.writeHead(200, {'Content-Type': 'text/plain'})
    response.end('Hello World\n')
  } 
}).listen(port)
```

