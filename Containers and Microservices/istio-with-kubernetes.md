# Istio with Kubernetes

## Prerequisites

1. Trial IBM Cloud Account
2. Kubrenetes Cluster
3. Kubernetes 1.9.x or later
4. IBM Cloud CLI with Kubernetes

## Setting Up The Environment

### Access Your Cluster

List your available clusters and then download the config and set an environment variable to point to it with

```bash
ibmcloud cs clusters
ibmcloud cs cluster-config <CLUSTER NAME>
$env:KUBECONFIG="C:\Users\NabeelValley\.bluemix\plugins\container-service\clusters\mycluster\kube-
config-mil01-mycluster.yml"
```

Then you can check the workers in your cluster and get information with

```bash
ibmcloud cs workers <CLUSTER NAME>
ibmcloud cs worker-get <WORKER ID>
```

You can get your nodes, services, deployments, and pods with the following

```bash
kubectl get node
kubectl get node,svc,deploy,po --all-namespaces
```

### Clone the Lab Repo

You can clone the lab repo from `https://github.com/IBM/istio101` and then navigate to the `workshop` directory

```bash
git clone https://github.com/IBM/istio101
cd istio101/workshop
```

### Install Istio on IBM Cloud Kubernetes Service

Download Istio from [here](https://github.com/istio/istio/releases) and extract to your root directory

Then add the `istioctl.exe`  file to your `PATH` variable

Thereafter navigate to the `istio-demo.yaml` file in the istio folder that you extracted and do the following

```bash
kubectl apply -f .\install\kubernetes\istio-demo.yaml
```

If you run into the following error

```bash
http: proxy error: dial tcp [::1]:8080: connectex: No connection could be made because the target machine actively refused it
```

Make sure that your `$env:KUBECTL` variable is set, if not get your cluster config and set it again

Once that is done, check that the istio services are running on the cluster with

```bash
kubectl get svc -n istio-system
```

### Download the App and Create the Database

#### Get the App

Clone the app from the GitHub repo

```bash
git clone https://github.com/IBM/guestbook.git
cd guestbook/v2
```

#### Create the Database

Next we can create a Redis Database with the following master and slave deployments and services from the Yaml files in the Guestbook project

```bash
kubectl create -f redis-master-deployment.yaml
kubectl create -f redis-master-service.yaml
kubectl create -f redis-slave-deployment.yaml
kubectl create -f redis-slave-service.yaml
```

### Install the Guestbook App with Manual Sidecar Injection

Sidecars are utility containers that support the main container, we can inject the Istio sidecar in two ways

* Manually with the Istio CLI
* Automatically with the Istio Initializer

With Linux you can do this

```bash
kubectl apply -f <(istioctl kube-inject -f ../v1/guestbook-deployment.yaml
kubectl apply -f <(istioctl kube-inject -f guestbook-deployment.yaml
```

But, if you're on Windows and you need to redirect your output, use this instead

```bash
$istiov1 = istio kube-inject -f ..\v1\guestbook-deployment.yaml
echo $istiov1 > istiov1.yaml
kubectl apply -f .\istiov1.yaml

$istiov2 = istio kube-inject -f .\guestbook-deployment.yaml
echo $istiov2 > istiov2.yaml
kubectl apply -f .\istiov2.yaml
```

Then create the Guestbook Service

```bash
kubectl create -f guestbook-service.yaml
```

### Adding the Tone Analyzer

Create a Tone Analyzer Service and get the credentials, then add these to the `analyzer-deployment.yaml` file

```bash
ibmcloud target --cf 
ibmcloud service create tone_analyzer lite my-tone-analyzer
ibmcloud service key-create my-tone-analyzer istiokey
ibmcloud service key-show my-tone-analyzer istiokey
```

Then do the following

```bash
$istioanalyzer = istio kube-inject -f analyzer-deployment.yaml
echo $istioanalyzer > istioanalyzer.yaml
kubectl apply -f .\istioanalyzer.yaml

kubectl apply -f analyzer-service.yaml
```

## Service Telemetry and Tracing

### Challenges with Microservices

One of the difficulties when using microservices is identifying issues and process bottlenecks as well as debugging

Istio comes with tracing built in for this exact purpose

### Configure Istio for Telemetry Data

In the v2 directory, do the following

```bash
istioctl create -f guestbook-telemetry.yaml
```

### Generate a Load on the Application

Then we can then generate a small load on our application from the worker's IP and Port

```bash
kubectl get service guestbook -n default
```

Or for a lite plan

```bash
ibmcloud cs workers <CLUSTER NAME>
kubectl get svc guestbook -n default
while sleep 0.5; do curl http://<guestbook_endpoint/; done
```

We can get our telemetry data at intervals with the following in Bash

```bash
while sleep 0.5; do curl http://<WORKER'S PUBLIC IP>:<NODE PORT>/; done
```

### View Data

#### Jaeger

We can find the external port for our tracing service and visit it based on that

```bash
kubectl get svc tracing -n istio-system
```

#### Grafana

We can establish port forwarding for Grafana and view the dashboard on `localhost:3000` 

```bash
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000
```

#### Prometheus

We can view the Prometheus dashboard at `localhost:9090`  

```bash
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') 9090:9090
```

#### Service Graph

Can view this at `http://localhost:8088/dotviz`

```bash
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') 8088:8088
```

## Expose the Service Mesh with Ingress

### Ingress Controller

Istio components are by default not exposed outside the cluster, an Ingress is a collection of rules that allow connections to reach a cluster

Navigate to the `istio101\workshop\plans` directory

#### Using a Lite Account

Configure the Guestbook App with Ingress

```bash
istioctl create -f guestbook-gateway.yaml
```

Then check the node port and IP of the Ingress

```bash
kubectl get svc istio-ingressgateway -n istio-system
ibmcloud cs workers <CLUSTER NAME>
```

In my case, I have the endpoint `159.122.179.103:31380` which is bound to port 80

#### Using a Paid Account

```bash
istioctl create -f guestbook-gateway.yaml
kubectl get service istio-ingress -n istio-system
```

### Set up a Controller to work with IBM Cloud Kubernetes Service


This will only work with a paid cluster


Get your Ingress subdomain

```bash
ibmcloud cs cluster-get <CLUSTER NAME>
```

Then add this subdomain to the `frontdoor.yaml` file, and create and list the details for your Ingress

```bash
kubectl apply -f guestbook-frontdoor.yaml
kubectl get ingress guestbook-ingress  -o yaml
```

## Traffic Management

### Traffic Management Rules

The core component for traffic management in istio is Pilot. This manages and configures all the Envoy proxy instances in a service mesh

Pilot translates high level rules into low level configurations by means of the following three resources

* Virtual Services - Defines a set of routing rules to apply when a host is addressed
* Destination Rules - Defines policies that apply to traffic intended for a service after routing has occurred, specifications for load balancing, connection pool size, outlier detection, etc
* Service Entries - Enables services to access a service not necessarily managed by Istio

### A/B Testing

Previously we had created two versions of the Guestbook app, v1 and v2. If we do not have any rules, istio will distribute requests evenly between the instances

To prevent Istio from using the default routing method we can do the following to route all traffic to v1

```bash
istioctl replace -f virtualservice-all-v1.yaml
```

### Incrementally roll our changes

We can incrementally roll our changes by changing the weighting of our different versions

```bash
istioctl replace -f virtualservice-80-20.yaml
```

### Circuit Breakers and Destination Rules

Istio lets us configure settings for destination rules as well as implementing circuit breakers for Envoys

## Securing Services

### Mutual Auth with Transport Layer Security

Istio can enable secure communication between app services without the need for application code changes. We can delegate service control to Istio instead of implementing it on each service

Citadel is the Istio component that provides sidecar proxies with an identity certificate . Envoys then use these certificates to encrypt and authenticate communication along channels between these services

When a microservice connects to another microservice communication between them is redirected through the Envoys

### Setting up a Certificate Authority

First check that Citadel is running

```bash
kubectl get deployment -l istio=citadel -n istio-system
```

Do the following with bash

```bash
ibmcloud cs cluster-config <CLUSTER NAME>
```

Then set the environment variable, and paste the following

```bash
cat <<EOF | C:/Users/NabeelValley/istio-1.0.3/bin/istioctl.exe create -f -
apiVersion: authentication.istio.io/v1alpha1
kind: Policy
metadata:
  name: mtls-to-analyzer
  namespace: default
spec:
  targets:
  - name: analyzer
  peers:
  - mtls:
EOF
```

You can then confirm the policy is set with

```text
kubectl get policies.authentication.istio.io
```

Next we can enable mTLS from a guestbook with a Destination Rule

```bash
cat <<EOF | istioctl create -f -
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: route-with-mtls-for-analyzer
  namespace: default
spec:
  host: "analyzer.default.svc.cluster.local"
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
EOF
```

### Verify Authenticated Connection

We can ssh into a pod by getting the pod name and opening the terminal

```bash
kubectl get pods -l app=guestbook
kubectl exec -it guestbook-v2-xxxxxxxx -c istio-proxy /bin/bash
```

Then we should be able to view the certificate `pem` files as follows

```bash
ls etc/certs/
```

## Enforcing Isolation

### Service Isolation with Adapters

Back-end systems typically integrate with services in a way that creates a hard coupling

Istio uses Mixer to provide a generic intermediate layer between app code and infrastructure back-ends

Mixer makes use of adapters to interface between code and back-ends

* Denier
* Prometheus
* Memquota
* Stackdriver

### Using the Denier Adapter

Block access to the Guestbook service with

```text
istioctl create -f mixer-rule-denial.yaml
```

The rule we have created is as follows



```yaml
apiVersion: "config.istio.io/v1alpha2"
kind: denier
metadata:
  name: denyall
  namespace: istio-system
spec:
  status:
    code: 7
    message: Not allowed
---
# The (empty) data handed to denyall at run time
apiVersion: "config.istio.io/v1alpha2"
kind: checknothing
metadata:
  name: denyrequest
  namespace: istio-system
spec:
---
# The rule that uses denier to deny requests to the guestbook service
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: deny-hello-world
  namespace: istio-system
spec:
  match: destination.service=="guestbook.default.svc.cluster.local"
  actions:
  - handler: denyall.denier
    instances:
    - denyrequest.checknothing
```



We can verify that the access is denied by navigating to our Ingress IP, next we can remove the rule with

```bash
istioctl delete -f mixer-rule-denial.yaml
```



