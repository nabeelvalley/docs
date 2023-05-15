---
published: true
title: Entity Framework with F#
subtitle: Introduction to using Entity Framework with SQL Express and F# Console Apps and Web APIs
---

[[toc]]


> Foreword, migrations don't work with F# (maybe some time but no hopes)

## Create the Database

Because we can't quite work with the normal EF Migrations we can either use C# to manage our data layer as per [this article](https://codeburst.io/creating-a-f-data-layer-using-entity-framework-core-746ec17d49e5) buuuuut I don't really want to do that, so let's just use SQL for now. Generally though I feel like maybe EF is not the way to go with F# but for the purpose of discussion

```sql
CREATE DATABASE TestDatabase
GO
```

And then run the following query on the database

```sql
CREATE TABLE [TestDatabase].[dbo].[Persons] (
    PersonId int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
)
GO
```

## Console App

Create a new console app, you can do this using Visual Studio or the `dotnet cli`

```
mkdir EFApp; cd EFApp
dotnet new console --language F#
```

### Adding the Types

Assuming we have a database that's already configured and we want to add mappings for our application we beed to define the type as well as the context

```fs
[<CLIMutable>]
type Person =
    { PersonId : int
      FirstName : string
      LastName : string
      Address : string
      City : string}

type PersonDataContext() =
    inherit DbContext()

    [<DefaultValue>]
    val mutable persons : DbSet<Person>

    member public this.Persons with get() = this.persons
                               and set p = this.persons <- p

    override __.OnConfiguring(optionsBuilder : DbContextOptionsBuilder) =
        optionsBuilder.UseSqlServer("YOUR CONNECTION STRING")
        |> ignore
```

### Using the Context

Next we can just make use of the `DbContext` that we created to access the database as we usually would using EF

```fs
[<EntryPoint>]
let main argv =
    let ctx = new PersonDataContext()

    ctx.Persons.Add(
        { PersonId = (new Random()).Next(99999)
          FirstName = "Name"
          LastName = "Surname"
          Address = "Address"
          City = "City" }
    ) |> ignore

    ctx.SaveChanges() |> ignore

    let getPersons(ctx : PersonDataContext) =
        async {
            return! ctx.Persons.ToArrayAsync()
                |> Async.AwaitTask
        }

    let persons = getPersons ctx |> Async.RunSynchronously

    persons
    |> Seq.iter Console.WriteLine

    0 // return an integer exit code
```

## Web API

IF we want to use it with a Web API we can do that pretty much the same as above, however we'll set up the DBContext as a service so it can be used with Dependency Injection

```
mkdir EFWebApi; mkdir EFWebApi
dotnet new webapi --language F#
```

### Set Up the Types

We'll use the same type setup as in the console app but but note that we make the type public. We can define this in a file called `Person.fs`, ensure this is the topmost file in your project

```fs
[<CLIMutable>]
type Person =
    { PersonId : int
      FirstName : string
      LastName : string
      Address : string
      City : string }

type PersonDataContext public(options) =
    inherit DbContext(options)

    [<DefaultValue>]
    val mutable persons : DbSet<Person>

    member public this.Persons with get() = this.persons
                               and set p = this.persons <- p
```

Note also that we've updated the type to make use of the `DbContextOptionsBuilder` and that we're not going to override the `OnConfiguring` method as we'll be using the service setup

### Service Configuration

In our startup file we can configure the service in the `ConfigureServices` method, I've just left that part of the `Startup.fs` file below

```fs
type Startup private () =
    new (configuration: IConfiguration) as this =
        Startup() then
        this.Configuration <- configuration

    // This method gets called by the runtime. Use this method to add services to the container.
    member this.ConfigureServices(services: IServiceCollection) =
        // Add framework services.
        services.AddControllers() |> ignore

        // Configure EF
        services.AddDbContext<PersonDataContext>(
            fun optionsBuilder ->
                optionsBuilder.UseSqlServer(
                    this.Configuration.GetConnectionString("Database")
                ) |> ignore
            ) |> ignore
```

### Usage

If we want to make use of the DBContext we can just reference it a controller's constructor as a dependency

```fs
[<ApiController>]
[<Route("[controller]")>]
type PersonController (logger : ILogger<PersonController>, ctx : PersonDataContext) =
    inherit ControllerBase()
```

And we can define some routes that make use of this within the `PersonController` type

```fs
[<HttpGet>]
[<Route("{id}")>]
member this.Get(id : int) =
    let person =  ctx.Persons.FirstOrDefault(fun p -> p.PersonId = id)

    if (box person = null)
    then this.NotFound() :> IActionResult
    else this.Ok person :> IActionResult

[<HttpPost>]
member this.Post(person : Person) : IActionResult=

    let createPerson(person : Person) : Person =
        ctx.Persons.Add(person) |> ignore
        ctx.SaveChanges() |> ignore
        ctx.Persons.First(fun p -> p = person)

    match person.PersonId with
    | 0 -> this.BadRequest("PersonId is required") :> IActionResult
    | _ ->
        match box(ctx.Persons.FirstOrDefault(fun p -> p.PersonId = person.PersonId)) with
        | null ->  createPerson person |> this.Ok :> IActionResult
        | _ ->
            ctx.Persons.First(fun p -> p.PersonId = person.PersonId)
            |> this.Conflict :> IActionResult
```

And this will allow you to make use of the provided endpoints on your application using either of the following:

- `GET /person/<ID>`
- `POST /person`

```json
{
  "personId": 1,
  "firstName": "John",
  "lastName": "Jackson",
  "address": "125 Green Street",
  "city": "Greenville"
}
```

If we would also like to verify if these records are being created in the database we can run:

```sql
SELECT TOP (1000) [PersonId]
      ,[LastName]
      ,[FirstName]
      ,[Address]
      ,[City]
  FROM [TestDatabase].[dbo].[Persons]
GO
```
