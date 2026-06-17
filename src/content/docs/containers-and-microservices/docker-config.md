---
published: true
title: Docker Configuration Scripts
---

## Docker Configuration Scripts

### Ubuntu

Run the following as `sudo` on an Ubuntu VM or WSL as per the instructions on the [Docker CE site](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

```bash
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo docker run hello-world
```

### WSL

[Take a look here](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly)

Note that WSL cannot independantly run the Daemon, but you can connect to the instance of Docker Daemon on your Windows system

```bash
## Update the apt package list.
sudo apt-get update -y

## Install Docker's package dependencies.
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

## Download and add Docker's official public PGP key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

## Verify the fingerprint.
sudo apt-key fingerprint 0EBFCD88

## Add the `stable` channel's Docker upstream repository.
#
## If you want to live on the edge, you can change "stable" below to "test" or
## "nightly". I highly recommend sticking with stable!
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

## Update the apt package list (for the new apt repo).
sudo apt-get update -y

## Install the latest version of Docker CE.
sudo apt-get install -y docker-ce

## Allow your user to access the Docker CLI without needing root access.
sudo usermod -aG docker $USER
```

Lastly in order to tell WSL where your Docker Daemon is running (assuming you've exposed it from Docker Desktop on Windows) you need to run the following

```bash
docker -H localhost:2375 images
```
