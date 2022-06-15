> From the [Ruby Documentation](https://www.ruby-lang.org/en/documentation/quickstart/)

# Interactive Ruby

We can use `irb` to run an interactive Ruby shell, when open, it will look like this:

```rb
irb(main):001:0> 
```

Once we've got that open, we can type a value, and the interactive shell will evaluate it

```rb
irb(main):001:0> "Hello World" 
=> "Hello World"
```

Though, to formally print something we can use `puts` like so:

```rb
irb(main):002:0> puts "Hello World" 
Hello World
=> nil
```

We can also see that the result of the `puts` command is `nil` which is the Ruby version of a nothing value

# Math

We can do basic math using IRB as well, like so:

```rb
irb(main):004:0> 5*7
=> 35
irb(main):005:0> 5**7
=> 78125
irb(main):006:0> Math.sqrt(5)
=> 2.23606797749979
irb(main):007:0> Math.sin(0)
=> 0.0
irb(main):008:0> Math.acos(1)
=> 0.0
```

# Methods

## Defining a Method

We can define a method using `def` and `end`, so a method that prints `Hello World` would look like this:

```ruby
def hi
  puts "Hello World"
end
```

Or, in the shell

```ruby
irb(main):017:0> def hi
irb(main):018:1> puts "Hello World"
irb(main):019:1> end
=> :hi
```

## Calling a Method

We can then call a method using either the name of the method, or the name followed by `()` if the method has no inputs

```ruby
irb(main):020:0> hi
Hello World
=> nil
irb(main):021:0> hi()
Hello World
=> nil
```

## Method Parameters

We can define `hi` such that it takes a `name` parameter like so:

```ruby
def hi(name)
  puts "Hello #{name}"
end
```

> Also note how string interpolation/templates can be done in the above string

```ruby
irb(main):026:0> hi("bob")
Hello bob
=> nil
```

We can also call methods on an object, for example `name` by using either the method name with or without parenthesis as mentioned before

```ruby
name.capitalize
```

```ruby
name.capitalize()
```

We can then implement that in our `hi` method

```ruby
def hi(name)
  puts "Hello #{name.capitalize}"
end
```

Which can be called like:

```ruby
hi("bob")
```

or

```ruby
hi "bob"
```

# Classes

Classes are defined using the `class` keyword

```ruby
class Greeter
  def initialize(name = "World")
    @name = name
  end

  def say_hi()
    puts "Hi #{@name}"
  end

  def say_bye()
    puts "Hi #{@name}"
  end
end
```

We can create an instance of the `Greeter` class by using `Greeter.new`, like so

```ruby
greeter = Greeter.new("bob")
```

And we can then use it with:

```ruby
irb(main):029:0> greeter.say_hi
Hi bob
=> nil
irb(main):030:0> greeter.say_bye
Hi bob
=> nil
```