---
published: true
title: SQL Cheatsheet
description: Code snippets for common tasks with SQL
---

## Instance Level Operations

### Create Database

```sql
CREATE DATABASE TestDatabase
```

## Drop Database

```sql
DROP DATABASE TestDatabase
```

### Create Table

```sql
CREATE TABLE Persons (
    PersonId int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
)
```

### Update Column Data Type

```sql
ALTER Table Persons
	ALTER COLUMN PersonId int NOT NULL
```

### Add Column Constraint

```sql
ALTER Table Persons
	ADD CONSTRAINT PK_Person PRIMARY KEY (PersonId)
```

### Create Table with Links

```sql
CREATE TABLE Items
   (
      ItemId int NOT NULL,
	  PersonId int NOT NULL,
	  Name nvarchar(50),
      CONSTRAINT PK_Items PRIMARY KEY (ItemId),
      CONSTRAINT FK_Items_Person FOREIGN KEY (PersonId)
      REFERENCES Persons (PersonId)
   )
```

### Drop Table

```sql
DROP TABLE Persons
```

### Insert Item into Table

```sql
INSERT INTO Persons
    (PersonId, LastName, FirstName, Address, City)
VALUES (1, 'Name', 'Surname', 'Home', 'Place')
```

### Retrieve Table Values

We can retrieve all values from a table with:

```sql
SELECT TOP (10) PersonId
      ,LastName
      ,FirstName
      ,Address
      ,City
  FROM Persons
```

We can get a specific set of values with a condition

```sql
SELECT *
FROM Persons
WHERE FirstName = 'John'
```

Or search for a pattern in a field with `LIKE`:

```sql
SELECT *
FROM Persons
WHERE FirstName LIKE '%John%'
```

### Update Table Item

```sql
UPDATE Persons
SET FirstName = 'John', LastName = 'Smith'
WHERE PersonId = 1
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

SELECT * FROM Persons

DELETE FROM Persons
	WHERE LastName = 'Person2'

SELECT * FROM Persons

ROLLBACK
```

And we can then `COMMIT` this when we are sure it works

```sql
BEGIN TRANSACTION

SELECT * FROM Persons

DELETE FROM Persons
	WHERE LastName = 'Person2'

SELECT * FROM Persons

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

FROM Persons as a
INNER JOIN Vehicles as b
ON a.ID = b.UserId
```

> Using `JOIN` can be used instead of `INNER JOIN`, but that can be confusing as there are other types of `JOIN`s

### Outer Join

There are multiple types of outer joins, namely `RIGHT JOIN`, `LEFT JOIN`, or `FULL JOIN`. When joining table `A` to `B`:

- A `LEFT JOIN` keeps rows from `A` whether or not there are any from `B`
- A `RIGHT JOIN` keeps rows from `B` whether or not there are any from `B`
- A `FULL JOIN` keeps rows from both tables

This works similar to the `INNER JOIN` in that it references two tables and joins `ON` a specific column:

```sql
SELECT DISTINCT a.Id, b.Vehicle
FROM Persons AS a 
LEFT JOIN Vehicles AS b
ON a.ID = b.UserId
```

> Older SQL might call these `RIGHT OUTER JOIN`, `LEFT OUTER JOIN`, or `FULL OUTER JOIN`. The `OUTER` is just a compatibility syntax and may be left out

## Subqueries

You can use subqueries inside of SQL queries for the purpose of comparing data against without actually returning/selecting the data from the inner query. Subqueries can be referenced anywhere that a normal table can be referenced

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

## Nulls

Queries might return columns with `NULL` values. We can do `NULL` testing in the `WHERE` clause by means of a `IS NULL` or `IS NOT NULL` like:

```sql
SELECT * 
FROM users
WHERE country IS NOT NULL
AND age > 50
```

## Expressions

Expressions can use mathematical or string functions to write logic within a query. Expressions can also be bound to an alias using `AS`

```sql
SELECT val * 10 AS big_count
FROM my_data
WHERE ABS(val) > 5
```

Or more complex, depending on data from a join for example:

```sql
SELECT 
    *,
    (domestic_sales + international_sales)/1000000 AS total
FROM movies
    INNER JOIN boxoffice on id = movie_id
```

## Grouping and Aggregation

### Aggregation Functions

Aggregation functions can be used across all rows by bying called with the column name, for example:

```sql
SELECT AVG(age) FROM persons
```

### Grouping

They can also be applied at a group level using `GROUP BY`

```sql
SELECT AVG(age) FROM persons
GROUP BY country
```

Some aggregation functions are `COUNT`, `MIN`, `MAX`, `AVG`, `SUM`

### Conditions on Groups

Conditions in the `WHERE` clause are applied to the main data and not the grouped result. When using a `GROUP BY`, the `HAVING` clause can provide filtering on the grouped data

```sql
SELECT AVG(age) FROM persons
GROUP BY country
HAVING country = 'Canada'
```

## Execution Order

A `SELECT` query consists of a few different parts, the overall syntax looks like this:

```sql
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
    JOIN another_table
      ON mytable.column = another_table.column
    WHERE constraint_expression
    GROUP BY column
    HAVING constraint_expression
    ORDER BY column ASC/DESC
    LIMIT count OFFSET COUNT;
```

Execution order looks like this:

1. `FROM` and `JOIN` determine what data to use
2. `WHERE` filters the working data, aliases from the `SELECT` part might not be available in some databases since they depend on execution
3. `GROUP BY` creates any grouping results
4. `HAVING` filters the result of the `GROUP BY`
5. `SELECT` defines the shape of the results
6. `DISTINCT` discards any non-unique rows
7. `ORDER_BY` sorts the data
8. `LIMIT` and `OFFSET` further discard data


## References and Additional Reading

- [SQL Bolt Interactive Learning](https://sqlbolt.com/)
- [SQL Indexing and Tuning](https://use-the-index-luke.com/)
