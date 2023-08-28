---
published: true
title: Code in a Container
subtitle: 25 July 2020
description: Using a Docker Container as a development container using the Visual Studio Code Remote-Containers Extension
---

---
published: true
title: Code in a Container
subtitle: 25 July 2020
description: Using a Docker Container as a development container using the Visual Studio Code Remote-Containers Extension
---

Recently I'd started using Visual Studio Code's _Remote Containers_ functionality for development and it's been really useful

The Remote Containers extension allows us to write code and develop applications within a virtualized environment that makes it easier for us to manage our development environment as well as more closely resemble our target deployment environment (if we're deploying to Docker or Kubernetes)

In this post, I'll take a look at what a Docker container is, why we would want to use one as a development environment, and how we can go about setting one up for VSCode

# Prerequisites

If you intend to follow along with this post you'll need to have the following installed:

- A Windows or Mac OS version capable of running Docker Desktop
- [Docker Desktop](https://docs.docker.com/desktop/#download-and-install)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Visual Studio Code's Remote Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Visual Studio Code's Docker Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- Some familiarity with using the command line

# Docker Containers

A Container, in this context, is a simple virtual machine that contains the code required to run an application with all its dependencies

A Docker container is built from a `docker image` and run by the `docker` command. I'll explain these as we go along

To check that Docker is installed correctly on your machine run the following command:

```
docker run hello-world
```

If your install is working correctly you should see something like this:

```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete

Digest: sha256:49a1c8800c94df04e9658809b006fd8a686cab8028d33cfba2cc049724254202
Status: Downloaded newer image for hello-world:latest

Hello from Docker

...
```

# Docker Images

Docker images are typically used to run applications in a production-type environment, every Docker container we run needs to be based on an image, every running container is like an instance of an image - similar to how objects are an instance of a class

An image states what our container will need to be made of, what it depends on, and how it runs. We define how docker should build our image in a `Dockerfile`

We're going to go through some of the basics of Docker Images and Docker as would typically be done when creating a container to be run in production before we get into development containers so you've got an understanding of how this all works

To get started create a new folder and open it from Visual Studio Code and do the following:

## Create an Application

We'll need a simple "hello-world" web server using Node.js, for the sake of example. You can, however, use any language (or Languages) you want when creating an application to run within Docker. You do not need to have any dependencies for the specific application or language installed on your computer, we will handle this using Docker

For our purpose, create a file called `index.js` with the following:

```js
const http = require('http')

const requestListener = function (req, res) {
  res.writeHead(200)
  res.end('Hello, World!')
}

const serverListeningCallback = function () {
  console.log('Server started')
}

const server = http.createServer(requestListener)
server.listen(8080, serverListeningCallback)
```

You can see in the above on the last line that the application will listen on port 8080, just keep this in mind

We don't need to run this file as yet, but if we want, we can run this with the following command from our working directory:

```bash
node app.js
```

At this point our working directory should look like this:

```text
working-directory
|__ index.js
```

## Create a Dockerfile

There are a few steps that are the same for most `Dockerfile`s you'll be building:

1. A Base Image that your container/image should use, in our case `node:12`, which has `node` and `npm` preinstalled
2. Copy all the code in the current (`.`) directory
3. Define your runtime port/ports (in the case of a web application)
4. The command that will be run to start the application

> Any line starting with a `#` is a comment, Docker will ignore these

`Dockerfile`

```dockerfile
# step 1 - FROM baseImage
FROM node:12

# step 2 - COPY source destination
COPY . .

# step 3 - EXPOSE port
EXPOSE 8080

# step 4 - CMD stratupCommandArray
CMD ["node", "app.js"]
```

At this point our working directory should look like this:

```text
working-directory
|__ index.js
|__ Dockerfile
```

We can build our image, based on the `Dockerfile` using the following `docker` command:

> Note the `.` at the end of the command

```
docker build -t my-docker-app .
```

The above command can be broken down as follows:

1. `docker build` the command from the Docker CLI to build an image
2. `-t my-docker-app` says what we want our image to be called, in the above `my-docker-app`
3. `.` which is the directory in which the `Dockerfile` is located, in our case our current directory

We can then run the image we just built like so:

```
docker run -p 8080:8080 my-docker-app
```

1. `docker run` is the command from the `Docker CLI` to run a container
2. `-p 8080:8080` is our port mapping, it is ordered as `HOST_PORT:CONTAINER_PORT` and allows us to say which port on our host we want to map to our container, the container port is the same port that our app listens on and is `EXPOSE`d in the `Dockerfile`
3. `my-docker-app` is the image tag we would like to run

> Each time we change the app files for a container like above we need to rebuild the container before running, and that normally making changes to files during the image build or container run will not modify the original files on our computer

Now that the application is running on port `8080` you can open `http://localhost:8080` in your browser and you should see your `Hello World` app running

When you're done with that you can go back to the terminal where the container was started and use `ctrl + c` to stop the container

If you've never used Docker before and have got everything running this far, congratulations! If you've got any questions you can comment below or hit me up on [Twitter @not_nabeel](https://twitter.com/not_nabeel)

Moving swiftly along

# Development Containers

So now that we understand a bit about containers and how we can go about using them in production, we'll look at why we may want to use them as a development environment

## Why Develop in a Container

As developers, we are far too familiar with the "it runs on my machine" dilemma. Development environments can be wildly inconsistent between different developers or different operating systems, and ensuring that our development code runs easily on everyone's computer can be challenging

Containers can help us to explicitly define our development environment, our application dependencies, what networking relationships, and (potentially) what other sibling applications need to be running in development, like databases, or other application tiers

Visual Studio Code can help transport us into a container so that we work on our application in a well-defined environment, not just run our application within one while reducing the overall number of things we need to have installed on our computer

## How to Develop in a Container

To develop in a Container using Visual Studio Code we will need to have:

- [Docker Desktop](https://docs.docker.com/desktop/#download-and-install)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Visual Studio Code's Remote Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

> What's important to note is that we don't need any of our application's runtime or development dependencies installed, like Node.js, these will all be handled by VSCode within our container

To configure our project for running in a container we need to first open the project folder (the folder we used previously) in Visual Studio Code

### Use an Existing Dockerfile

Once open use the keyboard shortcut `ctrl + shift + p` to open the Command Palette and search for `Remote-Containers: Add Development Container Configuration Files` and click `enter`, you will then have an option to use the existing Dockerfile `from Dockerfile` which will generate a `.devcontainer/devcontainer.json` file

At this point our working directory should look like this:

```text
working-directory
|__ .devcontainer
|   |__ devcontainer.json
|
|__ index.js
|__ Dockerfile
```

The `.devcontainer/devcontainer.json` file that was created will contain the following:

`devcontainer.json`

```js
// For format details, see https://aka.ms/vscode-remote/devcontainer.json or this file's README at:
// https://github.com/microsoft/vscode-dev-containers/tree/v0.128.0/containers/docker-existing-dockerfile
{
    "name": "Existing Dockerfile",

    // Sets the run context to one level up instead of the .devcontainer folder.
    "context": "..",

    // Update the 'dockerFile' property if you aren't using the standard 'Dockerfile' filename.
    "dockerFile": "..\\Dockerfile",

    // Set *default* container specific settings.json values on container create.
    "settings": {
        "terminal.integrated.shell.linux": null
    },

    // Add the IDs of extensions you want installed when the container is created.
    "extensions": []

    ...
}
```

The above file is the configuration for our development container, we can also allow VSCode to generate a Dockerfile which we'll look at later in the post

We'll stick to our simple `Dockerfile` for this post, but if you've got a different `Dockerfile` when running your application in Production and Development then you may need a different file in the `dockerFile` property below

Now that we've got a starting point we can add a little to our configuration so that everything is just right:

1. Change the `name` property to name our workspace (purely aesthetic)
2. Add a `forwardPorts` property to expose our application port to our localhost network, be sure to add the `,` after `"extensions":[]`

Once we make the above changes we should have this:

`devcontainer.json`

```js
{
    "name": "My Workspace",

    // Sets the run context to one level up instead of the .devcontainer folder.
    "context": "..",

    // Update the 'dockerFile' property if you aren't using the standard 'Dockerfile' filename.
    "dockerFile": "..\\Dockerfile",

    // Set *default* container specific settings.json values on container create.
    "settings": {
        "terminal.integrated.shell.linux": null
    },

    // Add the IDs of extensions you want installed when the container is created.
    "extensions": [],

    // Use 'forwardPorts' to make a list of ports inside the container available locally.
    "forwardPorts": [
        8080
    ],
    ...
}
```

Now that we've configured our build container, use `ctrl + shift + p` to open the Command Palette again and search for `Remote-Containers: Reopen in Container` and click `enter` which will build the container and set up an image with the following setup for us:

- Linked ports as defined in the `forwardPorts` property
- Configure a VSCode development server inside the container so our editor can link to it
- Mount our system's file directory into the container so we can edit our files
- Does not run the `CMD` command from our `Dockerfile`
- Open a VSCode window linked to the container so we can start working with our code

Now that you're in the container you can edit your files and run it by doing the following:

1. Use `ctrl + shift + p` and then search for `Terminal: Create new Integrated Terminal` and click `enter`
2. Type `node app.js` into the new Terminal window and click `enter` to run our app.js file
3. Navigate to `http://localhost:8080` in your browser to view your running app

At this point we've created a container to use as a development file and run our application, you can stop the application with `ctrl + c`

You can switch from developing in a container back to your local environment with `ctrl + shift + p` and searching for `Remote-Containers: Reopen locally` and clicking `enter`

Now that we're back on our local environment (and not docker) we can look at the other way we can set up our project for VSCode

### Using a Preconfigured Dockerfile

Visual Studio Code's Remote Containers Extension provides some pre-configured `Dockerfile`s for common application or application framework types. One of the available preconfigured `Dockerfile`s is for working on Node.js applications

> The preconfigured files usually just provide a starting point for applications and often you will need to modify these to suit your application, we don't need this for the application we're working on however

To redefine our Docker development config, let's delete the `.devcontainer` directory in our application and regenerate this

We can regenerate the files needed with `ctrl + shift + p`, and searching for `Remote-Containers: Add Development Container Configuration Files` again, clicking `enter` and then selecting the `From a predefined configuration definition` option, and then selecting `Node.js 12`, this should now create a `.devcontainer/devcontainer.json` file as well as a new `.devcontainer/Dockerfile` that we did not have previously, our working directory will now look like so:

```text
working-directory
|__ .devcontainer
|   |__ devcontainer.json
|   |__ Dockerfile         # predefined dev container Dockerfile
|
|__ index.js
|__ Dockerfile             # our self-defined Dockerfile
```

If we look at the `devcontainer.json` file we will see something similar to what we had before:

`devcontainer.json`

```js
{
    "name": "Node.js 12",
    "dockerFile": "Dockerfile",

    // Set *default* container specific settings.json values on container create.
    "settings": {
        "terminal.integrated.shell.linux": "/bin/bash"
    },

    // Add the IDs of extensions you want installed when the container is created.
    "extensions": [
        "dbaeumer.vscode-eslint"
    ]

    ...
}
```

You may, however, note that the `dockerFile` property is missing, this just means that VSCode will use the default `Dockerfile` which has been created in the `.devcontainer` directory

We can go ahead and change the name if we want, we should also add the `forwardPorts` option as we did previously:

`devcontainer.json`

```js
{
    ...

    "forwardPorts": [
        8080
    ],

    ...
}
```

Now looking at the `Dockerfile` which defines the base development container:

`Dockerfile`

```dockerfile
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-12
```

This is a bit different to ours because Visual Studio Code will handle the file copying and port exposing on its own for the development container. Note that this configuration can only be used for development and can't really be deployed as a production container. This type of setup is necessary if our development image and production image will be different (which they usually are)

Now that the development container has been set-up, we can use `ctrl + shift + p` and `Remote-Containers: Reopen in Container` to open our development container, from here we can work on our application and run the application the same as we did before

## Which Method to Use

We've looked at two different methods for configuring our development container, either of which can be used in any project. Below are my recommendations:

If you've got an existing `Dockerfile` and your development container can be the same as your production container, for things like simple `node.js` or `python` apps, and you don't want to maintain another `Dockerfile` then this may be a quick solution to opt for

Otherwise, if your development container needs to be different from your production one then it's probably easier to start with a predefined VSCode Container as a base and add in any development configuration you need to the `.devcontainer/Dockerfile`

Lastly, if you don't have an existing `Dockerfile` at all then I'd suggest using a predefined one so that even if it's not fully configured you've got a relatively good starting point, especially when working with more complex languages and frameworks as a custom `Dockerfile` for these can be some work to configure

# Summary

In this post, we've covered the basics of using Docker to run your applications in a container as well as how to define and build your images. We also looked at why we may want to use a container for development and how we can do this using Visual Studio Code

## Further Reading

For some more in-depth information on Docker and VSCode Development Containers you can look at the following resources:

1. [My General Docker Notes](/docs/)
   - [Docker Basics](/docs/containers-and-microservices/docker/)
   - [Express Application with MongoDB](/docs/containers-and-microservices/build-an-express-app-with-mongo/)
   - [Multi-stage Builds](/docs/containers-and-microservices/docker-multi-stage/)
2. [Docker's Documentation](https://docs.docker.com/)
3. [VSCode's Remote Containers Documentation](https://code.visualstudio.com/docs/remote/containers)
