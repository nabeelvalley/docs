
Bolero is a framework for building full stack web application using F# on the server in .NET and in the browser with WASM and is based on Blazor and makes use of the Elmish application architecture

# Create a new app

To create a new Bolero application you need to:

1. Install .NET CLI templates

```bash
dotnet new -i Bolero.Templates
```

2. Create an app

To create an app with server and client you can use:

```bash
dotnet new bolero-app -o MyBoleroApp
```

This will output the following:

```bash
MyBoleroApp
|- src
  |- MyBoleroApp.Client
  |- MyBoleroApp.Server
```

You can then build the app with:

```bash
dotnet restore
dotnet build
```

Or run it using:

```bash
dotnet run -p src/MyBoleroApp.Server
```

Which will automatically use the hot reloading for the `HTML` template files

If you want full rebuilding on changes you can use `dotnet watch` like so:

```bash
dotnet watch -p src/MyBoleroApp.Server run
```
