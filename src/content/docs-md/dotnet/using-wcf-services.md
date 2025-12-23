---
published: true
title: WCF Services
subtitle: Connecting to WCF Services Services using Visual Studio or the SVCUtil CLI
---

In order to consume a WCF Service from a .NET client you can make use of the `Connected Services` section in Visual Studio, or using the `svcutil` tool in the `dotnet cli`

## [SVCUtil](https://docs.microsoft.com/en-us/dotnet/core/additional-tools/dotnet-svcutil-guide?tabs=dotnetsvcutil2x)

You first need to install the `svcutil` with:

```
dotnet tool install --global dotnet-svcutil
```

To create a new service reference you can run the following command with your service endpoint

```
dotnet-svcutil http://myservice/service.svc
```

Which will create a `ServiceReference.cs` file which contains your service references

## Visual Studio

From the `Connected Services` item under the relevant project in the Visual Studio Solution Explorer, double click on Connected Services and then `Microsoft WCF Web Service Reference Provider` and input your URL and click `Go`

Thereafter the available services will be listed and you can set the service namespace and click `Finish`

### Usage

In your `.cs` file that you want to use the service do the following:

```cs
using ServiceReference;
```

In order to use the service you need to create an instance of the Service and then just call the required operation

```cs
var client = new ServiceClient(); // this will be the name of the client that you want to use
var response = await client.ClientMethod(); // the method you want to invoke
```
