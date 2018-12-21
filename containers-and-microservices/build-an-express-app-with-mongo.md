# Build an Express Application that uses MongoDB

Built with tons of help from:

-   [Getting started with Node and Mongo DB](https://closebrace.com/tutorials/2017-03-02/the-dead-simple-step-by-step-guide-for-front-end-developers-to-getting-up-and-running-with-nodejs-express-and-mongodb)
-   [Dockerise a Node-Mongo App](https://medium.com/statuscode/dockerising-a-node-js-and-mongodb-app-d22047e2806f)

## Contents

- [Build an Express Application that uses MongoDB](#build-an-express-application-that-uses-mongodb)
  - [Contents](#contents)
  - [Setting up Mongo](#setting-up-mongo)
    - [Adding Mongo to your PATH](#adding-mongo-to-your-path)
    - [Create a Data Directory](#create-a-data-directory)
    - [Running the DB Server](#running-the-db-server)
    - [Creating and Viewing Elements](#creating-and-viewing-elements)
    - [Connect to a Database](#connect-to-a-database)
    - [Insert Data](#insert-data)
    - [View Data](#view-data)
  - [Building the Express App](#building-the-express-app)
    - [Importing the Necessary Libraries](#importing-the-necessary-libraries)
    - [Configure the Database](#configure-the-database)
    - [Middleware](#middleware)
    - [View Comments](#view-comments)
    - [Creeate Comment](#creeate-comment)
  - [Deploy on k8s](#deploy-on-k8s)
    - [Building the Image](#building-the-image)
    - [Deploying on Kubernetes](#deploying-on-kubernetes)
  - [Running Locally](#running-locally)


## Setting up Mongo

### Adding Mongo to your PATH

If you have just downloaded and installed MongoDB, it may not be defined as a system variable in your PATH, you can do that finding the Mongo installation directory and adding this as a system environment variable, the directory should be like the following for Windows

```
C:\Program Files\MongoDB\Server\4.0\bin\
```

This will give us access to both `mongo` and `monod` commands

### Create a Data Directory

Next we will need a place to store our data, we can create this directory anywhere we want, in this case I'll make it inside of my app directory

```powershell
mkdir mongodata
cd mongodata

mkdir data
```

### Running the DB Server

Next we can run our database server with the following command inside of our `mongo` directory that we just created

```powershell
mongod --dbpath .\data\
```

If we see an output with

```
...
2018-12-21T09:01:21.883+0200 I NETWORK  [initandlisten] waiting for connections on port 27017
2018-12-21T09:01:21.928+0200 I INDEX    [LogicalSessionCacheRefresh] build index on: config.system.sessions properties: { v: 2, key: { lastUse: 1 }, name: "lsidTTLIndex", ns: "config.system.sessions", expireAfterSeconds: 1800 }
2018-12-21T09:01:21.928+0200 I INDEX    [LogicalSessionCacheRefresh]     building index using bulk method; build may temporarily use up to 500 megabytes of RAM
2018-12-21T09:01:21.936+0200 I INDEX    [LogicalSessionCacheRefresh] build index done.  scanned 0 total records. 0 secs
```

We know that the server is running

### Creating and Viewing Elements

In a new terminal window we open the Mongo Shell with

```powershell
mongo
```

### Connect to a Database

Next we need to connect to our database to access data, we can do this from the Mongo Shell with

```powershell
use mongodata
```

If successful we will see the output

```powershell
switched to db mongodata
```

### Insert Data

Next we can try to insert an element with the following

```powershell
db.comments.insert({"name":"myuser", "comment":"Hell World!"})
```

Mongo uses BSON (basically JSON with some sprinkles) for data storage

We can also insert data as follows

```powershell
newstuff = [{"name":"Nabeel Valley","comment":"Hello Nabeel. Weather good today"},{"name":"Kefentse Mathibe","comment":"I'm OK!"}]
db.comments.insert(newstuff)
```

### View Data

We can view our inserted data with

```powershell
db.comments.find().pretty()
```

Which will output the following

```powershell
{
        "_id" : ObjectId("5c1c93222712ad7e454a01a2"),
        "username" : "myuser",
        "email" : "me@email.com"
}
{ "_id" : ObjectId("5c1c94562712ad7e454a01a3"), "name" : "nabeel" }
{
        "_id" : ObjectId("5c1c94562712ad7e454a01a4"),
        "email" : "unknown@email.com",
        "age" : 7
}
```

## Building the Express App

This can all be found in the `server.js` file

The Express app will do a few things:

-   Serve the necessary static files for the app
-   Get and Insert data into Mongo
-   Build and send the Mongo content to the frontend

### Importing the Necessary Libraries

I'm making use of the following libraries to

-   Read environmental variables
-   Create my server
-   Parse JSON body from the create form

```js
require('dotenv').config()

// configure express
const express = require('express')
const app = express()
const port = process.env.PORT || 8080
const bodyParser = require('body-parser')
```

### Configure the Database

I'm using monk to easily interface with our database

```js
const mongo = require('mongodb')
const mongo = require('mongodb')
const monk = require('monk')
const mongoEndpoint = process.env.MONGO_ENDPOINT || 'mongo:27017/mongodata'
const db = monk(mongoEndpoint)
```

I've used the default value of `mongo:27017` for when the application is run in k8s in order to interface with a mongo instance more easily. If running locally we can set the `MONGO_ENDPOINT` in a `.env` file in the project root directory as follows

```
MONGO_ENDPOINT=localhost:27017
```

### Middleware

Configure express middleware for the following

-   Use static files
-   Parse JSON and Form data from request
-   Make DB accessible to the app

```js
app.use(bodyParser.json())
app.use(bodyParser.urlencoded())
app.use(express.static('public'))

app.use((req, res, next) => {
    req.db = db
    next()
})
```

### View Comments

Next I define a `/comments` that will retrieve content from the `comments` collection, render it with the `base.card` and `base.content` functions and send that as a response

```js
app.get('/comments', function(req, res) {
    let db = req.db
    let collection = db.get('comments')
    collection.find({}, {}, function(e, docs) {
        const base = require('./base')

        let content = ''
        docs.reverse().forEach(comment => {
            content += base.card(comment.name, comment.comment, comment._id)
        })
        content = base.content(content)

        res.send(content)
    })
})
```

### Creeate Comment

To create a comment I've used a simple form in the frontend, which can be seen below

```html
<form action="/submit" method="post">
    <div class="form-row">
        <div class="col-lg-12 mb-3">
            <label for="nameInput">Full Name</label>
            <input
                type="text"
                class="form-control"
                id="nameInput"
                placeholder="John Doe"
                value=""
                required
                name="name"
            />
        </div>
        <div class="col-lg-12 mb-3">
            <label for="commentInput">Comment</label>
            <input
                type="text"
                class="form-control"
                id="commentInput"
                placeholder=""
                value=""
                required
                name="comment"
            />
        </div>
    </div>
    <button class="btn btn-primary" type="submit">Submit form</button>
</form>
```

And an express route to handle the post and insert the new comment to the database

```js
app.post('/submit', (req, res) => {
    // Set our internal DB variable
    let db = req.db

    // Set our collection
    let collection = db.get('comments')

    // Submit to the DB
    collection.insert(req.body, function(err, doc) {
        if (err) {
            // If it failed, return error
            const base = require('./base')
            const content = base.content(
                '<h1>There was an error sending your content, please try again<h2>'
            )
            res.send(content)
        } else {
            // get id of inserted element
            console.log(doc._id)
            // And forward to success page
            res.redirect(`comments`)
            // res.redirect(`comments/${doc._id}`)
        }
    })
})
```

## Deploy on k8s

Once we are done we can push this as a Docker image and deploy it on a Kubernetes Cluster as follows

### Building the Image

From the application directory run

```bash
docker build -t <USERNAME>/comments-app
docker push
```

### Deploying on Kubernetes

Once logged into a kubernetes cluster we can make use of the `express.yaml` to deploy the express app, and the `mongo.yaml` file to deploy Mongo

```
kubectl create -f express.yaml
kubectl create -f mongo.yaml
```

This will create a deployment as well as a service for both the Express App and Mongo. The deployment configs are as follows

`express.yaml`
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  labels:
    app: comments-app
  name: comments-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: comments-app
  template:
    metadata:
      labels:
        app: comments-app
      name: comments-app
    spec:
      containers:
      - image: nabeelvalley/comments-app
        imagePullPolicy: Always
        name: comments-app

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: comments-app
  name: comments-app
spec:
  ports:
  - name: tcp-8080-8080-comments-app
    nodePort: 30016
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: comments-app
  type: LoadBalancer
```

`mongo.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
   name: mongo
   labels:
     run: mongo
spec:
   ports:
   - port: 27017
     targetPort: 27017
     protocol: TCP
   selector:
     run: mongo

---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
   name: mongo
spec:
   template:
     metadata:
       labels:
         run: mongo
     spec:
       containers:
       - name: mongo
         image: mongo
         ports:
         - containerPort: 27017
```

## Running Locally

If you'd like to run this application on a local Kubernetes cluster, take a look at the page on [Deploying an Express App that Uses Mongo on k8s Locally](deploy-an-express-app-with-mongo-on-k8s-locally.md)