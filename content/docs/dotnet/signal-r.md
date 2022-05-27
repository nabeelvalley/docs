[[toc]]

> [Microsoft Documentation](https://docs.microsoft.com/en-us/aspnet/core/tutorials/signalr-typescript-webpack?view=aspnetcore-3.1&tabs=visual-studio-code)

Signal R is a way to add real-time functionality to a .NET Web API, it makes use of a Server and Client side connection enabling two way transfer of data between them

# Setting Up

> This post assumes some base knowledge on .NET Core Web Applications as well as React and Typescript

## Create the Projects

1. Create a new directory for the project

```bash
mkdir SignalRTypeScript
```

2. Create a new .NET Web App and add it to the solution

```bash
dotnet new web -o Server
dotnet sln ./SignalRTypescript.sln add ./Server
```

3. Create a new React App with Typescript for the frontend

```bash
yarn create react-app web --template typescript
```

## Configure Server

On the `Server` application we need to:

1. Create a new class for our communication Hub

Inside of this class we can add a function that will allow us to receive a message and broadcast that message to all connected clients:

`Server/Hubs/MessageHub.cs`

```cs
using Microsoft.AspNetCore.SignalR;

namespace Server.Hubs
{
    public class MessageHub : Hub
    {
        public async Task NewMessage(string username, string message)
        {
            await Clients.All.SendAsync("messageReceived", username, message);
        }
    }
}
```

2. Add `SignalR` to the `ConfigureServices` method as well as `AddCors` so that our client can connect to our server

`Startup.cs`

```cs
public void ConfigureServices(IServiceCollection services)
{
    services.AddCors();
    services.AddSignalR();
}
```

3. Add the Hub mapping on the `Configure` method to the `app.UseEndpoints` lambda and the `Cors` rule we want to apply

`startup.cs`

```cs
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
   //... existing default code not shown

    app.UseCors(
        options => options.WithOrigins("http://localhost:3000")
                            .AllowAnyMethod()
                            .AllowAnyHeader()
                            .AllowCredentials()
    );

    app.UseEndpoints(endpoints =>
    {
        endpoints.MapHub<MessageHub>("/hub");
    });
}
```

4. Lastly we will need to either check what port our application is running on, or more simply set the port using Visual Studio or the `dotnet cli` when you run the application

## Configure the Client

1. On the Client application (web) we need to install the SignalR packages so that we can consume the SignalR Client library

```bash
yarn add @microsoft/signalr
```

We will make use of two React components in our application, the `App` component will be the main application component and will handle the dispatching of messages to the server, and the `MessageViewer` component which will handle subscribing to and displaying the messages broadcasted by the server

2. Create the `MessageViewer` component:

`MessageViewer.tsx`

```tsx
import React, { Component } from 'react';
import { HubConnectionBuilder, HubConnection } from '@microsoft/signalr'
import './App.css';

type Message = {
    message: string,
    username: string 
}

type MessageViewerState = {
    messages: Message[],
    connection: HubConnection
}

class MessageViewer extends Component<{}, MessageViewerState> {
    render() {
        return (
            <div className="MessageViewer">
                {this.state.messages.map(m => m.message).join(' ')}
            </div>
        )
    }
}

export default MessageViewer;
```

So far we have just implemented the render method for the component and the relevant types, however we need to implement the `constructor` to initialize our properties, and the `componentDidMount` and `messageHandler`  methods so we set up the connection to the Server and handle the messages sent from it. In the class definition for the `MessageViewerComponent` included those functions: 

In the `constructor` we just initialize our state with an empty `message` array and the `HubConnection`. The Hub Connection is built using the `HubConnectionBuilder`

`MessageViewer.tsx`

```tsx
constructor(props: any) {
    super(props)

    this.state = {
        messages: [],
        connection: new HubConnectionBuilder().withUrl("http://localhost:4000/hub").build()
    }
}
```

Then we will define an `async componentDidMount` method in which we will start the server connection as well as set up which messages we would like to subscribe and respond to:

`MessageViewer.tsx`

```tsx
async componentDidMount() {

    try {
        // start connection
        await this.state.connection.start()
        console.log('connection started')
    } catch (error) {
        console.error(error)
    }

    // subscribe to the `messageReceived` event
    this.state.connection.on('messageReceived', this.handleMessage)
}
```

And then define the `handleMessage` function which will update our state based on the messages we receive:

`MessageViewer.tsx`

```tsx
handleMessage = (username: string, message: string) => this.setState({
    ...this.state,
    messages: [...this.state.messages, { message, username }]
})
```

<details>
  <summary>Complete `MessageViewer.tsx` file</summary>

```tsx
import React, { Component } from 'react';
import { HubConnectionBuilder, HubConnection } from '@microsoft/signalr'
import './App.css';

type Message = {
    message: string,
    username: string
}

type MessageViewerState = {
    messages: Message[],
    connection: HubConnection
}

class MessageViewer extends Component<{}, MessageViewerState> {

    constructor(props: any) {
        super(props)

        this.state = {
            messages: [],
            connection: new HubConnectionBuilder().withUrl("http://localhost:4000/hub").build()
        }
    }

    handleMessage = (username: string, message: string) => this.setState({
        ...this.state,
        messages: [...this.state.messages, { message, username }]
    })


    async componentDidMount() {
        try {
            await this.state.connection.start()
            console.log('connection started')
        } catch (error) {
            console.error(error)
        }

        this.state.connection.on('messageReceived', this.handleMessage)
    }

    render() {
        return (
            <div className="MessageViewer">
                {this.state.messages.map(m => m.message).join(' ')}
            </div>
        )
    }
}

export default MessageViewer;
```

</details>

3. Create the `App` component

For our initial connection configuration we will use some of the same code we used in the `MessageViewer` component, the `App.tsx` file will however additionally send messages to the SignalR Hub, for our purpose a new message will be sent each time the user presses a key on the keyboard. Initially the `App.tsx` file contains the following basic content:

`App.tsx`

```tsx
import React, {     Component } from 'react';
import './App.css';
import { HubConnectionBuilder, HubConnection } from '@microsoft/signalr';
import MessageViewer from './MessageViewer';

type AppState = {
    connectionUser: string,
    connection: HubConnection
}

class App extends Component<{}, AppState> {

    constructor(props: any) {
        super(props)

        this.state = {
            connectionUser: 'App',
            connection: new HubConnectionBuilder().withUrl("http://localhost:4000/hub").build()
        }
    }

    render(){
        return (
            <div className="App">
                <MessageViewer />
            </div>
        );
    }
}

export default App;

```

Next, we need to add some functionality to the component. First, in the `async componentDidMount` function we will connect to the server and and add an event listener for `keydown` events, and a `componentWillUnmount` which will remove the listener when the component unmounts:

`App.tsx`

```tsx
async componentDidMount() {
    try {
        await this.state.connection.start()
        console.log('connection started')
    } catch (error) {
        console.error(error)
    }

    document.addEventListener('keydown', this.handleKeydown)        
}

componentWillUnmount() {
    document.removeEventListener('keydown', this.handleKeydown)
}
```

Lastly we can add the `handleKeydown` function on our component to send a message each time the `keydown` event is triggered

`App.tsx`

```tsx
handleKeydown = async (e: KeyboardEvent) => {
    try {
        await this.state.connection.send("newMessage", this.state.connectionUser, e.key)
    } catch (error) {
        console.error(error)
    }
}
```

You should be able to now run your Server and Web applications using `dotnet` and `yarn` (or `npm`) respectively and when clicking any key on your keyboard it should appear on the screen. This will be displayed in the `MessageViewer` component which is subscribed to the events