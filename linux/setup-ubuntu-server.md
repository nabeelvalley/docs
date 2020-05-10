# Dev Server Setup

## SSH Serup

### 1. Install SSH

```bash
sudo apt update
sudo apt install openssh-server
```

> Note using this SSH server you also connect for remote development using VSCode Remote Development,
> Additionally you can install the VSCode docker extension to work with docker on the server

### 2. Check SSH Status

```bash
sudo systemctl status ssh
```

### 3. Start/Stop SSH Server

If the SSH server is not working for some reason you can stop/start as needed

```bash
sudo systemctl stop ssh
sudo systemctl start ssh
```

### 4. Log in From Remote

You can log in using the following command from a machine with SSH installed

```bash
ssh username@ipaddress
```

Your username will be the same as your Ubuntu UN, and the IP can be found by running the following commmand on the Server

```bash
ip address | grep inet
```

Or more easily using

Next use the relevant `inet` ip address of the form `x.x.x.x`, e.g. `192.168.0.2`

You should also be able to access applications running on this server on their respective ports at the relevant IP

## RDP Setup

From Windows using RDP you will need to first install and activate the RDP Client, this can be done with

```bash
sudo apt install xrdp
sudo systemctl enable xrdp
```

Then connect from RDP with the server IP and Username/Password

> This is currently untested

## Open Ports

You can allow ports through your firewall (if this is a problem) with the following commans

```bash
# sudo ufw allow <PORTNUMBER>
sudo ufw allow 8080
sudo ufw status
```

## VS Code Server Setup

> Leaving this here for reference but just note that if you are using the VSCODE
> Remote development extension this will be automatically installed on the server
> IDK how it connects though ~ I think using SSH (who knows)

You can run [`code-server`]() using a Docker Image with the following command

```bash
docker run -it -p 8443:8443 --name vscode -v "${PWD}/repos:/home/coder/project" -d codercom/code-server --allow-http --no-auth
```

## Docker

I have not tested this installation method but it looks like docker provides an
installation script that you can use on [GitHub](https://github.com/docker/docker-install)

To use it you can run the following:

```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

## Jenkins

Configuring Jenkins on an Ubuntu server can be done by following [these instructions](https://linuxize.com/post/how-to-install-jenkins-on-ubuntu-18-04/), or the following steps below:

```bash
sudo apt update
sudo apt install openjdk-8-jdk
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
```

You can then verify it is running with

```bash
systemctl status jenkins
```

You can then go through the normal Jenkins Setup. Note that the initial admin password can be found with:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

> After installation be sure to add the Blue Ocean Plugin. Otherwise like what are you even doing? You can do that from Configure >
