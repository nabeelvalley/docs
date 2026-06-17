---
published: true
title: Authentication with MongoDB
subtitle: Configure MongoDB Authentication and Authorization
---

## Configuration File

> [The Docs](https://docs.mongodb.com/manual/reference/configuration-options/)

The Configuration File for a MongoDB Instance has all the options that the command line startup contains, use this for storing your configuration in a single location - makes retaining a configuration over multiple environments much easier

The file is located as follows:

| OS      | Location                             |
| ------- | ------------------------------------ |
| Linux   | `/etc/mongod.conf`                   |
| Windows | `<install directory>/bin/mongod.cfg` |
| macOS   | `/usr/local/etc/mongod.conf`         |

And the default file looks soomething like this:

`mongod.conf`

```yml
## mongod.conf

## for documentation of all options, see:
##   http://docs.mongodb.org/manual/reference/configuration-options/

## Where and how to store data.
storage:
  dbPath: C:\Program Files\MongoDB\Server\4.0\data
  journal:
    enabled: true
##  engine:
##  mmapv1:
##  wiredTiger:

## where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: C:\Program Files\MongoDB\Server\4.0\log\mongod.log

## network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1
#processManagement:

#security:

#operationProfiling:

#replication:

#sharding:
```

## Securing an Instance

> [The Docs](https://docs.mongodb.com/manual/administration/security-checklist/)

To secure an instance there are a few steps we should take such as:

1. Enabling Access Control
2. Enforcing Authentication
3. Configuring Role-Based access
4. Encrypt Communication (SSL/TLS)
5. Encrypt Data
6. Limit Network Exposure
7. Audit System Activity
8. Run Mongo with Secure Enabled
9. (Misc Compliance Related things)

### 1. Enable Access Control

> [The Docs](https://docs.mongodb.com/manual/tutorial/enable-authentication/)

#### Enabling a User Admin

To Enable access-control on an instance you will need to first:

1. Log into the existing instance using the `mongo` shell
2. Create a User Admin using the following:

```js
use admin
db.createUser(
  {
    user: "myUserAdmin",
    pwd: passwordPrompt(), // or cleartext password
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
  }
)
```

At this point you may also want to give your admin root access, you can do this with the following:

```js
use admin
db.grantRolesToUser("myUserAdmin", [{ role: "root", db: "admin" }])
```

> If you get a `passwordPrompt is not defined` error then just use the plaintext password

3. Shut down the instance:

```js
db.adminCommand({ shutdown: 1 })
```

4. Add the following to the `mongod.conf` file:

```yml
security:
  authorization: enabled
```

> Setting the above config is the same as running `mongod --auth` when starting up

5. Restart the instance with the `mongod` command

If we try to use the DB now and are not authenticated we will get a `db command requires autentication` error

> Note that if you do not restart the database authentication will not be enforced

#### Creating First User on Localhost

> [Docs on the Localhost Exception](https://docs.mongodb.com/manual/core/security-users/#localhost-exception)

If a database is started with the `--auth` param or the `security.authorization=enabled`, and the first login is done from `localhost` you will be allowed to create the initial user

#### Users and Roles

> [Docs on User Roles](https://docs.mongodb.com/manual/reference/built-in-roles/)

1. Open a new `mongo` shell and log in using the user admin credentials we created above:

```bash
mongo <hostname>  --authenticationDatabase "admin" -u "myUserAdmin" -p
```

And then enter the password on the prompt

2. We can create a user with some `readWrite` and `read` permissions using `db.createUser()`:

Select the DB to create the user (we'll use admin, but this can be another database):

```js
use admin
```

> If you use another database above then the database

Create the User on the DB:

```js
db.createUser({
  user: 'myTester',
  pwd: 'password', // or cleartext password
  roles: [
    { role: 'readWrite', db: 'dbTest' },
    { role: 'read', db: 'dbOtherData' },
  ],
})
```

The created user will then be created on the `admin` database and will have access to the `dbTest` and `dbOtherData` databases

### Using the User

#### From the Mongo Shell

You can now exit the mongo shell and re-login with your new username and password:

```bash
mongo <hostname>  --authenticationDatabase "admin" -u "myTester" -p
```

Or alternatively, from a currently open instance:

```bash
mongo <hostname>
```

You can then authenticate with:

```bash
use admin
db.auth("username", "password")
```

Thereafter, you should be able to execute queries with the limitations of the roles defined above

If trying to do something that was not allowed for your user you will see an authorization error

#### From an Application

An example Node.js application that makes use of the above user will look like the following:

```js
const { MongoClient } = require('mongodb')
const readline = require('readline')

const dbName = 'dbTest'

/// Note that our ConnectionString contains the Auth Source
const url = `mongodb://myTester:password@localhost:37200/?authSource=admin`

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
})

// init database
MongoClient.connect(url, (err, db) => {
  if (err) throw err

  console.log('DB Connected')
  app(db)
})

const app = (db) => {
  rl.question('Please enter a name to add to the DB ', (name, err) => {
    if (err) throw err
    db.db(dbName)
      .collection('people')
      .insertOne({ name }, (err, res) => {
        if (err) throw err

        console.log(res)
        rl.close()
      })
  })

  rl.on('close', () => {
    console.log('Database Closed')
    db.close()
    console.log('Application Closed')
    process.exit(0)
  })
}
```

The connection string we use in the above is important, and contains the following pieces of information:

1. The Database User's Username
2. The Database User's Password
3. The name of the database to authenticate against

If we want to, we can also define the database we're using to authenticate with in the connection string like so:

```
mongodb://myTester:password@localhost:37200/admin`
```

> Personally I don't like this because it implies that we're using the `admin` db as the parameter after the `/` is the database we want to use. The `authSource` method is clearer in my opinion

Connection strings like the following will not work now that authentication is enabled:

```
mongodb://myTester:incorrectpassword@localhost:37200/?authSource=admin
mongodb://localhost:37200/?authSource=admin
mongodb://localhost:37200/?authSource=nonExistentDB
```
