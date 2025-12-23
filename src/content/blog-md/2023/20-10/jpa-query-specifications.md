---
published: true
title: JPA Queries without the Magic
subtitle: 20 October 2023
description: Defining custom queries for JPA using specifications
---

> If you're just looking for the solution you can just [skip ahead](#the-solutions)

The go-to way to build web applications with Java or Kotlin is using [Spring](https://spring.io/). Spring is a pretty decent web framework that provides a lot of utilities for handling common web application related tasks

However I find that Spring does a fair amount of compiler magic to make it work the way it does - of particular concern to this post is how Spring generates implementations for database queries using [Query kewords](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#appendix.query.method.subject) as part of your function names which spring will resolve to a query on the underlying database

Below is a short example of how we would use Spring to query our database to illustrate the problem:

## The Example

Let us consider an application in which we have some entity in our system that we would like to store in a database and be able to search over

In order to do this, we need to define a couple of things things:

1. An Entity which represents that data structure for our User

In Spring we can define entities, like a `User` as a class with some annotations

```java
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "User")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column(unique = true)
    private String email;
}
```

2. A Repository which is the class through which we will interact with the database for the specific entity

```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> { }
```

For the repository all we really need is to use the `@Repository` annotation which will register the repository with the Spring dependency injection, and we need to extend `JpaRepository` which provides some base methods for our repository such as `findAll`, `save`, or `delete` among others

Up until this point, we haven't seen anything too weird and the code thus far is fairly easy to reason about - however, this becomes interesting when we want to add a method like `findByEmail` which we define in the interface as follows:

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> { 
    List<User> findByEmail(String email);
}
```

That's it, we don't implement this anywhere - Spring will generate this implementation for us - weird - but okay. We can use this function anywhere we have a repsitory instance and it will behave as expected

## Growing Pains

But now, what if we want the `findByEmail` function to be case incensitive? Well seemingly we can just name this however so let's try:

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> { 
    List<User> findByEmailCaseInsensitive(String email);
}
```

You can try using that, but it won't work - turns out the magic is documented at least, and Spring tells us that we actually need to use `IgnoreCase` in the name - this makes use of the Query Keywords I mentioned above

So sure, we can change this:

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> { 
    List<User> findByEmailIgnoreCase(String email);
}
```

And also go and change everwhere we're using that method, since it's name now dictates its implementation we will need to keep in mind that if we ever want to change the implementation we will need to update all our clients

But wait - that's very UN-Java like isn't it? This seems to break the entire purpose of using functions - if my function's behaviour is directly dependant on it's name then how is this any different to just repeating the implementation everywhere need this? We're typing the same code either way

Now, I'm not all complaints - using a half competent IDE we should be able to do this refactor fairly painlessly and move on with our day - this isn't the main issue yet

Where we start running into problems is when our queries need to get more complex, for example when we decide that we want the search to extend to something like a secondary email filed, for example if we add a new field to our entity, like `companyEmail`:

```java
@Entity
@Table(name = "User")
public class User {
    // ... existing code

    // new field
    @Column()
    private String companyEmail;
}
```

## The Limit Does Exist

And we now need to update our email function to:

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> { 
    List<User> findByEmailIgnoreCaseOrCompanyEmailIgnoreCase(String email);
}
```

That's a bit rough right? There's really no reason our method name should be that long - oh, and it won't work either - even though this follows the JPA naming convention it's just a little too complicated for the code generator to get right 

Okay, so now we're stuck right? No - Why would I go on this rant if I don't have a solution in my head

Well, time to share it I guess

## The Solution(s)

### Query Annotations

Spring gives us two escape hatches for handling the problem we just ran into - we can use the `@Query` annotation which allows us to define a custom `JQL` query (Not SQL) that is defined inline and will do the appropriate value substitutions as needed:

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> { 
    @Query("SELECT u FROM User u WHERE LOWER(u.email) LIKE LOWER(:query) OR LOWER(u.comanyEmail) LIKE LOWER(:query)")
    List<User> findByEmail(String email);
}
```

Now, if this were the only option, I could live with it, it takes away some of the magic and gives me a decent amount of control over what I'm doing

... but ... how can i say ... It's ugly

Even if we assume that we don't somehow have any errors in the above string, it's just a little odd - like other ORMs have lovely fluent interfaces like `LINQ` in C# or `knex` or `prisma` in Javascript/TypeScript that understand SQL and fit naturally into our programming languge

### Specifications

Specifications provide us with a way to define our query within our programming language, and I think that's nice, so here's how they work

In order to use specificiations we need to do a few things:

1. Define the specification method

It doesn't matter too much where we define the specification, but for our example we'll put it in a static class so we can use it wherever:

```java
import org.springframework.data.jpa.domain.Specification;

public class UserSpecification {

    /**
     * Search for an User using a free text search on the email and name fields
     *
     * @param search text to be searched
     * @return a specification that can be used with the `repository.findAll()` on a `JpaSpecificationExecutor`
     */
    public static Specification<User> searchForUserByEmail(String search) {
        var likeSearch = search.toLowerCase();

        return (root, query, criteriaBuilder) -> {
            return criteriaBuilder.or(
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("email")), likeSearch),
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("companyEmail")), likeSearch)
            );
        };
    }
}
```

The structure of the specification is a little verbose but you could refactor this to be a bit more reusable if you wanted

2. Extend the `JpaSpeficationExecutor` on our repository

We can delete all the methods in the repository and add the `JpaSpecificationExecutor<User>` to the list of things we're extending

```java
// ... existing imports

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> { }
```

The above definition will provide us with two nice method on the repository, namely `findAll` and `findOne` which both take a `Speficication`

3. Use the speficication with our repository

Now that we have everything defined, we can use this in some part of our application as such:

```java
var spec = UserSpecification.searchForUserByEmail("bob@email.com");
var result = userRepository.findOne(spec);

// or for findAll
var results = userRepository.findAll(spec)
```

And that's it, In my opinion the `Specification` solution is a bit easier to manage within the context of the greater codebase without having to worry about too much compile time magic and possible typos in the `JQL` query

## Conclusion

I think either of the the provided solutions are fair and give us with a good way to manage more complex queries more flexibly in a way that isolates our implementation from where we intend to use the code

> Oh, and since you made it this far - I'm SO sorry you're writing Java and I wish your sanity all the best