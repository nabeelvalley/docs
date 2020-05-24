Before reading through this, you may want to read the page about the application being deployed on the [Build an Express App that uses MongoDB](./build-an-express-app-with-mongo.md) page

- [Ketting started with Minicube](https://docs.bitnami.com/kubernetes/get-started-kubernetes/#option-1-install-minikube)
- [Installing Minicube on Windows](https://medium.com/@JockDaRock/minikube-on-windows-10-with-hyper-v-6ef0f4dc158c)
- [Dockerise a Node-Mongo App](https://medium.com/statuscode/dockerising-a-node-js-and-mongodb-app-d22047e2806f)

# Contents
- [Deploy an Express Application that uses MongoDB on k8s Locally](#deploy-an-express-application-that-uses-mongodb-on-k8s-locally)
  - [Contents](#contents)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
    - [Minikube](#minikube)
      - [Hyper-V](#hyper-v)
    - [VirtualBox](#virtualbox)
      - [Running Minikube](#running-minikube)
  - [Creating a Deployment](#creating-a-deployment)
    - [Building the Image](#building-the-image)
    - [Deploying on Kubernetes](#deploying-on-kubernetes)
    - [Use the App](#use-the-app)

# Prerequisites

- Docker
- Minicube
- Minikube k8s cluster
- `kubectl` installed
- Helm and Tiller

# Installation

## Minikube

### Hyper-V

Using minikube with Windows requires us to use Hyper-V as a driver, we can follow the instructions on [Jock Reed's Blog](https://medium.com/@JockDaRock/minikube-on-windows-10-with-hyper-v-6ef0f4dc158c) on how configure a new virtual switch, then we can start minikube using this switch as follows:

```bash
minikube start --vm-driver hyperv --hyperv-virtual-switch "Primary Virtual Switch"
```

After which point we can stop minikube

```bash
minikube stop
```

Enable Dynamic Memory from Hyper-V Manager, and then start minikube with:

```bash
minikube start 
```
## VirtualBox

We can use VirtualBox as our driver as well with the following

```bash
minikbe start --vm-driver virtualbox
```
### Running Minikube

```bash
minikube start
```

Note that this may download some files which will take a while, but you will eventually see the following output

```
Starting local Kubernetes v1.10.0 cluster...
Starting VM...
Downloading Minikube ISO
 178.87 MB / 178.87 MB [============================================] 100.00% 0s
Getting VM IP address...
E1215 14:28:43.740427    9968 start.go:210] Error parsing version semver:  Version string empty
Moving files into cluster...
Downloading kubelet v1.10.0
Downloading kubeadm v1.10.0
Finished Downloading kubeadm v1.10.0
Finished Downloading kubelet v1.10.0
Setting up certs...
Connecting to cluster...
Setting up kubeconfig...
Stopping extra container runtimes...
Starting cluster components...
Verifying kubelet health ...
Verifying apiserver health ...Kubectl is now configured to use the cluster.
Loading cached images from config file.


Everything looks great. Please enjoy minikube!
```

Next we can view our minikube dashboard with

```bash
minikube dashboard
```

# Creating a Deployment

We can create a deployment based on a deployment yaml file

For the purpose of this, we will make use of the deployment configurations that are defined in the [Build an Express App that uses MongoDB](./build-an-express-app-with-mongo.md) at the [Comments App GitHub Repository](https://github.com/nabeelvalley/CommentsApp)

To see how the app is constructed and how it communicates with the DB, read the page on [Building an Express App that uses Mongo](./build-an-express-app-with-mongo.md)

The Express App is exposed on port `8080` and will speak to the Mongo instance on `mongo:27017`

## Building the Image

Before we can deploy our application we need to build it as a Docker image and push it to a repository, in the case of the Comments App, this will be as follows

From the application directory run

```bash
docker build -t <USERNAME>/comments-app
docker push
```

If we do not wish to redeploy our

## Deploying on Kubernetes

Once logged into a kubernetes cluster we can make use of the `express.yaml` to deploy the express app, and the `mongo.yaml` file to deploy Mongo

```
kubectl create -f express.yaml
kubectl create -f mongo.yaml
```

This will create a deployment as well as a service for both the Express App and Mongo. The deployment configs are as follows

`express.yaml`
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  labels:
    app: comments-app
  name: comments-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: comments-app
  template:
    metadata:
      labels:
        app: comments-app
      name: comments-app
    spec:
      containers:
      - image: <USERNAME>/comments-app
        imagePullPolicy: Always
        name: comments-app

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: comments-app
  name: comments-app
spec:
  ports:
  - name: tcp-8080-8080-comments-app
    nodePort: 30016
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: comments-app
  type: LoadBalancer
```


`mongo.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
   name: mongo
   labels:
     run: mongo
spec:
   ports:
   - port: 27017
     targetPort: 27017
     protocol: TCP
   selector:
     run: mongo

---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
   name: mongo
spec:
   template:
     metadata:
       labels:
         run: mongo
     spec:
       containers:
       - name: mongo
         image: mongo
         ports:
         - containerPort: 27017
```

## Use the App

We can use minikube to View the application

```bash
minikube service comments-app
```

Once on the app we can create a comment, which will take us to the comments view page. When creating a comment a new record is inserted into Mongo, and when viewing them all existing comments are retrieved and displayed