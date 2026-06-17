---
published: true
title: Hyperledger Composer
subtitle: Introduction to Hyperledger Composer
---

# Overview

A business Network, defined in a **Business Network Archive** `.bna` File

- Models
- Logic
- Queries
- Access Control

In order to update a network, we simply upload the Archive `.bna` file to the network, this can either be done from the command line or from the Blockchain UI if using IBM Cloud

## Models

Models are files that define Assets, Participants and Transactions using the Hyperledger Composer Modelling Language

Models are defined in `.cto` files, and are written using the **Hyperledger Composer Modelling Language**

### CTO Language

[CTO Language](https://hyperledger.github.io/composer/v0.19/reference/cto_language.html)

A `.cto` file is composed of the following elements

1. A single namespace, all resource definitions are part of this namespace
2. A set of resource definitions
   - Assets
   - Transactions
   - Participants
   - Events
3. Optional import declarations than import resources from other namespaces

#### Namespaces

Resources are organized by namespaces, this is defined by first line in a `.cto` file which can be as follows

```js
namespace org.example.mynetwork
```

All other resources defined in the same file will be part of this namespace

#### Classes

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

#### Enums

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

#### Concepts

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

#### Primitive Types

Composer has a few primitive types, namely

- String
- Double
- Integer
- Long
- DateTime
- Boolean

#### Arrays

Arrays can simply be defined with `[]`

```js
o Integer[] integerArray
```

```js
--> Animal[] myAnimals
```

#### Relationships

A relationship is a tuple composed of

1. Namespace being referenced
2. Type being referenced
3. Identifier instance being referenced

For example

```js
org.example.Vehicle#23451
```

#### Field Validation

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

#### Imports

We can also import a type from a different namespace with the following

```js
import org.example.MyAsset
import org.example2.*
```

### Example

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
  - Commodity (Commodity _Asset_)
  - New Owner (Trader _Participant_)

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

## Logic

Logic is defined in **Script Files** `.js` which define transaction logic

### Example

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
  trade.commodity.owner = trade.newOwner

  // Persist updated asset in asset registry
  let assetRegistry = await getAssetRegistry('org.example.mynetwork.Commodity')
  await assetRegistry.update(trade.commodity)
}
```

## Queries

Queries are defined in **Query File** `.qry` file, note that a single `.bna` file can only have one query

## Access Control

Access Control Files `.acl` define what permissions different users have, a single network can only have one access control file

### Example

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

## Deployment

We can package our code into a `.bna` file by running the following command in our directory

```bash
composer archive create -t dir -n .
```

We then make use of a `PeerAdmin` identity card that contains the necessary credential and use this to install the `.bna` to the network

```bash
composer network install --card PeerAdmin@hlfv1 --archiveFile tutorial-network@0.0.1.bna
```
