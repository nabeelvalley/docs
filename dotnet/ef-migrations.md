# Database Migrations with Entity Framework

## Creating Migrations

When using Entity Framework database updates are defined by the application models available. In order to generate a migration script you would need to run the following command from your project directore

```
dotnet ef migrations add MIGRATION_NAME
```

This will create a new migration, you can also remove the last created migration with:

```
dotnet ef migrations remove
```

## Database Updates

In order to update a database with the updated migration you can make use of the following command

```
dotnet ef database update
```

And in the case where a database cannot be accessed, you can generate the relevant SQL scripts using the following commands ([documentation](https://docs.microsoft.com/en-us/ef/core/miscellaneous/cli/dotnet#dotnet-ef-migrations-script))

1.  Script all migrations

```
dotnet ef migrations script 0
```

2. Script from initial state to Specific Migration

```
dotnet ef migrations script 0 MyTargetMigration
```

3. Script from one migration to another

```
dotnet ef migrations script StartMigration EndMigration
```

When using the above scripts, the `-i` flag can be used to build a script that will work on a DB with any start-state, and the `-o` flag can be used to output to a file

```
dotnet ef migrations script 0 -i -f .\MyOutputFile.sql
```
