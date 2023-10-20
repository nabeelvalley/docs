---
title: Building Spring apps with Kotlin
description: Developing web applications using Kotlin and Spring Boot
published: true
---

This post outlines the general methodology and operation of Spring applications with Kotlin. For the sake of example we
will be building a project management application backend

# References

- [Spring](https://spring.io)
- [Spring Boot with Kotlin & JUnit](https://www.youtube.com/watch?v=TJcshrJOnsE&list=PL6gx4Cwl9DGDPsneZWaOFg0H2wsundyGr)

# About Spring

The Spring framework comes with lots of infrastructure for working with some common application needs like dependency
injection, transaction management, web apps, data access, and messaging

Spring boot provides an opinionated setup for building Spring applications using the framework

# Initializing an Application

To initialize an application we can use the [Spring initializr](https://start.spring.io/) and select the project
configuration that we would like. For this case adding selecting Maven, Kotlin, and Java 17 along with the Spring Web
Dependency

# Running the Application

The initialized application will have the Spring dev tools preinstalled. You can run the application in hot reloading
mode using them as follows:

```sh
mvn spring-boot:run
```

> While you can probably make all this stuff work using the command line but since the Kotlin experience seems kinda
> wack in VSCode I'll be using IntelliJ for this

So, with that noted - just hit the play button

# Defining a Controller

To define a controller we can simply create a class with the `@RequestController` to register the controller
and `@RequestMapping` to register the endpoint within this controller

Then, we can define a method in that controller, the name of the function is not super important but the annotation at
the top tells how it will be routed

The code for the controller can be seen below

`HelloController.kt`

```kotlin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("api/hello")
class HelloController {
    @GetMapping
    fun getHello() = "Hello World"
}
```

We can make the endpoint return data instead of just a string by defining a data class to return:

```kotlin
data class Data(val name: String, val age: Int)

// in controller

@GetMapping("")
fun getHello() = Data("Bob Smith", 45)
```

# Project Structure Overview

Some of the important parts of the generated project are the following:

- `mvnw` or `gradlew` files which are wrappers for executing commands for the respective build tool
- `pom.xml` or `build.gradle` files for configuring application dependencies
- The `main` function ni the `main/kotlin` directory, this will have the same name as your project, and is the
  application entrypoint
- The files in the `test` directory are where we will include our unit tests

For reference, the content of my main file are as follows:

```kotlin
package nabeelvalley.springkotlin

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class SpringAppWithKotlinApplication

fun main(args: Array<String>) {
    runApplication<SpringAppWithKotlinApplication>(*args)
}
```

# Models

The data layer for our application will consist of different models. We can define these inside of our application
code, for example we can create a class called `Project` which we can define as a data class as such:

`models/Project.kt`

```kotlin
package nabeelvalley.springkotlin.models

data class Project(
    val name: String,
    val description: String
);
```

# Data Sources

Data sources are retrieval and storage (aka database). This will allow us to provide us some method of getting data and
exchanging implementations of our storage layer

To create a data source we can create a class for a specific data source. When doing this, we usually want to create a
base interface that different data sources should implement. Spring calls these `Repositories`, so we'll name them using
that convention as well

The interface can be defined as so:

`data/IProjectRepository.kt`

```kotlin
package nabeelvalley.springkotlin.data

import nabeelvalley.springkotlin.models.Project

interface IProjectRepository {
    fun getProjects(): Collection<Project>
}
```

Thereafter, we can create a simple in-memory implementation of the above interface using the following:

```kotlin
package nabeelvalley.springkotlin.data

import nabeelvalley.springkotlin.models.Project
import org.springframework.stereotype.Repository

@Repository
class InMemoryProjectRepository : IProjectRepository {
    private val data = mutableListOf<Project>()

    override fun getProjects(): Collection<Project> = data
}
```

It is also important to note that the repository implementation has the `@Repository` attribute

# Testing

Testing will be done using `JUnit`. Creating test classes can be done by adding the relevant file into the `test/kotlin`
directory

We can add a test for the repository we created as follows:

`test/.../data/InMemoryProjectRepositoryTests.kt`

```kotlin
package nabeelvalley.springkotlin.data

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test

internal class InMemoryProjectRepositoryTests {

    private val repository = InMemoryProjectRepository()

    @Test
    fun `should list collection of projects`() {
        val result = repository.getProjects()

        Assertions.assertTrue(result.isNotEmpty())
    }
}
```

We can run the above test using IntelliJ, the result will be that the test is failing since we have not added any items
into our repository, we can add som sample items and run the test again, it should now be passing

The changes to the repository `data` definition can be seen below:

```kotlin
private val data = mutableListOf(
    Project("Project 1", "Description of the first project")
)
```

# Services

Services are defined using a class with the `@Service` annotation and generally imply that we will be using some kind of
data service or other data.

`@Service` and `@Repository` are extensions on the `@Component` implementation which is some kind of injectable class
that can be managed by Spring. These are all instances of an `@Bean`

We can define a class for the service which uses a project repository as follows:

`services/ProjectService.kt`

```kotlin
package nabeelvalley.springkotlin.services

import nabeelvalley.springkotlin.data.IProjectRepository
import org.springframework.stereotype.Service

@Service
class ProjectService(private val repository: IProjectRepository) {

    fun getAll() = repository.getProjects()
}
```

# Controllers

Controllers are used for mapping services to HTTP endpoints. We can define a controller like so:

## Get All

```kotlin
package nabeelvalley.springkotlin.controller

import nabeelvalley.springkotlin.services.ProjectService
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/project")
class ProjectController(private val service: ProjectService) {
    @GetMapping
    fun getAll() = service.getAll()
}
```

In the above we are using `@RestController` and `@RequestMapping` to define the controller and `@GetMapping` to annotate
the method for the defined handler

We can further defined tests for this controller using `@SpringBootTest` which will initialize the entire application
context for the purpose of a test. We can also restrict this a bit using Test Slices, but the example below just uses
the entire Spring application context

In the below test

The test file can be seen below in which we verify that the HTTP response matches what we would like as well as ensuring
that the data we received is aligned to the data we expect by way of converting the expected data to the JSON response

```kotlin
package nabeelvalley.springkotlin.controller

import com.fasterxml.jackson.databind.ObjectMapper
import nabeelvalley.springkotlin.models.Project
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get

@SpringBootTest
@AutoConfigureMockMvc
class ProjectControllerTests @Autowired constructor(
    private val mockMvc: MockMvc,
    private val objectMapper: ObjectMapper
) {
    @Test
    fun `should return a json response`() {
        val expectedData = listOf(
            Project("project-1", "Project 1", "Description of the first project")
        )
        val expectedJson = objectMapper.writeValueAsString(expectedData)

        mockMvc.get("/api/project")
            .andDo {
                print()
            }
            .andExpect {
                status {
                    isOk()
                }
                content {
                    contentTypeCompatibleWith(MediaType.APPLICATION_JSON)
                    json(expectedJson)
                }
            }
    }
}
```

Additionally, we will use `MockMvc` and `@AutoConfigureMockMvc` to mock HTTP requests without all the HTTP request
overhead. Using `@Autowired constructor` with this uses the Spring boot constructor dependency injection for the
relevant members in the constructor

## Get One

Using the methodology above we can implement controllers for getting one project by doing the following:

1. Update the project entity to have an `id` field:

```kotlin
data class Project(
    // add this field
    val id: String,
);
```

2. Update the repository to contain a method for getting a project by ID:

```kotlin
interface IProjectRepository {

    // add this method
    fun getProject(id: String): Project?
}
```

3. Update the repository implementation to use th `id` field and to get one by `id`:

```kotlin
@Repository
class InMemoryProjectRepository : IProjectRepository {
    private val data = mutableListOf(
        // add id to project
        Project("project-1", "Project 1", "Description of the first project")
    )

    // we add this method
    override fun getProject(id: String): Project? =
        data.find {
            it.id == id
        }
}
```

> In the above snippet, it is important to note that we are returning a `Nullable` project, this is because we may not
> find a value with the given `id`

4. Update the service to allow getting a value by `id`:

```kotlin
@Service
class ProjectService(private val repository: IProjectRepository) {
    // add this method
    fun getOne(id: String) = repository.getProject(id);
}
```

5. Add a new endpoint on the controller that uses the `id` as a `PathParam` which also contains the ID in
   the `@GetMapping` definition. In the controller, we will return a `ResponseEntity` with a `NotFound` status for a
   result that is not found, or an `OK` status for a result that is found

```kotlin
@RestController
@RequestMapping("/api/project")
class ProjectController(private val service: ProjectService) {
    // add this method  
    @GetMapping("/{id}")
    fun getOne(@PathVariable(required = true) id: String): ResponseEntity<Project> =
        when (val result = service.getOne(id)) {
            null -> ResponseEntity.notFound().build()
            else -> ResponseEntity.ok(result)
        }
}
```

## Query Params

We can handle query params in our application by using the `RequestParam` annotation:

```kotlin
    @GetMapping
fun getAll(@RequestParam name: String?) = service.getAll(name)
```

> Note that in the above example `name` is of type `String?`, if we were to make this a required type of `String` then
> the application would return a bad request if the consumer does not provide a value for the query parameter

Furthermore we can update our other members of our implementation to use this search parameter as follows:

In the service:

```kotlin
@Service
class ProjectService(private val repository: IProjectRepository) {

    fun getAll(query: String?) = repository.searchProjects(query)
```

In the repository interface:

```kotlin

interface IProjectRepository {
    // add this method
    fun searchProjects(query: String?): Collection<Project>
```

And in the reposotry implemetation:

```kotlin
@Repository
class InMemoryProjectRepository : IProjectRepository {
    // add this method
    override fun searchProjects(query: String?) = data.filter {
        it.name.contains(query ?: "")
    }
```

> Note that the `searchProjects` method here requires an optional string which we default in the `contains` function,
> the reason we do not default the value in the function parameter list is that it is not allowed when overriding a
> method to define a default in the method param. However under other circumstances we can default a parameter by
> defining it like so: `fun doStuff(text: String? = "")`

## Exceptions

If for some reason we are unable to use pattern matching and more functional methods for handling excpetions, Spring
Boot allows us to define an `ExceptionHandler` for our controller, for example, if we were to have some codepath throw
an error like `NoSuchElement`

```kotlin
@RestController
@RequestMapping("/api/project")
class ProjectController(private val service: ProjectService) {
    // add this method  
    @ExceptionHandler(NoSuchElementException::class)
    fun handleException(e: Exception) = ResponseEntity.internalServerError().body("Error handling: ${e.message}")
}
```

Or if we were to handle a more general exception being thrown:

```kotlin
@RestController
@RequestMapping("/api/project")
class ProjectController(private val service: ProjectService) {
    // add this method  
    @ExceptionHandler(Exception::class)
    fun handleException(e: Exception) = ResponseEntity.internalServerError().body("Error getting projects")
}
```

## POST and PUT endpoints

We can define endpoints that use POST or PUT using the relevant mapping annotation. In order to receive data in the body
we would also use the `@RequestBody` annotation. Furthermore we can use the `@ResponseStatus` to annotate that status
that will be returned to the user when the response is sent:

```kotlin
@RestController
@RequestMapping("/api/project")
class ProjectController(private val service: ProjectService) {
    // add this method
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun createOne(@RequestBody project: Project) = service.createOne(project)
}
```

> Note that you would still need to implement any service or repository level tasks as needed

## Other HTTP Methods

As needed, we can also implement other HTTP methods like `PATCH` and `DELETE` similar to the `POST` and `GET` methods
above respectively
