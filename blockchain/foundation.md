# Foundation

### --- Temporarily Discontinued --

[Based on this Cognitive Class Course](https://cognitiveclass.ai/courses/ibm-blockchain-foundation-dev/)

## Prerequisites

For Windows you need \(in this order\):

* Python 2.7
* Docker
* Node
  * [With these packages](https://hyperledger.github.io/composer/latest/installing/development-tools)
* VS Code
  * With Hyperledger Composer Extension

## Hyperledger Composer

### Introduction

Hyperledger composer is an application framework that contains API's, modelling language, and a programming model that can be used to deploy business networks. It defines JavaScript API's to interact with asset registries

It is an abstraction over Hyperledger Fabric which allows us to more easily model business networks and integrations

Overall, Hyperledger Composer

* Increases understanding of business concepts
* Saves time by allowing us to develop applications quickly
* Reduces risk as it is a well tested and designed to suite best practices as well as allows for reusability
* Increases flexibility due to the high level of abstraction we are able to easily modify and change our model as is needed over time

### Components and Structure

The key concepts in the composer programming model are 

A Business Network Archive consists of a few key elements such as

* Models
* Script Files
* ACLs
* Metadata

### The Toolset

We make use of a variety of open source tools such as

* JavaScript
* Node/NPM
* VS Code
* Yeoman
* Composer CLI
* Web Playground
* LoopBack/Swagger

### Lab 1

We can look at the Hyperledger composer home page to view tutorials and the [prerequisite ](https://hyperledger.github.io/composer/latest/installing/installing-prereqs)and [installation guide](https://hyperledger.github.io/composer/latest/installing/development-tools)

#### Setting up the Dev Environment

Before we can get started we need to install the windows build tools in **Powershell** as an administrator

```text
npm install -g --production windows-build-tools
```

If you are using Ubuntu, using your terminal you can easily install all the prerequisites with

```text
curl -O https://hyperledger.github.io/composer/latest/prereqs-ubuntu.sh
chmod u+x prereqs-ubuntu.sh
./prereqs-ubuntu.sh
```

Then install the required node packages

```text
npm install -g composer-cli@0.20
npm install -g composer-rest-server@0.20
npm install -g generator-hyperledger-composer@0.20
npm install -g yo
```

We can also install playground to edit and test Business Networks

```text
npm install -g composer-playground@0.20
```

Next up we need to log in to run docker as an administrator and log in before we can do much else

```text
docker login
```

Then Install the Hyperledger Fabric via **Bash** \(if on Windows as well as an administrator\) as to download Fabric as well as some other configurations

```text
mkdir ~/fabric-dev-servers && cd ~/fabric-dev-servers

curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
tar -xvf fabric-dev-servers.tar.gz

cd ~/fabric-dev-servers
export FABRIC_VERSION=hlfv12
./downloadFabric.sh

cd ~/fabric-dev-servers
export FABRIC_VERSION=hlfv12
./startFabric.sh
./createPeerAdminCard.sh
```

Note that when using Windows Hyper-V needs to be enabled in order for Docker to work

Next up we can look at the [Developer Tutorial](https://hyperledger.github.io/composer/latest/tutorials/developer-tutorial) for Hyperledger Composer and follow the process

### --- Stopping here for now due to Technical Issues --

### 



