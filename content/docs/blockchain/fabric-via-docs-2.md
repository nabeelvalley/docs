- [Working with Fabric - Part 2](#working-with-fabric---part-2)
  - [Add an Org to a Channel](#add-an-org-to-a-channel)
    - [Environment Setup](#environment-setup)
    - [Add Org3 to the Channel](#add-org3-to-the-channel)
    - [Add Org3 to the Channel Manually](#add-org3-to-the-channel-manually)
      - [Generate the Org3 Crypto Material](#generate-the-org3-crypto-material)

# [Add an Org to a Channel](https://hyperledger-fabric.readthedocs.io/en/latest/channel_update_tutorial.html)

This extends on the network from `byfn` by adding a new Organization to the channel. Chaincode updates are handled by an organization admin and not a chaincode or application developer

## Environment Setup

First we set up the environment by using the `byfn.sh` script, we do this by first clearning up any previous artifacts, generating new artifacts, and launching the network as follows:

```bash
./byfn.sh down
./byfn.sh generate
./byfn.sh up
```

If you run into a `Permission denied` error, run it again with `sudo`

## Add Org3 to the Channel

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

## Add Org3 to the Channel Manually

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

### Generate the Org3 Crypto Material

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

### Prepare the CLI Environment

We will mak use of the `configtxlator` tool which provides a stateless REST API aside from the SDK as well as allows us to easily convert between different data representations/formats

First `exec` into the CLI container export the following variables

```bash
docker exec -it cli bash
```

```bash
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CHANNEL_NAME=mychannel
```

> If you need to restart the CLI container, you will need to redefine the above variables (obviously)

### Fetch the Configuration

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

### Convert Config to JSON

We will now make use of the `configxlator` tool to decode the channel conifguration blok into JSON as well as strip away any metadata and creator signatures that are irrlevant to us as humans with the `jq` tool

```bash
configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
```

### Add the Org3 Crypto Material

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

### Sign and Submit the Update

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

## Cofiguring Leader Election

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

## Join Org3 to the Channel

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

## Upgrade and Invoke Chaincode

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

# Chaincode for Developers

Chaincode is a program in Go, Node or Java that implements the prescribed Chaincode Interface. It runs in a secured docker container isolated from the peer process and intiializes and manages ledger state by way of transactions

Chaincode handles business logic agreed by members of a network, similar to a smart contract. Chaincode can be invoked to update or query the ledger, and with the correct permissions even invoke other chaincode

## The Chaincode API

Any chaincode program must implement the `Chaincode` interface, whose methods are called in response to received transactions. Particularly the `Init` method is called when a chaincode receives an `instantiate` or `upgrade` transaction

The other interface available is the `ChaincodeStubInterface` and allows chaincodes to access and modify the ledger and make invocations to other chaincode

## Simple Asset Chaincode

We will make use of a simple chaincode built with Go (I will look at implementing this with Node as well, but the documentation uses Go for the time being)

Firstly, you will need to install Go and create the following directories (For more info on Go and how the Go file system needs to look - check out the notes on that [here](/docs/go/basics)

The Go Installation Instructions for Fabric can be found [here](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html#golang)

Make the directory in your Go workspace `go/src/sacc`. You can easily `cd` to this by using the `$GOPATH` environment variable, in the Go workspace, make the directory `src/sacc` in which we can add the chaincode

## Housekeeping

The chaincode file will need to import the necessary packages and have a struct which can define the asset

```go
package main

import (
  "fmt"

  "github.com/hyperledger/fabric/core/chaincode/shim"
  "github.com/hyperledger/fabric/protos/peer"
)

// SimpleAsset implements a simple chaincode to manage an asset
type SimpleAsset struct {
}
```

## Initialization

We need to provide the `Init` function, this is called when te chaincode is initialized or when chaincode is upgraded. When writing a chaincode upgrade be sure to modify the `Init` function to be empty if there is no migration that needs to be done

Our `Init` function will be defined as follows:
```go
// Init is called during chaincode instantiation to initialize any data.
func (t *SimpleAsset) Init(stub shim.ChaincodeStubInterface) peer.Response {

}
```

It will make use of the `GetStringArgs` function, since we are expecting a key-value pair, we will need to have two arguments so we will check for that

```go
// Init is called during chaincode instantiation to initialize any
// data. Note that chaincode upgrade also calls this function to reset
// or to migrate data, so be careful to avoid a scenario where you
// inadvertently clobber your ledger's data!
func (t *SimpleAsset) Init(stub shim.ChaincodeStubInterface) peer.Response {
  // Get the args from the transaction proposal
  _, args := stub.GetFunctionAndParameters()
  if len(args) != 2 {
    return shim.Error("Incorrect arguments. Expecting a key and a value")
  }
}
```

Then we will store the state in the ledger using the `PutState` function with the key and value, and if that went well we will return a `peer.Response`

```go
// Init is called during chaincode instantiation to initialize any
// data. Note that chaincode upgrade also calls this function to reset
// or to migrate data, so be careful to avoid a scenario where you
// inadvertently clobber your ledger's data!
func (t *SimpleAsset) Init(stub shim.ChaincodeStubInterface) peer.Response {
  // Get the args from the transaction proposal
  _, args := stub.GetFunctionAndParameters()
  if len(args) != 2 {
    return shim.Error("Incorrect arguments. Expecting a key and a value")
  }

  // Set up any variables or assets here by calling stub.PutState()

  // We store the key and the value on the ledger
  err := stub.PutState(args[0], []byte(args[1]))
  if err != nil {
    return shim.Error(fmt.Sprintf("Failed to create asset: %s", args[0]))
  }
  return shim.Success(nil)
}
```

## Invoking the Chaincode

`Invoke` is called per transaction, and may either be a `get` or `set` method. `set` will create a new asset by specifying the key-value pair

```go
// Invoke is called per transaction on the chaincode. Each transaction is
// either a 'get' or a 'set' on the asset created by Init function. The 'set'
// method may create a new asset by specifying a new key-value pair.
func (t *SimpleAsset) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

}
```

Once again, we need to extract the argumets from the `ChaincodeStubInterface`, our application has a `get` and a `set` function that allow the value of an asset to be set, or its current value to be retrieved. We first call the `GetFunctionAndParameters` to get the function name and params

```go
// Invoke is called per transaction on the chaincode. Each transaction is
// either a 'get' or a 'set' on the asset created by Init function. The Set
// method may create a new asset by specifying a new key-value pair.
func (t *SimpleAsset) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
    // Extract the function and args from the transaction proposal
    fn, args := stub.GetFunctionAndParameters()

}
```

Next, we will identify if the function is `get` or `set` and will call the respective functions, we do this simply as follows

```go
// Invoke is called per transaction on the chaincode. Each transaction is
// either a 'get' or a 'set' on the asset created by Init function. The Set
// method may create a new asset by specifying a new key-value pair.
func (t *SimpleAsset) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
    // Extract the function and args from the transaction proposal
    fn, args := stub.GetFunctionAndParameters()

    var result string
    var err error
    if fn == "set" {
            result, err = set(stub, args)
    } else {
            result, err = get(stub, args)
    }
    if err != nil {
            return shim.Error(err.Error())
    }

    // Return the result as success payload
    return shim.Success([]byte(result))
}
```

## Implementing the Chaincode Functionality

Next we can define the chaincode implementation by defining the `get` and `set` functions. We will make use of the `PutState` and `GetState` functions to do this

```go
// Set stores the asset (both key and value) on the ledger. If the key exists,
// it will override the value with the new one
func set(stub shim.ChaincodeStubInterface, args []string) (string, error) {
    if len(args) != 2 {
            return "", fmt.Errorf("Incorrect arguments. Expecting a key and a value")
    }

    err := stub.PutState(args[0], []byte(args[1]))
    if err != nil {
            return "", fmt.Errorf("Failed to set asset: %s", args[0])
    }
    return args[1], nil
}

// Get returns the value of the specified asset key
func get(stub shim.ChaincodeStubInterface, args []string) (string, error) {
    if len(args) != 1 {
            return "", fmt.Errorf("Incorrect arguments. Expecting a key")
    }

    value, err := stub.GetState(args[0])
    if err != nil {
            return "", fmt.Errorf("Failed to get asset: %s with error: %s", args[0], err)
    }
    if value == nil {
            return "", fmt.Errorf("Asset not found: %s", args[0])
    }
    return string(value), nil
}
```

## Starting the Chaincode

Lastly, we need to implement the `main` method that will call the `shim.Start` function

```go
// main function starts up the chaincode in the container during instantiate
func main() {
    if err := shim.Start(new(SimpleAsset)); err != nil {
            fmt.Printf("Error starting SimpleAsset chaincode: %s", err)
    }
}
```

## Final Chaincode

The overall chaincode will be as follows

```go
package main

import (
    "fmt"

    "github.com/hyperledger/fabric/core/chaincode/shim"
    "github.com/hyperledger/fabric/protos/peer"
)

// SimpleAsset implements a simple chaincode to manage an asset
type SimpleAsset struct {
}

// Init is called during chaincode instantiation to initialize any
// data. Note that chaincode upgrade also calls this function to reset
// or to migrate data.
func (t *SimpleAsset) Init(stub shim.ChaincodeStubInterface) peer.Response {
    // Get the args from the transaction proposal
    _, args := stub.GetFunctionAndParameters()
    if len(args) != 2 {
            return shim.Error("Incorrect arguments. Expecting a key and a value")
    }

    // Set up any variables or assets here by calling stub.PutState()

    // We store the key and the value on the ledger
    err := stub.PutState(args[0], []byte(args[1]))
    if err != nil {
            return shim.Error(fmt.Sprintf("Failed to create asset: %s", args[0]))
    }
    return shim.Success(nil)
}

// Invoke is called per transaction on the chaincode. Each transaction is
// either a 'get' or a 'set' on the asset created by Init function. The Set
// method may create a new asset by specifying a new key-value pair.
func (t *SimpleAsset) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
    // Extract the function and args from the transaction proposal
    fn, args := stub.GetFunctionAndParameters()

    var result string
    var err error
    if fn == "set" {
            result, err = set(stub, args)
    } else { // assume 'get' even if fn is nil
            result, err = get(stub, args)
    }
    if err != nil {
            return shim.Error(err.Error())
    }

    // Return the result as success payload
    return shim.Success([]byte(result))
}

// Set stores the asset (both key and value) on the ledger. If the key exists,
// it will override the value with the new one
func set(stub shim.ChaincodeStubInterface, args []string) (string, error) {
    if len(args) != 2 {
            return "", fmt.Errorf("Incorrect arguments. Expecting a key and a value")
    }

    err := stub.PutState(args[0], []byte(args[1]))
    if err != nil {
            return "", fmt.Errorf("Failed to set asset: %s", args[0])
    }
    return args[1], nil
}

// Get returns the value of the specified asset key
func get(stub shim.ChaincodeStubInterface, args []string) (string, error) {
    if len(args) != 1 {
            return "", fmt.Errorf("Incorrect arguments. Expecting a key")
    }

    value, err := stub.GetState(args[0])
    if err != nil {
            return "", fmt.Errorf("Failed to get asset: %s with error: %s", args[0], err)
    }
    if value == nil {
            return "", fmt.Errorf("Asset not found: %s", args[0])
    }
    return string(value), nil
}

// main function starts up the chaincode in the container during instantiate
func main() {
    if err := shim.Start(new(SimpleAsset)); err != nil {
            fmt.Printf("Error starting SimpleAsset chaincode: %s", err)
    }
}
```

## Build the Chaincode

We can compile the code with the following

```bash
go get -u github.com/hyperledger/fabric/core/chaincode/shim
go build
```

## Test the Code

We can test the chaincode with the `fabric-samples/docker-devmode` folder. For this we will need 3 terminals

### Terminal 1 - Start the Network
```bash
docker-compose -f docker-compose-simple.yaml up
```

### Terminal 2 - Build and Start the Chaincode

```bash
docker exec -it chaincode bash
```

```bash
cd sacc
go build
```

Then run the chaincode with

```bash
CORE_PEER_ADDRESS=peer:7052 CORE_CHAINCODE_ID_NAME=mycc:0 ./sacc
```

### Terminal 3 - Use the Chaincode

```bash
docker exec -it cli bash
```
```bash
peer chaincode install -p chaincodedev/chaincode/sacc -n mycc -v 0
peer chaincode instantiate -n mycc -v 0 -c '{"Args":["init","a","10"]}' -C myc
peer chaincode invoke -n mycc -c '{"Args":["set", "a", "20"]}' -C myc
peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C myc
```

## Note on the Instantiation Method

Note that the instantiation method in the official documentation for this tutorial does not make us of the `init` argument that should be passed in (This may result in it failing when using something like IBM Cloud Blockchain which by default passes in the `init` argument), for a better example of an Instantiation take a look at [this page](https://github.com/hyperledger/fabric-samples/blob/release-1.4/chaincode/chaincode_example02/go/chaincode_example02.go)
