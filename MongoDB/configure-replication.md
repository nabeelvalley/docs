Using a single MongoDB instance is cool, but you know what's cooler? Using more than one. Sometimes we need to set up a couple of different database replicas, this is a general method of how this can be done

# On a Development Machine

We'll create some additional MongoDB services on the machine and then link them together

## Create the DB Folders

We will need the folders for databases to store their data, we can create this from a clean folder like so:

```bash
mkdir rs0-0
mkdir rs0-1
mkdir rs0-2
```

This will create the folders for three database nodes

## Startup the DB Services

You can start three DB services in different terminals with the following:

```bash
mongod --replSet rs0 --port 37100 --bind_ip localhost --dbpath ./rs0-0  --oplogSize 128
```

```bash
mongod --replSet rs0 --port 37101 --bind_ip localhost --dbpath ./rs0-1  --oplogSize 128
```

```bash
mongod --replSet rs0 --port 37102 --bind_ip localhost --dbpath ./rs0-2  --oplogSize 128
```

Note that you can also configure an instance to startup with replication by using the `mongod.cfg` file (for a normal instance). To enable replication you can use the following:

```yml
replication:
  replSetName: rs0
```

You can thereafter go on to configure the replicaset, additionally it's helpful to note that any of the other options we passed in via the command line can be set-up including the Port, IPs, Oplog Size and DB Path

## Configure the Replica Set

Next, log in to one of the Database instances to use as the `PRIMARY` using the `mongo` shell:

```bash
mongo localhost:3700
```

And then create an configuration object and initiate the replicaset with the configuration:

```bash
rsconf = {
  _id: "rs0",
  members: [
    {
     _id: 0,
     host: "localhost:37100"
    },
    {
     _id: 1,
     host: "localhost:37101"
    },
    {
     _id: 2,
     host: "localhost:37102"
    }
   ]
}

rs.initiate( rsconf )
```

You can then view the replicaset config with:

```bash
rs.conf()
```

From this, we should see each member's current config look something like:

```json
{
    "_id" : 0,
    "host" : "localhost:37100",
    "arbiterOnly" : false,
    "buildIndexes" : true,
    "hidden" : false,
    "priority" : 1,
    "tags" : { },
    "slaveDelay" : NumberLong(0),
    "votes" : 1
},
```

## Create Some Data

From the Instance we are already logged into, we can create some data like so:

1. Set a DB to use (this won't exist, will be created automatically)

```bash
use dbPeople
```

2. Insert a document into a collection

```bash
db.contacts.insert({email: "john@email.com"})
```

3. View the inserted document

```bash
db.contacts.find()
```

This data should now be written to each instance within the replicaset we configured

## Check Replication Status

There are two functions we can use to get information while on the instance, that is `rs.status()` which will give a lot of detail about the status of nodes, or `rs.printSlaveReplicationInfo()` which will give us a summary of the sync status like so:

```
source: mongonode1:27017
        syncedTo: Mon Jul 13 2020 16:16:47 GMT+0200 (South Africa Standard Time)
        10 secs (0 hrs) behind the primary
source: mongonode2:27017
        syncedTo: Mon Jul 13 2020 16:16:47 GMT+0200 (South Africa Standard Time)
        10 secs (0 hrs) behind the primary
```

If we want, we can stop one of the `SECONDARY` DB containers and then run the above, for example, stopping Node 2 we can see:

```
source: mongonode1:27017
        syncedTo: Mon Jul 13 2020 16:22:07 GMT+0200 (South Africa Standard Time)
        0 secs (0 hrs) behind the primary
source: mongonode2:27017
        syncedTo: Thu Jan 01 1970 02:00:00 GMT+0200 (South Africa Standard Time)
        1594650127 secs (442958.37 hrs) behind the primary
```

Which is an indication that the node is down. If we disable the primary one of the other nodes will then become the primary node and the original primary will be marked as behind:

```
source: mongonode0:27017
        syncedTo: Thu Jan 01 1970 02:00:00 GMT+0200 (South Africa Standard Time)
        1594650319 secs (442958.42 hrs) behind the primary
source: mongonode2:27017
        syncedTo: Mon Jul 13 2020 16:25:19 GMT+0200 (South Africa Standard Time)
        0 secs (0 hrs) behind the primary
```

# Inside of Some Containers

## Start Some Databases

If we're just playing around with this it can be useful for us to start up a few databases that we can use for testing this process. To start a few simple database nodes we can use the following `docker-compose` file and start it all up with `docker-compose up` from the directory in which we have this file

> This database setup is not a production setup, just for testing purposes. It will not persist data once the containers are stopped

`docker-compose.yml`

```yml
# based on gist: https://gist.github.com/asoorm/7822cc742831639c93affd734e97ce4f
version: '3.3'

services:
  # mongonode0:27017
  node0:
    image: mongo
    hostname: mongonode0
    container_name: mongonode0
    restart: always
    ports:
     - "37000:27017"
    entrypoint: [ "/usr/bin/mongod", "--bind_ip_all", "--replSet", "rs0" ]
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password

  # mongonode1:27017
  node1:
    image: mongo
    hostname: mongonode1
    container_name: mongonode1
    restart: always
    ports:
     - "37001:27017"
    entrypoint: [ "/usr/bin/mongod", "--bind_ip_all", "--replSet", "rs0" ]
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password

  # mongonode2:27017
  node2:
    image: mongo
    hostname: mongonode2
    container_name: mongonode2
    restart: always
    ports:
     - "37002:27017"
    entrypoint: [ "/usr/bin/mongod", "--bind_ip_all", "--replSet", "rs0" ]
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password
```

The above yaml file will run three mongo containers along with the following details:

| Container Name | Internal Endpoint  | From-Host Endpoint |
| -------------- | ------------------ | ------------------ |
| `mongonode0`   | `mongonode0:27017` | `localhost:37000`  |
| `mongonode1`   | `mongonode1:27017` | `localhost:37001`  |
| `mongonode2`   | `mongonode2:27017` | `localhost:37002`  |

Note that in the `docker-compose.yml` file we specify some additional entrypoint params, these are very similar to the parameters we start the mongodb instance with on our local machine, these tell docker to start the containers wit the `replSet` option

## Set-up the ReplicaSet

Now that we have three DBs, we need to set up the replication. This is very similar to the way we did it above, we have two options to log into the instance:

1. From the Host Computer
2. From within the Docker container

Connecting from the Host is identical to what we did using the "On a Development Machine" section, to connect via the Docker container do the following:

1. Run the `docker exec` command for any node, this will become the `PRIMARY` node when we set up the replication

```bash
docker exec -it mongonode0 /bin/bash
```

2. Log into the Mongo Instance of the container

```bash
mongo localhost
```

> Note that because we are accessing the DB from `localhost` we don't need to worry about authentication

3. Initiate the replication, note that here we are using the internal hosts that are configured within the compose cluster

```bash
rsconf = {
  _id: "rs0",
  members: [
    {
     _id: 0,
     host: "mongonode0:27017"
    },
    {
     _id: 1,
     host: "mongonode1:27017"
    },
    {
     _id: 2,
     host: "mongonode2:27017"
    }
   ]
}

rs.initiate( rsconf )
```

4. View the Configuration:

```bash
rs.conf()
```

We can then go on to insert documents into the DB as we did on the local instance as well as verify the sync status

# Arbiters and 2-Node Setups

> From the [MongoDB Documentation](https://docs.mongodb.com/manual/tutorial/add-replica-set-arbiter/)

In a MongoDB ReplicaSet an Arbiter is a node that does not store data but is allowed to vote on the validity of data

> Before doing this ensure that you stop and remove previously running containers or delete your DB folders (based on the method you used)

Since it's not always possible to set-up a third (or additional) that store data, we can configure an arbiter. We can use either of the methods of starting up the Three DB instances as above, but we will instead only configure two instances as nodes. the below config will do that:


```bash
rsconf = {
  _id: "rs0",
  members: [
    {
     _id: 0,
     host: "mongonode0:27017"
    },
    {
     _id: 1,
     host: "mongonode1:27017"
    }
   ]
}

rs.initiate( rsconf )
```

Next, we can use the `rs.addArb(HOST_URL)` function to add the third node as an arbiter:

```bash
rs.addArbiter('mongonode2:27017')
```

# Remove a Member

> From the [MongoDB Documentation](https://docs.mongodb.com/manual/tutorial/remove-replica-set-member/)

To remove any member node you can use the `rs.remove(HOST_URL)` function like so:

```bash
rs.remove('mongonode2:27017')
```

> The above applies to both Replication and Arbiter nodes

# Edit Configuration

We can use the `rs.reconfig(NEW_CONFIG)` function to provide a new replicaset configuration. There are a few different ways this can be used:

1. Get the Configuration with `rs.config()`, then edit the config and re-provide it like so:

```js
newConfig = {  ... the_new_config_after_editing_stuff }
rs.reconfig(newConfig) // apply the config
```

2. Manipulate the config directly from the mongo console, for example you can use javascript in the console to manipulate the config object like so:

```js
newConfig = rs.config()
newConfig.members.push({ _id: 4, host: 'idonotexist:12345' })
rs.reconfig(newConfig) // apply the config
```
