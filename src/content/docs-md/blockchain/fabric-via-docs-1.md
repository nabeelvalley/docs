---
published: true
title: Hyperledger Fabric Part 1
subtitle: Intro to Hyperledger Fabric via the Docs
---

## Resources

- [Prerequisites](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html)
- [Tutorials](https://hyperledger-fabric.readthedocs.io/en/latest/tutorials.html)
  - [Writing your first application](https://hyperledger-fabric.readthedocs.io/en/latest/write_first_app.html)
  - [Build your first network](https://hyperledger-fabric.readthedocs.io/en/latest/build_network.html)
- [Glossary](https://hyperledger-fabric.readthedocs.io/en/latest/glossary.html)

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
fabric_client.getUserContext('user1', true)
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
const gateway = new Gateway()
await gateway.connect(ccp, {
  wallet,
  identity: 'user1',
  discovery: { enabled: false },
})

// Get the network (channel) our contract is deployed to.
const network = await gateway.getNetwork('mychannel')

// Get the contract from the network.
const contract = network.getContract('fabcar')

// Evaluate the specified transaction.
// queryCar transaction - requires 1 argument, ex: ('queryCar', 'CAR4')
// queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
const result = await contract.evaluateTransaction('queryAllCars')
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
const result = await contract.evaluateTransaction('queryAllCars')
```

To be as follows:

```js
fabric - samples / chaincode / fabcar / javascript / lib / fabcar.js
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
const gateway = new Gateway()
await gateway.connect(ccp, {
  wallet,
  identity: 'user1',
  discovery: { enabled: false },
})

// Get the network (channel) our contract is deployed to.
const network = await gateway.getNetwork('mychannel')

// Get the contract from the network.
const contract = network.getContract('fabcar')

// Submit the specified transaction.
// createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
// changeCarOwner transaction - requires 2 args , ex: ('changeCarOwner', 'CAR10', 'Dave')
await contract.submitTransaction(
  'createCar',
  'CAR12',
  'Honda',
  'Accord',
  'Black',
  'Tom'
)
console.log('Transaction has been submitted')

// Disconnect from the gateway.
await gateway.disconnect()
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
await contract.submitTransaction(
  'createCar',
  'CAR12',
  'Honda',
  'Accord',
  'Black',
  'Tom'
)
```

To

```js
await contract.submitTransaction('changeCarOwner', 'CAR10', 'Dave')
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
>
> ```bash
> ./byfn.sh down
> ```
>
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
