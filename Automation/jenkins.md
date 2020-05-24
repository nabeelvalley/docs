The Guide for getting started can be found [here](https://jenkins.io/doc/pipeline/tour/getting-started/)

# Setup

## Prerequisites

1. Docker
2. Java 8
3. Download Jenkins [here](http://mirrors.jenkins.io/war-stable/latest/jenkins.war)

Place your `jenkins.war` file in the project root directory

## Running

Run jenkins with the following command from the project root

```bash
java -jar jenkins.war --httpPort=8080
```

Navigate to `http://localhost:8080` in your browser and complete the setup

> You may need to configure the proxy, do this using the version without the `http://` part - for some reason it doesn't work otherwise. The Jenkins install will be at `C:\Users\USERNAME\.jenkins`

You can find the Admin Password at `C:\Users\USERNAME\.jenkins\secrets\initialAdminPassword`

## Adding a Local Repo

We can add a local repository by simply linking to it with `file://C:/Users/USERNAME/source/repos/jenkins-getting-started`

# Setting Up a Build

I'm using the BlueOcean Plugin to build the pipellines as the visual editor is easier, the documentation on using that can be found [here](https://jenkins.io/doc/book/blueocean/getting-started/)

> When configuring the pipeline on BlueOcean, you may run into an error when running a bash script on a Windows host, use Powershell Instead

# Docker Registry

Creating a local docker registry to store applications can be done by simply running the registry container, and then adding stage after the build to push the content to that registry and then run that as opposed to the "local" version of the container

Start a local registry with

```bash
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

We will push the content to the Docker Registry using the following command

```bash
docker push localhost:5000/node-hello-world
```

> If having issues with the above use `127.0.0.1:5000` instead of `localhost:5000`

The image can be removed from the build server with

```bash
docker image remove 127.0.0.1:5000/node-hello-world
```

Stop current running application and clean environment on target machine

```bash
docker stop node-app
docker container prune -f
```

Note that with the above you need to be sure to check if there is a container with that name currently running or else it will throw an error. This is handled using the following script in the pipeline:

```powershell
if (((docker container ls) | Out-String).Contains('node-app')) { docker container stop node-app; echo "Application Stopped" } else {echo "Application not running"} docker container prune -f
```

The final Docker image will be run on the client with

```bash
docker run -d -p 3001:3000 --name node-app 127.0.0.1:5000/node-hello-world
```

# Build Kickoff Automation

Ensure your git proxy is set up correctly with:

```bash
git config --global http.proxy ....
```

You need to make use of a `post-commit` hook in your `.git/hooks/post-commit` file with the following content, note that you need to make sure to bypass the proxy

```bash
#!/bin/sh
curl --proxy "" --location http://localhost:8080/git/notifyCommit?url=file://C:/Users/USER/source/repos/jenkins-getting-started
```

# Running a Build Slave

Ther are multiple methods for configuring a Jenkins Build Slave, usually using JNLP or SSH

You can run a slave instance for JNLP with docker using:

```
docker run jenkins/jnlp-slave -url http://jenkins-server:80 agentSecret jnlp-slave
```

Or an SSH Slave with:

```
docker run -p 22:22 jenkinsci/ssh-slave YOURPASSPHRASE
```

You will need to get your SSH key from the slave though, you can do this with:

```
ssh-keygen -t rsa
```

# DIY Docker SSH Build Slave

This is probably not a good idea but it works fine for testing your connections

First create the `sshUbuntu.Dockerfile` so we have something to run

```dockerfile
FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y openssh-server
RUN apt-get install -y default-jdk

RUN mkdir /var/run/sshd
RUN echo 'root:YOURPASSKEY123' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# if not already created
WORKDIR /root
RUN mkdir .ssh
WORKDIR /root/.ssh

# # when generating the key you can just leave the passphrase blank
RUN ssh-keygen -t rsa -f for_jenkins_key -N ""

# # add the jenkins key to the authorized keys
RUN cat for_jenkins_key.pub > authorized_keys
RUN cat authorized_keys

# # print out and copy the private `for_jenkins_key` file contents to the Jenkins Setup - not the `.pub`
RUN cat for_jenkins_key

WORKDIR /
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```

And then build and run that image with:

```
docker build -t ssh-ubuntu -f sshUbuntu.Dockerfile .
docker run -d -p 22:22 ssh-ubuntu
```

You can then log into this instance using SSH to test the connection (this is built into bash on Windows)

```bash
# clear existing keys for the host
# ssh-keygen -R yourhostname
ssh-keygen -R localhost

ssh roo@localhost

> password : YOURPASSKEY123

# check the generated key with:
cd  ~/.ssh
cat for_jenkins_key

# after you have tested the SSH connection you can disconnect with
exit
```

Then copy the entire key from the previous script and move to your Jenkins Setup

# Jenkins Slave Config

## Credentials

First go to your Jenkins Instance and Navigate to `Jenkins > Credentials > System > Global` or the following route in your browser `/credentials/store/system/domain/_/`

And click `Add Credential`, select the type as `SSH Username with private key` and set the username as `root` (or your actual user if you're doing this for real) and Select `Private Key: Enter Directly` and paste in the Key you copied from your slave container instance, if you created a Passphase for the key (the Docker one above does not) you will need to enter that in as well

## Node

Then navigate to `Jenkins > Manage > Manage Nodes` or `/computer/` in your browser and click `New Node`. Give this a name, e.g. `ubuntudockerssh`, use the `Permanent Agent` option. Thereafter set the Launch Method to be `Launch Agents via SSH` , the host should be `localhost` or whatever your actual host is, and be sure to use the Credentials we just created. Lastly the Host Key Verification Strategy should be `Manually Trusted key verification strategy` and click save

## Test Build

A simple Pipeline can be built using the following. Note that the `agent.label` value is the name of the Node set up in the previous step

```jenkinsfile
pipeline {
  agent {label 'ubuntudockerssh'}
  stages {
    stage('Check Running') {
      steps {
        sh 'echo "I am running"'
      }
    }
    stage('Get Random') {
      steps {
        sh 'echo $((1 + RANDOM % 10))'
      }
    }
    stage('Complete') {
      steps {
        sh 'echo "Pipeline Done"'
      }
    }
  }
}
```

# Checkout

To checkout code from a GitHub repo using the GitHub plugin, the following should work under most circumstances:

```groovy
stage('clone') {
  git branch: env.BRANCH_NAME,
    url: '<GIT URL>.git'
    credentialsId: 'credentials_id'
}
```

However for more complex repos which result in timeouts or other issues, it may be a better choice to use the `GitSCM` method instead, something more like this:

```groovy
stage('clone')
  checkout([
    $class: 'GitSCM',
    branches: [[name: env.BRANCH_NAME]],
    extensions: [[$class: 'CloneOption', timeout: 30]],
    gitTool: 'Default',
    useRemoteConfigs: [[credentialsId: 'credentials_id', url: '<GIT URL>.git']]
  ])
```
