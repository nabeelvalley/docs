---
title: SQLite
subtitle: Basic notes on setting up sqlite
published: true
---

> Notes on using Sqlite, [the getting started docs](https://www.sqlite.org/quickstart.html)

# Init a DB

A database file named `mydb.db` can be instantiated with:

```sh
sqlite3 mydb.db
```

> This will also start the prompt

# Using the Prompt

You can do things with the DB as normal using SQL, followed by `;` to run the query, for example we can create a table, insert some entries, etc.

```sh
sqlite> CREATE TABLE Persons (id int, name text, city text);
sqlite> INSERT INTO Persons (id, name, city) VALUES (1, "Bob", "New York");
sqlite> SELECT * FROM Persons;
1|Bob|New York
```

> And whatever SQL stuff like you'd normally do

# References

- [SQLite Docs](https://www.sqlite.org/)
- [Exercism SQLite Track](https://exercism.org/tracks/sqlite)
- [SQLite Tutorials](https://www.sqlitetutorial.net/)
