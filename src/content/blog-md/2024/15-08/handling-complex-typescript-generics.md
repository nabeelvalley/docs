---
title: More generic than it should be
published: true
description: A method for designing highly generic APIs in Typescript
subtitle: 15 August 2024
---

A method for designing highly generic APIs in Typescript

# The Pattern

A recurring point I've seen when designing highly generic API's in Typescript is around giving consumers of an API an interface that requires the least amount of extra information from them. For example, take the function below:

```ts
interface Data {
  name: string;
  age: number;
}

declare const data: Data;

function getProperty<D, K extends keyof D>(key: K) {
  return function getProp(data: D): D[K] {
    return data[key];
  };
}
```

In the above example, we define a function called `getProperty` that gets the `key` property of `data`, we would use this like so:

```ts
const getName = getProperty<Data, "name">("name");
```

The problem here is that the user of this function has to provide both generics when using the function since the object with type `D` is only provided to the function that is returned. The experience of a consumer here is a little cumbersome and would be nicer if we didn't have to do this.

# Some Other Ideas

We can also try the following where we just provide the `name`, but this won't work:

```ts
const getName = getProperty("name"); // Error: Argument of type 'string' is not assignable to parameter of type `never`
```

This is because the function doesn't know what type it's dealing with. The obvious next thing we can try is just provide a single type argument, but this doesn't work either since typescript needs us to provide both generics since we're not defaulting the second one

```ts
const getName = getProperty<Data>("name"); // Error: Expected 2 type arguments, but got 1
```

> We _could_ default the type of `K` which would take away our error but would also completely remove the benefit of it being a generic parameter in this case which is to narrow down the type the function returns

Now, a general strategy here is to instead swap around our type arguments, what if we defined `getProperty` instead by defining `D` in terms of `K`, something like:

```ts
function getProperty<K extends string>(key: K) {
  return function getProp<D extends Record<K, any>>(data: D): D[K] {
    return data[key];
  };
}
```

Now, this works and may be okay for your usecase, but often we want to constrain the `getProperty` function with the type of data known in advance. Also it can be more complicated than just a record with the key of the input type and this isn't always something we can extend more generally

This also has the issue that when using the `getProperty` function we end up with a function that lets anything through that maybe has a `name` property which may not be what we want

```ts
const getName = getProperty("name"); // getter is not constrained by the type of `D`
```

# A Weird Solution

What can be a better solution is to split our function into a part that provides a generic and a part that provides data:

```ts
function createGetter<D>() {
  return function getProperty<K extends keyof D>(key: K) {
    return function (data: D): D[K] {
      return data[key];
    };
  };
}
```

This can now be used in a way where we don't specify any more generics than we need and has the weirdness of us invoking a function twice for no reason other than providing a generic

```ts
const getName = createGetter<Data>()("name");
```

You can also make this a bit easier on the eyes by creating an intermediate variable:

```ts
const dataGetter = createGetter<Data>();
const getName = dataGetter("name");
```

This isn't too bad, and I'd be okay to leave it here, but after speaking to some other developers I end up having a lot of questions around how the mechanics of the generic type need to work as well as the fact that we have multiple levels of functions returning functions that creates confusion when trying to use this code

# A Classier Way

Weirdly, thinking of this as a class seemed to help. Instead of using a function to preload a generic, we can use a class:

```ts
class Getter<D> {
  property<K extends keyof D>(key: K) {
    return function (data: D): D[K] {
      return data[key];
    };
  }
}
```

I think this code reads a bit nicer and it's clear where the different generics come from. Ultimately it's doing the exact same thing but we're hiding the complexity of initializing the generic behind some syntax

Using this is quite nice now as well:

```ts
const dataGetter = new Getter<Data>();
const getName = dataGetter.property("name");
```

What's also different with using the class approach is that things have names now, we know that we are calling the `.property` method which is giving us something to work with. Something about using classes gives people a bit more familiarity when working with generic things and creates a good relationship between the mechanics of the method and the mental model most developers have of class based development

## Gross

I'm more and more moving towards the idea that this kind of generic stuff should be kept to a minimum. This is a relatively simple example but these concepts can get pretty complex and perhaps speaks to something more fundementally incorrect about the data structures being worked with. If you can control the data structures, then ideally simplify them so you don't need this level of type magic, but if you do - it's always handy to have a way to express things that makes it easier for other developers to understand and work with

