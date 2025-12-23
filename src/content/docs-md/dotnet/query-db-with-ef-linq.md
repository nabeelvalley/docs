---
published: true
title: Query a Database with Entity Framework
subtitle: Use Entity Framework and LINQ to Connect to and Query an Existing Database
---

> Info derived from [this post on LearnEntityFrameworkCore](https://www.learnentityframeworkcore.com/walkthroughs/existing-database)

Sometimes you want to use a database but don't want to deal with the difficulties created by SQL

## Setting Up

### Create Project

First, you will need a database to connect to, this can be done by any method, but I will use the `Northwind` database for this. The SQL Setup Script can be found [here](https://raw.githubusercontent.com/microsoft/sql-server-samples/master/samples/databases/northwind-pubs/instnwnd.sql)

Once that's done you can create a new project for running or queries

```bash
dotnet new console -n DBPlayground
```

### Add Packages

You will also need some packages installed on your application to make this all work

```bash
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Design
```

### Add EF Global

And you'll also need to install the `ef` tool if you don't already have it:

```bash
dotnet tool install --global dotnet-ef
```

## Scaffold Models

Now that you have everything installed, you can go ahead and run the following to scaffold your code models. I am connecting to `SQLEXPRESS` on the Northwind database but you can use any connection string that works for your purpose

```bash
dotnet ef dbcontext scaffold "Server=localhost\SQLEXPRESS;Database=Northwind;Trusted_Connection=True;" Microsoft.EntityFrameworkCore.SqlServer -o Model
```

The above will output generated models that align to the data in your database in the `Models` folder

## Using the Connection

When we ran the above it will have generated a `DBContext` file. In our case `NorthwindContext` which is the class for our Database. We can use this as follows:

```cs
using System;
using System.Linq;
using DBPlayground.Model;

namespace DBPlayground
{
    class Program
    {
        static void Main(string[] args)
        {
            var db = new NorthwindContext();
        }
    }
}
```

We can thereafter use the `db` instance to do database things using EF

```cs
db.Customers
    .Take(5)
    .ToList()
    .ForEach(c => Console.WriteLine($"{c.ContactName}\t{c.Country}"));
```
