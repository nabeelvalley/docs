---
published: true
title: SQL Cheatsheet
subtitle: Code snippets for common tasks with SQL Server and SQL Express
description: SQL Cheatsheet for SQL Server and SQL Express
---

> Mostly applies to SQL Server and SQL Express

## Log Into Instance

```bash
#sqlcmd -S <YOUR DATABASE NAME> -E
sqlcmd -S localhost\SQLEXPRESS -E
```

## Instance Level Operations

### List Instance Databases

```sql
SELECT [name] FROM [master].[dbo].[sysdatabases]
GO
```

### Create Database

```sql
CREATE DATABASE [TestDatabase]
GO
```

## Drop Database

```sql
DROP DATABASE TestDatabase
GO
```

## Database Level Operations

### List Database Tables

```sql
SELECT [TABLE_NAME]
FROM [TestDatabase].[INFORMATION_SCHEMA].[TABLES]
WHERE [TABLE_TYPE] = 'BASE TABLE'
GO
```

### List Columns in Table

```sql
SELECT * FROM [TestDatabase].[INFORMATION_SCHEMA].[COLUMNS]
 WHERE [TABLE_NAME] = 'Persons'
GO
```

### Create Table

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

### Update Column Data Type

```sql
ALTER Table [TestDatabase].[dbo].[Persons]
	ALTER COLUMN [PersonId] int NOT NULL
GO
```

### Add Column Constraint

```sql
ALTER Table [TestDatabase].[dbo].[Persons]
	ADD CONSTRAINT PK_Person PRIMARY KEY ([PersonId])
GO
```

### Create Table with Links

```sql
CREATE TABLE [TestDatabase].[dbo].[Items]
   (
      ItemId int NOT NULL,
	  PersonId int NOT NULL,
	  Name nvarchar(50),
      CONSTRAINT PK_Items PRIMARY KEY (ItemId),
      CONSTRAINT FK_Items_Person FOREIGN KEY ([PersonId])
      REFERENCES [Persons] ([PersonId])
   )
GO
```

### Drop Table

```sql
DROP TABLE [Persons]
GO
```

### Insert Item into Table

```sql
INSERT INTO [TestDatabase].[dbo].[Persons]
    ([PersonId], [LastName], [FirstName], [Address], [City])
VALUES (1, 'Name', 'Surname', 'Home', 'Place')
GO
```

### Retrieve Table Values

We can retrieve all values from a table with:

```sql
SELECT TOP (10) [PersonId]
      ,[LastName]
      ,[FirstName]
      ,[Address]
      ,[City]
  FROM [TestDatabase].[dbo].[Persons]
GO
```

We can get a specific set of values with a condition

```sql
SELECT *
FROM [TestDatabase].[dbo].[Persons]
WHERE [FirstName] = 'John'
```

Or search for a pattern in a field with `LIKE`:

```sql
SELECT *
FROM [TestDatabase].[dbo].[Persons]
WHERE [FirstName] LIKE '%John%'
```

### Update Table Item

```sql
UPDATE [TestDatabase].[dbo].[Persons]
SET [FirstName] = 'John', [LastName] = 'Smith'
WHERE [PersonId] = 1
GO
```

### Values in List

We can use the `IN` operator to select some data based on values being in a given list

```sql
SELECT * FROM users
WHERE id in (1,2,3)
```

## Testing Statements

When running SQL queries it may sometimes be necessary to check if your query will work as expected before you actually run it you can wrap your query in:

```sql
BEGIN TRANSACTION
    ... DO STUFF
ROLLBACK
```

> `ROLLBACK` will roll back to the DB status before the query was carried out

And once you have verified that the query did what you expected, you can change the `ROLLBACK` to `COMMIT`

```sql
BEGIN TRANSACTION
    ... DO STUFF
COMMIT
```

We can test a deletion of a `Person` and view the result with:

```sql
BEGIN TRANSACTION

SELECT * FROM [TestDatabase].[dbo].[Persons]

DELETE FROM [TestDatabase].[dbo].[Persons]
	WHERE [LastName] = 'Person2'

SELECT * FROM [TestDatabase].[dbo].[Persons]

ROLLBACK
```

And we can then `COMMIT` this when we are sure it works

```sql
BEGIN TRANSACTION

SELECT * FROM [TestDatabase].[dbo].[Persons]

DELETE FROM [TestDatabase].[dbo].[Persons]
	WHERE [LastName] = 'Person2'

SELECT * FROM [TestDatabase].[dbo].[Persons]

COMMIT
```

## Table Joining

### Inner Join

To use an Inner Join based on two tables we can use the `INNER JOIN` keywords and then get the fields from the tables we want to use for our output table:

```sql
SELECT
a.FirstName as FirstName,
a.Email as Email,
a.ID as ID,

b.Vehicle as Vehicle,
b.Registered as IsRegistered

FROM Table_1 as a
INNER JOIN Table_2 as b
ON a.ID = b.UserId
```

## Inner Queries

You can use subqueries inside of SQL queries for the purpose of comparing data against without actually returning/selecting the data from the inner query

```sql
SELECT *
FROM users
WHERE id IN 
    (
        SELECT user_id 
        FROM orders 
        WHERE order_id IN (1,3)
    )
AND LOWER(username) LIKE LOWER('%bob%')
```