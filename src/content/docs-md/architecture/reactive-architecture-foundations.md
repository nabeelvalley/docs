---
published: true
title: Reactive Architecture Foundations
subtitle: Notes on reactive architecture for microservices
---

> [Based on this CognitiveClass learning path](https://cognitiveclass.ai/learn/reactive-architecture-foundations)

# Foundations

## Why Reactive

The primary goal of reactive architecture is to provide an architecture that is responsive under all conditions. Reactive architecrure is about solving business problems that are caused by technical challenges

## Unresponsive Software

Unresponsive software can be an annoyance to users even if this is due to another system that you're dependant on. Ideally we want to find ways that we can isolate ourselves from these external failures

In the case of certain organizations, an outage like this can be extremely costly in both monetary loss as well as customer loss

## The Goal

How can we build software that:

- Scales to the necessery users
- Only consumes the necessary users
- Handle failures with little to no user impact
- Can be distributed over different machines
- Maintains a consistent level of responsivenes despite other factors

## The Reactive Principles

[The Reactive Manifesto](https://www.reactivemanifesto.org/) is a set of patterns for solving some problems that companies were facing in a changing landscape

A reactive system has 4 main principles:

- Responsive - responds in a timely fashipn
- Resillient - remains responsive even when failures occur
- Elastic - remains responsive despite changes to the system load
- Message Driven - built on async, non-blocking messages

### Responsive

> "Responsiveness is the cornerstone of usability

Responsive systems build user confidence. In a reactive system all other principles are used to drive responsiveness

### Resilient

> "Resillience provides responsiveness despite failure"

Resillience is made possible by:

- Replication
- Isolation
- Containment
- Deligation

Failures should be isolated to a single component and recovery should be delegated to external components such as monitoring or lifecycle management components

It's important that failures don't bring down the entire system like it would in a monolith

### Elastic

> "Elasticity provides responsiveness, despite increases or decreases in load"

This implies that an architecture is able to both scale up or scale down in order to prevent bottlenecks as well as improve cost effectiveness

### Message Driven

> "Responsiveness, Resillience, and Elasticity are all supported by a Message Driven Architecture"

Messages should be async and non-blocking

Messages should provide:

- Loose coupling
- Isolation
- Location transparency

Additionally, this ensures that resources are not consumed while waiting as the application is not blocking or using threads while waiting for a response that may never come

## Reactive Systems vs Reactive Programming

- Reactive systems are built in a way such that our individual application services and components interact in a reactive way (the above points). Reactive systems are separated along asynchronous boundries
- Reactive programming can be used to develop reactive systems makes use of async, often callback-based programming

## The Actor Model

The Actor model is a programming paradigm that supports the development of reactive systems. The actor model is Message Driven and provides abstractions for Elasticity and Resillience

- All computation occurs inside an actor
- Each actor has an address
- Communication is done through async messages only

### Location Transparency

The message driven design provides Location Transparency. All actors communicate using the same technique regardless of location. The original actor does not need to know the details of where another actor is located

The communication may be via a router that is able to direct messages as needed which also enables us to distribute actors

### Reactive Systems without Actors

It's possible to develop a Ractive system without the actor model using things like a:

- Service registry
- Load balancer
- Message bus

The result is a system that's reactive at the architectural scale compared to the actor model in which individual components in the system are reactive in themselves which simplifies things as the development of the system grows

# Domain Driven Design

One of the key goals of DDD is about establishing a communication channel between domain experts and the software

Large domains can be difficult to model, to better handle this we try to split domains into clearly differentiated sub-domains

DDD provides us with a set of guidelines for splitting these domains

## What is a Domain

> "A domain is a sphere of knowledge"

In software this refers to some business or idea that we are trying to model, the key goal of DDD is to build a model that domain experts understand

- The model represents our understanding of the domain
- The software is an implemetation of the model

### Ubiquitous Language

This is a common language that is used to communicate between developers and domain experts, this language and terminology is driven by the domain experts and is based on words that come from the domain

It's very important to ensure that the domain and software terminology is kept aligned

## Decomponsing the Domain

Business domains are often large and complicated and which can contain many different ideas and actions with complex interactions. Trying to model a large domain can be complex, so it makes sense to split these domains into smaller subdomains for related parts of the domain

Some parts or ideas may exist in multiple subdomains and in each of these domains these may evolve separately so it is important to also realize that abstracting these things may not always be appropriate

### Bounded Context

Each subdomain will have its own ubiquitous language. Often when building microservices we use Bounded Contexts as a starting point which we may break up further later on

Between different bounded contexts the same word may have very different meanings. For example an "order" may mean something very different to a waiter when compared to someone managing inventory

Some guidelines for identifying bounded contexts:

- Human culture and interaction - if different areas of the domain are handled by different people this may suggest a natural division
- Changes in Ubiquitous Language - if language changes meaning this may suggest a new context
- Varying levels of Detail - certain details may be relevant in one domain but irrelevant in another

Bounded contexts should be strongly separated and should result in smooth workflows. A context with too many dependencies may be overcomplicated

Traditional DDD focused on Objects, more modern DDD is focused on Events. This is also known as Event-First Domain Driven Design

> The process of identifying these events is known as Event Storming

## Domain Activities

When defining activities it can be useful to have a common notation to keep things clear, the `subject-verb-object` notation is one method of doing this, an example of this would be "**Customer** _creates_ a **booking**"

- Customer - subject
- Creates - verb
- Booking - object

Sometimes there may also be a direct or indirect object, for example in an example like "**Host** _creates_ a **booking** for a **customer**" we have the following:

- Host - subject
- Creates - verb
- Booking - direct object
- Customer - indirect object

The indirect object is an object that's related to the direct object

There are a few different types of activities in a domain:

### Commands

- Represents a request to perform an activity
- Not yet happened, can be rejected
- Usually delivered to a specific location
- Causes a state change

### Events

- Represent an action that happened in the past
- Can't be rejected
- Often broadcast to many destinations
- Records a change to domain state, often the result of a command
- Always worded in past tense

### Queries

- Request for information
- Expect a response
- Usually delivered to a specific destination
- Should not alter the state of the domain

In a reactive system, Commands, Events, and Queries are the types of messages in a reactive system and they form the API of a bounded context

## Maintaining Purity

Once the domain has been split into bounded contexts it's necessary to ensure those domains are maintined

### Anti-Corruption Layers

Anti-Corruption layers help us to prevent details from one domain leaking into another

The ACL can be implemented as an abstract interface and there will then be an implementation that will translate this object between different domains

Sometimes Anti-Corruption systems are needed for interfacing with legacy systems that may not have good domain separation

### Context Map

A context map is a way of visualizing bounded contexts as well as the relationships between them. The relationships/arrows between contexts indicate a dependency of some kind

## Ubiquitous Language to Code

As we develop a bounded context we start translating commands into code, for example "Create a Booking" would translate to something like `CreateBooking`

## Domain Objects

### Value Object

- Defined by attributes
- Two objects are the same if their attributes are the same
- Immutable
- Messages in Reactive Systems are implemented as Value objects

### Entities

- Identified by a unique identity
- May change attributes but not identity
- If identity changes then it is a new entity, regardless of attributes

### Aggregates

- Collection of domain objects bound to an entity
- Objects in an aggregate can be treated as a single unit
- The root entity is called the Aggregate Root
- Access to objects in the Aggregate must go through the Aggregate Root
- Transactions should not span multiple Aggregate roots
- Aggregates are good candidates for distribution

Choosing an aggregate root is not always straightforward and can be different between different contexts. Some contexts may require multiple aggregates but this is not usually the case

Considerations when determining the Aggregate Root:

- Is the entity involved in most operations in the context
- Does deleting the entity require us to delete other entities
- Will a single transaction span multiple entities

## Object-Field Notation

We use something like `Order(orderId, orderItems, tableNumber, serverId)` as a way to identify th fields of an object

## Domain Abstractions

### Services

Some abstractions don't necessarily fit with an Entity of Value Object

- Should be stateless
- Logic can be abstracted into services
- Can abstract away an anti-corruption layer

Services should be very thin layers over some business logic

### Factories

Often there may be a lot of logic/complexity involved in creating a domain object

- Abstract away creation of domain objects
- Factories abstract away the creation logic
- May require access to external resources like databases, etc.

### Repositiories

Repositories are a way of retreiving or modifying existing objects

- Used to read, udpdate, and delete existing objects
- Abstract access to external resources like databases, web services, etc.
- Allows you to switch in specific implementations when needed

Often we combine factories into repositories which then also handle the creation of objects as well

## Hexagonal Architecture

> Also known as "Ports and Adapters" and an alternative to the "N-Tier" architecture

- Domain is isolated to the center of the architectural focus
- Ports are exposed as APIs for the domain
- Adapters commuunicate with the domain through the port
- Can be viewed as an onion
- Outer layers depend on inner layers, inner layers do not depend on outer laers
- Ensures proper separation of domain from infrastructure
- Can be enforced with packages or projects
- Pieces of infrastructure can be swapped around without impacting domain, and vice versa

Since the domain has no dependency on the other parts of the architecture it can be portable

# Reactive Microservices

## Monoliths

The worst-case for a monolith can often have:

- No clear isolation
- Complex dependencies
- Hard to understand and modify

To clean up a an application like above we would often split the application into a few separate domain boundries

### Characteristics

- Deployed as a single application
- Single, shared database
- Communicate with synchronous method calls
- Deep coupling between components, often through the DB
- Big releases
- Long development cycles (weeks or months)
- Careful synchronization of features and releases needed

Scaling a monolith involves multiple instances of the same application with a shared database

### Advantages

- Easy cross-module refactoring
- Easier to maintain consistency
- Single deployment process
- Snigle application to monitor
- Simple scaling model

### Disadvantges

- Limited by the max size of a single server
- Only scales within the limitations of a database
- Components must all be scaled together
- Deep coupling, inflexibility
- Slow development cycles
- a Serious failure can bring down the entire monolith and can potentially cascade through instances

## Service Oriented Architecrure

> Not necessarily the same as microservices

The introduction of isolation can be done by way of a service-oriented-architecture

In an SOA each individual service:

- Has its own database
- All access goes through the service's API
- Services can live in a monolith or as a set of microservices

## Microservices

- Subset of SOA
- Logical components are separated into services
- Should be deployed independently
- Each component has its own data store
- Independent and self governing

### Characteristics

- Deployed independently
- Multiple independent databases
- Synchronous or asynchronous communication
- Loose coupling
- Rapid deployments
- Teams manage features on their own
- Teams use a DevOps approach

### Scaling

- Each service scales independenntly
- Can be one or multiple copies of each service per server
- Each server hosts a subset of the entire system

### Advantages

- Individual services can be deployed and scaled
- Increased availabilities, more isolated failures
- Isolation and decoupling creates more flexibility
- Supports multiple platforms and languages

### Team Organization

- Team independence
- Faster release cycles
- Cross-team coordination is less necessary
- Can increase productivity

### Disadvantages

- May require complex deployment and monitoring systems
- Cross-service refactoring is complicated
- Requires supporting older API versions
- May require organizational changes

## Responsibilities of Microservices

### Single Responsibility Principle

> "A class should have only one reason to change"

The SRP can also be applied to microservices. A micorservice should only have a single responsibility and a change to the internals of one microservice should not necessitate changes to other services

### Bounded Contexts

Bounded contexts are a good starting point for the division of individual services. These define a context in which a specific model applies

After the initial definition, services may additionally be subdivided within a bounded context

## Principles of Isolation

- State
- Space
- Time
- Failure

### State

Isolation of state is accomplished by ensuring all state access goes through the API, this allows internal evolution of the service while maintaining the internal api

### Space

Microservices should not care where other services are deployed. This allows the service to be scaled up or down as needed

### Time

Microservices should not wait for each other. Requests should be async and non-blocking which enables us to free up additional resource time

This enables eventual consistency which means that now services can sale in independently

### Failure

A service's failure should not cause failure in other services. This enables our system to remain operational even if some parts are failing

## Bulkheading

Bulkheading is a technique for isolating failures

- Create failure zones in an application
- Prevent failure propogarion
- Overall system can remain operational

## Circuit Breaker

When a service is overloaded a caller may not realize the service is overloaded and the retries may lead to further failure

- Avoid overloading a service
- Quarantine a failing service so it can fail fast
- Allows failing service time to recover without overloading

In the event of a failure the circuit breaker is failed fast and this causes messages to go through the circuit breaker instead of to the service itself

Over time the circuit breaker will allow a single request through to basically test if the service is back up, if the service is up then the circuit breaker switches back to the closed state

States:

1. Closed - normal operation, service is acessible
2. Open - once tripped by some error state, this will prevent requests from going to the service to allow it time to recover
3. Half Open - after some time of being close the circuit breaker will switch to this state, this will allow one request to go through to check if the service is operational, if it works then the the service will become available again and the circuit breaker will Reset itself back to the Closed state. If the request does not work it will again go back to the Open state

## Message Driven Architecture

Reactive systems are based on messaging

- Aysnc, non-blocking - decouples by time and faiulure
- Services are not dependent on responses from each other
- If a request fails, the failure won't propogate
- The client isn't waiting for a response

## Autonomy

Each service should be able to operate independently

- Microservices can only gaarantee their own behaviour
- Isolation allows a service to operate independently
- Each service can be autonomous
- Automnomous services have enough information to resolve conflicts and repair failures
- Don't require other services to be operational all the time

### Benefits

- Stronger scalability and availability
- Scaled indefinitely
- Operate indepentently means that services are more failure tolerant

### Implementation

- Communicate through async messages
- Maintain enough internal state for isolated functioning
- Use Eventual Consistency
- Avoid direct, synchronous dependencies on external services

## Gateway Services

Microservices can lead to complexities in the API

- Data may be distributed between services
- Clients may need to aggregate data
- Client may need to know about all services
- Clients must manage complex aggregations and failure handling

API Gateway Services are services between microservices and clients

- Gateway sents requests to individual services for aggregation
- Logic and aggregation happens in the Gateway service
- Gateway handles failures from each service, client only needs to handle gateway failures
