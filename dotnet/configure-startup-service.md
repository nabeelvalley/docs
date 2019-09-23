# Configuring Startup Services/Dependencies in WebAPI

You can think of a service simply as a reusable class instance that can be reused in different controllers. This can be injected via dependency injection where it is needed

## Define a Service

To create a new service, you will first need to define a `class` that provides the relevant functionality. We can define a simple class for a service as follows:

```cs
public class MyCat {
  public string Name { get; set; }
  
  public MyCat(string name) 
  {
    Name = name;
  }
  
  public string SayHi () 
  {
    return "Hello, from " + Name;
  }
}
```

## Add Service

You can the define this as a service in your `startup.cs` file's `ConfigureServices` method with the `services<T>.AddScoped` function to create a service that can be used by your controllers

```cs
services.AddScoped<MyCat>(serviceProvider => new MyCat("Bob"));
```

Additionally if you would like your service to be able to make use of other services, or do any more complex things, you can access the different parts of the lambda, such as reading from the application config the `Name` value

```cs
services.AddScoped<MyCat>(serviceProvider => {
  var config = serviceProvider.GetRequiredService<IConfiguration>();
  var name = config.GetValue<string>("Name");
  
  return new MyCat(name);
});
```

Using the same pattern as above, we can define an SMTP Client with preconfigured information with the following:

```cs
services.AddScoped<SmtpClient>(serviceProvider => {
  var config = serviceProvider.GetRequiredService<IConfiguration>();
  return  new SmtpClient()
  {
    UseDefaultCredentials = false,
    EnableSsl = true,
    Host = config.GetValue<string>("Host"),
    Port = config.GetValue<int>("Port"),
    Credentials = new NetworkCredential(
        config.GetValue<string>("Username"),
        config.GetValue<string>("Password"),
        config.GetValue<string>("Domain")
      )
    };
});
```
            
The service can then be used by a controller by including a reference based on the service type in the controller's constructor and its functionality can be used by the controller like with the example below:

```cs
public class CatController : Controller
{

  private MyCat _cat;
  
  public CatController(MyCat cat)
  {
    _cat = cat;
  }

  public ActionResult Index()
  {
    return _cat.SayHi();
  }
}
```

Note that the `MyCat` service is injected into our controller simply by us defining it in the constructor as a dependency
