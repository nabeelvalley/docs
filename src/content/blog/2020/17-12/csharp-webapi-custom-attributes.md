---
published: true
title: Custom Attributes in C# Web Controllers
subtitle: 17 December 2020
description: Modify controller behaviour using Attributes
---

Implementing an attribute for a WebAPI or class in C# can help to reduce duplication and centralize parts of the application logic. This could be used for a variety of tasks such as logging information when methods are called as well as managinng authorization

In this post I'm going to cover the following:

## Attribute Types and Execution Order

There are a few different attribute types that we can handle on a WebAPI that provide us with the ability to wrap some functionality around our endpoints, below are some of the common attributes that we can implement and the order in which they execute ([StackOverflow](https://stackoverflow.com/questions/19249511/difference-between-iactionfilter-and-iauthorizationfilter))

1. Authorization - `IAuthorizationFilter`
2. Action - `IActionFilter`
3. Result - `IResultFilter`
4. Exception - `IExceptionFilter`

### IActionFilter

The `IActionFilter` executes before and after a method is executed and contains two different methods for doing this, namely the `OnActionExecuting` and `OnActionExecuted` methods respectively. A basic implemtation of `IActionFilter` would look like this:

```cs
namespace CSharpAttributes.Attributes
{
  public class LogStatusAttribute : Attribute, IActionFilter
  {
    public LogStatusAttribute()
    {
      Console.WriteLine("Attribute Initialized");
    }

    public void OnActionExecuting(ActionExecutingContext context)
    {
      Console.WriteLine("OnActionExecuting");
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
      Console.WriteLine("OnActionExecuted");
    }
  }
}
```

This can then be implemented on a controller method with a `[LogStatus]` attribute:

```cs
[LogStatus]
[HttpGet]
public IEnumerable<WeatherForecast> Get()
{
  Console.WriteLine("Executing Get");
  return data;
}
```

The order of logging which we see will be as follows:

1. `Attribute Initialized` when the controller is instantiated
2. `OnActionExecuting` when the controller is called
3. `Executing Get` when the controller is executed
4. `OnActionExecuted` when the controller is done executing

### IAuthorizationFilter

The `IAuthorizationFilter` executes as the first filter on a controller's method call

```cs
namespace CSharpAttributes.Attributes
{
  public class CustomAuthorizeAttribute : Attribute, IAuthorizationFilter
  {
    public CustomAuthorizeAttribute()
    {
      Console.WriteLine("Attribute Initialized");
    }

    public void OnAuthorization(AuthorizationFilterContext context)
    {
      Console.WriteLine("OnAuthorization");
    }
  }
}
```

This can then be implemented on a controller method with a `[CustomAuthorize]` attribute:

```cs
[CustomAuthorize]
[HttpGet]
public IEnumerable<WeatherForecast> Get()
{
  Console.WriteLine("Executing Get");
  return data;
}
```

The order of logging which we see will be as follows:

1. `Attribute Initialized` when the controller is instantiated
2. `OnAuthorization` when the controller is called
3. `Executing Get` when the controller is executed

## Modify Response Data

An attribute's `context` parameter gives us ways by which we can access the `HttpContext` as well as set the result of a method call so that it can be handled down the line. For example, we can implement our CustomAuthorize attribute with the following:

```cs
public void OnAuthorization(AuthorizationFilterContext context)
{
  if (!context.HttpContext.Request.Headers.ContainsKey("X-Custom-Auth"))
  {
    context.Result = new UnauthorizedResult();
  }

  Console.WriteLine("Attribute Called");
}
```

This will mean that if we set the `context.Result` in our method then the controller will not be executed and the endpoint will return the `UnauthorizedResult` early. You can also see that we're able to access things like the `HttpContext` which makes it easy for us to view the request/response data and do things based on that

## Attribute on a Class

Note that it's also possible to apply the above to each method in a class by adding the attribute at the top of the class declaration:

```cs
[ApiController]
[LogStatus]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
  ...
```

## Attributes with Input Parameters

We are also able to create attributes that enable the consumer to modify their behaviour by taking input parameters to the constructor, we can update our `LogStatus` attribute to do something like add a prefix before all logs:

```cs
namespace CSharpAttributes.Attributes
{
  public class LogStatusAttribute : Attribute, IActionFilter
  {
    private readonly string _prefix;

    public LogStatusAttribute(string prefix = "")
    {
      _prefix = prefix;
      Console.WriteLine("Attribute Initialized");
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
      Console.WriteLine(_prefix + "OnActionExecuted");
    }

    public void OnActionExecuting(ActionExecutingContext context)
    {
      Console.WriteLine(_prefix + "OnActionExecuting");
    }
  }
}
```

Then, applying to our controller method like so:

```cs
[LogStatus("WeatherController-Get:")]
[HttpGet]
public IEnumerable<WeatherForecast> Get()
{
  Console.WriteLine("Executing Get");
  return data;
}
```

So the new output will look like so:

1. `Attribute Initialized` when the controller is instantiated
2. `WeatherForecast-Get:OnActionExecuting` when the controller is called
3. `Executing Get` when the controller is executed
4. `WeatherForecast-Get:OnActionExecuted` when the controller is done executing

## Attribute Setting at Class and Method Level

Since an attribute can be implemented at a class and method level it's useful for us to be able to implement it at a class and the override the behaviour or add behaviour for a specific method

We can do this by setting the attribute inheritence to `false`

Updating out `LogStatusAttribute` we can add the `AttributeUsage` Attribute as follows:

```cs
namespace CSharpAttributes.Attributes
{
  [AttributeUsage(AttributeTargets.All, Inherited = false)]
  public class LogStatusAttribute : Attribute, IActionFilter
  {
    ...
```

This means that we can independently apply the attribute at class and method levels, so now our controller can look something like this:

```cs
namespace CSharpAttributes.Controllers
{
  [ApiController]
  [Route("[controller]")]
  [LogStatus("WeatherForecast:")]
  public class WeatherForecastController : ControllerBase
  {
    [LogStatus("Get:")]
    [HttpGet]
    public IEnumerable<WeatherForecast> Get()
    {
      Console.WriteLine("Executing Get");
      return data;
    }
  }
}
```

Which will output the logs as follows:

1. `Attribute Initialized` when the controller is instantiated
2. `WeatherForecast:OnActionExecuting` when the class is called
3. `Get:OnActionExecuting` when the controller is called
4. `Executing Get` when the controller is executed
5. `Get:OnActionExecuted` when the controller is done executing
6. `WeatherForecast:OnActionExecuted` when the class is done executing
