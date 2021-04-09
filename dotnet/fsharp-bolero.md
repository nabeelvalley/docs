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