# Setup Project

Init an NPM project with Redis and Express:

```sh
mkdir express-redis
cd express-redis
npm init -y

npm install express redis
```

# Create Container

To start a Redis Container run:

```sh
docker run --name node-redis -p 6379:6379 -d redis redis-server --appendonly yes
```

# Test A DB Query

The following code should create a key-value pair on redis, you can add this to a file called `db.js`

`db.js`

```js
const redis = require("redis");
const client = redis.createClient();

client.on("error", function(error) {
  console.error(error);
});

client.set("bob", "i am bob", redis.print);
client.get("bob", redis.print);
```

Or, if you're feeling that the default client is sketchy you can use this with the explicit url:

```js
const client = redis.createClient({
  url: " redis://localhost:6379"
});
```

Either way, you can run this using `node db.js` which should output the creation success

# View the Data from DB

You can login to the redis container via docker, and then from the command line you can log into the db itself with:

```sh
redis-cli
```

And then list all the keys using:

```sh
keys *
```

And we can even get the data from the DB using the `get` command:

```sh
get bob
```

# Create an Express Client

A simple express client which will do key-value creates and lookups can be defined in an `index.js` file:

`index.js`

```js
const express = require('express')
const redis = require("redis");

const port = process.env.PORT || 8080

const app = express()

app.use(express.text())

const client = redis.createClient({
  url: "redis://localhost:6379"
});

client.on("error", function(error) {
  console.error(error);
});

app.get("/", (req, res) => {
  console.log("request at URL")
  res.send("hello nabeeel from port " + port)
})

app.get("/:key", (req, res) => {
  const key = req.params.key
  client.get(key, (error, reply) => {
    if (error) res.send("Error")
    else res.send(reply)
  })
})

app.post("/:key", (req, res) => {
  const key = req.params.key
  const data = req.body
  client.set(key, data, (error, reply) => {
    if (error) res.send("Error")
    else res.send(reply)
  })
})

app.posts

app.listen(port, () => {
  console.log("app is listening on port " + port)
})
```

You can then just run the web server with:

```sh
node index.js
```

# Test the App

And you should then be able to make requests to the application from something like Postman for creating and retreiving a record

## Set

With the server running you can create a new item with:

```htttp
POST localhost:8080/my-test-key

BODY "my test data"

RESPONSE "OK"
```

## Get

You can then get the value using the key with:

```http
GET localhost:8080/my-test-key

RESPONSE "my test data"
```

# Setting Up Compose

> Before moving on please ensure you stop the Redis container we previously started with `docker container stop node-redis`

Since we're using Docker, it would be great to configure our application using a Docker compose file. In the compose file we'll define a `web` and `redis` service and will provide the Redis URL in the environment for our Express app, the service config for `web` is:


```yml
web:
  image: express-app
  build:
    context: .
    dockerfile: ./Dockerfile
  environment:
    NODE_ENV: production
    REDIS_URL: redis://redis:6379
  ports:
    - 8080:8080
```


And for the `redis` service it's pretty much the same as what we provided to the container we started with the command line:

```yml
redis:
  image: redis
  environment:
    # ALLOW_EMPTY_PASSWORD is recommended only for development.
    - ALLOW_EMPTY_PASSWORD=yes
    - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL
  ports:
    - 6379:6379
  volumes:
    - .db:/data
  restart: always
  entrypoint: redis-server --appendonly yes
```

So the overall compose file will now be:

`docker-compose.yml`

```yml  
version: '3.4'

services:
  web:
    image: express-app
    build:
      context: .
      dockerfile: ./Dockerfile
    environment:
      NODE_ENV: production
      REDIS_URL: redis://redis:6379
    ports:
      - 8080:8080

  redis:
    image: redis
    environment:
      # ALLOW_EMPTY_PASSWORD is recommended only for development.
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL
    ports:
      - 6379:6379
    volumes:
      - .db:/data
    restart: always
    entrypoint: redis-server --appendonly yes
```

# Access Redis from Within Network

Now, it should be possible for us to access the redis instance using Service Discovery within the compose network, to do this we'll use the `REDIS_URL` environment variable we defined above which will make a connection to `redis://redis:6379` which will be resolved within the docker network that our application will run in

We can modify our client app by updating the connection to Redis as follows:

`index.js`

```js
const redisUrl = process.env.REDIS_URL

// other stuff

const client = redis.createClient({
  url: redisUrl
});
```

So the final file will now be:

`index.js`

```js

const express = require('express')
const redis = require("redis");

const port = process.env.PORT || 8080
const redisUrl = process.env.REDIS_URL

const app = express()

app.use(express.text())

const client = redis.createClient({
  url: redisUrl
});

client.on("error", function(error) {
  console.error(error);
});

app.get("/", (req, res) => {
  console.log("request at URL")
  res.send("hello nabeeel from port " + port)
})

app.get("/:key", (req, res) => {
  const key = req.params.key
  client.get(key, (error, reply) => {
    if (error) res.send("Error")
    else res.send(reply)
  })
})

app.post("/:key", (req, res) => {
  const key = req.params.key
  const data = req.body
  client.set(key, data, (error, reply) => {
    if (error) res.send("Error")
    else res.send(reply)
  })
})

app.listen(port, () => {
  console.log("app is listening on port " + port)
})
```

And you should be able to run this all with: 

```sh
docker-compose up
```

And this will run Redis as well as your Application, and you are pretty much good to use the application exactly as we did before addding the compose setup and will connect our application to Redis from within the docker network