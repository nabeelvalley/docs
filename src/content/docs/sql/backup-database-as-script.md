---
published: true
title: Backup SQL Server Database as Script
subtitle: Use the Scripted Backup for a SQL Server Database
---

---
published: true
title: Backup SQL Server Database as Script
subtitle: Use the Scripted Backup for a SQL Server Database
---

To create a scripted backup of a database on SQL Server do the following:

1. Right click on the database name > `Tasks` > `Generate Scripts...`
2. On the `Choose Objects` screen select `Scriot entire database and all database objects`
3. On the `Set Scripting Options` screen click on `Advanced` and select:
   1. `Script DROP and CREATE = Script CREATE`
   2. `Types of data to script = Schema and data`
4. Set the location to save the script
5. On the `Summary` page you can click `Next` which will start the generation
6. Thereafter you can view the generated database script from the location it was generated to
