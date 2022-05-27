[[toc]]

# Deploy a Kubernetes App on ICP

You can do any of the following

- [Install on your Machine (or on a VM)](https://www.ibm.com/support/knowledgecenter/SSBS6K_1.2.0/installing/install_containers_CE.html)
- [Reserve a VM on BlueDemos](https://bluedemos.com/show/199)
- [ICP Hosted Trial on BlueDemos](https://bluedemos.com/show/1484)
- [Reserve a Hosted Trial](https://www.ibm.com/cloud/garage/dte/tutorial/ibm-cloud-private-hosted-trial)

## Deploy a an App to the Cluster

We can use `kubectl` to deploy an application to ICP

### Configure `kubectl`

We can use the configuration code from ICP as follows

```bash
kubectl config set-cluster cluster.local --server=https://10.0.0.1:8001 --insecure-skip-tls-verify=true
kubectl config set-context cluster.local-context --cluster=cluster.local
kubectl config set-credentials admin --token=<YOUR TOKEN>kubectl config set-context cluster.local-context --user=admin --namespace=cert-manager
kubectl config use-context cluster.local-context
```

### Deploy the Application

[DeveloperWorks Article on Doing this](https://developer.ibm.com/recipes/tutorials/setting-up-access-logging-on-ibm-cloud-private/)

Then we need to get our deployment manifest file and run the deploy command, we will need the following

- Deployment manifest
- Service manifest
- Ingress manifest

We need the service to expose our app on a port, and an ingress rule to expose that externally

`deployment.yaml`
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
 name: express-basic
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: express-basic
        version: v2
    spec:
      containers:
      - image: nabeelvalley/express-basic
        name: express-basic
        ports:
        - containerPort: 8080
```

`service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
 name: express-basic
 labels:
   app: express-basic
   version: v2
spec:
 ports:
 - port: 8080
   name: http
 selector:
   app: express-basic
   version: v2
```

`ingress.yaml`
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
 name: express-basic-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        backend:
         serviceName: express-basic
         servicePort: 8080
      - path: /test
        backend:
          serviceName: express-basic
          servicePort: 8080 
```

We can then deploy these resource definitions on our cluster with

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
```

Alternatively we can include all three in a single file and apply it as follows

`deploy.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
 name: express-basic
 labels:
   app: express-basic
   version: v2
spec:
 ports:
 - port: 8080
   name: http
 selector:
   app: express-basic
   version: v2

---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
 name: express-basic
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: express-basic
        version: v2
    spec:
      containers:
      - image: nabeelvalley/express-basic
        name: express-basic
        ports:
        - containerPort: 8080
---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
 name: express-basic-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        backend:
         serviceName: express-basic
         servicePort: 8080
      - path: /test
        backend:
          serviceName: express-basic
          servicePort: 8080 
---
```

```bash
kubectl apply -f deploy.yaml
```