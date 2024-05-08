---
title: Phoenix LiveView with Elixir
---

> Notes based on [How to start writing LiveView](https://www.youtube.com/watch?v=GsOcNO0NlHU)

# Prerequisites

Probably take a look at the [Elixir Notes](./intro) and [Phoenix Notes](./phoenix)

In order to get started the following are required:

- [Elixir](https://elixir-lang.org/install.html)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html)

It's also handy to have the following installed if using VSCode:

- [DevDb VSCode Exetension](https://marketplace.visualstudio.com/items?itemName=damms005.devdb)
- [Elixir Language Server for VSCode](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls)
- [Thunder Client](https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client)

# Initialize a Project

Firstly, initialize a new Phoenix app called `phoenixlive` with:

```sh
mix phx.new phoenixlive --database sqlite3
```

A few important files we want to be aware of specifically related to the LiveView app are:

1. `lib/elixirlive_web/components/layouts/root.html.heex` which is loaded once
2. `lib/elixirlive_web/components/layouts/app.html.heex` which is updated by LiveView when changes happen

# Authentication

Phoenix comes with a generator for building user authentication. In order to do this we can use:

```sh
mix phx.gen.auth Users User users
```

Then, re-fetch dependencies:

```sh
mix deps.get
```

And run migrations

```sh
mix ecto.migrate
```

Then, start the server with:

```sh
mix phx.server
```

You can then visit the application and you will now see a Register and Log In button. You can register to create a new user

# Resource

We can generate a live resource called Link:

```sh
mix phx.gen.live Links Link links url:text
```

And then run `mix ecto migrate`

All of the live views will be in the `lib/web/live` directory

This will have generated a lot of content but we'll delete most of this as we go on

# Live Views

LiveView implicitly has some callbacks that we should implement

1. `mount`
2. `handle_params`
3. `render` - implicit when we have a template file

Before we can start, we need to delete the following files from the `` directory that we won't be immediately using:

1. `show.html.heex
2. `show.ex`
3. `form_component.ex`

We can clear our resource's `index.ex` file and add the following:

```elixir title="lib/phoenixlive_web/live/link_live/index.ex"
defmodule PhoenixliveWeb.LinkLive.Index do
  use PhoenixliveWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
```

The `socket` is like our `conn` in a normal route. Every function basically does something to the socket and passes it on and this is effectively how a request is executed from a functional standpoint

Next, we'll update the router to require that a user is logged in when accesing the links page:

```elixir path="lib/phoenixlive_web/router.ex" ins={9}
scope "/", PhoenixliveWeb do
  pipe_through [:browser, :require_authenticated_user]

  live_session :require_authenticated_user,
    on_mount: [{PhoenixliveWeb.UserAuth, :ensure_authenticated}] do
    live "/users/settings", UserSettingsLive, :edit
    live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

    live "/links", LinkLive.Index
  end
end
```
