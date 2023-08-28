---
published: true
title: SAFE Stack
subtitle: Overview of the SAFE Stack
description: Overview of the SAFE Stack
---

---
published: true
title: SAFE Stack
subtitle: Overview of the SAFE Stack
description: Overview of the SAFE Stack
---

An F# stack for everywhere, [here's the docs](https://safe-stack.github.io)

# Prereqs

To get started you will need:

- .NET Core SDK 2.2
- `FAKE` CLI (`dotnet tool install -g fake-cli`)
- Paket (optional)
- Node.js
- Yarn/NPM
- An F# IDE

# Getting Started

1. Install the `FAKE` CLI with

```
dotnet tool install -g fake-cli
```

2. Install the SAFE template with

```
dotnet new -i SAFE.Template
```

3. Create a new SAFE project

```
mkdir safe-intro
cd safe-intro
dotnet new SAFE
```

Aside from the default template above you can create a template with a few different choices around the server, communication, and package manager, get help on this [here](https://safe-stack.github.io/docs/template-overview/#template-options) or with:

```
dotnet new SAFE --help
```

4. Run the application

```
fake build --target run
```

If you're using VSCode the relevant configs are already there for you to use under the debug options

# The Stack

The Safe Stack consists of the following technologies

- Saturn for backend F# services, based on .NET Core and the Giraffe Library. Giraffe can also be unsed directly in place of Saturn. Additionally Freya can be used
- Azure for hosting, well also Docker or k8s or whatever really
- Fable for running F# in Browser, F# to JS compiler powered by Babel
- Elmish for client-side UI, based on React

# Code Sharing

SAFE makes use of code sharing between the client and the server, this includes shared types as well as behaviour (such as validation)

Messages are sent between the client and server using a few different methods:

- HTTP with Saturn
- Contracts via Fable Remoting
- Stateful servers with Elmish Bridge

Code that is shared between the client and server is contianed in the `Shared.fs` file and is referenced in the client and server

## Communication

# HTTP

First, create a customer type in your `Shared.fs` file

```fs
type Customer = { Id:int ; Name:string }
```

Then create a function that will load a customer

```fs
let loadCustomersFromDb() =
    [ { Id = 1; Name = "John Smith" } ]
```

Thereafter create an endpoint handler which will return the customer with the `json` function within the `Giraffe` HTTP context

```fs
let getCustomers next ctx =
    json (loadCustomersFromDb()) next ctx
```

Next you will need to expose the endpoint through `Saturn`'s router

First, define the router

```fs
let customerApi = router {
    get "/api/customers" getCustomers
}
```

This can then be added to the `app` by adding the following into the app builder definition

```fs
    use_router customerApi
```
