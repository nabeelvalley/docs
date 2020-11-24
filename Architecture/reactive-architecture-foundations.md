> [Based on this CognitiveClass learning path](https://cognitiveclass.ai/learn/reactive-architecture-foundations)

# Why Reactive

The primary goal of reactive architecture is to provide an architecture that is responsive under all conditions. Reactive architecrure is about solving business problems that are caused by technical challenges

# Unresponsive Software

Unresponsive software can be an annoyance to users even if this is due to another system that you're dependant on. Ideally we want to find ways that we can isolate ourselves from these external failures

In the case of certain organizations, an outage like this can be extremely costly in both monetary loss as well as customer loss

# The Goal

How can we build software that:

- Scales to the necessery users
- Only consumes the necessary users
- Handle failures with little to no user impact
- Can be distributed over different machines
- Maintains a consistent level of responsivenes despite other factors

# The Reactive Principles

[The Reactive Manifesto](https://www.reactivemanifesto.org/) is a set of patterns for solving some problems that companies were facing in a changing landscape

A reactive system has 4 main principles:

- Responsive - responds in a timely fashipn
- Resillient - remains responsive even when failures occur
- Elastic - remains responsive despite changes to the system load
- Message Driven - built on async, non-blocking messages

## Responsive

> "Responsiveness is the cornerstone of usability 

Responsive systems build user confidence. In a reactive system all other principles are used to drive responsiveness

## Resilient

> "Resillience provides responsiveness despite failure"

Resillience is made possible by:

- Replication
- Isolation
- Containment 
- Deligation

Failures should be isolated to a single component and recovery should be delegated to external components such as monitoring or lifecycle management components

It's important that failures don't bring down the entire system like it would in a monolith

## Elastic

> "Elasticity provides responsiveness, despite increases or decreases in load"

This implies that an architecture is able to both scale up or scale down in order to prevent bottlenecks as well as improve cost effectiveness

## Message Driven

> "Responsiveness, Resillience, and Elasticity are all supported by a Message Driven Architecture"

Messages should be async and non-blocking

Messages should provide:

- Loose coupling
- Isolation
- Location transparency

Additionally, this ensures that resources are not consumed while waiting as the application is not blocking or using threads while waiting for a response that may never come

# Reactive Systems vs Reactive Programming 

- Reactive systems are built in a way such that our individual application services and components interact in a reactive way (the above points). Reactive systems are separated along asynchronous boundries
- Reactive programming can be used to develop reactive systems makes use of async, often callback-based programming

# The Actor Model

The Actor model is a programming paradigm that supports the development of reactive systems. The actor model is Message Driven and provides abstractions for Elasticity and Resillience

- All computation occurs inside an actor
- Each actor has an address
- Communication is done through async messages only

## Location Transparency

The message driven design provides Location Transparency. All actors communicate using the same technique regardless of location. The original actor does not need to know the details of where another actor is located

The communication may be via a router that is able to direct messages as needed which also enables us to distribute actors

## Reactive Systems without Actors

It's possible to develop a Ractive system without the actor model using things like a:

- Service registry
- Load balancer
- Message bus

The result is a system that's reactive at the architectural scale compared to the actor model in which individual components in the system are reactive in themselves which simplifies things as the development of the system grows
