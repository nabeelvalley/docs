[[toc]]

[Based on this Cognitive Class course](https://cognitiveclass.ai/courses/get-started-with-microservices-istio-and-ibm-cloud-container-service/)

# Twelve Factor App

## [Methodology](https://www.12factor.net/)

A methodology for developing SaaS based on

* Declarative automation
* Clean contract with underlying OS
* Suitable for deployment on modern cloud platforms
* Minimize divergence with CD for agility
* Easily scale without significant changes to tooling or architecture

The twelve factor system is a set of best practices that allow us to build applications that are truly cloud native. Furthermore this method has characteristics that are ideal for developing microservices and the cloud infrastructure 

## The Factors

1. **Codebase**: One codebase tracked in revision control, many deployments
2. **Dependencies**: Explicitly declare and isolate dependencies
3. **Config**: Store configuration in the environment
4. **Backing services**: Treat backing services as attached resources
5. **Build, release, run**: Strictly separate build and run stages
6. **Processes**: Execute the app as one or more stateless processes
7. **Port binding**: Export services via port binding
8. **Concurrency**: Scale out via the process model
9. **Disposability**: Maximize robustness with fast startup and graceful shutdown
10. **Dev/prod parity**: Keep development, staging, and production as similar as possible
11. **Logs**: Treat logs as event streams
12. **Admin processes**: Run admin/management tasks as one-off processes

### Codebase

We make use of a single codebase for our application and version control software. Based on this we can make use of multiple deployment types such as Containers and CF Application deployments

Each microservice should have its own main branch and membership but should all be stored in the same repository

### Dependencies

Dependencies should be explicitly declared and isolated from your codebase. Build packs control our dependencies, not system-wide dependencies

### Configuration

Configurations should be stored in the environment and not the source codebase. We should effectively separate out any config from our source codebase

A guiding principle is the ability for our codebase to be made open source at any time without exposing any credentials

### Backing Services

These are treated as attached resources that can be bound, local and remote resources are treated identically

### Build, Release, Run

Separation of our Build, Release, and Run stages should be done

* In the Build stage we transform the repository into an executable bundle, this stage will get our dependencies and compile the code
* The Release stage is when the code is combined with our deployment configuration, the resulting build contains our executable code as well as our environmental configurations
* The Run stage is when the app is actually running, this code should not be modified

### Processes

Applications should be run as one or more stateless processes. Runtimes should be stateless but our services can have state

### Port Binding

Services should be exposed by port binding, this is generally done by the build, and we should avoid hard-coding port values

### Concurrency

We should ensure that our applications can be horizontally scaled out such that different instances can be run independent of one another

### Disposability

Processes should start fast and shut down gracefully,  once shut down there should be no residual state information that needs to be cleaned out

Runtimes should be immutable and be able to be killed and re-instantiated as needed

### Development and Production Parity

Development, staging, and production environments should be as similar as possible at all stages, we should use the same backing services in each environment and minimize incompatible elements

Use things like Agile and CI/CD

### Logs

Out application should not write or manage log files

Processes should write to `stdout` and the environment will figure out how to gather, aggregate, and persist this output

### Admin Processes

These should be viewed as processes that will be repeated and therefore should be done as such. They should be stored and version controlled such that there is a record of what was done

# Microservices

## Introduction

Microservices are an architectural style that divides apps into components where each component is a miniature app that performs a single business task

A mircoservice has a well defined set of dependencies and interfaces so they can run and be developed fairly independently

Furthermore microservices make teams more efficient by reducing the amount of communication needed an allowing people to work in smaller teams on more specific tasks

## Architecture

The architecture is based on completely decoupling app components from one another such that they can be maintained and scaled more easily

This revolves around Service Oriented Architecture \(SOA\) which focuses on reuse, technical integration and APIs

## Key Tenets

* Independent services for processes
* Services optimised for single function
* Communication through REST and message brokers
* Avoid tight coupling through communication via a database
* CI/CD defined per service
* Availability and Clustering defined per service

# Microservice Component Architecture

## Microservice types

We have different types of microservices

* Dispatcher
  * Web
  * API 
  * Mobile
    * IOS
    * Android
* Business Service

Out dispatchers are dependent on the types of clients that we have which use out API

## Language Decisions

Microservices can be deployed in any language that supports REST and can be deployed on Cloud

Typically we use Node for dispatchers as we can handle a large number of clients and lots of concurrent I/O

Business services are often done with Java as it handles CPU intensive tasks well and is good at connecting to eternal systems

## Backend for Frontend 

BFF enables us to have a single team be in charge of the the client app to the dispatcher as these need to be designed for each other

# Microservice Integration

## Inter-Service Communication

The standard for communication is JSON/REST with asynchronous integration. Communication should also be language-neutral so that different services in different languages can communicate

We achieve complete decoupling by

* Messaging whenever possible
* Service Registries and Discovery
* Load Balancing
* Circuit Breaker Patterns

## IBM Message Hub

Messages between services can be done using HTTP or Apache Kafka

# Service Meshes

## Introduction

A service mesh is a set of proxies that gives us better visibility into our services and the health and performance of services

The also allow us to more easily define security for our application and control how different members can communicate

They help us solve a lot of issues that we come across when implementing microservices. In general we make use of a service registry to manage and control access between different containers and services

## Service Registry

A simple key-value pair of current working service instances and their locations. Services will register themselves with the registry upon starting 

## Service Discovery and Proxies

Service Discovery functions allow services to find and connect with each other in order to function

## Client Side Discovery

Using this method the service client works directly with the registry in order to identify which service instance to use

## Server Side Discovery

This makes use of a Load Balancer to direct traffic to a service instance. In this case the Client will call the load balancer which will then direct traffic as needed

# Istio

## Introduction

An open platform service mesh for connecting, managing, and securing mircoservices. As service meshes grow in complexity tools like Istio are necessary to manage our services

Istio has the following functionality

* Traffic management
*  Observability
* Policy enforcement
* Service identity and security
* Platform support
* Integration and customization

Overall Istio helps us to decouple application code from the running platforms and policy

## How it Works

An Istio mesh is split into a Data Plane and a Control Plane

The Data Plane is a set of intelligent proxies deployed as sidecars that mediate and control network communication

The Control Plane manages and configures proxies to route traffic and enforce policy

### Sidecar Proxies

These control access to other objects in a cluster, this enables the service mesh to manage interactions

A sidecar adds behaviour to a container without changing it, the pod hosts a sidecar and a service as a single unit

### Envoy

Istio uses an extended version of the _Envoy_ proxy to mediate all network traffic. Envoy is deployed as a sidecar to the relevant service in the same Kubernetes pod

### Mixer

_Mixer_ is a platform independent component which enforces access control and usage policies across the mesh

### Pilot

_Pilot_ provides service discovery for Envoy sidecars, traffic management and intelligent routing 

### Citadel

_Citadel_ provides string service-to-service authentication with built in identity and credential management and provides the ability to enforce policy that is based on service identity rather than network controls



