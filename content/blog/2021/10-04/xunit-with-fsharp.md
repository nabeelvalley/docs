
An important part of writing any software is testing. Unit testing is an automated testing method in which we test individual components of our software to verify that their behaviour aligns with our expectations

This post will take a look at the process of setting up a new F# library and two methods of configuring XUnit to test your project's code

[[toc]]

# Create a Project

Before we can start testing we need a project that we can run tests on

First, we're going to create a folder that we can work in:

```bash
mkdir MyProject
cd MyProject
```

We can use the following command to create a new project in our `MyProject` directory:

```bash
dotnet new classlib -lang=f# -o MyProject.Lib
```

The project that we created will contain the following `Library.ts` file, this is the file that we'll write tests for. First, we want to update the `hello` function so that it returns a formatted string:

`MyProject.Lib/Library.fs`

```fs
namespace MyProject.Lib

module Say =
    let hello name =
        sprintf "Hello %s" name
```

# Adding Tests

Depending on our preferred project structure we can either:

1. Add tests in a separate project
2. Add test files alongside lib files

## Method 1: Create Tests in Separate Project

The standard method of .NET unit testing with XUnit is to make use of separate Project and Test solutions, so a normal test setup would look something like:

```
MyProject.Lib
MyProject.Lib.Tests
```

To add an new XUnit test project you can run:

```bash
dotnet new xunit -lang=f# -o MyProject.Tests
```

Then, so we're able to test the code from `MyProject.Lib`, we need to add a reference to it from the Test project we just created:

```bash
dotnet add MyProject.Tests reference MyProject.Lib
```

Then we can create a file in our test project called `LibraryTests.fs` which will contain our test code which we will cover in the last section, as well as adding a reference to this file in the `MyProject.Tests.fsproj`

`MyProject.Tests.fsproj`

```xml
...
  <ItemGroup>
    <Compile Include="Tests.fs" />
    <!-- Add the next line -->
    <Compile Include="LibraryTests.fs" /> 
    <Compile Include="Program.fs" />
  </ItemGroup>
...
```

## Method 2: Create Tests Alongside Lib Files

The second method I'm going to discuss is keeping our `test.fs` files alongside the code that the file is testing. The structure of our project is something more like this:

```bash
MyProject.Lib
|- Library.fs
|- Library.test.fs
```

Overall I find this more manageable is the way I keep my test code in other languages and frameworks as well

To implement this method we need to add some dependencies to our project

```bash
cd MyProject.Lib
dotnet add package Microsoft.NET.Test.Sdk
dotnet add package xunit
dotnet add package xunit.runner.visualstudio
```

Then we can create a file in our project called `Library.test.fs` which will contain our test code which we will cover next, as well as a reference to this file in the `MyProject.Lib.fsproj`

`MyProject.Lib.fsproj`

```xml
...
  <ItemGroup>
    <Compile Include="Library.fs" />
    <!-- Add the next line -->
    <Compile Include="Library.test.fs" />
  </ItemGroup>
...
```

It's important to note that this file must be added below the `Library.fs` file as it will reference it for tests to run

# Test Files

> More detailed information on XUnit can be found in [Unit Testing notes](/docs/dotnet/unit-testing-intro)

Since we've configured XUnit it may be useful to understand how these tests work in the context of F#. XUnit tests are organized into modules. Regardless of which of the two methods above you're using the test files work the same

Generally, a test file will contain:

1. A top-level module definition
2. `open` statements to import XUnit
3. Test functions annotated with `Fact` or `Theory`

XUnit tests can be broken into 2 types:

1. Single-case tests without input parameters inputs are labelled `Fact`
2. Multi-case tests which make use of input parameters are labelled `Theory` and use `InlineData`

## Fact

Let's add the following content into our test file into one that tests the `hello` function from our `Lib` code with the input `"Name"`

`LibraryTests.fs/Library.test.fs`

```fs
module LibraryTests

open Xunit
open MyProject.Lib.Say

[<Fact>]
let ``Say.hello -> "Hello name" `` () =
    let name = "name"
    let expected = "Hello name"
    
    let result = hello name

    Assert.Equal(expected, result)
```

F# allows us to name our functions using special characters provided they're enclosed in backticks as seen above. Naming test functions this way allows them to be more discriptive than more traditional variable names

Additionally, there's the normal XUnit test setup which includes calling our test function with some input and asserting something about it using `Assert.Equal` from `XUnit`

## Theory

We can add a `Theory` to test our function with multiple different inputs:

`LibraryTests.fs/Library.test.fs`

```fs
[<Theory>]
[<InlineData("name", "Hello name")>]
[<InlineData("World", "Hello World")>]
let ``Say.hello -> concantenated string`` (name:string, expected: string) =
    let result = hello name

    Assert.Equal(expected, result)

```

In the above we add the `InlineData` attribute which allows us to provide inputs to our test, as well as specifying a `name` and `expected` argument for our function. The test framework will then call our test using the arguments as specified in `InlineData`

When we're done our test file should have the following content:

```fs
module LibraryTests

open Xunit
open MyProject.Lib.Say

[<Fact>]
let ``Say.hello -> "Hello name" `` () =
    let name = "name"
    let expected = "Hello name"
    
    let result = hello name

    Assert.Equal(expected, result)

[<Theory>]
[<InlineData("name", "Hello name")>]
[<InlineData("World", "Hello World")>]
let ``Say.hello -> concantenated string`` (name:string, expected: string) =
    let result = hello name

    Assert.Equal(expected, result)
```

# Running Tests

In order to run tests we can use the `dotnet-cli`. Depending on the method used you can run your test from the project's root directory using the following command:

- **Method 1** - `dotnet test MyProject.Tests`
- **Method 2** - `dotnet test MyProject.Lib`

Alternatively, tests can also be run from your IDE or Visual Studio Code with the `Ionide` and `.NET Core Test Explorer` extensions installed

# Additional Resources

If you'd like a deeper look into F# or XUnit here are some of my other posts which cover those:

- [Introduction to F# Web APIs](/blog/2019/30-10/fsharp-webapi)
- [Introduction to F#](/docs/dotnet/intro-to-fs)
- [Entity Framework with F#](/docs/dotnet/fs-entity-framework)
- [Introduction to Unit Testing](/docs/dotnet/unit-testing-intro)
- [Testing Private Members](/docs/dotnet/test-private-members)

> Nabeel Valley
