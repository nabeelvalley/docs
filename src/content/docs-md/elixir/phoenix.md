---
title: Web Apps using the Elixer Phoenix Framework
published: false
---

# References

- [Elixir Mentor - YouTube](https://youtu.be/s3WNCjN4Pes)

# Prerequisites

In order to get started the following are required:

- [Elixir](https://elixir-lang.org/install.html)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html)
- [PostgreSQL](https://www.postgresql.org/download/)
  - When installing Postgres set the admin password to `postgres` to avoid changing the application config when generated

# Create the Application

> I have had some issues using the Elixir related CLI tools from Nu Shell so just be using your normal shell instead

Mix is a build tool for Elixir - To create the application we will use the `mix` CLI along with the Phoenix template

```sh
mix phx.new myapp
```

Then, `cd` into your app directory and run the following to create a database in your Postgres instance:

```sh
mix ecto.create
```

You can find the configuration for this in `config/dev.exs`

Thereafter, you can start your application using:

```sh
mix phx.server
```

In future, when making dependency the following command can be used to install dependencies:

```sh
mix deps.get
```

# Application Structure

The application code is laid out as follows:

```
├── _build  // compilation artifacts
├── assets  // client-side assets (JS/CSS)
├── config  // configuration for application. config.exs is the main file that imports environments. runtime.exs can be used for loading dynamic config
├── deps    // dependecy code
├── lib     // application code
│   ├── myapp       // Model - business logic
│   ├── myapp.ex
│   ├── myapp_web   // View and Controller - exposes business logic to API
│   └── myapp_web.ex
├── priv  // resources necessary in production but not exactly source code - e.g. migrations
└── test
```

Some of the important files we have are:

- `mix.ex` - dependencies and project meta
- `config/dev.ex` - development config - particularly database config
- `lib/myapp_web/router.ex` - application routes

# Defining a JSON resource

We can use phoenix and mix to generate and inialize a resource using the Mix CLI

For the sake of our application we're going to define `User` and `Account` entities

```sh
mix phx.gen.json Accounts Account accounts email:string hash_password:string
mix phx.gen.json Users User users account_id:references:accounts full_name:string bio:text
```

> The above commands are in the structure of `Context Entity dbtable ...fields`

The above commands will generate the reelvant modules and JSON code for interacting with application entities:

- Controllers for each resource
- Entity schemas for each resource
- Migrations for each resource
