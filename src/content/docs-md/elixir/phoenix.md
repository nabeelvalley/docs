---
title: Web Apps using the Elixer Phoenix Framework
published: false
---

> Notes based on [Phoenix Framework REST API Crash Course](https://www.youtube.com/watch?v=9xaN44PNxps)

# Prerequisites

Probably take a look at the [Elixir Notes](./intro) first

In order to get started the following are required:

- [Elixir](https://elixir-lang.org/install.html)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html)

It's also handy to have the following installed if using VSCode:

- [DevDb VSCode Exetension](https://marketplace.visualstudio.com/items?itemName=damms005.devdb)
- [Elixir Language Server for VSCode](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls)
- [Thunder Client](https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client)

# Create the Application

Mix is a build tool for Elixir - To create the application we will use the `mix` CLI along with the Phoenix template

```sh
mix phx.new elixirphoenix --database sqlite3
```

In the above setup we're going to use SQLite as the database. You can find the configuration for this in `config/dev.exs`

> The databse is fairly abstracted from our application so the overall implementation shouldn't differ too much other than in some configuration

Thereafter, you can start your application using:

```sh
mix phx.server
```

In future, when updating dependencies the following command can be used to install dependencies:

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
│   ├── elixirphoenix       // Model - business logic
│   ├── elixirphoenix.ex
│   ├── elixirphoenix_web   // View and Controller - exposes business logic to API
│   └── elixirphoenix_web.ex
├── priv  // resources necessary in production but not exactly source code - e.g. migrations
└── test
mix.exs   // basic elixir project configuration and dependencies
mix.lock  // dependency lockfile
```

Some of the important files we have are:

- `mix.ex` - dependencies and project meta
- `config/dev.ex` - development config - particularly database config
- `lib/elixirphoenix_web/router.ex` - application routes

# Routing

We can take a look at the `router.ex` file to view our initial app structure:

```elixir title="lib/elixirphoenix_web/router.ex" mark={20}
defmodule ElixirphoenixWeb.Router do
  use ElixirphoenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixirphoenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirphoenixWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirphoenixWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixirphoenix, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirphoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
```

In the above we can se that we are using the `PageController`, the `PageController` is defined also as:

```elixir title="lib/elixirphoenix_web/controllers/page_controller.ex"
defmodule ElixirphoenixWeb.PageController do
  use ElixirphoenixWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
```

The above is rendering the `:home` page which we can find by the `lib/elixirphoenix_web/controllers/page_html/home.html.heex` which is just a template file. We can replace the contents with a simple hello world

```html title="lib/elixirphoenix_web/controllers/page_html/home.html.heex"
<h1>Hello World</h1>
```

## Creating a Route

In general, we follow the following process when adding routes to our application:

1. We go to the router file and define a reference to our routes
2. We go to the controller file and define the routes which may render a template
3. We go to the template file which renders our content

Let's create a route in the `PageController` called `users`. Do this we need to asadd a reference to it in the `router.ex` file:

```elixir title="lib/elixirphoenix_web/router.ex" mark={5}
scope "/", ElixirphoenixWeb do
  pipe_through :browser

  get "/", PageController, :home
  get "/users", PageController, :users
end
```

Next, we can add a function in the `PageController` called `users` as we defined by `:users` above:

```elixir title="lib/elixirphoenix_web/controllers/page_controller.ex"
def users(conn, _params) do
  IO.puts("/users endpoint called")
  users = [
    %{id: 1,name: "Alice", email: "alice@email.com"},
    %{id: 2,name: "Bob", email: "bob@email.com"},
  ]

  render(conn, :users, users: users, layout: false)
end
```

And we can create a `users.html.heex` file:

```heex title="lib/elixirphoenix_web/controllers/page_html/users.html.heex"
<h1>Users</h1>

<ul>
  <%= for user <- @users do %>
    <li><%= user.name %> - <%= user.email %></li>
  <% end %>
</ul>
```

In the `heex` file above, the elixir code that is embedded in the template is denoted by the `<%= ... %>`.

> `HEEx` stands for **HTML + Embedded Elixir**

# Working with Data

Phoenix

# Defining a JSON resource

We can use phoenix and mix to generate and inialize a resource using the Mix CLI

We're going to generate a simple entity called a `Post` for our application

```sh
mix phx.gen.json Posts Post posts title:string body:string
```

> The above commands are in the structure of `Context Entity dbtable ...fields`

The `Context` is an elixir module that will be used to contain all the related functionality for a given entity. For example we may have a `User` in multiple different `Contexts` such as `Accounts.user` and `Payments.user`

The above commands will generate the relvant modules and JSON code for interacting with application entities:

- Controllers for each resource
- Entity schemas for each resource
- Migrations for each resource

Overall, when working with phoenix, we use the Model-View-Controller architecture (MVC), when building an API, we can think of the JSON structure as the view for the sake of our API

After running the above command we will have some instructions telling us to add some content to the `router.ex` file. We're going to first create a new scope and add it into that scope:

```elixir title="lib/elixirphoenix_web/router.ex"
scope "/api", ElixirphoenixWeb do
  pipe_through :api

  resources "/posts", PostController, except: [:new, :edit]
end
```

Next, we need to run the following command as instructed:

```sh
mix ecto.migrate
```

Which will run the database migration that sets up the posts which was generated during the above command:

```elixir title="priv/repo/migrations/20240508103250_create_posts.exs"
defmodule Elixirphoenix.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string

      timestamps()
    end
  end
end
```

This sets up the database to work with the `Post` entity that was generated which can be seen below:

```elixir title="lib/elixirphoenix/posts/post.ex"
defmodule Elixirphoenix.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
```

Which we then access from the controller that we exposed earlier in our router:

```elixir title="lib/elixirphoenix_web/controllers/post_controller.ex"
defmodule ElixirphoenixWeb.PostController do
  use ElixirphoenixWeb, :controller

  alias Elixirphoenix.Posts
  alias Elixirphoenix.Posts.Post

  action_fallback ElixirphoenixWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, :index, posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/posts/#{post}")
      |> render(:show, post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, :show, post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
      render(conn, :show, post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
```

If we run our app now using `mix phx.server` we can go to `http://localhost:4000/api/posts` where we will see the date returned by our controller:

```json title="GET http://localhost:4000/api/posts"
{
  "data": []
}
```

We can also do the same request using Nushell or any other HTTP Client you want

This is empty since we have nothing in our database as yet. We can create a POST request with the data for a user to the same endpoint which will create a new Post using the following:

```jsonc title="POST http://localhost:4000/api/posts"
// REQUEST
{
  "post": {
    "title": "My Post Title",
    "body": "Some content for my post"
  }
}

// RESPONSE
{
  "data": {
    "id": 1,
    "title": "My Post Title",
    "body": "Some content for my post"
  }
}
```

The above is the format of our API though we can change this if we wanted. The method handling the above request can be seen below:

```elixir title="lib/elixirphoenix_web/controllers/post_controller.ex"
def create(conn, %{"post" => post_params}) do
  # pattern match the result of post creation with an ok status
  with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", ~p"/api/posts/#{post}")
    |> render(:show, post: post)
  end
end
```

If we post invalid data we will return an error depending on the data we send as will be defined from the

We can also see in the above that we return data using the `render(:show, post: post)` call, this renders the response using the following template:

```elixir title="lib/elixirphoenix_web/controllers/post_json.ex"
defmodule ElixirphoenixWeb.PostJSON do
  alias Elixirphoenix.Posts.Post

  @doc """
  Renders a list of posts.
  """
  def index(%{posts: posts}) do
    %{data: for(post <- posts, do: data(post))}
  end

  @doc """
  Renders a single post.
  """
  def show(%{post: post}) do
    %{data: data(post)}
  end

  defp data(%Post{} = post) do
    %{
      id: post.id,
      title: post.title,
      body: post.body
    }
  end
end
```
