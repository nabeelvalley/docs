[[toc]]

So we're going to be taking a bit of a look on how you can go about building your first F# Web API using .NET Core. I'm going to cover a lot of the basics, a lot of which should be familiar to anyone who has worked with .NET Web Applications and F# in general.

Along the way I'm also going to go through some important concepts that I feel are maybe not that clear from a documentation perspective that are actually super relevant to using this F# in a real-life context

> If you're totally new to F# though you may want to take a look at <a href="https://fsharpforfunandprofit.com/" target="_blank">F# for Fun and Profit</a> or my personal quick reference documentation over on <a href="https://github.com/nabeelvalley/Docs/blob/master/dotnet/intro-to-fs.md" target="_blank">GitHub</a>

# Getting Started

Assuming you've got the .NET Core SDK with F# installed, you can simply create a new project with the following:

```
dotnet new webapi --language F# --name FSharpWebApi

code .\FSharpWebApi
```

> Alternatively, if you're feeling a little _unexperimental_ you can use the Visual Studio project creation wizard, psshhtt

Once you have the project open you can run the following command to launch the application:

```
dotnet run
```

Which should start the application on `https://localhost:5001` and `http://localhost:5000`, you can see the current existing endpoint at `/weatherforecast`, this is handled by the `Controllers/WeatherForecastController.fs` file

# Looking Around

Looking at the structure of the project files you should see the following:

```
FSharpWebApi
│   appsettings.Development.json
│   appsettings.json
│   FSharpWebApi.fsproj
│   Program.fs
│   Startup.fs
│   WeatherForecast.fs
│
├───Controllers
│       WeatherForecastController.fs
│
└───Properties
        launchSettings.json
```

So, mostly we see the typical Web API stuff that we'd expect for a C# project such as the `startup` and `program` files. In F# they serve pretty much the same purpose.

Looking at the `Program.fs` file we can see that it contains the `main` function and configures the Web Host, next we can see that the `Startup.fs` file contains the usual configuration methods. We should note that the method calls within these functions are piped to an `ignore` so the the functions to not return their respective `Builders` as this will break the application

The `Program.fs` and `Startup.fs` files can be seen below

`Program.fs`

```fs
namespace FSharpWebApi

module Program =
    let exitCode = 0

    let CreateHostBuilder args =
        Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(fun webBuilder ->
                webBuilder.UseStartup<Startup>() |> ignore
            )

    [<EntryPoint>]
    let main args =
        CreateHostBuilder(args).Build().Run()

        exitCode
```

`Startup.fs`

```fs
namespace FSharpWebApi

type Startup private () =
    new (configuration: IConfiguration) as this =
        Startup() then
        this.Configuration <- configuration

    // This method gets called by the runtime. Use this method to add services to the container.
    member this.ConfigureServices(services: IServiceCollection) =
        // Add framework services.
        services.AddControllers() |> ignore

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    member this.Configure(app: IApplicationBuilder, env: IWebHostEnvironment) =
        if (env.IsDevelopment()) then
            app.UseDeveloperExceptionPage() |> ignore

        app.UseHttpsRedirection() |> ignore
        app.UseRouting() |> ignore

        app.UseAuthorization() |> ignore

        app.UseEndpoints(fun endpoints ->
            endpoints.MapControllers() |> ignore
            ) |> ignore

    member val Configuration : IConfiguration = null with get, set
```

Next we have the `FSharpWebApi.fsproj` file which contains references to the relevant code files. It's important to note that the order of the files in the `ItemGroup` specifies the order that files depend on each other. Lower files depend on files higher up

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">

  <PropertyGroup>
    <TargetFramework>netcoreapp3.0</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <Compile Include="WeatherForecast.fs" />
    <Compile Include="Controllers/WeatherForecastController.fs" />
    <Compile Include="Startup.fs" />
    <Compile Include="Program.fs" />
  </ItemGroup>

</Project>
```

Lastly, we have a controller that resides in the `Controllers/WeatherForecastController.fs` with its types defined in the `WeatherForecast.fs` file. Looking at the `WeatherForecast.fs` file we can see that the type has a few simple properties and one function

`WeatherForecast.fs`

```fs
namespace FSharpWebApi

open System

type WeatherForecast =
    { Date: DateTime
      TemperatureC: int
      Summary: string }

    member this.TemperatureF =
        32 + (int (float this.TemperatureC / 0.5556))
```

Next up, we can see the controller which contains a single `GET` endpoint which delivers a random array of weather forecasts. Here we can see a few different things. First, the namespace is `FSharpWebApi.Controllers`, this pretty much follows the .NET standard of the Namespace being related to the Folder name, we can also see the `ApiController` attribute that adds <a href="https://docs.microsoft.com/en-us/aspnet/core/web-api/?view=aspnetcore-3.0#apicontroller-attribute" target="_blank">some useful functionality</a> for basic API handling and the `Route` attribute that states the controller route

The `WeatherForecastController` type defines the controller and that it inherits from `ControllerBase`, additionally the constructor requires the `ILogger` service which will be provided by DependencyInjection

Lastly, looking at the `__Get` method we can see the `HttpGet` attribute that specifies that this is a Get Method, and the `__` shows that we don't care about references to the function's `this`, and the return type for the function is an `array` of `WeatherForecast`

`WeatherForecastController.fs`

```fs
namespace FSharpWebApi.Controllers

open System
open Microsoft.AspNetCore.Mvc
open Microsoft.Extensions.Logging
open FSharpWebApi

[<ApiController>]
[<Route("[controller]")>]
type WeatherForecastController (logger : ILogger<WeatherForecastController>) =
    inherit ControllerBase()

    let summaries = [| "Freezing"; "Bracing"; "Chilly"; "Cool"; "Mild"; "Warm"; "Balmy"; "Hot"; "Sweltering"; "Scorching" |]

    [<HttpGet>]
    member __.Get() : WeatherForecast[] =
        let rng = System.Random()
        [|
            for index in 0..4 ->
                { Date = DateTime.Now.AddDays(float index)
                  TemperatureC = rng.Next(-20,55)
                  Summary = summaries.[rng.Next(summaries.Length)] }
        |]
```

# Creating a Controller

Creating a new controller is not particularly complex given that we have the above as a starting point.

# Get Handler

We're going to create a handler that is able to return a simple message for an `even` param, and a `404` for a `odd` param in order to look at how we can return actual response codes in cases where we aren't always able to return something of a constant type

First, we can create a `Controllers/MessageController.fs` file with just some basic scaffolding to start with. We'll define a `Get` controller that just returns the `id` it receives as a route param multiplied by two if the the result `shouldDouble` param is set to `true`. Additionally we can see the `sprint` function used to format the output as a string

Before we can add the data to the actual controller we need to add the `<Compile Include="Controllers/MessageController.fs" />` to the `ItemGroup` in the `FSharpWebApi.fsproj` file, :

`FSharpWebApi.fsproj`

```xml
  <ItemGroup>
    <Compile Include="WeatherForecast.fs" />
    <Compile Include="Controllers/WeatherForecastController.fs" />
    <Compile Include="Controllers/MessageController.fs" />
    <Compile Include="Startup.fs" />
    <Compile Include="Program.fs" />
  </ItemGroup>
```

And then we can put together the controller in the `MessageController.fs` file:

`MessageController.fs`

```fs
namespace FSharpWebApi.Controllers

open Microsoft.AspNetCore.Mvc
open Microsoft.Extensions.Logging

[<ApiController>]
[<Route("[controller]")>]
type MessageController (logger : ILogger<MessageController>) =
    inherit ControllerBase()

    [<HttpGet("{id}")>]
    member __.Get (id : int, shouldDouble : bool) : string=
        logger.LogInformation("I am a controller")

        let result =
            match shouldDouble with
            | true -> id * 2
            | false -> id

        sprintf "Hello %d" result
```

From the function's signature we can see that it has an `id` and `shouldDouble` values as inputs and that it returns a string. We have made these explicit however if we were to leave them out it would be fine too as F# would be able to infer the types, see that below:

We can open the following URLs in our browser and should be able to open the `/message/3` and `/message/3?shouldDouble=true` routes and see `hello 3` and `hello 6` respectively

> Note that if not specified the handler inputs will try to be parsed from the body

Now, if we would want to update this to return some sort of general HTTP Response Code when a user sends some kind of input, for example if the `result` is 4, we will need to modify the function such that we are able to reference the `this` and the return type of the function is now an `IActionResult`

```fs
[<HttpGet("{id}")>]
member this.Get (id : int, shouldDouble : bool) : IActionResult =
    logger.LogInformation("I am a controller")

    let result =
        match shouldDouble with
        | true -> id * 2
        | false -> id

    match result with
    | 4 -> this.NoContent() :> IActionResult
    | _ ->
        sprintf "Hello %d" result
        |> this.Ok
        :> IActionResult
```

From this we can see that we are using an additional match to either return `this.NoContent()` as an `IActionResult` or `this.Ok` with the piped message as an `IActionResult`. Just note that the following matches are equivalent:

```fs


// call the `this.Ok` function with
match result with
| 4 -> this.NoContent() :> IActionResult
| _ ->
    this.Ok(sprintf "Hello %d" result) :> IActionResult

// pipe the result of the format through
match result with
| 4 -> this.NoContent() :> IActionResult
| _ ->
    sprintf "Hello %d" result
    |> this.Ok
    :> IActionResult

// pipe the result of the format through on a single line
match result with
| 4 -> this.NoContent() :> IActionResult
| _ -> sprintf "Hello %d" result |> this.Ok :> IActionResult
```

# Post Handler

We can also create a `POST` handler that will pretty much do the same as the above handler, we can pretty much just take the values from the function body and pass it to the previous handler we put together

Before we can create the handler, we need to create a type called `PostData` that can be used by the method to receive data, we can define this towards the top of the file, above the type definition for our `MessageController`. The type also needs to have the `CLIMutable` attribute so that the JSON deserializer can parse the data from the post body into it correctly

```fs
[<CLIMutable>]
type PostData =
    { id : int
      shouldDouble : bool }
```

Next we simply need to define the `Post` method with an `HttpPost` attribute which will just call the `this.Get` using the input params. this can be done pretty simply too

```fs
[<HttpPost>]
member this.Post(data : PostData) : IActionResult =
    this.Get(data.id, data.shouldDouble)
```

And that's really all that's needed

# Conclusion

So yeah, that's pretty much it - Not that bad right? I feel like there are a couple of things that feel a little bit weird because of the pieces of OOP running around from C# that add a bit more overhead than I'd like, but it's .NET, that's inevitable

Still a few more to posts on F# to come, so stay in tuned

> Nabeel Valley
