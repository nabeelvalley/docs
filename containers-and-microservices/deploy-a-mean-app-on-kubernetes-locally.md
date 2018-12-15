# Deploy a MEAN app on Kubernetes Locally

[Based on this article](https://docs.bitnami.com/kubernetes/how-to/deploy-mean-application-kubernetes-helm/)

[Ketting started with Minicube](https://docs.bitnami.com/kubernetes/get-started-kubernetes/#option-1-install-minikube)

[Installing Minicube on Windows](https://medium.com/@JockDaRock/minikube-on-windows-10-with-hyper-v-6ef0f4dc158c)

- [Deploy a MEAN app on Kubernetes Locally](#deploy-a-mean-app-on-kubernetes-locally)
	- [Prerequisites](#prerequisites)
	- [Installation](#installation)
		- [Minikube](#minikube)

## Prerequisites

- Docker
- Minicube
- Minikube k8s cluster
- `kubectl` installed
- Helm and Tiller

## Installation

### Minikube

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

Or 

```bash
minikube start --vm-driver hyperv --hyperv-virtual-switch "Primary Virtual Switch"
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


