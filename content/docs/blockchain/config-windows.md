# Script

Before running the below script, ensure that you are in Administrator Powershell and that your Execution Policy is set to Remote Signed, if not then first run the following command

```powershell
Set-ExecutionPolicy RemoteSigned
```

Then run the script below

```powershell
cd ~
choco install python2 docker-desktop docker-compose golang nodejs git -y
npm install --global windows-build-tools
npm install --global grpc
mkdir .\go\src\github.com\hyperledger
cd go\src\github.com\hyperledger
git clone https://github.com/hyperledger/fabric.git
```

This will install the necessary prerequisites and should also set up the environment variables as well as the Go Workspace, but you may need to verify that the below steps were completed correctly

(Don't know how accurate this script is as it may not necessarily work, but the instructions are as follows)

# Received Instructions

## Install Git for Windows x64 to include Uname command

https://curl.haxx.se/windows/

## Extract binaries + add to Env Variables

https://store.docker.com/editions/community/docker-ce-desktop-windows

## Install Windows Xxtras

Node JS - https://nodejs.org/download/release/v8.9.4/
https://hyperledger-fabric.readthedocs.io/en/release-1.3/prereqs.html#id1

```powershell
npm install --global windows-build-tools
npm install --global grpc
```

## Install Go

1. Set Env Variables, PATH, GOPATH
2. Create Workspace

(Not sure if this will work on Powershell/how it would be done correctly)

```bash
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

## Install Python

https://www.python.org/downloads/release/python-2715/

## Set up Docker Shared Drives

https://docs.docker.com/docker-for-windows/#shared-drives

1. 1SET Env PATH var:

D:\Development\hyperledger\fabric-samples\bin

2. NEW ENV VAR

```bash
compose_convert_windows_paths = 1
MSYS_NO_PATHCONV=1
clone git clone https://github.com/hyperledger/fabric.git
to $GOPATH-> src/hyperledger
```
