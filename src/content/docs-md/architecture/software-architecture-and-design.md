# Software Architecture and Design

> From [this Udacity Course](https://classroom.udacity.com/courses/ud821), the course structure and recommended reading can be found [here](https://www.udacity.com/wiki/saad/schedule)

# Introduction

This course will teach high level design based on object-oriented concepts

## Objectives

- Express analysis and design using of applications using Unified Modeling Language (UML)
- Specify functional semantics using the Object Constraint Language (OML)
- Specify and evaluate software architectures
- Select and use appropriate architectural styles
- Understand and applu obect-oriented design techniques
- Select and use appropriate software design patterns

## Tools

The class makes use of [Argo UML](http://argouml.tigris.org/) and the Eclipse IDE, additionally there is a [VM Setup](https://www.udacity.com/wiki/saad/vm-setup) that can be used that has everything preinstalled

Additionally you can potentially use [Draw.io](https://www.draw.io/), Visio, or even Visual Studio to build Class Diagrams

# Text Browser Excercise

## Analysis Model

- UML class-model diagam
- Rectangles for classes
- Lines between components to denote relations

For the Text Browser Application we can represent the different components using a UML:

- ViewPort
- ScrollBar
- FileManager

## Operations

The operations are the actions that a user would use to interact an application, such as:

- View text
- Scroll
- Resize ViewPort

## Percepts

These are the externally observable properties of a system, e.g the size of the viewport. These are any interfaces that are used to connect to an external actor

## Relationships

We have three types of relationships:

1. Asociations
2. Aggregations
3. Generalizations

Certain relationships can't be shown in a UML diagram such as relationships with constraints or constraints on Percepts. To display these we would make use of OCL

In our case we have a relationship where the number of lines visible is dependant on the FileManager and the ViewPort relationship

# Design Concepts
