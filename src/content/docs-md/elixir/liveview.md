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

For now though, we can add the live routes to our `router.ex` file as directed by the command output:

```elixir title="lib/phoenixlive_web/router.ex" ins={9}
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

> Make sure that your IDE doesn't auto import anything when adding routes - I got stuck with an annoying `_live_/0 is undefined` issue because it added an import that had a naming collision with my routes

At this point to avoid potential collisions and issues please also delete the following files:

1. `lib/phoenixlive_web/live/link_live/show.ex`
2. `lib/phoenixlive_web/live/link_live/show.html.heex`
3. `lib/phoenixlive_web/live/link_live/form_component.ex`

# Live Views

LiveView implicitly has some callbacks that we should implement

1. `mount`
2. `handle_params`
3. `render` - implicit when we have a template file

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

And we can update the `index.html.heex` to just have some placeholder content for now:

```elixir title="lib/phoenixlive_web/live/link_live/index.html.heex"
<div>Hello World</div>
```

If we start our server again we can visit the `/links` page when logged in to see the content of the page we just added

## Listing Links for the Current User

We can update our screen to list thelinks for the current user. In order to do this we need to do a few things first:

1. Add a reference to the user from our Link schema
2. Define a migration for adding the user reference to the database table
3. Add a way to list links by user
4. Get the user from the current route and use that to list the links
5. Display a list of links in the HEEX template

### Add Reference to User

To add the reference to the user, we can add the following lines to our schema:

```elixir title="lib/phoenixlive/links/link.ex" ins={8,16-17}
defmodule Phoenixlive.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :url, :string

    belongs_to :user, Phoenixlive.Users.User

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :user_id])
    |> validate_required([:url, :user_id])
  end
end
```

### Add a Migration

We can define a migration by generating a new migration with:

```sh
mix ecto.gen.migration add_user_to_link
```

Which should generate a migration file into which we add the following:

```elixir title="priv/repo/migrations/20240510083258_add_user_to_link.exs"
defmodule Phoenixlive.Repo.Migrations.AddUserToLink do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
```

Then we can apply the migration with:

```sh
mix ecto.migrate
```

### List Links by User

We can update our `list_links` function to take a `user_id`. We can implement it using the [Ecto Query Syntax](https://hexdocs.pm/ecto/Ecto.Query.html):

```elixir title="lib/phoenixlive/links.ex"
def list_links(user_id) do
  Repo.all(from l in Link, where: l.user_id == ^user_id)
end
```

### Get Current User from Route

We can get the current user from the route using the `socket.assigns`, this comes from the router `:ensure_authenticated` reference that we have in the `router.ex` file. Using this data we can list the links for the user and `assign` it to the socket which will make it available during render:

```elixir title="lib/phoenixlive_web/live/link_live/index.ex"
defmodule PhoenixliveWeb.LinkLive.Index do
  alias Phoenixlive.Links
  use PhoenixliveWeb, :live_view

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id

    socket = socket
    |> assign(:links, Links.list_links(user_id))

    {:ok, socket}
  end
end
```

### Display Links in the HEEX Template

We can access the links using `@links` in our template. Phoenix uses this for change tracking in live view which means this data will be re-rendered when changed. We can use the `for` attribute to iterate through these values. The resulting template can be seen below:

```heex title="lib/phoenixlive_web/live/link_live/index.html.heex"
<h1>Links</h1>

<ol>
  <li :for={link <- @links}><%= link.url %>></li>
</ol>
```

## Creating a Link

We have a way to list links but we don't have anything in our database at this point, in order to do this we need to add a way to add links. First, we're going to add a link using the [LiveView Link Component](https://hexdocs.pm/phoenix_live_view/live-navigation.html). We're going to use the `navigate` property which will give us SPA like naviation along with the `~p` syntax for the route which will type check the URL we use relative to our app router and warn us if it does not exist:

```heex title="lib/phoenixlive_web/live/link_live/index.html.heex" ins={4-6}
<h1>Links</h1>

<.link navigate={~p"/new"}>
  Add Link
</.link>

<ol>
  <li :for={link <- @links}><%= link.url %>></li>
</ol>
```

Next, we can define our Live View and make it pass in a `form` attribute that can be used by our template to render a form. This makes use of a `changeset` and the `to_form` method to get the data into the form data structure. Additionally, we need to handle the `submit` event so that the user can submit the form and we will create the entry in our database

```elixir title=""
defmodule PhoenixliveWeb.LinkLive.New do
  alias Phoenixlive.Links
  use PhoenixliveWeb, :live_view

  def mount(_params, _session, socket) do
    changeset = Links.Link.changeset(%Links.Link{})

    socket = socket
    |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  def handle_event("submit", %{"link" => link_params}, socket) do
    user_id = socket.assigns.current_user.id

    params = link_params |> Map.put("user_id", user_id)

    case Links.create_link(params) do
      {:ok, _link} ->
        socket = socket
        |> put_flash(:info, "Link created successfully")
        |> push_navigate(to: ~p"/links")

        {:noreply, socket}

      {:error, changeset} ->
        socket = socket
        |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end
end
```

In the `handle_event` when the form is submitted we use `Links.create_link` to create a new link in the database using the `user_id` from the `socket.assigns`. We also use [`put_flash`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#put_flash/3) which will show a message to the user in the UI as well as [`push_navigate`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#push_navigate/2) which will navigate the user to another URL

When we have an error, we currently assign the changeset back to the form, an example of a changeset which deontes an error can be seen below:

```elixir
#Ecto.Changeset<
  action: :insert,
  changes: %{},
  errors: [
    user_id: {"can't be blank", [validation: :required]},
    url: {"is invalid", [type: :string, validation: :cast]}
  ],
  data: #Phoenixlive.Links.Link<>,
  valid?: false
>
```

Next, we can add a template for the `/links/new` route which references the LiveView Form Component that will use the `@form` data we pass into the template. We will also use the `.input` component from our `lib/phoenixlive_web/components/core_components.ex` file to render the fields for our form:

```heex title="lib/phoenixlive_web/live/link_live/new.html.heex"
<h1>Add Link</h1>

<.form for={@form} phx-submit="submit">
  <.input field={@form[:url]} type="text" label="url" />

  <button type="submit">Submit</button>
</.form>
```

In the form, we also use the `phx-submit` attribute which defines the event that our form submission will fire, this relates directly to the event we defined in our `handle_event` method above

And add a reference to this page in the router:

```elixir title="lib/phoenixlive_web/router.ex"
scope "/", PhoenixliveWeb do
  pipe_through [:browser, :require_authenticated_user]

  live_session :require_authenticated_user,
    on_mount: [{PhoenixliveWeb.UserAuth, :ensure_authenticated}] do
    live "/users/settings", UserSettingsLive, :edit
    live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

    live "/links", LinkLive.Index
    live "/links/new", LinkLive.New
  end
end
```

We should be able to visit the `/links/new` screen now to view our new page

## Making things Live

The thing that makes LiveView really "Live" is the ability to easily work with data and forms and have the result easily visible to a user. To do this, we'll add a delete button in our list view:

```heex title="lib/phoenixlive_web/live/link_live/index.html.heex" ins={10}
<h1>Links</h1>

<.link navigate={~p"/links/new"}>
  Add Link
</.link>

<ol>
  <li :for={link <- @links}>
    <%= link.url %>
    <button phx-click={JS.push("delete", value: %{id: link.id})}>Delete</button>
  </li>
</ol>
```

And then we'll implement the deletion logic similar to how we did for our previous event hander. In this case note that we reassign the `:links` property which will update this where it is used in the UI:

```elixir title="lib/phoenixlive_web/live/link_live/index.ex"
def handle_event("delete", %{"id" => id}, socket) do
  user_id = socket.assigns.current_user.id

  case Links.delete_link(%Links.Link{id: id}) do
    {:ok, _link} ->
      socket = socket
      |> assign(:links, Links.list_links(user_id))
      |> put_flash(:info, "Link deleted successfully")

      {:noreply, socket}

    {:error, _changeset} ->
      socket = socket
      |> put_flash(:error, "Error deleting link")

      {:noreply, socket}
  end
end
```

# Conclusion

The power of live view comes from us being able to write a fairly small amount of code and handle in a fairly straightforward mannner that let's us quite quickly go from simple forms to automatic live-updating UI without us having to think about it at all
