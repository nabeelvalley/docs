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

The same goes for integers, their methods are located in the `Integer` namespace

### Compound Types

Compound types are types that consist of many other values

For these compound types we can't use `IO.puts` to print them out since they're not directly stringable - we can instead use `IO.inspect` which will print them out in some way that makes sense for the data type as in the following example:

```elixir
time = Time.new(16,30,0,0)
IO.inspect(time)
```

### Dates and Times

We can create dates and times using their respective constructors:

```elixir
time = Time.new(16,30,0,0)
date = Date.new(2024, 1, 1)
```

In the above code the `new` functions return a result, if we want to unwrap this we can add a `!` in our function call:

```elixir
time = Time.new!(16,30,0,0)
date = Date.new!(2024, 1, 1)

dt = DateTime.new(date, time)
```

Unwrapping the values lets us use them directly if we want to, we can do this along with different functions for working with dates, e.g. converting it to a string:

```elixir
time = Time.new!(16,30,0,0)
date = Date.new!(2024, 1, 1)

dt = DateTime.new!(date, time)
IO.puts(DateTime.to_string(dt))
```

### Tuples

Tuples allow us to store multiple values in a single variable. Tuples have a fixed number of elements and they can be different data types. Tuples use `{}`

```elixir
bob = {"Bob Smith", 55}
```

We can also create a new tuple to which we append new values using `Tuple.append`

```elixir
bob = {"Bob Smith", 55}
bob = Tuple.append(bob, :active)

IO.inspect(bob)
```

We can also do math on tuples, for example as seen below:

```elixir
prices = {20,50, 10}
avg = Tuple.sum(prices)/tuple_size(prices)

IO.inspect(avg)
```

We can get individual properties out of a tuple using the `elem` method with the index:

```elixir
prices = {20,50, 10}
avg = Tuple.sum(prices)/tuple_size(prices)

IO.puts("Average of: #{elem(prices,0)}, #{elem(prices,1)}, #{elem(prices,2)} is #{avg}")
```

Or we can descructure the individual values:

```elixir
bob = {"Bob Smith", 55}
bob = Tuple.append(bob, :active)

{name, age, status} = bob

IO.puts("#{name} #{age} #{status}")
```

### Lists

Lists are used when we have a list of elements but we don't know how many elements we will have. Lists use `[]`

```elixir
user1 = {"Bob Smith", 44}
user2 = {"Alice Smith", 55}
user3 = {"Jack Smith", 66}

users = [
  user1,
  user2,
  user3
]

Enum.each(users, fn {name, age} ->
    IO.puts("#{name} #{age}")
  end)
```

We can also use the `Enum.each` method to iterate over these values as we can see above

### Maps

Maps are key-value pairs. Maps use `%{}`

```elixir
user1 = {"Bob Smith", 44}
user2 = {"Alice Smith", 55}
user3 = {"Jack Smith", 66}

members = %{
  bob: user1,
  alice: user2,
  jack: user3
}

{name, age}= members.alice
IO.puts("#{name} #{age}")
```

Maps are expecially useful since we will also get autocomplete for the fields that are in the map.

### Structs

Structs are used for defining types that have got defined structures

Structs can be defined within a module using the `defstruct` keyword. This is the struct that the module operates with:

```elixir
defmodule User do
  defstruct [:name, :age]
end
```

And we can create an instance of the struct using the `%Name{}` syntax

```elixir
user = %User{name: "Bob Smith", age: 55}
```

We can access properties of the struct using dot notation:

```elixir
user = %User{name: "Bob Smith", age: 55}

IO.puts(user.name)
```

### Random

We can get a random int using the following:

```elixir
random = :rand.uniform(11) -1
```

Whenever we use the `:name` syntax for accessing a namespace it means we are referring to some Erlang based code

### Piping

We can get user input using the `IO.gets` method:

```elixir
guess = IO.gets("Guess a number between 1 and 10: ") |> String.trim() |> Integer.parse()
```

In the above example we also use function piping to trim and parse the input string

### Pattern Matching

The above leads to the result being either a value or an error, we can use pattern matching to interpret this value:

```elixir
case guess do
  {result, ""} -> IO.puts("Fully parsed: #{result}")

  {result, other} -> IO.puts("Partially parsed: #{result} with #{other}")

  :error -> IO.puts("Failed to parse")
end
```

If we want to ignore the partial error case, we can use an `_`:

```elixir
case guess do
  {result, _}-> IO.puts("Parsed: #{result}")

  :error -> IO.puts("Failed to parse")
end
```

Combining the above, we can create a small guessing game:

```elixir
correct = :rand.uniform(11) - 1

guess = IO.gets("Guess a number between 0 and 10: ") |> String.trim() |> Integer.parse()

IO.inspect(guess)

case guess do
  {result, _} ->
    if result === correct do
      IO.puts("You guessed correctly!")
    else
      IO.puts("The correct answer is #{correct}, you said #{result}")
    end

  :error ->
    IO.puts("Failed to parse")
end
```

### List Comprehension

List comprehension is used for doing some operation for each item in a list, the syntax is as follows:

```elixir
values = [25, 50, 75, 100]

for n <- values, do: IO.puts("value: #{n}")
```

We can also assign the result of the `do` to a new array

```elixir
values = [25, 50, 75, 100]

double_values = for n <- values, do: n * 2
```

We can also combine a comprehension with a condition:

```elixir
values = [25, 50, 75, 100]

evens = for n <- values, n > 50, do: "Value is: #{n}"
```

> The condition in the above example is `n > 50` but this can be anything that evaluates to a boolean

### Appending to Lists

If we want to append to a list we can use the `++` operator:

```elixir
values = [25, 50, 75, 100]

added_values = values ++ [101, 102]
```

### Prepending to a List

We can use the `|` operator to prepend to a list using the following syntax:

```elixir
values = [25, 50, 75, 100]

added_values = [101, 102 | values]
```

### Function Arity

The arity of a function refers to how many parameters the fuction takes. In elixir functions use the `/` t ndicate the arity. This is because we may have multiple functions with the same name in a module that each have a different arity. For example, there are two versions of `String.split` which take one and two parameters. We refer to these as `String.split/1` and `String.split/2` respectively:

```elixir
# split by whitespace `String.split/1`
a = String.split("hello world, how are you?")
IO.inspect(a)

# split by comma `String.split/2`
a = String.split("hello world, how are you?", ",")
IO.inspect(a)
```

### Passing Functions as Parameters

We can pass anonymous functions to other functions:

```elixir
values = [25, 50, 75, 100]

result = Enum.map(values, fn n -> Integer.to_string(n) end)
```

We can pass fuctions to other functions. For example, equivalent to the above:

```elixir
values = [25, 50, 75, 100]

result = Enum.map(values, &Integer.to_string/1)
```

> The `&` operator converts a function to an anonymous function. This requires that we also specify the arity of a function so that we can pass the correct instance as a callback

### Defining Functions

We can define functions using the `def name do ... end` syntax:

```elixir
def sum(a,b) do
  a + b
end
```

And we can use this:

```elixir
result = sum(5,32)

values = [25, 50, 75, 100]
result = Enum.reduce(values, &Example.sum/2)
```

Another small example is a function for printing out a list of numbers:

```elixir
def print_numbers(lst) do
  lst |> Enum.join(" | ") |> IO.puts()
end
```
