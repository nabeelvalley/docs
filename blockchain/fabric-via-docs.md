# Working with Fabric

- [Working with Fabric](#working-with-fabric)
  - [Overview](#overview)
    - [Models](#models)
      - [CTO Language](#cto-language)
        - [Namespaces](#namespaces)
        - [Classes](#classes)
        - [Enums](#enums)
        - [Concepts](#concepts)
        - [Primitive Types](#primitive-types)
        - [Arrays](#arrays)
        - [Relationships](#relationships)
        - [Field Validation](#field-validation)
        - [Imports](#imports)
      - [Example](#example)
    - [Logic](#logic)
      - [Example](#example-1)
    - [Queries](#queries)
    - [Access Control](#access-control)
      - [Example](#example-2)
    - [Deployment](#deployment)
  - [Prerequisites](#prerequisites)
    - [Installing Samples](#installing-samples)
  - [Writing your First Application](#writing-your-first-application)
    - [Setting up the environment](#setting-up-the-environment)
    - [Installing Clients and Launching the Network](#installing-clients-and-launching-the-network)
    - [Enroll the Admin User](#enroll-the-admin-user)
    - [Enroll a new User](#enroll-a-new-user)
    - [Querying the Ledger](#querying-the-ledger)
    - [Updating the Ledger](#updating-the-ledger)

- [Prerequisites](https://hyperledger-fabric.readthedocs.io/en/release-1.3/prereqs.html)
- [Tutorials](https://hyperledger-fabric.readthedocs.io/en/release-1.3/tutorials.html)
  - [Writing your first application](https://hyperledger-fabric.readthedocs.io/en/release-1.3/write_first_app.html)
  - [Build your first network](https://hyperledger-fabric.readthedocs.io/en/release-1.3/build_network.html)

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

## [Prerequisites]((https://hyperledger-fabric.readthedocs.io/en/release-1.3/prereqs.html)

Before you can really get started you will need to first [install the necessary prerequisites](https://hyperledger-fabric.readthedocs.io/en/release-1.3/prereqs.html)


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

## [Writing your First Application](https://hyperledger-fabric.readthedocs.io/en/release-1.3/write_first_app.html)

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

