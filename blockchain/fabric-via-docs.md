# Working with Fabric

## Resources

- [Prerequisites](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html)
- [Tutorials](https://hyperledger-fabric.readthedocs.io/en/latest/tutorials.html)
  - [Writing your first application](https://hyperledger-fabric.readthedocs.io/en/latest/write_first_app.html)
  - [Build your first network](https://hyperledger-fabric.readthedocs.io/en/latest/build_network.html)
- [Glossary](https://hyperledger-fabric.readthedocs.io/en/latest/glossary.html)

## Overview

A business Network, defined in a **Business Network Archive** `.bna` File

- Models
- Logic
- Queries
- Access Control

In order to update a network, we simply upload the Archive `.bna` file to the network, this can either be done from the command line or from the Blockchain UI if using IBM Cloud

### Models

Models are files that define Assets, Participants and Transactions using the Hyperledger Composer Modelling Language

Models are defined in `.cto` files, and are written using the **Hyperledger Composer Modelling Language**

#### CTO Language

[CTO Language](https://hyperledger.github.io/composer/v0.19/reference/cto_language.html)

A `.cto` file is composed of the following elements

1. A single namespace, all resource definitions are part of this namespace
2. A set of resource definitions
   - Assets
   - Transactions
   - Participants
   - Events
3. Optional import declarations than import resources from other namespaces

##### Namespaces

Resources are organized by namespaces, this is defined by first line in a `.cto` file which can be as follows

```js
namespace org.example.mynetwork
```

All other resources defined in the same file will be part of this namespace

##### Classes

A resource definition has the following properties

1. A namespace (defined by the namespace of its parent file)

```js
namespace org.example.mynetwork
```

2. A name and identifying field

```js
/**
 * A vehicle asset.
 */
asset Vehicle identified by vin {
  o String vin
}
```

3. Optional supertype
4. Any additional properties

```js
/**
 * A car asset. A car is related to a list of parts
 */
asset Car extends Vehicle {
  o String model
  --> Part[] Parts
}
```

5. An optional Abstract declaration to state that the type cannot be created but can only be extended

```js
/**
 * An abstract Vehicle asset.
 */
abstract asset Vehicle identified by vin {
  o String vin
}
```

6. A set of relationships to other Composer types

```js
/**
 * A Field asset. A Field is related to a list of animals
 */
asset Field identified by fieldId {
  o String fieldId
  o String name
  --> Animal[] animals
}
```

##### Enums

Enumerables can be defined as follows

```js
/**
 * An enumerated type
 */
enum ProductType {
  o DAIRY
  o BEEF
  o VEGETABLES
}
```

And can be used in another class as a type

```js
participant Farmer identified by farmerId {
    o String farmerId
    o ProductType primaryProduct
}
```

##### Concepts

Concepts are abstract classes that are not assets, participants or transactions. They are contained by another resource and do not have an identifier and cannot be directly stored in registries or referenced in relationships

For example we can define a concept as follows

```js
abstract concept Address {
  o String street
  o String city default ="Winchester"
  o String country default = "UK"
  o Integer[] counts optional
}

concept UnitedStatesAddress extends Address {
  o String zipcode
}
```

And then use it in a class definition

```js
participant Farmer identified by farmerId {
    o String farmerId
    o UnitedStatesAddress address
    o ProductType primaryProduct
}
```

##### Primitive Types

Composer has a few primitive types, namely

- String
- Double
- Integer
- Long
- DateTime
- Boolean

##### Arrays

Arrays can simply be defined with `[]`

```js
o Integer[] integerArray
```

```js
--> Animal[] myAnimals
```

##### Relationships

A relationship is a tuple composed of

1. Namespace being referenced
2. Type being referenced
3. Identifier instance being referenced

For example

```js
org.example.Vehicle#23451
```

##### Field Validation

Attributes may include a default value, string fields may include a regex validation, numerical values may include a range, these can be seen below

```js
asset Vehicle extends Base {
  // An asset contains Fields, each of which can have an optional default value
  o String reg default="ABC123"
  // A numeric field can have a range validation expression
  o Integer year default=2016 range=[1990,] optional // model year must be 1990 or higher
  o Integer[] integerArray
  o String V5cID regex=/^[A-z][A-z][0-9]{7}/
  o String LeaseContractID
  o Boolean scrapped default=false
  --> Participant owner //relationship to a Participant, with the field named 'owner'.
  --> Participant[] previousOwners optional // Nary relationship
  o Customer customer
}
```

##### Imports

We can also import a type from a different namespace with the following

```js
import org.example.MyAsset
import org.example2.*
```

#### Example

We can define a trading network consisting of the following models

- Asset
  - Name: Commodity
  - ID: Trading Symbol
  - Attributes
    - Trading Symbol
    - Description
    - Main Exchange
    - Quantity
    - Owner (Trader Participant)
- Participant
  - Name: Trader
  - ID: TradeID
  - First Name
  - Last Name
- Transaction
  - Name: Trade
  - Commodity (Commodity *Asset*)
  - New Owner (Trader *Participant*)

The model file for the above network can be defined as follows

`models.cto`
```js
namespace org.example.mynetwork
asset Commodity identified by tradingSymbol {
    o String tradingSymbol
    o String description
    o String mainExchange
    o Double quantity
    --> Trader owner
}
participant Trader identified by tradeId {
    o String tradeId
    o String firstName
    o String lastName
}
transaction Trade {
    --> Commodity commodity
    --> Trader newOwner
}
```

### Logic

Logic is defined in **Script Files** `.js` which define transaction logic

#### Example

The logic for a transaction can be defined by a javascript function, in this example, for example, if a transaction occurs in which a Commodity changes Ownership from one Owner to a New Owner, the function can be defined as follows

`trade.js`
```js
/**
 * Track the trade of a commodity from one trader to another
 * @param {org.example.mynetwork.Trade} trade - the trade to be processed
 * @transaction
 */
async function tradeCommodity(trade) {
    // Assign the commodity owner to the new owner
    trade.commodity.owner = trade.newOwner;

    // Persist updated asset in asset registry
    let assetRegistry = await getAssetRegistry('org.example.mynetwork.Commodity');
    await assetRegistry.update(trade.commodity);
}
```

### Queries

Queries are defined in **Query File** `.qry` file, note that a single `.bna` file can only have one query

### Access Control

Access Control Files `.acl` define what permissions different users have, a single network can only have one access control file

#### Example

Access control files look like the following

```js
/**
 * Access control rules for tutorial-network
 */
rule Default {
    description: "Allow all participants access to all resources"
    participant: "ANY"
    operation: ALL
    resource: "org.example.mynetwork.*"
    action: ALLOW
}

rule SystemACL {
  description:  "System ACL to permit all access"
  participant: "ANY"
  operation: ALL
  resource: "org.hyperledger.composer.system.**"
  action: ALLOW
}
```

### Deployment

We can package our code into a `.bna` file by running the following command in our directory

```bash
composer archive create -t dir -n .
```

We then make use of a `PeerAdmin` identity card that contains the necessary credential and use this to install the `.bna` to the network

```bash
composer network install --card PeerAdmin@hlfv1 --archiveFile tutorial-network@0.0.1.bna
```

## [Prerequisites]((https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html)

Before you can really get started you will need to first [install the necessary prerequisites](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html)


- Curl
- Docker and Docker Compose
- GoLang
- Node and NPM
- Python 2.7

### Installing Samples

Select a directory in which the `fabric-samples` should be downloaded, for simplicity use your `~` directory

```bash
curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash -s 1.3.0
```

If you run ito the following error while running the above command 

```raw
docker: Got permission denied while trying to connect to the Docker daemon socket at unix
```

Run the following command, **then reboot your machine** and try to run the previous command again

```bash
sudo usermod -a -G docker $USER
```

Next add the path to the downloaded files to your environment with

```bash
export PATH=~/fabric-samples/bin:$PATH
```

## [Writing your First Application](https://hyperledger-fabric.readthedocs.io/en/latest/write_first_app.html)

### Setting up the environment

Once the necessary prerequisites have been installed and the `fabric-samples` folder has been downloaded navigate into the `fabcar` directory within it and `ls`

```bash
cd fabric-samples/fabcar
ls
```

Note the `startFabric.sh` file, as this will be needed in future

In this folder you should see a few choices for javascript/typescript, navigate in to the `javascript` directory

```bash
cd javascript
ls
```

This should then contain the following files

```raw
enrollAdmin.js     invoke.js       package.json    query.js        registerUser.js  wallet
```

Next, clear any active docker containers

```bash
docker rm -f $(docker ps -aq)
docker network prune
```

If this tutorial has been done before, also remove the chaincode image with the following

```bash
docker rmi dev-peer0.org1.example.com-fabcar-1.0-5c906e402ed29f20260ae42283216aa75549c571e2e380f3615826365d8269ba
```

### Installing Clients and Launching the Network

From the `fabcar/javascript` directory install the dependencies and start fabric from the `fabcar` folder

```bash
npm install
cd ..
./startFabric.sh
```

### Enroll the Admin User

Open a new terminal and run the following command to stream Docker logs

```bash
docker logs -f ca.example.com
```

When the network was launched, an admin user was registered as the Certificate Authority, the `admin` object will then be used to register and enroll new users

We now need to send an enrollment call and retrieve the Enrollment Certificate for the admin user. Switch back to the `fabcar/javascript` directory and run the following

```bash
node enrollAdmin.js
```

If this works you should see the following output

```raw
Successfully enrolled admin user "admin" and imported it into the wallet
```

### Enroll a new User

We can now register a new user using the admin eCert to communicate with the CA server. This `user1` identity will be used when querying and updating the ledger

Still in the `fabcar/javascript` directory, run the following

```bash
node registerUser.js
```

This will yield the following output if it works

```raw
Successfully registered and enrolled admin user "user1" and imported it into the wallet
```

### Querying the Ledger

Queries are how you read data from the ledger, data is stored as key-value pairs and we can query for the value of a single key or multiple keys, if the ledger is written in a format like JSON we can perform more complex search operations

We can query the ledger to return all cars on it with the `user1` identity. The `query.js` file contains the following line that specifies the signer

```js
fabric_client.getUserContext('user1', true);
```

To run the query, from the `fabcar/javascript` folder, run the following command

```bash
node query.js
```

Which should return something like this

```bash
Successfully loaded user1 from persistence
Query has completed, checking results
Response is  [{"Key":"CAR0", "Record":{"colour":"blue","make":"Toyota","model":"Prius","owner":"Tomoko"}},
{"Key":"CAR1",   "Record":{"colour":"red","make":"Ford","model":"Mustang","owner":"Brad"}},
{"Key":"CAR2", "Record":{"colour":"green","make":"Hyundai","model":"Tucson","owner":"Jin Soo"}},
{"Key":"CAR3", "Record":{"colour":"yellow","make":"Volkswagen","model":"Passat","owner":"Max"}},
{"Key":"CAR4", "Record":{"colour":"black","make":"Tesla","model":"S","owner":"Adriana"}},
{"Key":"CAR5", "Record":{"colour":"purple","make":"Peugeot","model":"205","owner":"Michel"}},
{"Key":"CAR6", "Record":{"colour":"white","make":"Chery","model":"S22L","owner":"Aarav"}},
{"Key":"CAR7", "Record":{"colour":"violet","make":"Fiat","model":"Punto","owner":"Pari"}},
{"Key":"CAR8", "Record":{"colour":"indigo","make":"Tata","model":"Nano","owner":"Valeria"}},
{"Key":"CAR9", "Record":{"colour":"brown","make":"Holden","model":"Barina","owner":"Shotaro"}}]
```

The query in the `query.js` file is constructed with the following code

```js
// Create a new gateway for connecting to our peer node.
const gateway = new Gateway();
await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: false } });

// Get the network (channel) our contract is deployed to.
const network = await gateway.getNetwork('mychannel');

// Get the contract from the network.
const contract = network.getContract('fabcar');

// Evaluate the specified transaction.
// queryCar transaction - requires 1 argument, ex: ('queryCar', 'CAR4')
// queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
const result = await contract.evaluateTransaction('queryAllCars');
```

When the query was run, it invoked the `fabcar` chaincode on the peer and ran the `queryAllCars` function within it, we can lok at the `fabric-samples/chaincode/fabcar/javascript/lib/fabcar.js` file to see the function that was evoked, which is the following

```js
async queryAllCars(ctx) {
  const startKey = 'CAR0';
  const endKey = 'CAR999';

  const iterator = await ctx.stub.getStateByRange(startKey, endKey);

  const allResults = [];
  while (true) {
    const res = await iterator.next();

    if (res.value && res.value.value.toString()) {
      console.log(res.value.value.toString('utf8'));

      const Key = res.value.key;
      let Record;
      try {
        Record = JSON.parse(res.value.value.toString('utf8'));
      } catch (err) {
        console.log(err);
        Record = res.value.value.toString('utf8');
      }
      allResults.push({ Key, Record });
    }
    if (res.done) {
      console.log('end of data');
      await iterator.close();
      console.info(allResults);
      return JSON.stringify(allResults);
    }
  }
}
```

The above pattern of using an application to interface with a smart contract which in turn interacts with the ledger is how transactions are done on the blockchain

If we want to modify our query to only search for `CAR4` we can change the following line:

```js
 const result = await contract.evaluateTransaction('queryAllCars');
```

To be as follows:

```js
fabric-samples/chaincode/fabcar/javascript/lib/fabcar.js
```

Running the query again from the terminal

```
node query.js
```

Should return the following

```bash
{"colour":"black","make":"Tesla","model":"S","owner":"Adriana"}
```

Using the `queryCar` function we can query any cat in the ledger

### Updating the Ledger

The `invoke.js` file will update the ledger by creating a car. The application will propose an update, and receive the endorsed update which it will then send to be written to every peer's ledger

The request in the `invoke.js` file can be seen below

```js
const gateway = new Gateway();
await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: false } });

// Get the network (channel) our contract is deployed to.
const network = await gateway.getNetwork('mychannel');

// Get the contract from the network.
const contract = network.getContract('fabcar');

// Submit the specified transaction.
// createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
// changeCarOwner transaction - requires 2 args , ex: ('changeCarOwner', 'CAR10', 'Dave')
await contract.submitTransaction('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom');
console.log('Transaction has been submitted');

// Disconnect from the gateway.
await gateway.disconnect();
```

We can run the transaction with

```bash
node transaction.js
```

Which will result in the following ouput

```bash
Transaction has been submitted
```

We can now modify the transaction to update `CAR10` by changing

```js
await contract.submitTransaction('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom');
```

To

```js
await contract.submitTransaction('changeCarOwner', 'CAR10', 'Dave');
```

And run `invoke.js` again

```bash
node query.js
```

If we run `query.js` for `CAR10` this time, we should see the following

```bash
Response is  {"colour":"Red","make":"Chevy","model":"Volt","owner":"Dave"}
```

### Cleanup

Clear any active docker containers

```bash
docker rm -f $(docker ps -aq)
docker network prune
```

If this tutorial has been done before, also remove the chaincode image with the following

```bash
docker rmi dev-peer0.org1.example.com-fabcar-1.0-5c906e402ed29f20260ae42283216aa75549c571e2e380f3615826365d8269ba
```

## [Building your First Network](https://hyperledger-fabric.readthedocs.io/en/latest/build_network.html#configuration-transaction-generator)

This tutorial needs to be run from the `fabric-samples/first-network` directory

```bash
cd fabric-samples/first-network
```

### Network Builder Script

We can look at the help information for the `byfn.sh` script as follows

```bash
./byfn.sh --help
```

```bash
Usage:
  byfn.sh <mode> [-c <channel name>] [-t <timeout>] [-d <delay>] [-f <docker-compose-file>] [-s <dbtype>] [-l <language>] [-i <imagetag>] [-v]
    <mode> - one of 'up', 'down', 'restart', 'generate' or 'upgrade'
      - 'up' - bring up the network with docker-compose up
      - 'down' - clear the network with docker-compose down
      - 'restart' - restart the network
      - 'generate' - generate required certificates and genesis block
      - 'upgrade'  - upgrade the network from v1.0.x to v1.1
    -c <channel name> - channel name to use (defaults to "mychannel")
    -t <timeout> - CLI timeout duration in seconds (defaults to 10)
    -d <delay> - delay duration in seconds (defaults to 3)
    -f <docker-compose-file> - specify which docker-compose file use (defaults to docker-compose-cli.yaml)
    -s <dbtype> - the database backend to use: goleveldb (default) or couchdb
    -l <language> - the chaincode language: golang (default), node or java
    -i <imagetag> - the tag to be used to launch the network (defaults to "latest")
    -v - verbose mode
  byfn.sh -h (print this message)

Typically, one would first generate the required certificates and
genesis block, then bring up the network. e.g.:

        byfn.sh generate -c mychannel
        byfn.sh up -c mychannel -s couchdb
        byfn.sh up -c mychannel -s couchdb -i 1.1.0-alpha
        byfn.sh up -l node
        byfn.sh down -c mychannel
        byfn.sh upgrade -c mychannel

Taking all defaults:
        byfn.sh generate
        byfn.sh up
        byfn.sh down
```

The default channel name will be `mychannel`, the default timeout will be 10s

#### Generate Network Artifacts

To generate network artifacts we can run the following command

```bash
./byfn.sh generate
```

Which will have a description of what it will do and an option to continue

The first step generates all of the certificates and keys for our network entities, the `genesis block` used to bootstrap the ordering service, and a collection of configuration transactions required to configure the Channel

#### Bring Up the Network

You can bring up the network with the `./byfn.sh up` command, which will by default use GoLang for the chaincode. If we want to use Node (which I do), use the following command instead

To bring up the network with Node as the Language, use the following command:

```bash
./byfn.sh up -l node
```

Furthermore if we want to use by defining a language channel name, and DB type, we can use look at the documentation for more commands on the script. For example if we wanted to use Node, and CouchDB with our channel called `mychannel` we can do that with the following

```bash
./byfn.sh up -c mychannel -s couchdb -l node
```

When the network is up and transacting you will see the following

```raw
Starting with channel 'mychannel' and CLI timeout of '10'
Continue? [Y/n]
proceeding ...
Creating network "net_byfn" with the default driver
Creating peer0.org1.example.com
Creating peer1.org1.example.com
Creating peer0.org2.example.com
Creating orderer.example.com
Creating peer1.org2.example.com
Creating cli


 ____    _____      _      ____    _____
/ ___|  |_   _|    / \    |  _ \  |_   _|
\___ \    | |     / _ \   | |_) |   | |
 ___) |   | |    / ___ \  |  _ <    | |
|____/    |_|   /_/   \_\ |_| \_\   |_|

Channel name : mychannel
Creating channel...
```

The above command will launch all the containers and run through a complete end-to-end application scenario, scrolling through these logs will allow you to see al the transactions

When complete you will see the following output

```raw
Query Result: 90
2017-05-16 17:08:15.158 UTC [main] main -> INFO 008 Exiting.....
===================== Query successful on peer1.org2 on channel 'mychannel' =====================

===================== All GOOD, BYFN execution completed =====================


 _____   _   _   ____
| ____| | \ | | |  _ \
|  _|   |  \| | | | | |
| |___  | |\  | | |_| |
|_____| |_| \_| |____/
```

If we want to use a different language we need to bring down and restart the network

#### Bringing Down the Network

You can bring down the network with the following command

```bash
./byfn.sh down
```

### Crypto Generator

We use the `cryptogen` tool to generate cryptographic material for network entities. These certificates are representative of identities and allow for sign/verify authentication between entities

Cryptogen consumes a file `crypto-config.yaml` which contains the network topology and allows us to generate certificates and keys for Organizations and the Certificates belinging to them

Each organization is provisioned a unique `ca-cert` that binds certain peers and orderers to it. By assigning each Org a unique CA we mimic the way a typical network would work

Transactions are signed by a private key (`keystore`) and verified with a private key (`signcerts`)

The `crypto-config.yaml` file contains the following

```yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# ---------------------------------------------------------------------------
# "OrdererOrgs" - Definition of organizations managing orderer nodes
# ---------------------------------------------------------------------------
OrdererOrgs:
  # ---------------------------------------------------------------------------
  # Orderer
  # ---------------------------------------------------------------------------
  - Name: Orderer
    Domain: example.com
    # ---------------------------------------------------------------------------
    # "Specs" - See PeerOrgs below for complete description
    # ---------------------------------------------------------------------------
    Specs:
      - Hostname: orderer
# ---------------------------------------------------------------------------
# "PeerOrgs" - Definition of organizations managing peer nodes
# ---------------------------------------------------------------------------
PeerOrgs:
  # ---------------------------------------------------------------------------
  # Org1
  # ---------------------------------------------------------------------------
  - Name: Org1
    Domain: org1.example.com
    # ---------------------------------------------------------------------------
    # "Specs"
    # ---------------------------------------------------------------------------
    # Uncomment this section to enable the explicit definition of hosts in your
    # configuration.  Most users will want to use Template, below
    #
    # Specs is an array of Spec entries.  Each Spec entry consists of two fields:
    #   - Hostname:   (Required) The desired hostname, sans the domain.
    #   - CommonName: (Optional) Specifies the template or explicit override for
    #                 the CN.  By default, this is the template:
    #
    #                              "{{.Hostname}}.{{.Domain}}"
    #
    #                 which obtains its values from the Spec.Hostname and
    #                 Org.Domain, respectively.
    # ---------------------------------------------------------------------------
    # Specs:
    #   - Hostname: foo # implicitly "foo.org1.example.com"
    #     CommonName: foo27.org5.example.com # overrides Hostname-based FQDN set above
    #   - Hostname: bar
    #   - Hostname: baz
    # ---------------------------------------------------------------------------
    # "Template"
    # ---------------------------------------------------------------------------
    # Allows for the definition of 1 or more hosts that are created sequentially
    # from a template. By default, this looks like "peer%d" from 0 to Count-1.
    # You may override the number of nodes (Count), the starting index (Start)
    # or the template used to construct the name (Hostname).
    #
    # Note: Template and Specs are not mutually exclusive.  You may define both
    # sections and the aggregate nodes will be created for you.  Take care with
    # name collisions
    # ---------------------------------------------------------------------------
    Template:
      Count: 1
      # Start: 5
      # Hostname: {{.Prefix}}{{.Index}} # default
    # ---------------------------------------------------------------------------
    # "Users"
    # ---------------------------------------------------------------------------
    # Count: The number of user accounts _in addition_ to Admin
    # ---------------------------------------------------------------------------
    Users:
      Count: 1
```

The naming convention for a network entity is `<HOSTNAME>.<DOMAIN>`, so for the ordering node we have `orderer.example.com`

After running the `cryptogen` tool, the generated certificates and keys will be saved to a folder called `crypto-config`

### Configuration Transaction Generator

The `configtxgen` tool is used to generate four configuration artifacts 

- Orderer `genisis block`
- Channel `configuation transaction`
- Two `anchor peer transactions` - One for each Peer Org

The `genesis block` is the configuration block that initializes the ordering service and serves as the first block on a chain

Configtxgen works by consuming a `configtx.yaml` file which contains definitions for the network

In the `configtx.yaml` file we define the following

- One Orderer Org `OrdererOrg`
- Two Peer Orgs `Org1` and `Org2`
- A Consortium `SampleConsortium`

The file also has two unique headers

- One for the Orderer Genesis Block `TwoOrgsOrdererGenesis`
- One for the Channel `TwoOrgsChannel`

Which can be seen in the file below

```yaml
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

---
################################################################################
#
#   Section: Organizations
#
#   - This section defines the different organizational identities which will
#   be referenced later in the configuration.
#
################################################################################
Organizations:

    # SampleOrg defines an MSP using the sampleconfig.  It should never be used
    # in production but may be used as a template for other definitions
    - &OrdererOrg
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: OrdererOrg

        # ID to load the MSP definition as
        ID: OrdererMSP

        # MSPDir is the filesystem path which contains the MSP configuration
        MSPDir: crypto-config/ordererOrganizations/example.com/msp

    - &Org1
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: Org1MSP

        # ID to load the MSP definition as
        ID: Org1MSP

        MSPDir: crypto-config/peerOrganizations/org1.example.com/msp

        AnchorPeers:
            # AnchorPeers defines the location of peers which can be used
            # for cross org gossip communication.  Note, this value is only
            # encoded in the genesis block in the Application section context
            - Host: peer0.org1.example.com
              Port: 7051

################################################################################
#
#   SECTION: Application
#
#   - This section defines the values to encode into a config transaction or
#   genesis block for application related parameters
#
################################################################################
Application: &ApplicationDefaults

    # Organizations is the list of orgs which are defined as participants on
    # the application side of the network
    Organizations:

################################################################################
#
#   SECTION: Orderer
#
#   - This section defines the values to encode into a config transaction or
#   genesis block for orderer related parameters
#
################################################################################
Orderer: &OrdererDefaults

    # Orderer Type: The orderer implementation to start
    # Available types are "solo" and "kafka"
    OrdererType: solo

    Addresses:
        - orderer.example.com:7050

    # Batch Timeout: The amount of time to wait before creating a batch
    BatchTimeout: 2s

    # Batch Size: Controls the number of messages batched into a block
    BatchSize:

        # Max Message Count: The maximum number of messages to permit in a batch
        MaxMessageCount: 10

        # Absolute Max Bytes: The absolute maximum number of bytes allowed for
        # the serialized messages in a batch.
        AbsoluteMaxBytes: 99 MB

        # Preferred Max Bytes: The preferred maximum number of bytes allowed for
        # the serialized messages in a batch. A message larger than the preferred
        # max bytes will result in a batch larger than preferred max bytes.
        PreferredMaxBytes: 512 KB

    Kafka:
        # Brokers: A list of Kafka brokers to which the orderer connects
        # NOTE: Use IP:port notation
        Brokers:
            - 127.0.0.1:9092

    # Organizations is the list of orgs which are defined as participants on
    # the orderer side of the network
    Organizations:

################################################################################
#
#   Profile
#
#   - Different configuration profiles may be encoded here to be specified
#   as parameters to the configtxgen tool
#
################################################################################
Profiles:

    OneOrgOrdererGenesis:
        Orderer:
            <<: *OrdererDefaults
            Organizations:
                - *OrdererOrg
        Consortiums:
            SampleConsortium:
                Organizations:
                    - *Org1
    OneOrgChannel:
        Consortium: SampleConsortium
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - *Org1
```


### Run the Tools

We can make use of the `configtxgen` and `cryptogen` commands to do what we need, alternatively we can also adapt the `byfn.sh` script's `generateCerts` function to meet our requirements

> Before running the remainder of the tools, make sure the previous network is down by running the following
> ```bash
> ./byfn.sh down
> ```
> If you run into an error that says `cannot remove .... Permission denied` run the command as `sudo`

#### Manually Generate the Artifacts

We can refer to the `generateCerts` function to see how we would go about doing this, but we can also do this using the binaries manually as follows

```bash
../bin/cryptogen generate --config=./crypto-config.yaml
```

Which should have the following output

```
org1.example.com
org2.example.com
```

Which will output the certs and keys into a `cypto-config` directory

Next we need to use the `cofigtxgen` tool as follows

```bash
export FABRIC_CFG_PATH=$PWD

../bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
```

Which should have an output like

```
2017-10-26 19:21:56.301 EDT [common/tools/configtxgen] main -> INFO 001 Loading configuration
2017-10-26 19:21:56.309 EDT [common/tools/configtxgen] doOutputBlock -> INFO 002 Generating genesis block
2017-10-26 19:21:56.309 EDT [common/tools/configtxgen] doOutputBlock -> INFO 003 Writing genesis block
```

#### Create Channel Configuration

Create the `CHANNEL_NAME` environment variable

```bash
export CHANNEL_NAME=mychannel
```

And create the Channel Transaction Artifact

```bash
../bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
```

Then define the Anchor Peer for `Org1` and `Org2` as follows

```bash
../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
```

### Start the Network

We make use of the docker compose files to bring up the fabric containers and bootstrap the Orderer with the `genesis.block`

There are a few different steps as follows

Start the network from your terminal with the following command, the `-d` flag disables container logs, if you want to view the logs, run the following command in a new terminal

```bash
docker-compose -f docker-compose-cli.yaml up -d
```

#### Environment Variables

We need to configure some environment variables. The variables for `peer0.org1.example.com` are coded into the CLI container via the `docker-compose-cli.yaml` file, however if we want to send calls to other peers or Orderers, we need to modify the following values in the `cli.environment` object in the `yaml` file before starting the network

```yaml
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
CORE_PEER_ADDRESS=peer0.org1.example.com:7051
CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
```

#### Create and Join a Channel

We created the channel configuraion transaction using the `configtxgen` tool, that process can be repeated to create additional channel configurations with the `configtx.yaml` file by using the same or different profiles

We enter the CLI container next with `docker exec`

```bash
docker exec -it cli bash
```

If successful you will see the following

```bash
root@0d78bb69300d:/opt/gopath/src/github.com/hyperledger/fabric/peer#
```

Now we need to set previously mentioned variables in the `cli` container as they are different to what we had previously set in the `docker-compose-cli.yaml` file. From the Container's terminal run the following

```bash
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
```

Next we specify the channel name with the `-c` flag, and the channel transaction with the `-f` flag, we will create the channel with the following from our terminal:

```bash
export CHANNEL_NAME=mychannel

# the channel.tx file is mounted in the channel-artifacts directory within your CLI container
# as a result, we pass the full path for the file
# we also pass the path for the orderer ca-cert in order to verify the TLS handshake
# be sure to export or replace the $CHANNEL_NAME variable appropriately

peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

If you run into an error at this stage, such as the one below

```bash
Error: error getting endorser client chaincode: endorser client failed to connect to peer0.org1.example.com:7051 failed to create new connection context deadline exceeded.
```

It likely indicatesthat the previous network was not taken down correctly, run `sudo ./byfn. down` and ensure that you have no running containers with `docker container ls`

Note the `--cafile` is the Certificate file for the Orderer allowing us to verify the TLS handshake

The command we just executed generated a proto called `mychannel.block` which we can see by running `ls` from within the container

We can now join `peer0.org1.example.com` to the channel we just created with the following

```bash
peer channel join -b mychannel.block
```

Thereafter join `peer0.org2` by prefacing it with the appropriate environment variables and joining the channel on behalf of `peer0.org2`

```bash
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp CORE_PEER_ADDRESS=peer0.org2.example.com:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt peer channel join -b mychannel.block
```

#### Update the Anchor Peers

Nexty we will perform channel updates which will propogate to the definition of the channel, essentially adding configuration deltas for the channel's genesis block to define the anchor peers

We can define the anchor peer for Org1 as `peer.0org1.example.com`, as our environment variables still hold the values for 

```bash
peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

And for Org2 as `peer0.org2.example.com` by updating 

```bash
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp CORE_PEER_ADDRESS=peer0.org2.example.com:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

#### Install and Instantiate Chaincode

Applications interact with the ledger through `chaincode`, we need to install chaincode on every peer that will need to execute and endorse out interactions. Chaincode can be written in Go, Java, and Javascript and runs on the peer in the context of a chaincode container with a specific name and version and exists on the peer's filesystem

We can install chaincode on a peer with the following command, the `-l` flag allows us to specify the language

```bash
peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/chaincode_example02/node/
```

The `-p` argument is the path to the file and the `-n` is the name of the chaincode

Next we can instantiate the Chaincode on the peer, the `-P` flag indicates the endorsement policy needed, in the following case it is `-P "AND ('Org1MSP.peer','Org2MSP.peer')"`

Next, modify the environment variables and install the chaincode on peer 2

```bash
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
CORE_PEER_ADDRESS=peer0.org2.example.com:7051
CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
```

```bash
peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/chaincode_example02/node/
```

We can instantiate the chaincode with the following

```bash
peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc -l node -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"
```

Note that the above command may take a while to execute for Node and Java as it is also installing a shim and container respectively

#### Verify Chaincode

We can make some queries and transactions to verify that the chaincode was correctly installed

##### Query

we can query the value od `a` to make sure the state DB was populated as follows

```bash
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
```

The queey should return `100`

##### Invoke

Next, move 10 from `a` to `b`

```bash
peer chaincode invoke -o orderer.example.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"Args":["invoke","a","b","10"]}'
```

##### Query

Thereafter, query the value again to verify that the transfer succeeded

```bash
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
```

We should now see `90`

##### Install on New Peer

Now, Install the chaincode on a third peer `peer1.org2`, first set the folowing environment variables

```bash
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
CORE_PEER_ADDRESS=peer1.org2.example.com:7051
CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
```

Then install the chaincode

```bash
peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/chaincode_example02/node/
```

##### Join Channel

Next the new peer needs to join the channel before it can respond to queries

```bash
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp CORE_PEER_ADDRESS=peer1.org2.example.com:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt peer channel join -b mychannel.block
```

##### Query

After a few seconds when the peer has joined the channel, we can submit the query

```bash
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
```

We should see the same output as before of `90`

### Take Down the Network

Lastly, we can take down the network with

```bash
./byfn.sh down
```

The process we just covered is the same as what happens when we run `./byfn.sh up`, we can run this again and look at the logs in order to see the above with some neat output which I will not put here

### Important Points

- Chaincode must be installed on a peer for it to successfully read and write
- Chaincode is not instantiated until an `init` or `read/write` transaction is performed against the chaincode
- An intial transaction causes a container to start
- All peers on a channel maintain the same copy of the ledger, even those without the chaincode installed on them

### Viewing Transactions

We can see transactions by looking at the logs for the CLI container

```bash
docker logs -f cli
```

Furhtermore we can see the chaincode logs by looking at the logs for each respective peer

```bash
docker logs dev-peer0.org2.example.com-mycc-1.0
dokcer logs dev-peer0.org1.example.com-mycc-1.0
docker logs dev-peer1.org2.example.com-mycc-1.0
```

### CouchDB

We can switch the database from GloveDB to CouchDB in order to allow us to make more complex queries additional to the standard chaincode functionality, to use CouchDB we simply compose with the `docker-compose-couch.yaml` file as follows

```bash
docker-compose -f docker-compose-cli.yaml -f docker-compose-couch.yaml up -d
```

While running a development environment we can map CouchDB to a port in order to allow us to use the REST API and visualize the Db with the Web UI, however port mapping is not recommended for Production environments

If we want to look at a tutorial for doing the above with CouchDB we can find that [here](https://hyperledger-fabric.readthedocs.io/en/latest/build_network.html#using-couchdb)

CouchDB allows us to store more complex JSON data in a fully queryable format, as well as enhancing security for compliance and allows us to do field-level security such as calue masking and filtering

### Troubleshooting

If you need to shoot some trouble you can find some information in the [Fabric Docs](https://hyperledger-fabric.readthedocs.io/en/latest/build_network.html#troubleshooting)

## [Add an Org to a Channel](https://hyperledger-fabric.readthedocs.io/en/latest/channel_update_tutorial.html)

This extends on the network from `byfn` by adding a new Organization to the channel. Chaincode updates are handled by an organization admin and not a chaincode or application developer

### Environment Setup

First we set up the environment by using the `byfn.sh` script, we do this by first clearning up any previous artifacts, generating new artifacts, and launching the network as follows:

```bash
./byfn.sh down
./byfn.sh generate
./byfn.sh up
```

If you run into a `Permission denied` error, run it again with `sudo`

### Add Org3 to the Channel

Newt we should be able to add Org3 to the channel with the `eyfn.sh` script as follows

```bash
./eyfn.sh up
```

We can also make use of the script to configure our network with a few different options with

```bash
./byfn.sh up -c testchannel -s couchdb -l node
```

And then

```bash
./eyfn.sh up -c testchannel -s couchdb -l node
```

Once we are done, we can look at the logs and then run the following script to bring down the network

```bash
./eyfn.sh down
```

### Add Org3 to the Channel Manually

Before starting, modify the `docker-compose-cli.yaml` in the `first-network` directory to set the `FABRIC_LOGGING_SPEC` to  `DEBUG`

```yaml
cli:
  container_name: cli
  image: hyperledger/fabric-tools:$IMAGE_TAG
  tty: true
  stdin_open: true
  environment:
    - GOPATH=/opt/gopath
    - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
    #- FABRIC_LOGGING_SPEC=INFO
    - FABRIC_LOGGING_SPEC=DEBUG
```

And do the same for the `docker-compose-org3.yaml` file

```yaml
Org3cli:
  container_name: Org3cli
  image: hyperledger/fabric-tools:$IMAGE_TAG
  tty: true
  stdin_open: true
  environment:
    - GOPATH=/opt/gopath
    - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
    #- FABRIC_LOGGING_SPEC=INFO
    - FABRIC_LOGGING_SPEC=DEBUG
```

Now, bring up the initial network with the following commands:

```bash
./byfn.sh generate
./byfn.sh up
```

This will get us to the same network state as before we executed the `./eyfn.sh up` command

#### Generate the Org3 Crypto Material

In a new terminal cd into the `org3-artifacts` directory and generate the crypto material for Org3 using the `org3-crypto.yaml` and the `configtx.yaml` files

```bash
../../bin/cryptogen generate --config=./org3-crypto.yaml
```

This command reads the `org3-crypto.yaml` file and uses `cryptogen` to generate the keys and certificates for an Org3 CA and 2 Peers, the crypto material is then placed into the `orypto-config` subdirectory

Next we use the `configtxgen` tool to create the Org3 config material in JSON as follows

``bash
export FABRIC_CFG_PATH=$PWD && ../../bin/configtxgen -printOrg Org3MSP > ../channel-artifacts/org3.json
```

This command creates a JSON file that contains policy definitions for Org3 as well as the following certificates:

- Admin user certificate
- CA root cert
- TLS root cert

This JSON file will later be appended to the channel configuration

Next, we'll make a copy of the Orderer's TLS root cert to allow for secure communication between Org3 entities and the Ordering node

```bash
cd ../ && cp -r crypto-config/ordererOrganizations org3-artifacts/crypto-config/
```

Now we have all the required material to update the channel

#### Prepare the CLI Environment

We will mak use of the `configtxlator` tool which provides a stateless REST API aside from the SDK as well as allows us to easily convert between different data representations/formats

First `exec` into the CLI container export the following variables

```bash
docker exec -it cli bash
```

```bash
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CHANNEL_NAME=mychannel
```

> Iy you need to restart the CLI contiiner, you will need to redefine the above variables (obviously)

#### Fetch the Configuration

Now that we have defined the two environment variables we can fetch the most recent config block for the channel. We will then save a binary protobuf channel configuration block to a `config_block.pb` file with the following command

```bash
peer channel fetch config config_block.pb -o orderer.example.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
```

The last line of the output should say something like

```
readBlock -> DEB 011 Received block: 2
```

From here we can see that the most recent block is from the `byfn` script and it was when the script defined `Org2`, The following are the configurations we have done so far

- Block 0 - Genesis Block
- Block1 - Org 1 Anchor Peer update
- Block 2 - Org 2 Anchor Peer update

#### Convert Config to JSON

We will now make use of the `configxlator` tool to decode the channel conifguration blok into JSON as well as strip away any metadata and creator signatures that are irrlevant to us as humans with the `jq` tool

```bash
configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
```

#### Add the Org3 Crypto Material

Up until this point the steps for making any config update will be the same, from here the steps are specific to adding a channel

Now that we have the Channel config as JSON we can use `jq` to append the `org3.json` definition and save it as `modified_config.json`

```bash
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org3MSP":.[1]}}}}}' config.json ./channel-artifacts/org3.json > modified_config.json
```

And thereafter we translate the `config.json` and `modified_config.json` to protobufs `config.pb` and `modified_config.pb` respectively so we can calculate the delta between the two configs

```bash
configtxlator proto_encode --input config.json --type common.Config --output config.pb

configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
```

Then we can calculate the deltas

```bash
configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config.pb --output org3_update.pb
```

The file we just genreated `org3_update.pb` contains the Org3 definitions and is the definition of the deltas

Before submiting to the channel, we need to add some headers and additional content around the JSON file, we can do that by first getting a JSON version of our deltas

```bash
configtxlator proto_decode --input org3_update.pb --type common.ConfigUpdate | jq . > org3_update.json
```

And wrapping it in some additional data and adding the meta back with `jq`

```bash
echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat org3_update.json)'}}}' | jq . > org3_update_in_envelope.json
```

Lastly, we will convert the final JSON deltas into a protobuf file as follows

```bash
configtxlator proto_encode --input org3_update_in_envelope.json --type common.Envelope --output org3_update_in_envelope.pb
```

#### Sign and Submit the Update

We have the updated proto in the `org3_update_in_envelope.json` file in the conainerm however we need signatures from the required admin users before the conffig change can we written to the ledger

The modification policy is set to the default value of `MAJORITY`, since we have two peers, this means they oth need to sign the change otherwise the ordering service will reject the transaction

We can first sign the update as Org1 Admin as follows (since the CLI is bootstrapped with the Org1 MSP Material) by executing the following command

```bash
peer channel signconfigtx -f org3_update_in_envelope.pb
```
Next we switch to Org2 by changing our environment credentials and running the `peer channel update` command

> Note that realistically a single container would not have all the network's crypto material

Export the Org2 environment variables

```bash
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:7051
```

And then sign the update with this peer as well

```bash
peer channel update -f org3_update_in_envelope.pb -c $CHANNEL_NAME -o orderer.example.com:7050 --tls --cafile $ORDERER_CA
```

### Cofiguring Leader Election

The default leader mode is dynamic for new peers. New peers are bootstrapped with the genesis block that does not contain information about the Org they are in. New peers are unable to verify blocks until they get a channel configuration transaction, they therefore must have a leader mode in order to receive blocks from the Ordering service

Static:

```bash
CORE_PEER_GOSSIP_USELEADERELECTION=false
CORE_PEER_GOSSIP_ORGLEADER=true
```

Dynamic:

```bash
CORE_PEER_GOSSIP_USELEADERELECTION=true
CORE_PEER_GOSSIP_ORGLEADER=false
```

### Join Org3 to the Channel

Until this point the channel config has been updated to include `Org3`, meaning that new peers on `Org3` can jon the channel `mychannel`

We can set up `Org3` by using the docker compose file for it

```bash
docker-compose-org3-yaml up -d
```

And then we can `exec` into it with the following

```bash
docker exec -it Org3cli bash
```

And export the key variables

```bash
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CHANNEL_NAME=mychannel
```

Next we can send a call to the ordering service to retrieve the block we just added

```bash
peer channel fetch 0 mychannel.block -o orderer.example.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
```

Note that the `0` we pass to the above command will retrieve the Genesis block and not the latest block in the chain

Next we can join the peer to the channel using the genesis block as follows

```bash
peer channel join -b mychannel.block
```

We can then add a second peer to the block with:


```bash
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=peer1.org3.example.com:7051

peer channel join -b mychannel.block
```

### Upgrade and Invoke Chaincode

The new chaincode policy has been put in place to include Org3, we can install the updated chaincode on Org3 with the following:

```bash
peer chaincode install -n mycc -v 2.0 -p github.com/chaincode/chaincode_example02/go/
```

And then from the original CLI container we can install the chaincode onto `peer0.org1` and `peer0.org2` with the following

```bash
peer chaincode install -n mycc -v 2.0 -p github.com/chaincode/chaincode_example02/go/

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

peer chaincode install -n mycc -v 2.0 -p github.com/chaincode/chaincode_example02/go/
```

Now that the chaincode has been installed we can upgrade the chaincode and specify the new endorsement policy for transactions. Furthermore we can see that we are passing the initialize command with a few arguments

```bash
peer chaincode upgrade -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -v 2.0 -c '{"Args":["init","a","90","b","210"]}' -P "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')"
```

Next we can query the chaincode, invoke it, and query it again to see that it works as follows

```bash
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
peer chaincode invoke -o orderer.example.com:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -c '{"Args":["invoke","a","b","10"]}'
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
```