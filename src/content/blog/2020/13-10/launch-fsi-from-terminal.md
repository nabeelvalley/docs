---
published: true
title: Scripting with FSharp
subtitle: 13 October 2020
description: Using the .NET CLI to use the F# Interactive console and run F# Scripts
---

> Before you can use the following, you will need the [.NET Core SDK installed](https://dotnet.microsoft.com/download)

# Open the F# Interactive Console

To open an F# interactive console using the `dotnet` CLI. You can run the following command:

```sh
dotnet fsi
```

> Note that to end statements/execute in the F# Interactive console use `;;` at the end of a line or section of code

Once in the console, running `#help;;` from the `fsi` console to view the help menu, and `#quit;;` to quit the interactive session

Additionally, you can write multi-line `F#` code as well as just single line expressions. Each expression should be terminated with `;;`. For example, you can write a function that will print some data into the console:

```fs
let printer s =
    printfn s
;;
```

Next, you can call the function with:

```fs
printer "Hello World";;
```

Which will execute the above code and output `Hello World`

# Run an F# Script

F# scripts can be run using the `dotnet fsi` command as well, followed by the path to an F# script file:

```sh
dotnet fsi ./myscript.fsx
```
