> Note that you can follow this entire process or skip to the [Shortcut](#Shortcut) section at the end

Using the Microsoft [docs on LINQ to SQL](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql/linq/) and the [sample database setup script](https://raw.githubusercontent.com/microsoft/sql-server-samples/master/samples/databases/northwind-pubs/instnwnd.sql)

> You will also need Visual Studio installed

# Create the Database

To get started first create the database based on the Script above by applying it from SQL Server Management Server or another database management tool

# Typical Process

The typical process for a LINQ to SQL application development is as follows:

1. Create a model class and execute simple queries
2. Add additional classes and execute more complex queries
3. Add, change, and delete database items
4. Use Stored Procedures

# 1. Model Setup and Single Entity Query

> [Documentation here](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql/linq/walkthrough-simple-object-model-and-query-csharp)

## Configure the Project

1. In Visual Studio create a new .NET Framework Console App called `LinqToSql`
2. From the Solution Explorer right click on the Project and select `References > Add Reference` and add a reference to `System.Data.Linq` from the `Framework` section
3. Add the following `usings` to the `Program.cs` file:

```cs
using System.Data.Linq;
```

## Mapping a Class to Database Table

Now we can create a new class and map it to our database table. Create a file in the Project called `Models/Customer.cs` with the following class definition. This states that the Table Name for our `Customer` collection is Customer

```cs
[Table(Name = "Customers")]
public class Customer { }
```

In the class body we can reference the different columns as well as the private internal variable that will hold the value, this is referenced by the Column Annotation, don't collapse it to a single property (even if Visual Studio tells you to). We can see the full `Customer.cs` file below:

```cs
using System.Data.Linq.Mapping;

namespace LinqToSql.Models
{
    [Table(Name = "Customers")]
    public class Customer
    {
        private string _CustomerID;
        [Column(IsPrimaryKey = true, Storage = "_CustomerID")]
        public string CustomerID
        {
            get
            {
                return this._CustomerID;
            }
            set
            {
                this._CustomerID = value;
            }

        }

        private string _City;
        [Column(Storage = "_City")]
        public string City
        {
            get
            {
                return this._City;
            }
            set
            {
                this._City = value;
            }
        }
    }
}
```

## Query Database

We need to create a link to our database using a `DataContext` object. The documentation makes use of the connection to the `mdf` file, however we'll use a `ConnectionString` instead as this makes more sense in practice

We can create a new `DataContext` as follows

```cs
DataContext db = new DataContext("<ConnectionString>")
```

Thereafter we can query a table in our `db` object by using the `db.GetTable` function

```cs
Table<Customer> customers = db.GetTable<Customer>();
```

Using our `customers` object we can make queries against the table with:

```cs
IQueryable<Customer> custQuery = customers.Where(c => c.City == "London");
```

And print out the reqults of the query with:

```cs
foreach (Customer c in custQuery)
{
    Console.WriteLine("ID={0}, City={1}", c.CustomerID, c.City);
}
```

Putting this all together, our `Program.cs` file should now contain the following:

```cs
using LinqToSql.Models;
using System;
using System.Data.Linq;
using System.Linq;

namespace LinqToSql
{
    class Program
    {
        static void Main(string[] args)
        {
            DataContext db = new DataContext(@"Data Source=localhost\SQLEXPRESS;Initial Catalog=Northwind;Integrated Security=True");

            db.Log = Console.Out;

            Table<Customer> customers = db.GetTable<Customer>();

            IQueryable<Customer> custQuery = customers.Where(c => c.City == "London");

            foreach (Customer c in custQuery)
            {
                Console.WriteLine("ID={0}, City={1}", c.CustomerID, c.City);
            }

            Console.ReadLine();
        }
    }
}
```

# 2. Query Across Relationships

> [Documentation here](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql/linq/walkthrough-querying-across-relationships-csharp)

## Update the Data Model

First, create the `Models/Order.cs` file with the following content:

```cs
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace LinqToSql.Models
{
    [Table(Name = "Orders")]
    public class Order
    {
        private int _OrderID = 0;
        private string _CustomerID;
        private EntityRef<Customer> _Customer;
        public Order() { this._Customer = new EntityRef<Customer>(); }

        [Column(Storage = "_OrderID", DbType = "Int NOT NULL IDENTITY",
        IsPrimaryKey = true, IsDbGenerated = true)]
        public int OrderID
        {
            get { return this._OrderID; }
        }

        [Column(Storage = "_CustomerID", DbType = "NChar(5)")]
        public string CustomerID
        {
            get { return this._CustomerID; }
            set { this._CustomerID = value; }
        }

        [Association(Storage = "_Customer", ThisKey = "CustomerID")]
        public Customer Customer
        {
            get { return this._Customer.Entity; }
            set { this._Customer.Entity = value; }
        }
    }
}
```

> Note that in the `Order` model we do not have a getter for the `OrderId` as this is generated by the database and cannot be set

Next we should add a reference to the `Order` model from the `Customer` model so as to make it easier to navigate the relationship. We can do this by dding a reference to the `Order` entity in our constructor:

```cs
public Customer()
{
    this._Orders = new EntitySet<Order>();
}
```

And then adding the `Orders` property on the field:

```cs
private EntitySet<Order> _Orders;
[Association(Storage = "_Orders", OtherKey = "CustomerID")]
public EntitySet<Order> Orders
{
    get
    {
        return this._Orders;
    }
    set
    {
        this._Orders.Assign(value);
    }
}
```

Finally the `Customer.cs` file should be as follows:

```cs
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace LinqToSql.Models
{
    [Table(Name = "Customers")]
    public class Customer
    {
        public Customer()
        {
            this._Orders = new EntitySet<Order>();
        }

        private string _CustomerID;
        [Column(IsPrimaryKey = true, Storage = "_CustomerID")]
        public string CustomerID
        {
            get
            {
                return this._CustomerID;
            }
            set
            {
                this._CustomerID = value;
            }

        }

        private string _City;
        [Column(Storage = "_City")]
        public string City
        {
            get
            {
                return this._City;
            }
            set
            {
                this._City = value;
            }
        }

        private EntitySet<Order> _Orders;
        [Association(Storage = "_Orders", OtherKey = "CustomerID")]
        public EntitySet<Order> Orders
        {
            get
            {
                return this._Orders;
            }
            set
            {
                this._Orders.Assign(value);
            }
        }
    }
}
```

## Query Across Multiple Entities

Now we can query this data from the `Program.cs` file with a query like the following:

```cs
IQueryable<Customer> custOrderQuery = db.Customers.Where(c => c.Orders.Any());

foreach (Customer c in custOrderQuery)
{
    Console.WriteLine("ID={0}, City={1}, Orders={2}", c.CustomerID, c.City, c.Orders.Count);
}

```

## Create a Strongly Typed Database View

It can be easier to create a strongly typed view of the database by creating a `DataContext` object that we define instead of using the `GetTable` function to retrieve a specific table

Create a class called `NorthwindContext` with the following code containing a definition for `Customers` and `Orders`:

```cs
using System.Data.Linq;

namespace LinqToSql.Models
{
    public class NorthwindContext : DataContext
    {
        // Table<T> abstracts database details per table/data type.
        public Table<Customer> Customers;
        public Table<Order> Orders;

        public Northwind(string connection) : base(connection) { }
    }
}
```

We can now replace `DbContext` definition with `NorthwindContext` and the call to `GetTable` to just use the `Customers` property in the `NorthwindContext` class like so:

```cs
NorthwindContext db = new NorthwindContext(@"Data Source=localhost\SQLEXPRESS;Initial Catalog=Northwind;Integrated Security=True");

IQueryable<Customer> custQuery = db.Customers.Where(c => c.City == "London");
```

As well as in our second query:

```cs
IQueryable<Customer> custOrderQuery = db.Customers.Where(c => c.Orders.Any());
```

# 3. Manipulating Data

To manipulate data we can use some of the functions provided to us by LINQ to SQL

We can update data in our database by followind a few basic steps

1. Retreive the entity we want to modify
2. Create, Update, or Delete the entity
3. Submit changes to the datbase

## Retrieve an Entity

We can retrieve an entity by wuerying the database for it

```cs
Customer custToUpdate = db.Customers.Where(c => c.Orders.Any()).First();
```

## Modify Entity

Next you we can modify the `City` and delete an `Order` from the customer

```cs
custToUpdate.City = "NEW CITY";

db.Orders.DeleteOnSubmit(custToUpdate.Orders[0]);
```

## Submit Changes

Lastly we can submit the changes to the database

```cs
db.SubmitChanges();
```

# 4. Using Stored Procedures

In order to use existing Stored Procedures you can make use of the [`SQLMetal` tool](https://docs.microsoft.com/en-us/dotnet/framework/tools/sqlmetal-exe-code-generation-tool) or using the [`Object Relational Designer`](https://docs.microsoft.com/en-us/visualstudio/data-tools/linq-to-sql-tools-in-visual-studio2?view=vs-2019) in Visual Studio

# Getting Started with the O/R Designer

> [Documentation](https://docs.microsoft.com/en-us/visualstudio/data-tools/linq-to-sql-tools-in-visual-studio2?view=vs-2019)

First, create a new `Linq to SQL Class` file from the `Right Click Project > Add New Item` dialog, you can call the file `DataClasses.dbml`

Next add a link to the Database you are working with from the Server Explorer in Visual Studio and you can drag in the `Customers` and `Orders` table and the relationship should be visible and this should update the generated `DataContext` classes with the information you update in the designer. This will not update the database

> The O/R Designer only supports 1:1 mappings

You can modify and update information in this view although I would suggest doing it from the

Creating Methods from Stored Procedures can be done by pulling them in from the `Stored Procedures` folder on the DB to the `methods` section on the designer view

# Shortcut

You don't need to do all the above manually. From Visual Studio do the following:

1. Create the project
2. Open the database in the Server Explorer
3. Add a LinqToSQL Class file (`.dbml`)
4. Drag in the tables you would like to work and it will generate the
