---
published: true
title: FeathersJS Basics
---

[[toc]]

> Notes from [this Coding Garden Series](https://www.youtube.com/watch?v=eXnKKnaoA08&list=PLM_i0obccy3uvP4ZMI6NwTzM0BvYBQ7Xd&index=1) on FeathersJS

# Simple Feathers Service

To create a super simple `feathers` service you can do the following:

## Init App

```sh
mkdir feathers-service
cd feathers-service

yarn init -y
yarn add @feathersjs/feathers
```

## Create Feathers Instance

Next up, create an `app.js` file with the following to initialize a feathers app:

`app.js`

```js
const feathers = require('@feathersjs/feathers')
const app = feathers()
```

## Create Service

You can then create a service, each service needs to have a class which defines what methods are available in the service, for example the `MessageService` below defines a `find` and `create` method:

`app.js`

```js
class MessageService {
  constructor() {
    this.messages = [];
  }

  async find() {
    return this.messages;
  }

  async create(data) {
    const message = {
      id: this.messages.length,
      text: data.text,
    };

    this.messages.push(message)
    return message
  }
}
```

## Register Service

We can then register a service by using `app.use` with a name for the service followed by an instance of the service class:

```js
app.use('messages', new MessageService())
```

## Listen to Events

We can use the `app.service('...').on` method to add a handler to an event on a service which will allow us to react to the service events:

```js
app.service("messages").on("created", (message) => {
  console.log("message created");
});
```

## Interact with Service

We can interact with a service by referencing a method in a service:

```js
const main = async () => {
  await app.service("messages").create({
    text: "hello world",
  });

  const messages = await app.service("messages").find();

  console.log("messages: ", messages);
};

main();
```

## Expose as REST and Web Socket

Once we've defined a `feathers` service we can expose it as a REST endpoint as well as a Web Socket automatically using feathers' `express`

Install the `@feathersjs/express` and `@feathersjs/socketio` packages:

```sh
yarn add @feathersjs/express @feathersjs/socketio
```

Then, we need to configure the app as an express app instead as follows:

```js
const express = require("@feathersjs/express");
const socketio = require("@feathersjs/socketio";

const app = express(feathers());
```

Next, add the middleware for `json`, `urlencoded`, and `static` serving:

```js
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(__dirname)); 
```

And then, automatically create the epxress and feathers endpoints for our services:

```js
app.configure(express.rest());
app.configure(socketio());

app.use("/messages", new MessageService());
```

> Note that the `messages` from the previous service definition now becomes `/messages` as it's an endpoint definition now

Lastly, we add the express error handler:

```js
app.use(express.errorHandler());
```

Now, we will be able to listen to the `connection` event to trigger something each time a client connects and that will give us access to the connection. We can also add any client that connects to a group so that messages can be broadcast to them:

```js
// when a user connects
app.on("connection", (connection) => {
  // join them to the everybody channel
  app.channel("everybody").join(connection);
});


// publish all changes to the everybody channel
app.publish(() => app.channel("everybody"));
```

Lastly, we start the server:

```js
app.listen(3030).on("listening", () => {
  console.log("app now listening");
});
```

Now, you can start the application with `node app.js` and go to `http://localhost:3030/messages` where you can see the list of messages that are currently in the service

## Connect from Browser

Create an `index.html` file, from here we'll be connecting to the feathers backend we've configured using the `feathersjs` and `socketio` clients for the browser:

Which we can then include in the `index.html` file:

`index.html`

```js
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Feathers App</title>
</head>

<body>
  <h1>Hello World</h1>

  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/core-js/2.1.4/core.min.js"></script>
  <script src="//unpkg.com/@feathersjs/client@^4.5.0/dist/feathers.js"></script>
  <script src="//unpkg.com/socket.io-client@^2.3.0/dist/socket.io.js"></script>
</body>

</html>
```

Then, in the `index.html` we can use the following js to subscribe to the socket. We can actually use code that's almost identical to what we use on the server to interact with the service. An example of a form that allows users to send data to the service and receive updates from the service would look something like this:

`index.html`

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Feathers App</title>
</head>

<body>
  <h1>Feathers App</h1>

  <form onsubmit="sendMessage(event.preventDefault())">
    <input type="text" id="message-text" />
    <button type="submit">Add Message</button>
  </form>

  <h2>Messages</h2>

  <div id="messages"></div>

  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/core-js/2.1.4/core.min.js"></script>
  <script src="//unpkg.com/@feathersjs/client@^4.5.0/dist/feathers.js"></script>
  <script src="//unpkg.com/socket.io-client@^2.3.0/dist/socket.io.js"></script>

  <script>
    const createMessage = (message) => {
      document.getElementById('messages').innerHTML += `<div>${message}</div>`
    }

    
    const socket = io('/');
    const app = feathers();
    
    
    app.configure(feathers.socketio(socket))
    
    const messageService = app.service('messages')
    
    messageService.on('created', message => {
      createMessage(message.text)
    })

    const sendMessage = async () => {
      const messageInput = document.getElementById('message-text');

      await messageService.create({
        text: messageInput.value
      })

      messageInput.value = ""
    }

    const main = async () => {
      const messages = await messageService.find()

      messages.forEach(m => createMessage(m.text));
    }

    main()

  </script>
</body>

</html>
```

# Init Feathers Application

The previous app that's been configured is a very simple service. To make a more complete `feathers` app we will make use of the CLI

To create a new `feathers` app you will need to use npm or yarn to install the `cli`

```sh
yarn global add @feathersjs/cli
```

And then create an app with:

```sh
mkdir my-feathers-app
cd my-feathers-app

feathers generate app
```

Below are the options I've chosen:

```raw
? Do you want to use JavaScript or TypeScript? TypeScript
? Project name app
? Description
? What folder should the source files live in? src
? Which package manager are you using (has to be installed globally)? Yarn
? What type of API are you making? REST, Realtime via Socket.io
? Which testing framework do you prefer? Jest
? This app uses authentication Yes
? What authentication strategies do you want to use? (See API docs for all 1
80+ supported oAuth providers) Username + Password (Local)
? What is the name of the user (entity) service? users
? What kind of service is it? NeDB
? What is the database connection string? nedb://../data
```

## Config

Once created you can find the application config in the `config/default.json` file. In the config files you can do something like `"PORT"` as a value which will automatically replace it with an environment variable called `PORT`, this can apply to any environment variable you want to use in your config file

## Entrypoint

The entrypoint to a `feathers` application is the `index.ts` file which imports the `app` as well as some logging config, etc.

Additionally, there's the `app.ts` file which pretty much configures an express app for `feathers` with a lot of the usual configuration settings, body parsers, and middleware

## Models and Hooks

The User Model and Class Files specify the default behaviour for the specific `user` entity. Additionally this also uses `hooks` to allow us to run certain logic before and after a service is run as well as manage things like authentication

## Channels

The `channel.ts` file is where connections are handled as well as assign users to channels in which they have access to as well as manage what channels get which events published to them

## Authentication

The `authentication.ts` defines an AuthenticationService and configures the auth providers that are available

## Configure

The `app.configure` function is used all over a feathers app. A `configure` function is a function that takes the `app` function.

`app.configure` takes a function that takes the `app` and is able to configure additional things and create services from the `app`. The `configure` function essentially allows us to break out application into smaller parts

## Feathers Services

Feathers services are an object or class instance that implements specific methods, they can do things like:

1. Read or write from a DB
2. Interact with the file system
3. Call another API
4. Call other services

Service interfaces should implement certain `CRUD` methods and each service should implement one or more of the following:

| Service  | Method   | Endpoint Structure  | Event Name |
| -------- | -------- | ------------------- | ---------- |
| `find`   | `GET`    | `/things?name=john` |            |
| `get`    | `GET`    | `/things/1`         |            |
| `create` | `POST`   | `/things`           | `created`  |
| `update` | `PUT`    | `/things/1`         | `updated`  |
| `patch`  | `PATCH`  | `/things/1`         | `patched`  |
| `remove` | `DELETE` | `/things/1`         | `removed`  |

Incoming requests get mapped to a corresponding rest method

Every service automatically becomes an `EventEmitter` which means that every time a certain modification action is created then the service will automatically emit the specific event that can then be subscribed to from other parts of the application

Due to the design of services we are able to have each service exposed by Feathers via REST and Web Sockets 

> Database adapters are just services which have been implemented to work with specific databases automatically

We can generate a service using feathers with:

```sh
feathers generate service
```

Which will then allow you to select the DB to be used for the service as well as a name for it:

```raw
? What kind of service is it? NeDB
? What is the name of the service? messages
? Which path should the service be registered on? /messages
? Does the service require authentication? Yes
```

This will generate a new service in our `services` directory as well as  a `model` in the `models` directory

We are also able to modify a service's class so that it behaves the way we would like it to, for example we can modify the `users` service class so that it generates an avatar url for each user:

`users.class.ts`

```ts
export class Users extends Service<User> {
  //eslint-disable-next-line @typescript-eslint/no-unused-vars
  constructor(options: Partial<NedbServiceOptions>, app: Application) {
    super(options);
  }

  async create(data: Partial<User>): Promise<User | User[]> {
    const hash = createHash('md5')
      .update(data.email?.toLowerCase() || '')
      .digest('hex');

    const avatar = `${gravatarUrl}/${hash}/?${query}`;

    const userData: Partial<User> = {
      email: data.email,
      password: data.password,
      githubId: data.githubId,
      avatar,
    };

    return super.create(userData);
  }
}
```

## Hooks

Hooks allow us to make use of reusable components that gets implemented as middleware on all service methods. An example implentation of these are the `user` hooks which do some authentication as well as output data cleansing:

`users.hooks.ts`

```ts
export default {
  before: {
    all: [],
    find: [ authenticate('jwt') ],
    get: [ authenticate('jwt') ],
    create: [ hashPassword('password') ],
    update: [ hashPassword('password'),  authenticate('jwt') ],
    patch: [ hashPassword('password'),  authenticate('jwt') ],
    remove: [ authenticate('jwt') ]
  },

  after: {
    all: [ 
      // Make sure the password field is never sent to the client
      // Always must be the last hook
      protect('password')
    ],
  ...
};
```

We can implemet a hook like `createdAt` or `updatedAt` on a service so that we can track date timestamps on an entity and modify data on the `context` object

In order to generate a hook you can run:

```sh
feathers generate hook
```

And then enter the hook name as well as when it should be run:

```raw
? What is the name of the hook? setTimestamp
? What kind of hook should it be? before
? What service(s) should this hook be for (select none to add it yourself)?
 messages
? What methods should the hook be for (select none to add it yourself)? create, update
```

Then, we can update the hook implementation to match our requirements:s

`hooks/set-timestamp.ts`

```ts
// Use this hook to manipulate incoming or outgoing data.
// For more information on hooks see: http://docs.feathersjs.com/api/hooks.html
import { Hook, HookContext } from '@feathersjs/feathers'

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export default (propName: string): Hook => {
  return async (context: HookContext): Promise<HookContext> => {
    context.data[propName] = new Date()
    return context
  }
}
```

In this case, we would use the above hook with:

```ts
export default {
  before: {
    all: [authenticate('jwt')],
    find: [],
    get: [],
    create: [setTimestamp('createdAt')],
    update: [setTimestamp('updatedAt')],
  ...
```

## Service vs Hooks

Services and Hooks are very similar, we will primarily make use of services for functionality that is specific to a service and we will make use of hooks when the functionality is something that can be abstracted and shared with different services