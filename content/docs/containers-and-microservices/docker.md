[Based on this Cognitive Class Course](https://courses.cognitiveclass.ai/courses/course-v1:IBMDeveloperSkillsNetwork+CO0101EN+v1/info)

# Prerequisites

- Docker
- WSL2 for Windows (ideally) (if using Windows)

# Run a Container

## Introduction

Containers are a group of processes that run in isolation, these processes must all be able to run on a shared kernel

Virtual machines are heavy and include an entire operating system, whereas with a container they only contain what is necessary. Containers do not replace virtual machines

Docker is a toolset to manage containers and integrate into our CI/CD pipelines. This allows us to ensure that all our running environments are identical. Furthermore Docker provides a standard interface for developers to work with

## Running a Container

To run a container on our local machine we use the Docker CLI

```text
docker container run -t ubuntu top
```

This command will look for the ubuntu image locally, which it will not find and will then check for the image online, after which it will run the `ubuntu` container with the `top` command. This can be seen with the following output

```bash
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
473ede7ed136: Pull complete
c46b5fa4d940: Pull complete
93ae3df89c92: Pull complete
6b1eed27cade: Pull complete
Digest: sha256:29934af957c53004d7fb6340139880d23fb1952505a15d69a03af0d1418878cb
Status: Downloaded newer image for ubuntu:latest
top - 13:08:05 up  5:20,  0 users,  load average: 0.02, 0.03, 0.00
Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni, 99.8 id,  0.2 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  2027760 total,    93568 free,   410976 used,  1523216 buff/cache
KiB Swap:  1048572 total,  1048564 free,        8 used.  1447916 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
    1 root      20   0   36588   3148   2724 R   0.3  0.2   0:00.09 top
```

It is important to note that the container does not have its own kernel but instead runs on the host kernel, the Ubuntu image only provides the file system and tools

We can view our running containers with

```bash
docker container ls
```

We can interact with the container by

```bash
docker container exec -it be81304e2786 bash
```

Where

- `-it` states that we want to interact with the shell
- `be81304e2786` is the container ID
- `bash` is the tool we want to use to inspect our container

Now that we are in the container we can view our running processes with

```bash
ps -ef
```

To get out of our container and back to our host we run

```bash
exit
```

## Running Multiple Containers

Just run another container, basically

### Ngix

```bash
docker container run --detach --publish 8080:80 --name nginx nginx
```

### Mongo

```bash
docker container run --detach --publish 8081:27017 --name mongo mongo:3.4
```

If you run into the following error, simply restart Docker

```
Error response from daemon: driver failed programming external connectivity on endpoint xenodochial_spence (d2836ffdcd649ba692d504e34af61c9aab57bf3a135587875db3c88ca0baa070): Error starting userland proxy: mkdir /port/tcp:0.0.0.0:8080:tcp:172.17.0.2:80: input/output error.
```

We can list running containers and inspect one that we chose with

```bash
docker container ls
docker container inspect <CONTAINER ID>
```

It is important to remember that each container includes all the dependencies that it needs to run

A list of available Docker images can be found [here](https://store.docker.com/search?type=image&source=community)

## Remove Containers

We can stop containers with

```bash
docker container stop <CONTAINER IDs>

docker container stop jn4 es3 fe3
```

Then remove all stopped containers with

```bash
docker system prune
```

# CI/CD with Docker Images

## Introduction

A Docker image is an archive of a container that can be shared and containers can be created from them

Docker images can be shared via a central registry, the default store for Docker is Docker Hub

To create an image we use a Dockerfile which has instructions on how to build our image

Docker is made of layers, image layers are build on top of the layers before them, based on this we only need to update or rebuild layers that are changed or need to be updated, based on this we try to keep the area where we are making modifications to the bottom of our Dockerfile in order to prevent unnecessary layers from being rebuilt constantly

## Create a Python App

Make a simple python app in a directory that you want your app to be in which contains the following

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "hello world!"

if __name__ == "__main__":
    app.run(host="0.0.0.0")
```

This app will simply use Flask to expose a web server on port 5000 \(the default Flask port\)

> Note that the concepts used for this app can be used for any application in any language

## Create and Build the Docker Image

Create a file named `Dockerfile` in the same directory with the following contents

```dockerfile
FROM python:3.6.1-alpine
RUN pip install flask
CMD ["python","app.py"]
COPY app.py /app.py
```

So, what does this file do?

- `FROM python:3.6.1-alpine` is the starting point for our `Dockerfile`, each Dockerfile needs this to select the base layer we want for our application, we use the `-alpine` tag to ensure that changes to the parent dependency are controlled
- `RUN pip install flask` is executing a command that is necessary to set up our image for our application, in this case installing a package
- `CMD ["python","app.py"]` is what is run when our container is started, this is only run once for a container, we are using it here to run our app.py we can leave this here even though it will only be run once all the other lines are as this will not yield any changes to layers
- `COPY app.py /app.py` says that docker should copy the file in the local directory to our image, this is at the end as it is our source code which changes frequently and hence should affect as few layers as possible

From the directory of our application we can build our image

```bash
docker image build -t python-hello-world .
```

If you run into the following error you may need to ensure that your encoding is UTF 8

```text
Error response from daemon: Dockerfile parse error line 1: unknown instruction: ��F R O M
```

We can then view our image in the list with

```bash
docker image ls
```

We can run our image with

```bash
docker run -p 5001:5000 -d python-hello-world
```

The `-p` option maps port 5001 on our host to port 5000 of our container

Navigating to `http://localhost:5001` with our browser we should see

```bash
hello world!
```

If we do not get a response from our application, and if our application is not shown under the list of running containers we can view our logs for information, we use the string that was output when we did `docker run` as this is the container ID we tried to run

We can view our container logs with

```bash
docker container logs <CONTAINER ID>
```

## Push to a Central Registry

We can push our docker images to Docker Hub by logging in, tagging our image with our username, and then pushing the image

```bash
docker login
docker tag python-hello-world <USERNAME>/python-hello-world
docker push <USERNAME>/python-hello-world
```

Note that the `<USERNAME>/python-hello-world` refers to a repository to which we want to push our image

Thereafter we can log into Docker Hub via our browser and see the image

![Image on Docker Hub](/docs/assets/image%20%287%29.png)

## Deploy a Change

We can modify our `app.py` file and simply rebuild and push our update

```bash
docker image build -t <USERNAME>/python-hello-world .
docker push <USERNAME>/python-hello-world
```

We can view the history of our image with

```text
docker image history python-hello-world
```

## Removing Containers

We can remove containers the same as before

```text
docker container stop <CONTAINER IDS>
docker system prune
```

# Container Orchestration with Swarm

## Introduction

Orchestration addresses issues like scheduling and scaling, service discovery, server downtime, high availibility, A/B testing

Orchestration solutions work by us declaring our desired state and it maintaining that state

## Create a Swarm

We will be using [Play-With-Docker](https://labs.play-with-docker.com/) for this part

Click on **Add a new instance** to add three nodes

![Play With Docker](/docs/assets/image%20%2833%29.png)

Thereafter initialize a swarm on Node 1 with

```bash
docker swarm init --advertise-addr eth0
```

This will output something like the following

```bash
docker swarm join --token SWMTKN-1-1m4p457lt447dgth3ovrnwajn7x66wghumgcw415rh7lj2nzfi-bsora9haiad4ikx6r9hap7rkm 192.168.0.28:2377
```

We can then add a manager to the swarm with

```bash
docker swarm join-token manager
```

We can then run the `docker swarm-join` command from the other two nodes, then on node 1 we can view the swarm with

```bash
docker node ls
```

![Complete Swarm](/docs/assets/image%20%2830%29.png)

## Deploy a Service

On node 1 we can create an ngix service

```bash
docker service create --detach=true --name nginx1 --publish 80:80  --mount source=/etc/hostname,target=/usr/share/nginx/html/index.html,type=bind,ro nginx:1.12
```

We can then list the services we have created with

```bash
docker service ls
```

We can check the running container of a service with

```bash
docker service ps <SERVICE ID>
```

Because of the way the swarm works, if we send a request for a specific service, it will automatically be routed to the container which has ngix running, we can test this from each node

```bash
curl localhost:80
```

## Scale the Service

If we want to replicate our service instances we can do so with

```bash
docker service update --replicas=5 --detach=true nginx1
```

When we update our service replicas Docker Swarm recognises that we no longer match the service requirement and it therefore creates more instances of the service

We can view the running services

```text
docker service ps nginx1
```

We can send many requests to the node and we will see that the request is being handled by different nodes

```bash
curl localhost:80
```

We can view our service logs with

```bash
docker service logs ngix1
```

## Rolling Updates

We can do a rolling update of a service with

```bash
docker service update --image nginx:1.13 --detach=true nginx1
```

We can fine-tune our update process with

- `--update-parallelism` specifies the number of containers to update immediately
- `--update-delay` specifies the delay between finishing updating a set of containers before moving on to the next set

After a while we can view our ngix service instances to see that they have been updated

```bash
docker service ps nginx1
```

## Reconciliation

Docker Swarm will automatically manage the state we tell it to, for example if a node goes down it will automatically create a new one to replace it

## How Many Nodes?

We typically aim to have between three and seven manager nodes, in order to correctly apply the consensus algorithm, which requires more than half our nodes to be in agreement of state, the following is advised

- Three manager nodes tolerate one node failure
- Five manager nodes tolerate two node failures
- Seven manager nodes tolerate three node failures

It is possible to have an even number of manager nodes but this adds no additional value in terms of consensus

However we can have as many worker nodes as we like, this is inconsequential
