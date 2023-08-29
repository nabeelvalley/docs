---
published: true
title: Blockchain Foundations
subtitle: Basic Blockchain Concepts using Hyperledger
---

[Based on this Cognitive Class Course](https://cognitiveclass.ai/courses/ibm-blockchain-foundation-dev/)

## Prerequisites

For Windows you need (in this order), Note that I cannot seem to get this to work on Windows, however there is information on running this with Ubuntu on [this page](/content/docs/blockchain/fabric-via-docs-1)

- Python 2.7
- Docker
- Node
  - [With these packages](https://hyperledger.github.io/composer/latest/installing/development-tools)
- VS Code
  - With Hyperledger Composer Extension

## Hyperledger Composer

### Introduction

Hyperledger composer is an application framework that contains API's, modelling language, and a programming model that can be used to deploy business networks. It defines JavaScript API's to interact with asset registries

It is an abstraction over Hyperledger Fabric which allows us to more easily model business networks and integrations

Overall, Hyperledger Composer

- Increases understanding of business concepts
- Saves time by allowing us to develop applications quickly
- Reduces risk as it is a well tested and designed to suite best practices as well as allows for reusability
- Increases flexibility due to the high level of abstraction we are able to easily modify and change our model as is needed over time

### Components and Structure

The key concepts in the composer programming model are

A Business Network Archive consists of a few key elements such as

- Models
- Script Files
- ACLs
- Metadata

### The Toolset

We make use of a variety of open source tools such as

- JavaScript
- Node/NPM
- VS Code
- Yeoman
- Composer CLI
- Web Playground
- LoopBack/Swagger

## Fabric

### Participants and Components

#### Participants

- Regulator to regulate the industry
- Blockchain architect
- Blockchain developer
- Blockchain network operator
- Traditional processing systems
- Traditional data sources
- Membership services
- Blockchain user

#### Components

- Ledger
  - Stores world state
- Smart contract
  - Encode business logic
- Peer network
  - eCerts for identity
  - tCerts for transactions
- Events
  - Pub/Sub event based system
- Wallet
  - Stores membership certificates/identity
- Integrations
  - Means of working with existing systems

#### Developer Considerations

Developers will be really interested in aspects like the Application and Smart Contracts, not things like Peers, Consensus and Security

A ledger consists of two different data structures, a blockchain which is a series of transactions and the world state which is a representation of the current state of assets

The application submits a transaction to a smart contract. This works synchronously across the network

The World state will change over time, but the Blocks will store transactions and thus be immutable

There are a variety of ways that we can integrate with existing system

We can make use of the Event Pub/Sub system to allow us to communicate between events, furthermore an external system can submit requests as a user

Smart contracts can also call out directly to existing systems, however this can very easily cause problems within the blockchain and if we are querying different information we may lead to a lack in consensus due to them all calling for the information at different times

### Administrator Considerations

A blockchain operator needs to look at the

- Peers
- Consensus
- Security

They will typically not care about application code, smart contracts, events, and integration

Consensus is the method of getting agreement and helps us to keep peers up to date and reach consensus while quarantining any malicious nodes

### Consensus

1. Application submits a request
2. Request is distributed throughout network
3. Designator creates a block containing a transaction
4. Runs blocks against ruleset
5. Network attempts to reach consensus
6. Once agreement is reached the block is added to th chain

There are many ways that consensus can be reached such as:

- Proof of work
  - Good when we do not know who we are working for
  - Very power intensive
  - Bitcoin, Ethereum
- Proof of stake
  - Works in untrusted network
  - Requires intrinsic cryptocurrency, "Nothing at stake" problem
  - Nxt
- Solo
  - Well suited for development
  - No consensus
  - Used in Hyperledger 1.0
- Kafka/Zookeeper
  - Efficient and fault tolerant
  - Does not guard against malicious activity
  - Used in Hyperledger 1.0
- Proof of Elapsed Time
  - Efficient
  - Tailored towards one vendor
  - Sawtooth-Lake
- PBFT based
  - Efficient and tolerent against malicious peers
  - Validators are known and totally connected
  - Used in Hyperledger 0.6

### Public vs Private

- Public
  - Transactions are viewable by anyone
  - Participant identity is unknown
- Private
  - Transactions are secret
  - Participants are known

Private blockchains make use of Identity Certificates and a Certificate Authority that issues certificates into a user's wallet and they submit their transactions using their certificates to submit transactions

### Architect Considerations

An architect will need to look at a variety of things such as

- Performance
- Security
- Resiliency

### Network Consensus Considerations

We have two different types of systems in a network

- Peers
  - Committing
    - Maintain ledger and state
    - Commits transactions
    - **May** hold chaincode
  - Endorsing
    - Specialized comitting peer
    - Endorses transaction proposals
    - Grants or denies endorsement
    - **Must** hold chaincode
- Ordering Service
  - Approves inclusion of transaction blocks into the ledger
  - Communicates with commiting and endorsing peer nodes
  - Does not hold smart contract or ledger

### Transaction Process

1. Propose transaction
   - Application will submit a proposed transaction to target peers
   - Nodes will need to endorse the policy
2. Execute Proposal
   - Each Endorser node will carry out the transaction
3. Proposal Response
   - The Endorser will send back the original transaction
   - Additionally will send the read/write state
   - Transaction Signature
4. Order Transaction
   - Verified transaction will be sent to the orderer
   - Orderer will group transactions into a block
5. Deliver Transaction
   - The orderer will then distribute the block to all the peers
6. Validate Transaction
   - Peers will then verify that the transaction is correct
   - The block will then be added to the chain
7. Notify Transaction
   - Send an event to say that the block has been added to the chain
