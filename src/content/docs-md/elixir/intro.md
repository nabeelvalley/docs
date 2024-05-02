---
title: Introduction to Elixir
description: Elixir syntax and basic concepts
---

> Notes from the [Elixir Programming Introduction YouTube Video](https://www.youtube.com/watch?v=-lgtb-YSUWE)

# Installation and Setup

## Installation

1. Follow the installation instructions as per the [Elixir Docs](https://elixir-lang.org/install.html) for your operating system
2. Install the Elixir Language Server for VSCode (`JakeBecker.elixir-ls`)
3. Install the Elixirt Formatter for VSCode (`saratravi.elixir-formatter`)

You can text the installation by opening the Elixir repl using `iex` (interactive elixir) in your terminal

## Running Code

To start writing some code, we just need to create a file wih an `exs` extension

```elixir title="intro.exs"
IO.puts("Hello World")
```

You can then run it using:

```sh
elixir intro.exs
```

> In general, we use `exs` for code that we will run using the interpreter and `ex` for code we will compile

## Mix

Mix is a tool for working with Elixir code. We can use the `mix` command to create and manage Elixir projects

# Programming in Elixir

## Creating a Project

We can create an example project with some code in it by using `mix new`, we can create a project like so:

```sh
mix new example
```

This should show the following output:

```sh
* creating README.md
* creating .formatter.exs
* creating .gitignore
* creating mix.exs
* creating lib
* creating lib/example.ex
* creating test
* creating test/test_helper.exs
* creating test/example_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd example
    mix test

Run "mix help" for more commands.
```

For our sake,. we'll be working in the `lib/example.ex` file which defines the module for our application

A module is effectively a mainspace which is within the `do...end` block. We also have a `hello` function in our module. The generated file can be seen below:

```elixir title="lib/example.ex"
defmodule Example do
  @moduledoc """
  Documentation for `Example`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Example.hello()
      :world

  """
  def hello do
    :world
  end
end
```

### Interacting with a Module

We can compile the project using:

```sh
mix compile
```

Then, we can interact with this code interactively using `iex`

```sh
iex -S mix
```

Thereafter we will find ourself with the module loaded into the interactive session, we can interact with the code that we loaded via the module like:

```sh
# within the Elixir REPL
iex(1)> Example.hello
```

Next, you can run the function using mix

```sh
mix run -e "Example.hello"
```

In the case when we use `mix` the result of the function will not be output since it is nit printed using `IO.puts`

### Running a Project

> Something important to know - code outside of the module definition is executed when the code is compiled, not during runtime

We can define an entrypoint at our application configuration level - this is done in the `mix.exs` file:

```elixir title="mix.exs" mark={5}
  # ... rest of file
  def application do
    [
      # define our entry module
      mod: {Example, []},
      extra_applications: [:logger]
    ]
  end
  # ... rest of file
```

Next, we need to provide a start method in our module that will be called when the app is run. We can clear out our `Example` module and will just have the following:

```elixir title="lib/example.ex" mark={5-8}
defmodule Example do
  use Application

  # `mix run` looks for the `start` function in the module
  def start(_type, _args) do
    IO.puts("App Starting")
    Supervisor.start_link([], strategy: :one_for_one)
  end
end
```

In the above, we use the `_` prefix to denote that we're not using those parameters - if we remove these we will get warnings when using `mix`

We can run the above code using either `mix` or `mix run`:

```sh
# `mix` is shorthand for `mix run`
mix run
```

The above line with `Supervisor.start_link` isn't really doing anything as yet - but it is needed to satisfy the requirement of Elixir that the app returns a supervision tree

### Dependencies

Dependencies in Elixir can be installed using `hex` which is Elixir's package manager. We can set this up by using:

```sh
mix local.hex
```

We can then look for packages on [Hex Website](https://hex.pm/packages). For the sake of example we're going to install the `uuid` package. We do this by adding it to the `mix.exs` file:

```elixir title="mix.exs" mark={3}
  defp deps do
    [
      {:uuid, "~> 1.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
```

Therafter, run the following command to install the dependencies:

```sh
mix deps.get
```

We can then use the package we installed in our code:

```elixir title="lib/example.ex" mark={3,7}
defmodule Example do
  use Application
  alias UUID

  # `mix run` looks for the `start` function in the module
  def start(_type, _args) do
    IO.puts(UUID.uuid4())

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
```

## Syntax

### Defining Variable Bindings

```elixir
def main() do
  # binding a variable
  x = 5
  IO.puts(x)

  # can re-bind a variable
  x=10
  IO.puts(x)
end
```

You can also implement constants at the module level by using `@` as follows:

```elixir
@y  15

def main() do
  IO.puts(@y)
end
```

### Atoms and Strings

Atoms are kind of like an alternative to a string. These values have the same name and value and are constant - these cannot be randomly defined by users

We prefer to use atoms for static values since these have better performance since certain things like comparing values can be done based on memory location for atoms instead of value for strings

```elixir
str = "Hello World"
atm = :hello_world
atm = :"Hello World"
```

> We can also have spaces and special characters in atoms provided we enclose it in quotes

### Conditional Statements

Conditions use the following syntax:

```elixir
status = Enum.random([:gold, :silver, :bronze])

if status === :gold do
  IO.puts("First Place")
else
  IO.puts("You Lose")
end
```

We can do equality checking using `===` or `==` which is less strict (a bit like javascript)

### Case Statements

```elixir
status = Enum.random([:gold, :silver, :bronze, :something_else])

case status do
  :gold -> IO.puts("Winner")
  :silver -> IO.puts("Scond Place")
  :bronze -> IO.puts("You Lose")

  _  -> IO.puts("What are you doing here?")
end
```

In the above, we use the `_` as a default case

### Strings

`IO.puts` prints a string and adds a newline at the end. Strings can contain special characters and expressions as well as as various other things like unicode character codes

```elixir
name = "Bob Smith"
message = "Our new Employee is:\n  - #{name}"

IO.puts(message)
```

### Numbers

```elixir
# integer
x = 5

# float
y= 3.0

# if all inputs are int then z is int, otherwise it will be a float
z = x + y
```

Elixir is dynamically typed so it doesn't care too much about how we work with these kinds of data types

The float type is 64 bit in Elixir and there is no double type

We can also format and print numbers using `:io.format`:

```elixir
x = 0.1
:io.format("~.20f", [x])
```

Formatting the above also shows us that we don't have very high precision using floats as normally using floating points values

There are also numerous other methods for working with numbers contained in the `Float` namespace. For example the `ceil` method:

```elixir
x = 0.1234
r = Float.ceil(x,2)
```
