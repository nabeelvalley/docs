---
published: true
title: Managing a Node using Chef
subtitle: Managing a Node using Chef
---

[From this Module](https://learn.chef.io/modules/manage-a-node-chef-server/ubuntu/bring-your-own-system#/)

```
Infrastructure Automation > Manage a node > Ubuntu > On premises
```

# Overview

Chef typically comprises of three different parts

1. A Workstation which is the computer that cookbooks are authored and administered from (This can be your daily PC with any OS)
2. A Chef Server is the central repository for cookbooks as well as information about the nodes they manage
3. A Node is any computer managed by a Chef server and has Chef installed on it (This can be any instance of Ubuntu 14.04)

For this section we will need to have all of the above set up

# Set Up Your Workstation

## Download Chef

You will first need to download the Chef for your workstation from [here](https://downloads.chef.io/chef-workstation/)

## Open Chef Workstation

On Windows open the Chef Workstation Powershell app (CW Powershell), on Mac and Ubuntu open a terminal as usual

> Be sure to use CW Powershell for the remainder of steps being carried out on Windows

## Create a Working Directory

We'll use our `learn-chef` directory that we set up earlier

## Install Git

> How do you not have this??

## Verify SSH

If you need to connect to your Chef Server with SSH, verify that you have SSH installed by running `ssh` in your terminal. For Windows an SSH client is included with Git and Chef Workstation

# Install Chef Server

## Install and Configure

On the server, create a file `/tmp/install-chef-server.sh` with the following contents

```bash
#!/bin/bash
apt-get update
apt-get -y install curl

# create staging directories
if [ ! -d /drop ]; then
  mkdir /drop
fi
if [ ! -d /downloads ]; then
  mkdir /downloads
fi

# download the Chef server package
if [ ! -f /downloads/chef-server-core_12.17.33_amd64.deb ]; then
  echo "Downloading the Chef server package..."
  wget -nv -P /downloads https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/16.04/chef-server-core_12.17.33-1_amd64.deb
fi

# install Chef server
if [ ! $(which chef-server-ctl) ]; then
  echo "Installing Chef server..."
  dpkg -i /downloads/chef-server-core_12.17.33-1_amd64.deb
  chef-server-ctl reconfigure

  echo "Waiting for services..."
  until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
  while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

  echo "Creating initial user and organization..."
  chef-server-ctl user-create chefadmin Chef Admin admin@4thcoffee.com insecurepassword --filename /drop/chefadmin.pem
  chef-server-ctl org-create 4thcoffee "Fourth Coffee, Inc." --association_user chefadmin --filename 4thcoffee-validator.pem
fi

echo "Your Chef server is ready!"
```

Next make the script a binary with

```bash
sudo chmod u+x /tmp/install-chef-server.sh
```

And then run it

```bash
sudo /tmp/install-chef-server.sh
```

## Configure Ports

Ensure that ports 22, 80, and 443 are exposed on the Chef Server - On VirtualBox I just used port forwarding to map these to my local 22, 80, and 443 ports

# Configure the Workstation

`kife` is the command line tool that provides the interface between the your Workstation and the Chef Server, `knife` requires two files to authenticate with the Chef Server:

1. An RSA Private Key - The Chef server holds the public part, the Workstation holds the private
2. A `knife` config file, typically called `knife.rb` and contains information like the Chef Server's URL, the location of the RSA Private key, and the default cookbook location

Both of these are usually located in a `.chef` directory

`knife` provides a a way for you to download the necessary files as a starter kit, but that resets all keys for all users in the account, hence we will do so manually by following the instructions [here](https://docs.chef.io/chefdk_setup.html#without-webui)

## Create an Organization

> Do not do this now, the setup script already has configured this for us

We can create an organization with the `chef-server-ctl org-create` command, the command has the following structure

```bash
 chef-server-ctl org-create ORG_NAME ORG_FULL_NAME -f FILE_NAME
```

## Create a User

> Do not do this now, the setup script already has configured this for us

Similar to the process above, use `chef-server-ctl user-create` to create a user, this has the general structure of

```bash
chef-server-ctl user-create USER_NAME FIRST_NAME LAST_NAME EMAIL PASSWORD -f FILE_NAME
```

## Move the `.pem` Files

Move the `.pem` files we just created to our `chef-repo` with the following command

```bash
cp /path/to/ORGANIZATION-validator.pem ~/chef-repo/.chef
```

## Copy the Private Key to Workstation

Copy the `chefadmin.pem` file to your Workstation's `learn-chef/.chef` directory

## Create Knife Config File

Create a `knife` config file `learn-chef/.chef/knife.rb` and replace the `chef_server_url` with your Chef server's FQDN

```rb
current_dir = File.dirname(__FILE__)
log_level                 :info
log_location              STDOUT
node_name                 "chefadmin"
client_key                "#{current_dir}/chefadmin.pem"
chef_server_url           "http://localhost/organizations/4thcoffee"
cookbook_path             ["#{current_dir}/../cookbooks"]
```

## Verify the Setup

From the `learn-chef` directory, with CW Powershell (or bash on another OS) run the following commands

```bash
knife ssl fetch
knife ssl check
```
