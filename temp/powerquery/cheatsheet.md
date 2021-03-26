`Power Query` is query language which makes use of the `M` langauge to transform, manipulate, and query data and is used in different MS data applications such as PowerBI and Excel

# Primitives and Operators

Power Query provides some basic literals such as numbers, text, booleans, and lists and they can be defined like so:

| Type      | Example                                        |
| --------- | ---------------------------------------------- |
| `Number`  | `0`, `10`, `9999`                              |
| `Text`    | `"Hello world"`                                |
| `Logical` | `true`, `false`                                |
| `list`    | `{"hello", 1}`, `{{"hello", 1}, { "bye", 2 }}` |

Additionally, there are the usual operators as well as some kind of special ones below:

| Operator        | Example                               | Result           |
| --------------- | ------------------------------------- | ---------------- |
| Plus `+`        | `1 + 2`                               | 3                |
|                 | `#time(12,23,0) + #duration(0,0,2,0)` | `#time(12,25,0)` |
| Combination `&` | `"Hello " & "world"`                  | `"Hello world"`  |
|                 | `{1} & {2,3}`                         | `{1,2,3}`        |
|                 | `[a = 1] & [b = 2]`                   | `[a = 1, b = 2]` |
| Not `not`       |                                       | Logical `NOT`    |
| Or `or`         |                                       | Logical `OR`     |
| And `and`       |                                       | Logical `AND`    |

# Expressions

An expression is a part of a query that can be evaluated, such as `"Hello"` or `Table.FromRows({{"Jeff"}, {"Smith"}}, {"Name"})`

Using variables in PowerQuery is done using using the `let ... in` expression where `let` defines a block in which variables can be assigned, each assignment separated by a `,` and `in` defines the block with the return expression

```powerquery-m
let
    data = {{"Jeff"}, {"Smith"}},
    cols = {"Name"}
in
    Table.FromRows(data, cols)
```

# Functions

Thera are also the function expression which can be defined using the following type of syntax for a single line function:

```powerquery-m
MyFunction = (param1, param2, paramN) => param1 + param2 + paramN
```

Or a more complex multi-line function making use of a `let ... in` expression and other function calls

```powerquery-m
CreateTable = (colName) =>
    let
        data = {{"Jeff"}, {"Smith"}},
        cols = {colName}
    in
        Table.FromRows(data, cols)
```

And integrating that with the above `let ... in` expression will look something more like this in a query

```powerquery-m
let
    CreateTable = (colName) =>
        let
            data = {{"Jeff"}, {"Smith"}},
            cols = {colName}
        in
            Table.FromRows(data, cols)
in CreateTable("Col Name")
```

# Misc

## Pivot Multi-Hot-Encoded Entries as Many Separate Ones

`data`

| Id  | Started | In Progress | Completed |
| --- | ------- | ----------- | --------- |
| 1   | true    | false       | false     |
| 2   | true    | true        | true      |
| 3   | true    | true        | false     |

We can use the following query to pivot our table out like so:

```powerquery-m
= let
    Filter = (cond, stat) =>
        Table.AddColumn(
            Table.SelectColumns(
                Table.SelectRows(data, cond), {"Id"}
            ), "Stage", each stat
        ),

    initRows = Filter(each true, "Exists"),
    startedRows = Filter(each [Started], "Started"),
    progressRows = Filter(each [In Progress], "In Progress"),
    completedRows = Filter(each [Completed], "Completed")
in
    Table.Combine({initRows, startedRows, progressRows, completedRows})
```

Which will result in an output data table with:

`result`

| Id  | Stage       |
| --- | ----------- |
| 1   | Exists      |
| 2   | Exists      |
| 3   | Exists      |
| 1   | Started     |
| 2   | Started     |
| 3   | Started     |
| 2   | In Progress |
| 3   | In Progress |
| 2   | Completed   |

# A Time-Period Based Target Table

Targets are often measured using metrics like YTD or MTD in PowerBI, however this may not be the optimal method as it may alternatively be useful to get the target as a running total for the time period

There's probably a better way to do this but the method I've worked it to create a running target table that only has columns for each target in it's own row which can then be linked to a Date/calendar table for making targets time-calculable:

```powerquery-m
= let 
    dates =  Table.FromColumns(
        {List.Dates(#date(2016, 1, 1), 2000, #duration(1, 0, 0, 0))}, {"Date"}
    ),

    AddTargetCol = (t, name, target) => Table.AddColumn(t, name, each (target/365)),

    withT1 = AddTargetCol(dates, "Target 1", 5000),
    withT2 = AddTargetCol(withT1, "Target 2", 10000),
    withT3 = AddTargetCol(withT2, "Target 3", 100)
in 
    withT3
```

Now, when measuring targets by time you can simply filter the appropriate time period and use a sum of time to display the time-appropriate target
