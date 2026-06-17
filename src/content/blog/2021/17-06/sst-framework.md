---
published: true
title: Building Serverless Apps using the Serverless Stack Framework
subtitle: 17 June 2021
description: Build, debug, and deploy serverless applications on AWS using SST and VSCode
---

> Prior to doing any of the below you will require your `~/.aws/credentials` file to be configured with the credentials for your AWS account

## Serverless Stack Framework

SST Framework is a framework built on top of CDK for working with Lambdas and other CDK constructs

It provides easy CDK setups and a streamlined debug and deploy process and even has integration with the VSCode debugger to debug stacks on AWS

### Init Project

To init a new project use the following command:

```sh
npx create-serverless-stack@latest my-sst-app --language typescript
```

Which will create a Serverless Stack applocation using TypeScript

### Run the App

You can run the created project in using the config defined in the `sst.json` file:

```json
{
  "name": "my-sst-app",
  "stage": "dev",
  "region": "us-east-1",
  "lint": true,
  "typeCheck": true
}
```

Using the following commands command will build then deploy a dev stack and allow you to interact with it via AWS/browser/Postman/etc.

```sh
npm run start
```

Additionally, running using the above command will also start the application with hot reloading enabled so when you save files the corresponding AWS resources will be redeployed so you can continue testing

### The Files

The application is structured like a relatively normal Lambda/CDK app with `lib` which contains the following CDK code:

#### Stack

`lib/index.ts`

```ts
import MyStack from './MyStack'
import * as sst from '@serverless-stack/resources'

export default function main(app: sst.App): void {
  // Set default runtime for all functions
  app.setDefaultFunctionProps({
    runtime: 'nodejs12.x',
  })

  new MyStack(app, 'my-stack')

  // Add more stacks
}
```

`lib/MyStack.ts`

```ts
import * as sst from '@serverless-stack/resources'

export default class MyStack extends sst.Stack {
  constructor(scope: sst.App, id: string, props?: sst.StackProps) {
    super(scope, id, props)

    // Create the HTTP API
    const api = new sst.Api(this, 'Api', {
      routes: {
        'GET /': 'src/lambda.handler',
      },
    })

    // Show API endpoint in output
    this.addOutputs({
      ApiEndpoint: api.httpApi.apiEndpoint,
    })
  }
}
```

And `src` which contains the lambda code:

`src/lambda.ts`

```ts
import { APIGatewayProxyEventV2, APIGatewayProxyHandlerV2 } from 'aws-lambda'

export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2
) => {
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'text/plain' },
    body: `Hello, World! Your request was received at ${event.requestContext.time}.`,
  }
}
```

### Add a new Endpoint

Using the defined constructs it's really easy for us to add an additional endpoint:

`src/hello.ts`

```ts
import { APIGatewayProxyEventV2, APIGatewayProxyHandlerV2 } from 'aws-lambda'

export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2
) => {
  const response = {
    data: 'Hello, World! This is another lambda but with JSON',
  }

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(response),
  }
}
```

And then in the stack we just update the routes:

`lib/MyStack.ts`

```ts
const api = new sst.Api(this, 'Api', {
  routes: {
    'GET /': 'src/lambda.handler',
    'GET /hello': 'src/hello.handler', // new endpoint handler
  },
})
```

So that the full stack looks like this:

`lib/MyStack.ts`

```ts
import * as sst from '@serverless-stack/resources'

export default class MyStack extends sst.Stack {
  constructor(scope: sst.App, id: string, props?: sst.StackProps) {
    super(scope, id, props)

    // Create the HTTP API
    const api = new sst.Api(this, 'Api', {
      routes: {
        'GET /': 'src/lambda.handler',
        'GET /hello': 'src/hello.handler',
      },
    })

    // Show API endpoint in output
    this.addOutputs({
      ApiEndpoint: api.httpApi.apiEndpoint,
    })
  }
}
```

### VSCode Debugging

SST supports VSCode Debugging, all that's required is for you to create a `.vscode/launch.json` filw with the following content:

`.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug SST Start",
      "type": "node",
      "request": "launch",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["start"],
      "port": 9229,
      "skipFiles": ["<node_internals>/**"]
    },
    {
      "name": "Debug SST Tests",
      "type": "node",
      "request": "launch",
      "runtimeExecutable": "${workspaceRoot}/node_modules/.bin/sst",
      "args": ["test", "--runInBand", "--no-cache", "--watchAll=false"],
      "cwd": "${workspaceRoot}",
      "protocol": "inspector",
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen",
      "env": { "CI": "true" },
      "disableOptimisticBPs": true
    }
  ]
}
```

This will then allow you to run `Debug SST Start` which will configure the AWS resources using the `npm start` command and connect the debugger to the instance so you can debug your functions locally as well as make use of the automated function deployment

### Add a DB

> From [these docs](https://serverless-stack.com/examples/how-to-create-a-crud-api-with-serverless-using-dynamodb.html)

We can define our table using the `sst.Table` class:

```ts
const table = new sst.Table(this, 'Notes', {
  fields: {
    userId: sst.TableFieldType.STRING,
    noteId: sst.TableFieldType.NUMBER,
  },
  primaryIndex: {
    partitionKey: 'userId',
    sortKey: 'noteId',
  },
})
```

Next, we can add some endpoint definitions for the functions we'll create as well as access to the table name via the environment:

```ts
const api = new sst.Api(this, 'Api', {
  defaultFunctionProps: {
    timeout: 60, // increase timeout so we can debug
    environment: {
      tableName: table.dynamodbTable.tableName,
    },
  },
  routes: {
    // .. other routes
    'GET  /notes': 'src/notes/getAll.handler', // userId in query
    'GET  /notes/{noteId}': 'src/notes/get.handler', // userId in query
    'POST /notes': 'src/notes/create.handler',
  },
})
```

And lastly we can grant the permissions to our `api` to access the `table`

```ts
api.attachPermissions([table])
```

Adding the above to the `MyStack.ts` file results in the following:

```ts
import * as sst from '@serverless-stack/resources'

export default class MyStack extends sst.Stack {
  constructor(scope: sst.App, id: string, props?: sst.StackProps) {
    super(scope, id, props)

    const table = new sst.Table(this, 'Notes', {
      fields: {
        userId: sst.TableFieldType.STRING,
        noteId: sst.TableFieldType.STRING,
      },
      primaryIndex: {
        partitionKey: 'userId',
        sortKey: 'noteId',
      },
    })

    // Create the HTTP API
    const api = new sst.Api(this, 'Api', {
      defaultFunctionProps: {
        timeout: 60, // increase timeout so we can debug
        environment: {
          tableName: table.dynamodbTable.tableName,
        },
      },
      routes: {
        // .. other routes
        'GET  /notes': 'src/notes/getAll.handler', // userId in query
        'GET  /notes/{noteId}': 'src/notes/get.handler', // userId in query
        'POST /notes': 'src/notes/create.handler',
      },
    })

    api.attachPermissions([table])

    // Show API endpoint in output
    this.addOutputs({
      ApiEndpoint: api.httpApi.apiEndpoint,
    })
  }
}
```

Before we go any further, we need to install some dependencies in our app, particularly `uuid` for generating unique id's for notes, we can install a dependency with:

```sh
npm install uuid
npm install aws-sdk
```

### Define Common Structures

We'll also create some general helper functions for returning responses of different types, you can view the details for their files below but these just wrap the response in a status and header as well as stringify the body

`src/responses/successResponse.ts`

```ts
const successResponse = <T>(item: T) => {
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(item),
  }
}

export default successResponse
```

`src/responses/badResuestsResponse.ts`

```ts
const badRequestResponse = (msg: string) => {
  return {
    statusCode: 400,
    headers: { 'Content-Type': 'text/plain' },
    body: msg,
  }
}

export default badRequestResponse
```

`src/responses/internalErrorResponse.ts`

```ts
const internalErrorResponse = (msg: string) => {
  console.error(msg)
  return {
    statusCode: 500,
    headers: { 'Content-Type': 'text/plain' },
    body: 'internal error',
  }
}

export default internalErrorResponse
```

And we've also got a `Note` type which will be the data that gets stored/retreived:

`src/notes/Note.ts`

```ts
type Note = {
  userId: string
  noteId: string
  content?: string
  createdAt: number
}

export default Note
```

### Access DB

Once we've got a DB table defined as above, we can then access the table to execute different queries

We would create a DB object instance using:

```ts
const db = new DynamoDB.DocumentClient()
```

#### Create

A `create` is the simplest one of the database functions for us to implement, this uses the `db.put` function with the `Item` to save which is of type `Note`:

```ts
const create = async (tableName: string, item: Note) => {
  await db.put({ TableName: tableName, Item: item }).promise()
}
```

#### Get

We can implement a `getOne` function by using `db.get` and providing the full `Key` consisting of the `userId` and `noteId`

```ts
const getOne = async (tableName: string, noteId: string, userId: string) => {
  const result = await db
    .get({
      TableName: tableName,
      Key: {
        userId: userId,
        noteId: noteId,
      },
    })
    .promise()

  return result.Item
}
```

#### GetAll

We can implement a `getByUserId` function which will make use of `db.query` and use the `ExpressionAttributeValues` to populate the `KeyConditionExpression` as seen below:

```ts
const getByUserId = async (tableName: string, userId: string) => {
  const result = await db
    .query({
      TableName: tableName,
      KeyConditionExpression: 'userId = :userId',
      ExpressionAttributeValues: {
        ':userId': userId,
      },
    })
    .promise()

  return result.Items
}
```

### Define Lambdas

Now that we know how to write data to Dynamo, we can implement the following files for the endpoints we defined above:

#### Create

`src/notes/create.ts`

```ts
import { APIGatewayProxyEventV2, APIGatewayProxyHandlerV2 } from 'aws-lambda'
import { DynamoDB } from 'aws-sdk'
import { v1 } from 'uuid'
import internalErrorResponse from '../responses/internalErrorResponse'
import successResponse from '../responses/successResponse'
import badRequestResponse from '../responses/badRequestResponse'
import Note from './Note'

const db = new DynamoDB.DocumentClient()

const toItem = (data: string, content: string): Note => {
  return {
    userId: data,
    noteId: v1(),
    content: content,
    createdAt: Date.now(),
  }
}

const parseBody = (event: APIGatewayProxyEventV2) => {
  const data = JSON.parse(event.body || '{}')

  return {
    userId: data.userId,
    content: data.content,
  }
}

const isValid = (data: Partial<Note>) =>
  typeof data.userId !== 'undefined' && typeof data.content !== 'undefined'

const create = async (tableName: string, item: Note) => {
  await db.put({ TableName: tableName, Item: item }).promise()
}

export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2
) => {
  if (typeof process.env.tableName === 'undefined')
    return internalErrorResponse('tableName is undefined')

  const tableName = process.env.tableName
  const data = parseBody(event)

  if (!isValid(data))
    return badRequestResponse('userId and content are required')

  const item = toItem(data.userId, data.content)
  await create(tableName, item)

  return successResponse(item)
}
```

#### Get

`src/notes/get.ts`

```ts
import { APIGatewayProxyEventV2, APIGatewayProxyHandlerV2 } from 'aws-lambda'
import { DynamoDB } from 'aws-sdk'
import badRequestResponse from '../responses/badRequestResponse'
import internalErrorResponse from '../responses/internalErrorResponse'
import successResponse from '../responses/successResponse'

type RequestParams = {
  noteId?: string
  userId?: string
}

const db = new DynamoDB.DocumentClient()

const parseBody = (event: APIGatewayProxyEventV2): RequestParams => {
  const pathData = event.pathParameters
  const queryData = event.queryStringParameters

  return {
    noteId: pathData?.noteId,
    userId: queryData?.userId,
  }
}

const isValid = (data: RequestParams) =>
  typeof data.noteId !== 'undefined' && typeof data.userId !== 'undefined'

const getOne = async (tableName: string, noteId: string, userId: string) => {
  const result = await db
    .get({
      TableName: tableName,
      Key: {
        userId: userId,
        noteId: noteId,
      },
    })
    .promise()

  return result.Item
}

export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2
) => {
  const data = parseBody(event)

  if (typeof process.env.tableName === 'undefined')
    return internalErrorResponse('tableName is undefined')

  const tableName = process.env.tableName

  if (!isValid(data))
    return badRequestResponse(
      'noteId is required in path, userId is required in query'
    )

  const items = await getOne(
    tableName,
    data.noteId as string,
    data.userId as string
  )

  return successResponse(items)
}
import { APIGatewayProxyEventV2, APIGatewayProxyHandlerV2 } from 'aws-lambda'
import { DynamoDB } from 'aws-sdk'
import badRequestResponse from '../responses/badRequestResponse'
import internalErrorResponse from '../responses/internalErrorResponse'
import successResponse from '../responses/successResponse'

type RequestParams = {
  noteId?: string
  userId?: string
}

const db = new DynamoDB.DocumentClient()

const parseBody = (event: APIGatewayProxyEventV2): RequestParams => {
  const pathData = event.pathParameters
  const queryData = event.queryStringParameters

  return {
    noteId: pathData?.noteId,
    userId: queryData?.userId,
  }
}

const isValid = (data: RequestParams) =>
  typeof data.noteId !== 'undefined' && typeof data.userId !== 'undefined'

const getOne = async (tableName: string, noteId: string, userId: string) => {
  const result = await db
    .get({
      TableName: tableName,
      Key: {
        userId: userId,
        noteId: noteId,
      },
    })
    .promise()

  return result.Item
}

export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2
) => {
  const data = parseBody(event)

  if (typeof process.env.tableName === 'undefined')
    return internalErrorResponse('tableName is undefined')

  const tableName = process.env.tableName

  if (!isValid(data))
    return badRequestResponse(
      'noteId is required in path, userId is required in query'
    )

  const items = await getOne(
    tableName,
    data.noteId as string,
    data.userId as string
  )

  return successResponse(items)
}
```

#### GetAll

`src/notes/getAll.ts`

```ts
import { APIGatewayProxyEventV2, APIGatewayProxyHandlerV2 } from 'aws-lambda'
import { DynamoDB } from 'aws-sdk'
import badRequestResponse from '../responses/badRequestResponse'
import internalErrorResponse from '../responses/internalErrorResponse'
import successResponse from '../responses/successResponse'

type PathParams = {
  userId?: string
}

const db = new DynamoDB.DocumentClient()

const parseBody = (event: APIGatewayProxyEventV2): PathParams => {
  const data = event.queryStringParameters

  return {
    userId: data?.userId,
  }
}

const isValid = (data: PathParams) => typeof data.userId !== 'undefined'

const getByUserId = async (tableName: string, userId: string) => {
  const result = await db
    .query({
      TableName: tableName,
      KeyConditionExpression: 'userId = :userId',
      ExpressionAttributeValues: {
        ':userId': userId,
      },
    })
    .promise()

  return result.Items
}

export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2
) => {
  const data = parseBody(event)

  if (typeof process.env.tableName === 'undefined')
    return internalErrorResponse('tableName is undefined')

  const tableName = process.env.tableName

  if (!isValid(data)) return badRequestResponse('userId is required in query')

  const items = await getByUserId(tableName, data.userId as string)

  return successResponse(items)
}
```

#### Testing

Once we've got all the above completed, we can actually test our endpoints and create and read back data

`create`:

```http
POST https://AWS_ENDPOINT_HERE/notes

{
  "userId": "USER_ID",
  "content": "Hello world"
}
```

Which responds with:

```http
200

{
  "content": "Hello world",
  "createdAt": 1619177078298,
  "noteId": "NOTE_ID_UUID",
  "userId": "USER_ID"
}
```

`get`:

```http
GET https://AWS_ENDPOINT_HERE/notes/NOTE_ID_UUID?userId=USER_ID
```

```http
200

{
  "content": "Hello world",
  "createdAt": 1619177078298,
  "noteId": "NOTE_ID_UUID",
  "userId": "USER_ID"
}
```

`getAll`

```http
GET htttps://AWS_ENDPOINT_HERE/notes?userId=USER_ID
```

```http
200

[
  {
    "content": "Hello world",
    "createdAt": 1619177078298,
    "noteId": "NOTE_ID_UUID",
    "userId": "USER_ID"
  }
]
```

### Creating Notes Using a Queue

When working with microservices a common pattern is to use a message queue for any operations that can happen in an asynchronous fashion, we can create an SQS queue which we can use to stage messages and then separately save them at a rate that we're able to process them

In order to make this kind of logic we're going to break up our `create` data flow - a the moment it's this:

```
lambda -> dynamo
return <-
```

We're going to turn it into this:

```
lambda1 -> sqs
 return <-

          sqs -> lambda2 -> dynamo
```

This kind of pattern becomes especially useful if we're doing a lot more stuff with the data other than just the single DB operation and also allows us to retry things like saving to the DB if we have errors, etc.

A more complex data flow could look something like this (not what we're implementing):

```
lambda1 -> sqs
 return <-

           sqs -> lambda2 -> dynamo // save to db
               -> lambda3 -> s3     // generate a report
           sqs <-

           sqs -> lambda4           // send an email
```

#### Create Queue

SST provides us with the `sst.Queue` class that we can use for this purpose

To create a Queue you can use the following in stack:

```ts
const queue = new sst.Queue(this, 'NotesQueue', {
  consumer: 'src/consumers/createNote.handler',
})

queue.attachPermissions([table])
queue.consumerFunction?.addEnvironment(
  'tableName',
  table.dynamodbTable.tableName
)
```

The above code does the following:

1. Create a `queue`
2. Give the queue permission to access the `table`
3. Add the `tableName` environment variable to the `queue`'s `consumerFunction`

We will also need to grant permissions to the API to access the `queue` so that our `create` handler is able to add messages to the `queue`

```ts
api.attachPermissions([table, queue])
```

Which means our Stack now looks like this:

`lib/MyStack.ts`

```ts
import * as sst from '@serverless-stack/resources'

export default class MyStack extends sst.Stack {
  constructor(scope: sst.App, id: string, props?: sst.StackProps) {
    super(scope, id, props)

    const table = new sst.Table(this, 'Notes', {
      fields: {
        userId: sst.TableFieldType.STRING,
        noteId: sst.TableFieldType.STRING,
      },
      primaryIndex: {
        partitionKey: 'userId',
        sortKey: 'noteId',
      },
    })

    const queue = new sst.Queue(this, 'NotesQueue', {
      consumer: 'src/consumers/createNote.handler',
    })

    queue.attachPermissions([table])
    queue.consumerFunction?.addEnvironment(
      'tableName',
      table.dynamodbTable.tableName
    )

    // Create the HTTP API
    const api = new sst.Api(this, 'Api', {
      defaultFunctionProps: {
        timeout: 60, // increase timeout so we can debug
        environment: {
          tableName: table.dynamodbTable.tableName,
          queueUrl: queue.sqsQueue.queueUrl,
        },
      },
      routes: {
        'GET  /': 'src/lambda.handler',
        'GET  /hello': 'src/hello.handler',
        'GET  /notes': 'src/notes/getAll.handler',
        'POST /notes': 'src/notes/create.handler',
        'GET  /notes/{noteId}': 'src/notes/get.handler',
      },
    })

    api.attachPermissions([table, queue])

    // Show API endpoint in output
    this.addOutputs({
      ApiEndpoint: api.httpApi.apiEndpoint,
    })
  }
}
```

#### Update the Create Handler

Since we plan to create notes via a queue we will update our `create` function in the handler to create a new message in the `queue`, this is done using the `SQS` class from `aws-sdk`:

`src/notes/create.ts`

```ts
import { SQS } from 'aws-sdk'

const queue = new SQS()
```

Once we've got our instance, the `create` function is done by means of the `queue.sendMessage` function:

`src/notes/create.ts`

```ts
const create = async (queueUrl: string, item: Note) => {
  return await queue
    .sendMessage({
      QueueUrl: queueUrl,
      DelaySeconds: 0,
      MessageBody: JSON.stringify(item),
    })
    .promise()
}
```

Lastly, our `handler` remains mostly the same with the exception of some additional validation to check that we have the `queue` connection information in the environment:

`src/notes/create.ts`

```ts
export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2
) => {
  // pre-save validation
  if (typeof process.env.queueUrl === 'undefined')
    return internalErrorResponse('queueUrl is undefined')

  const queueUrl = process.env.queueUrl

  const data = parseBody(event)

  if (!isValid(data))
    return badRequestResponse('userId and content are required')

  // save process
  const item = toItem(data.userId, data.content)
  const creatresult = await create(queueUrl, item)

  if (!creatresult.MessageId) internalErrorResponse('MessageId is undefined')

  return successResponse(item)
}
```

Implementing the above into the `create` handler means that our `create.ts` file now looks like this:

`src/notes/create.ts`

```ts
import { APIGatewayProxyEventV2, APIGatewayProxyHandlerV2 } from 'aws-lambda'
import { v1 } from 'uuid'
import internalErrorResponse from '../responses/internalErrorResponse'
import successResponse from '../responses/successResponse'
import badRequestResponse from '../responses/badRequestResponse'
import Note from './Note'
import { SQS } from 'aws-sdk'

const queue = new SQS()

// helper functions start

const toItem = (data: string, content: string): Note => {
  return {
    userId: data,
    noteId: v1(),
    content: content,
    createdAt: Date.now(),
  }
}

const parseBody = (event: APIGatewayProxyEventV2) => {
  const data = JSON.parse(event.body || '{}')

  return {
    userId: data.userId,
    content: data.content,
  }
}

const isValid = (data: Partial<Note>) =>
  typeof data.userId !== 'undefined' && typeof data.content !== 'undefined'

// helper functions end

const create = async (queueUrl: string, item: Note) => {
  return await queue
    .sendMessage({
      QueueUrl: queueUrl,
      DelaySeconds: 0,
      MessageBody: JSON.stringify(item),
    })
    .promise()
}

export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2
) => {
  // pre-save validation
  if (typeof process.env.queueUrl === 'undefined')
    return internalErrorResponse('queueUrl is undefined')

  const queueUrl = process.env.queueUrl

  const data = parseBody(event)

  if (!isValid(data))
    return badRequestResponse('userId and content are required')

  // save process
  const item = toItem(data.userId, data.content)
  const creatresult = await create(queueUrl, item)

  if (!creatresult.MessageId) internalErrorResponse('MessageId is undefined')

  return successResponse(item)
}
```

#### Add Queue-Based Create Handler

Now that we've updated our logic to save the notes into the `queue`, we need to add the logic for the `src/consumers/createNote.handler` consumer function as we specified above, this handler will be sent an `SQSEvent` and will make use of the DynamoDB Table we gave it permissions to use

First, we take the `create` function that was previously on the `create.ts` file for saving to the DB:

`src/consumers/createNote.ts`

```ts
import { DynamoDB } from 'aws-sdk'

const db = new DynamoDB.DocumentClient()

const create = async (tableName: string, item: Note) => {
  const createResult = await db
    .put({ TableName: tableName, Item: item })
    .promise()
  if (!createResult) throw new Error('create failed')

  return createResult
}
```

We'll also need a function for parsing the `SQSRecord` object into a `Note`:

`src/consumers/createNote.ts`

```ts
const parseBody = (record: SQSRecord): Note => {
  const { noteId, userId, content, createdAt } = JSON.parse(record.body) as Note

  // do this to ensure we only extract information we need
  return {
    noteId,
    userId,
    content,
    createdAt,
  }
}
```

And finally we consume the above through the `handler`, you can see in the below code that we are iterating over the `event.Records` object, this is because the `SQSEvent` adds each new event into this array, the reason for this is because we can also specify batching into our Queue so that the handler is only triggered after `n` events instead of each time, and though this isn't happening in our case, we still should handle this for our handler:

`src/consumers/createNote.ts`

```ts
export const handler: SQSHandler = async (event) => {
  // pre-save environment check
  if (typeof process.env.tableName === 'undefined')
    throw new Error('tableName is undefined')

  const tableName = process.env.tableName

  for (let i = 0; i < event.Records.length; i++) {
    const r = event.Records[i]
    const item = parseBody(r)
    console.log(item)

    const result = await create(tableName, item)
    console.log(result)
  }
}
```

Putting all the above together our `createNote.ts` file now has the following code:

```ts
import { SQSHandler, SQSRecord } from 'aws-lambda'
import Note from '../notes/Note'
import { DynamoDB } from 'aws-sdk'

const db = new DynamoDB.DocumentClient()

const create = async (tableName: string, item: Note) => {
  const createResult = await db
    .put({ TableName: tableName, Item: item })
    .promise()
  if (!createResult) throw new Error('create failed')

  return createResult
}

const parseBody = (record: SQSRecord): Note => {
  const { noteId, userId, content, createdAt } = JSON.parse(record.body) as Note

  // do this to ensure we only extract information we need
  return {
    noteId,
    userId,
    content,
    createdAt,
  }
}

export const handler: SQSHandler = async (event) => {
  if (typeof process.env.tableName === 'undefined')
    throw new Error('tableName is undefined')

  const tableName = process.env.tableName

  for (let i = 0; i < event.Records.length; i++) {
    const r = event.Records[i]
    const item = parseBody(r)
    console.log(item)

    const result = await create(tableName, item)
    console.log(result)
  }
}
```

This completes the implementation of the asynchronous saving mechanism for notes. As far as a consumer of our API is concerned, nothing has changed and they will still be able to use the API exactly as we had in the [Testing section above](#testing)

## Deploy

Thus far, we've just been running our API in `debug` mode via the `npm run start` command, while useful for testing this adds a lot of code to make debugging possible, and isn't something we'd want in our final deployed code

Deploying using `sst` is still very easy, all we need to do is run the `npm run deploy` command and this will update our lambda to use a production build of the code instead:

```sh
npm run deploy
```

## Teardown

Lastly, the `sst` CLI also provides us with a function to teardown our `start`/`deploy` code. So once you're done playing around you can use this to teardown all your deployed services:

```ts
npm run remove
```

> Note that running the `remove` command will not delete the DB tables, you will need to do this manually
