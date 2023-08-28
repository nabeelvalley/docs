---
published: true
title: Hangfire
subtitle: Task Automation using Hangfire with F#
description: Task Automation using Hangfire with F#
---

---
published: true
title: Hangfire
subtitle: Task Automation using Hangfire with F#
description: Task Automation using Hangfire with F#
---

So I've been playing around a bit with Hangfire and Entity Framework thinking about how I can go about building some interesting task automation, and I thought I'd like to explore this concept a bit, at least at a more basic level with F#. So here goes

# Prerequisites

> Note that these downloads may take a while, they're kind of big and it's annoying

- [.NET Core SDK](https://dotnet.microsoft.com/download)
- [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-editions-express)
- Optional: [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
- Optional: SLQ Server (mssql) VSCode Extension

# Creating the Project

The first thing that we need to do is create a project for the application. In this case we'll just have a single project and solution file and we can create this with the `dotnet core cli`. First create a new solution, project, and add the project to the solution

```ps
mkdir HangfireAutomation
cd HangfireAutomation

dotnet new sln

dotnet new webapi --language F#

dotnet sln .\HangfireAutomation.sln add .\HangfireAutomation.fsproj
```

Since we've only got one project at the moment there isn't really a need for us to add different folders for our solution, although with bigger projects that would ideally be how we'd structure the application

We can then build and run the project using the following commands

```ps
dotnet run
```

You can view the running application at `https://localhost:<PORT>/weatherforecast`

Additionally we can also open the solution and run it from Visual Studio (which I'll be doing from this point)

# Setting up the DB

Now we can set up the database, once you have installed SQL Server Express you can launch the DB from the `Connect Now` button or by running the following command from Powershell:

```
sqlcmd -S localhost\SQLEXPRESS -E
```

Next we need to create a database for Hangfire:

```sql
CREATE DATABASE [HangfireAutomation]
GO
```

You can then list out the databases currently the `SQLExpress` instance to verify that the database was created:

```sql
SELECT name, database_id, create_date
FROM sys.databases ;
GO
```

Your connection string will be in the installation information, for a default install of SQL Express it should be as follows:

```
Server=localhost\SQLEXPRESS;Database=master;Trusted_Connection=True;
```

For the database we just created you can therefore use:

```
Server=localhost\SQLEXPRESS;Database=HangfireAutomation;Trusted_Connection=True;
```

# Setting up Hangfire

Now that we have the database set up we can add Hangfire to the application with the following

1. Add the database connection string to the `appsettings.json` file as follows:

```
"ConnectionStrings": {
"Database": "Server=localhost\\SQLEXPRESS;Database=HangfireAutomation;Trusted_Connection=True;"
}
```

2. In the `startup.fs` file we need to configure the Hangfire service, we will need to first import Hangfire

```fs
open Hangfire
```

And then in the `ConfigureServices` method we need to configure the actual service to use SQL Server and the connection string that we added to the `appsettings.json` file:

```fs
// Hangfire service configuration
services.AddHangfire(
    fun config ->
        config.UseSqlServerStorage(
            this.Configuration.GetConnectionString("Database")
            ) |> ignore
    ) |> ignore
```

Thereafter we can configure the actual Server and Dashboard. We will use the `/` route for the dashboard as we don't have anything running on that. We will do this on the `Configure` method in the `staertup.fs` file:

```fs
app.UseHangfireDashboard "" |> ignore
app.UseHangfireServer() |> ignore
```

Now that we've configured hangfire we can run the application, additionally we can change the start URL from Visual Studio under the Project properties to be `/` so that we launch into the dashboard

3. Now that Hangfire is up and running correctly we can modify the `Configure` method's constructor to include the `IBackgroundClient` dependency so we can create a job as follows:

```fs
member this.Configure(app: IApplicationBuilder, env: IWebHostEnvironment, backgroundJobClient: IBackgroundJobClient) =
```

And then in the `Configure` method we can call the `backgroundJobClient.Enqueue` method to start a job. Note that the job takes in a lambda for the function we want to execute

```fs
backgroundJobClient.Enqueue(
    fun () ->
        Console.WriteLine "Startup Job"
    ) |> ignore
```

Once we've added the task we can run the application again and we will see that the job has executed

Next up we can just set up another recurring job using the static `RecurringJob.AddOrUpdate` function in the `Configure` method as well:

```fs
RecurringJob.AddOrUpdate(
    fun () ->
        Console.WriteLine "Recurring Job"
    , Cron.Minutely
    )
```

Once we are done with the above, the overall `startup.fs` file should look something like:

```fs
namespace HangfireAutomation

open System
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.Extensions.Configuration
open Microsoft.Extensions.DependencyInjection
open Microsoft.Extensions.Hosting
open Hangfire

type Startup private () =
    new (configuration: IConfiguration) as this =
        Startup() then
        this.Configuration <- configuration

    // This method gets called by the runtime. Use this method to add services to the container.
    member this.ConfigureServices(services: IServiceCollection) =
        // Add framework services.
        services.AddControllers() |> ignore

        // Hangfire service configuration
        services.AddHangfire(
            fun config ->
                config.UseSqlServerStorage(
                    this.Configuration.GetConnectionString("Database")
                    ) |> ignore
            ) |> ignore

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    member this.Configure(app: IApplicationBuilder, env: IWebHostEnvironment, backgroundJobClient: IBackgroundJobClient) =
        if (env.IsDevelopment()) then
            app.UseDeveloperExceptionPage() |> ignore

        app.UseHttpsRedirection() |> ignore
        app.UseRouting() |> ignore

        app.UseAuthorization() |> ignore

        app.UseEndpoints(fun endpoints ->
            endpoints.MapControllers() |> ignore
            ) |> ignore

        app.UseHangfireDashboard "" |> ignore
        app.UseHangfireServer() |> ignore

        backgroundJobClient.Enqueue(
            fun () ->
                Console.WriteLine "Startup Job"
            ) |> ignore

        RecurringJob.AddOrUpdate(
            fun () ->
                Console.WriteLine "Recurring Job"
            , Cron.Minutely
            )

    member val Configuration : IConfiguration = null with get, set
```

And your `appsettings.json` like:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Warning",
      "Microsoft.Hosting.Lifetime": "Information"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "Database": "Server=localhost\\SQLEXPRESS;Database=HangfireAutomation;Trusted_Connection=True;"
  }
}
```
