# SQL Cheatsheet

> Mostly applies to SQL server and SQLExpress

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

```sql
SELECT TOP (10) [PersonId]
      ,[LastName]
      ,[FirstName]
      ,[Address]
      ,[City]
  FROM [TestDatabase].[dbo].[Persons]
GO
```

### Update Table Item

```sql
UPDATE [TestDatabase].[dbo].[Persons]
SET [FirstName] = 'John', [LastName] = 'Smith'
WHERE [PersonId] = 1
GO
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
