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

Then we need to get our deployment manifest file and run the deploy command, in my case as follows

`deploy.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: express-basic
  labels:
    app: express-basic
    version: "1.0"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: express-basic
  template:
    metadata:
      labels:
        app: express-basic
        version: "1.0"
    spec:
      containers:
      - name: express-basic
        image: nabeelvalley/express-basic
        ports:
        - name: http-server
          containerPort: 8080
```

Then create a new resource with

```bash
kubectl create -f deploy.yaml
```

Next we can expose our application as a service with

```bash
kubectl expose deployment/express-basic --type="NodePort" --port=8080
```

(For some reason this doesn't seem to be working as planned, will try to re-approach)