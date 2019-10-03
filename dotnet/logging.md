# Logging

Logging can be done in a bunch of different ways, but the best one I've found this far is `Serilog`, and the setup is as follows:

## Install Serilog

You will need to add the following dependencies to your application from NuGet

1. `Serilog`
2. `Serilog;.Sinks.Console`
3. `Serilog.Sinks.File`
4. `Serilog.Settings.Configuration`

## Basic Logger

Setting up a basic logger that will log to a file or console can be done as follows, using rolling log files and logger instances that can be shared between processes. There are a lot of other config options but these are the main ones

```cs
using Serilog;
using Serilog.Events;

...

var logger = new LoggerConfiguration()
        .WriteTo.Console()
        .WriteTo.File("logs/log.txt", shared: true)
        .WriteTo.File("debug/debug.txt", shared: true, rollingInterval: RollingInterval.Hour, restrictedToMinimumLevel: LogEventLevel.Debug)
        .WriteTo.File("fatal/fatal.txt", shared: true, rollingInterval: RollingInterval.Day, restrictedToMinimumLevel: LogEventLevel.Fatal)
        .CreateLogger();

logger.Information("Hello World!");
```

## Using Configuration

Additionally you can set the loggers up using the `appsettings.json` file as well, for which the `Serilog` parts will be as follows

`appsettings.json`

```json
{
...
  "Serilog": {
    "WriteTo": [
      {
        "Name": "File",
        "Args": {
          "path": "logs/info/info-.txt",
          "rollingInterval": "Day",
          "shared": true
        }
      },
      {
        "Name": "File",
        "Args": {
          "path": "logs/errors/errors-.txt",
          "rollingInterval": "Day",
          "shared": true,
          "restrictedToMinimumLevel": "Warning"
        }
      }
      
    ]
  },
 ...
 }
```

This can then be loaded into a logger instance with:


```cs
var config = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .Build();
    
var logger = new LoggerConfiguration()
                .WriteTo.Console()
                .ReadFrom
                .Configuration(config)
                .CreateLogger();
```

## Logging Service

Lastly, you can also make use of a logger service in Web Application using the `Startup.cs/ConfigureServices` function with the following:

```cs
services.AddScoped<Serilog.ILogger>(serviceProvider =>
    new LoggerConfiguration()
        .WriteTo.Console()
        .ReadFrom
        .Configuration(serviceProvider.GetRequiredService<IConfiguration>())
        .CreateLogger()
);
```

And then use this using Dependency Injecton on a Controller's Constructor like:

```cs
public MyStuffController(Serilog.ILogger logger)
{
  _logger = logger;
}
```

And then simply use the logger where required

```cs
public string TestLog()
{
  _logger.Information("Some Log Stuff");
}
