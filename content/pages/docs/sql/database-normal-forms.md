---
title: Database Normalization
---

> Notes from from https://www.youtube.com/watch?v=GFQaEYEc8_8

## Normalization

- Normalization refers to structuring a database table such that it can't express redundant information
- Normalized tables are easier to enhance and extend
- Helps prevent data anomalies and inconsistencies

## The Normal Forms

- Varying levels that are determined through a series of criteria

### First Normal Form (1NF)

1NF ensures that:

1. Row order does not convey information
	- If ordering matters we should use an explicit field that specifies that
2. Columns do not mix data types
	- Columns should only have a single type of data
3. Tables always have primary keys
	- A table should always have a primary key
	- Primary keys can be composite
4. Repeating data groups are not used on a single row
	- We should use additional tables and appropriate relationships


### Second Normal Form (2NF)

2NF is about how keys and non-key attributes relate. 2NF says that each non-key attribute must depend on the entire primary key 

If an attribute depends on only one part of the primary key then the table is not in second normal form. In this scenario it is necessary to move the attribute  to a different attribute or possibly create a new table

### Third Normal Form (3NF)

Every non-key attribute in a table should only depend on the whole primary key

> This is almost exactly the same as _Boyce-Codd Normal Form_ which states that every attribute must only depend on the whole primary key 

Non-key attributes should not depend on other non-key attributes

In most cases, once a table is at 3NF it is considered to be fully normalized

### Fourth Normal Form (4NF)

The only kind of multi-valued dependencies must be multi-valued dependencies on the key

### Fifth Normal Form (5NF)

5NF requires that if a table (which is already in 4NF) can not be logically re-composed by joining some other tables together
