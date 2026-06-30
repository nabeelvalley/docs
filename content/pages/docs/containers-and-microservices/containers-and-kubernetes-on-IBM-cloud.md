---
published: true
title: Containers and Kubernetes on IBM Cloud
---

[Based on this Cognitive Class Learning Path](https://cognitiveclass.ai/learn/containers-k8s-and-istio-on-ibm-cloud/)

## Prerequisites

Before getting started, you will need a few prerequisites

- IBM Cloud CLI
  - Kubernetes Plugin
  - Container Registry Plugin
- Kubernetes CLI
- Docker 1.9 or later

## Kubernetes

Kubernetes is a container orchestrator to provision, manage and scale apps

It allows us to manage app resources, clusters, and infrastructure declaratively

## Set Up and Deploy an App

### Push an Image to Registry

Note that the `ng.bluemix.net` should be replaced with your API endpoint, for example in my case `eu-gb.bluemix.net`, this is dependant on your Cloud Region

Clone the [GitHub Repo](https://github.com/IBM/container-service-getting-started-wt) and navigate into Lab 1

```bash
git clone https://github.com/IBM/container-service-getting-started-wt.git
cd '.\container-service-getting-started-wt\Lab 1\'
```

Then log into the IBM Cloud CLI with

```bash
ibmcloud login
```

Or, if using SSO

```bash
ibmcloud login -sso
```

Next, log into the Cloud Registry with

```bash
ibmcloud cr login
```

Then create a namespace in the registry to store your images

```bash
ibmcloud cr namespace-add <NAMESPACE>
```

And lastly build and push the docker image

```bash
docker build --tag registry.ng.bluemix.net/<NAMESPACE>/hello-world .
docker images
docker push registry.ng.bluemix.net/<NAMESPACE>/hello-world
```

Lastly we can make sure that our cluster is in a normal, operational state with

```bash
ibmcloud cs clusters
ibmcloud cs workers <CLUSTER NAME>
```

### Deploy Application

First we need to get our Kubernetes cluster configuration with

```bash
ibmcloud cs cluster-config <CLUSTER NAME or ID>
```

Once that has completed we will be faced with an option to set this config file as an environmental variable, we can copy this command and run it from Powershell to set the environmental variable, the resulting command will look something like the following for Windows

```bash
SET KUBECONFIG=C:\..\..\.bluemix\plugins\container-service\clusters\mycluster\kube-config-mil01-mycluster.yml
```

Next we can run our image as a deployment with

```bash
kubectl run hello-world --image=registry.ng.bluemix.net/<namespace>/hello-world
```

If after running that you are faced with an error which says `error: failed to discover supported resources` it could be an indicator that the environmental variable did not set, in this case do the following

```bash
$env:KUBECONFIG="C:\Users\NabeelValley\.bluemix\plugins\container-service\clusters\mycluster\kube-
config-mil01-mycluster.yml"
kubectl run hello-world --image=registry.ng.bluemix.net/<namespace>/hello-world
```

This will take some time, to view the status of our deployment we can use

```bash
kubectl get pods
```

When the status reads _Running_ we can expose the deployment as a service which is accessed through the IP of the worker nodes, the HelloWorld example in this lab listens at _8080_

```bash
kubectl expose deployment/hello-world --type="NodePort" --port=8080
```

We can examine our service with

```bash
kubectl describe service <DEPLOYMENT NAME>
```

We can get the public IP of our service with

```bash
ibmcloud cs workers <CLUSTER NAME>
```

We can visit our service/container from the

```bash
<PUBLIC IP>:<NODE PORT>
```

Visiting this via our browser should yield

```bash
Hello world from hello-world-85794b747c-z8g2s! Your app is up and running in a cluster!
```

## Scale and Update Apps

### Scale Application with Replicas

We can view our deployment configuration file with

```bash
kubectl edit deployment/<DEPLOYMENT NAME>
```

This will open a file that looks like this

```yaml
    ...
    spec:
      replicas: 1
      selector:
        matchLabels:
          run: hello-world
      strategy:
        rollingUpdate:
          maxSurge: 1
          maxUnavailable: 1
        type: RollingUpdate
      template:
        metadata:
          creationTimestamp: null
          labels:
            run: hello-world
    ...
```

From here change the `spec.replicas` to 10

```yaml
    ...
    spec:
      replicas: 10
    ...
```

Then we can rollout our changes with

```bash
kubectl rollout status deployment/<DEPLOYMENT NAME>
```

Once that is done we can view our pods with

```bash
kubectl get pods
```

Which should list our ten running pods

### Update and Rollback Apps

Kubernetes allows us to rollout app updates easily, and update the images on running pods, as well as rollback if issues are identified

Before we begin, we can get an image with a specific tag \(in this case 1\) and push it with

```bash
docker build --tag registry.ng.bluemix.net/<namespace>/hello-world:1 .
docker push registry.ng.bluemix.net/<namespace>/hello-world:1
```

Thereafter we can make a change to our code and build the new docker image and push those to the cloud registry with a tag 2

```bash
docker build --tag registry.ng.bluemix.net/<namespace>/hello-world:2 .
docker push registry.ng.bluemix.net/<namespace>/hello-world:2
```

Next, we can edit our config file with

```bash
kubectl edit deployment/<DEPLOYMENT NAME>
```

Or we can edit the deployment with the command line with

```bash
kubectl set image deployment/hello-world hello-world=registry.ng.bluemix.net/<NAMESPACE>/hello-world:2
```

If you see the following error on the Kubernetes Dashboard it may mean that you are using an incorrect registry endpoint in the last command, it is important to ensure that the registry endpoint is correct \(as mentioned previously, in this case `eu-gb` and not `ng`\)

```bash
Failed to pull image "registry.ng.bluemix.net/nabeellab1/hello-world:2": rpc error: code = Unknown desc = Error response from daemon: Get https://registry.ng.bluemix.net/v2/nabeellab1/hello-world/manifests/2: unauthorized: authentication required
```

Once we have updated our deployment configuration we can rollout our changes and check the status with one of the following commands

```bash
kubectl rollout status deployment/<DEPLOYMENT NAME>
kubectl get replicasets
```

If we see that our deployments are not

Lastly we can do a rollout with

```bash
kubectl rollout undo deployment/<DEPLOYMENT NAME>
```

### Check Application Health

We can check app health periodically by using the `healthcheck.yml` file, we can open this file with from our `Lab 2` directory

```text
notepad .\healthcheck.yml
```

We can edit this file as needed, by updating our image repository in this spec at

```yaml
    ...
    spec:
      containers:
        - name: hw-demo-container
          image: "registry.ng.bluemix.net/<NAMESPACE>/hello-world:2"
    ...
```

Then, while still in the `Lab 2` directory, push this update with

```text
kubectl apply -f .\healthcheck.yml
```

## Deploy an App with Watson Services

### Deploy the Watson App

Navigate to the `Lab 3` Directory and build and push the Watson image to the Registry

```text
docker build -t registry.ng.bluemix.net/<NAMESPACE>/watson ./watson
docker push registry.ng.bluemix.net/<NAMESPACE>/watson
```

Then do the same for the Watson Talk image

```text
docker build -t registry.ng.bluemix.net/<namespace>/watson-talk ./watson-talk
docker push registry.ng.bluemix.net/<namespace>/watson-talk
```

Next, in the `watson-deployment.yml` file, update the registry information in the `spec.containers` for the two containers

```yaml
        spec:
          containers:
            - name: watson
              image: "registry.ng.bluemix.net/<namespace>/watson"
              # change to the path of the watson image you just pushed
              # ex: image: "registry.ng.bluemix.net/<namespace>/watson"
    ...
        spec:
          containers:
            - name: watson-talk
              image: "registry.ng.bluemix.net/<namespace>/watson-talk"
              # change to the path of the watson-talk image you just pushed
              # ex: image: "registry.ng.bluemix.net/<namespace>/watson-talk"
```

### Create Instance of Watson Service from CLI

We can create an instance of the Watson Tone Analyzer Service with

```text
ibmcloud target --cf
ibmcloud cf create-service tone_analyzer standard tone
```

Where

- `tone_analyzer` is the service type
- `standard` is the plan
- `tone` is the service name

We can view that our service was created with

```text
ibmcloud cf services
```

### Bind the Service to out Cluster

We can simply bind the service to our cluster with

```text
ibmcloud cs cluster-service-bind <CLUSTER NAME> default <SERVICE NAME>
```

And verify that it was created with

```text
kubectl get secrets
```

### Create Pods and Services

We can expose the secret to our pod so the service can be used by creating a secret data store as part of our deployment config, this is done already in the `watson-deployment.yml` file

```yaml
    volumeMounts:
            - mountPath: /opt/service-bind
              name: service-bind-volume
      volumes:
        - name: service-bind-volume
          secret:
            defaultMode: 420
            secretName: binding-tone
            # from the kubectl get secrets command above
```

Then we can build the app in the `Lab 3` directory with

```bash
kubectl create -f watson-deployment.yml
```

We can verify that the Watson pods were created with

```bash
kubectl get pods
```

### Run the App and Service

We can explore the new objects we have created from the Kubernetes Dashboard or with the following commands

```bash
kubectl get pods
kubectl get deployments
kubectl get services
```

We can once again view our app by getting the public IP for the worker note with

```bash
ibmcloud cs workers <CLUSTER NAME>
```

We can run a get to our endpoint with a message

```text
 http://<PUBLIC IP>:30080/analyze/"Today is a beautiful day"
```

if we get a JSON output then we know the service and applications are running
