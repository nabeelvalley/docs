---
published: true
title: CDK Local Lambdas
subtitle: Local Development and Testing of AWS CDK Lambdas
---

---
published: true
title: CDK Local Lambdas
subtitle: Local Development and Testing of AWS CDK Lambdas
---

# Introduction

The AWS CDK enables us to define application infrastructure using a programming language instead of markup, which is then transformed by the CDK to CloudFormation templates for the management of cloud infrustructure services

The CDK supports TypeScript, JavaScript, Python, Java, and C#

# Prerequisites

AWS Lamda development requires SAM to be installed, depending on your OS you can use the installation instructions [here](https://aws.amazon.com/serverless/sam/)

In addition to SAM you will also require [Docker](https://www.docker.com/products/docker-desktop)

> I'm using `aws-sam-cli@1.12.0` to avoid certain compat issues from the current version

And lastly, you will need to install `cdk`

```
npm i -g aws-cdk
```

# Init Project

To initialize a new project using SAM and CDK run the following command:

```sh
mkdir my-project
cd my-project
cdk init app --language typescript
npm install @aws-cdk/aws-lambda
```

This will generate the following file structure:

```
my-project
  |- .npmignore
  |- jest.config.js
  |- cdk.json
  |- README.md
  |- .gitignore
  |- package.json
  |- tsconfig.json
  |- bin
      |- my-project.ts
  |- lib
      |- my-project-stack.ts
  |- test
      |- my-project.test.ts
```

In the generated files we can see the `bin/my-project.ts` file which creates an instance of the `Stack` that we expose from `lib/my-project-stack.ts`

`bin/my-project.ts`

```ts
#!/usr/bin/env node
import 'source-map-support/register'
import * as cdk from '@aws-cdk/core'
import { MyProjectStack } from '../lib/my-project-stack'

const app = new cdk.App()
new MyProjectStack(app, 'MyProjectStack', {})
```

# Create a Handler

Next, we can create a handler for our file, we'll use the Typescript handler but the concept applies to any handler we may want to use

First, we'll export a handler function from our code, I've named this `handler` but this can be anything and we will configure `CDK` as to what function to look for. We'll do this in the `lambdas/hello.ts` file as seen below. Note the use of the `APIGatewayProxyHandler` type imported from `aws-lambda`, this helps inform us if our `event` and `return` types are what AWS expects

`lambdas/hello.ts`

```ts
import { APIGatewayProxyHandler } from 'aws-lambda'

export const handler: APIGatewayProxyHandler = async (event) => {
  console.log('request:', JSON.stringify(event, undefined, 2))

  const res = {
    hello: 'world',
  }

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(res),
  }
}
```

# Define Stack

Next, in order to define our application stack we will need to use CDK, we can do this in the `lib/my-project-stack.ts` file utilizing `@aws-cdk/aws-lambda-nodejs` to define our Nodejs handler:

`lib/my-project-stack.ts`

```ts
import * as cdk from '@aws-cdk/core'
import { NodejsFunction } from '@aws-cdk/aws-lambda-nodejs'

export class MyProjectStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props)

    // this defines a Nodejs function handler
    const hello = new aws_lambda_nodejs_1.NodejsFunction(this, 'HelloHandler', {
      runtime: lambda.Runtime.NODEJS_12_X,
      // code located in lambdas directory
      entry: 'lambdas/hello.ts',
      // use the 'hello' file's 'handler' export
      handler: 'handler',
    })
  }
}
```

If we want, we can alternatively use the lower-level `cdk.Function` class to define the handler like so:

```ts
const hello = new lambda.Function(this, 'HelloHandler', {
  runtime: lambda.Runtime.NODEJS_12_X,
  // define directory for code to be used
  code: lambda.Code.fromAsset('./lambdas'),
  // define the name of the file and handler function
  handler: 'hello.handler',
})
```

> Note, avoid running the above command using `npm run sdk ...` as it will lead to the `template.yaml` file including the `npm` log which is not what we want

# Create API

Next, we need to add our created lambda to an API Gateway instance so that we can route traffic to it, we can do this using the `@aws-cdk/aws-apigateway` package

To setup the API we use something like this in the `Stack`:

```ts
let api = new apiGateway.LambdaRestApi(this, 'Endpoint', {
  handler: hello,
})
```

So our `Stack` now looks something like this:

`lib/my-project-stack.ts`

```ts
import * as cdk from '@aws-cdk/core'
import * as lambda from '@aws-cdk/aws-lambda'
import * as apiGateway from '@aws-cdk/aws-apigateway'
import { NodejsFunction } from '@aws-cdk/aws-lambda-nodejs'

export class MyProjectStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props)

    // define the `hello` lambda
    const hello = new NodejsFunction(this, 'HelloHandler', {
      runtime: lambda.Runtime.NODEJS_12_X,
      // code located in lambdas directory
      entry: 'lambdas/hello.ts',
      // use the 'hello' file's 'handler' export
      handler: 'handler',
    })

    // our main api
    let api = new apiGateway.LambdaRestApi(this, 'Endpoint', {
      handler: hello,
    })
  }
}
```

# Generate Template

Now that we have some API up, we can look at the process for making it requestable. The first step in the process for running this locally is generating a `template.yaml` file which the `sam` CLI will look for in order to setup the stack

We can build a Cloud Formation template using the `cdk synth` command:

```sh
cdk synth --no-staging > template.yaml
```

> You can take a look at the generated file to see the CloudFormation config that CDK has generated, note that creating the template this way is only required for local `sam` testing and isn't the way this would be done during an actual deployment kind of level

# Run the Application

Once we've got the `template.yaml` file it's just a matter of using `sam` to run our API. To start our API Gateway application locally we can do the following:

```sh
sam local start-api
```

This will allow you to make requests to the lambda at `http://localhost:3000`. A `GET` request to the above URL should result in the following:

```json
{
  "hello": "world"
}
```

# Use a DevContainer

I've also written a Dev container Docker setup file for use with CDK and SAM, It's based on the `Remote Containers: Add Development Container Configuration Files > Docker from Docker` and has the following config:

`Dockerfile`

```dockerfile
# Note: You can use any Debian/Ubuntu based image you want.
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby CLI instead of the licensed Docker CLI
ARG USE_MOBY="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=automatic
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# install python and pip
RUN apt-get update && apt-get install -y \
    python3.4 \
    python3-pip

# install nodejs
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash -
RUN apt-get -y install nodejs

# install cdk
RUN npm install -g aws-cdk

# install SAM
RUN pip3 install aws-sam-cli==1.12.0

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to
# the Docker socket if "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
```

`.devcontainer/devcontainer.json`

```json
// For format details, see https://aka.ms/devcontainer.json. For config options, see the README at:
// https://github.com/microsoft/vscode-dev-containers/tree/v0.166.1/containers/docker-from-docker
{
  "name": "Docker from Docker",
  "dockerFile": "Dockerfile",
  "runArgs": ["--init"],
  "mounts": [
    "source=/var/run/docker.sock,target=/var/run/docker-host.sock,type=bind"
  ],
  "overrideCommand": false,
  // Use this environment variable if you need to bind mount your local source code into a new container.
  "remoteEnv": {
    "LOCAL_WORKSPACE_FOLDER": "${localWorkspaceFolder}"
  },
  // Set *default* container specific settings.json values on container create.
  "settings": {
    "terminal.integrated.shell.linux": "/bin/bash"
  },
  // Add the IDs of extensions you want installed when the container is created.
  "extensions": ["ms-azuretools.vscode-docker"],
  "workspaceMount": "source=${localWorkspaceFolder},target=${localWorkspaceFolder},type=bind",
  "workspaceFolder": "${localWorkspaceFolder}",
  // Use 'forwardPorts' to make a list of ports inside the container available locally.
  // "forwardPorts": [],
  // Use 'postCreateCommand' to run commands after the container is created.
  // "postCreateCommand": "npm install",
  // Comment out connect as root instead. More info: https://aka.ms/vscode-remote/containers/non-root.
  "remoteUser": "vscode"
}
```

Especially note the `workspaceMount` and `workspaceFolderz sections as these ensure the directory structure maps correctly between your local folder structure and container volume so that the CDK and SAM builds are able to find and create their assets in the correct locations

# References

- [The AWS Docs](https://docs.aws.amazon.com/cdk/latest/guide/home.html)
- [CDK Workshop](https://cdkworkshop.com/)
