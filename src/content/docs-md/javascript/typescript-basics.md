---
published: true
title: Typescript Basics
subtitle: Introduction and cheatsheet for basic Typescript concepts
---

## Types

A `type` is the most basic thing in typescript and is an object structure

```ts
type Person = {
  name: string
  location: {
    streetName: string
    streetNumber: number
  }
}
```

We can also create option types which specify what the allowed values are for a type

```ts
type PersonType = 'work' | 'social' | 'other'
const personType: PersonType = 'work' // can't be any value other than what's allowed above
```

Below is an option type

```ts
type ID = string | number
```

Here's a type that uses the option type

```ts
type OfficialData = {
  idNumber: ID
}
```

### Types can be composed

#### Merging types

```ts
type FullOfficalPerson = Person & OfficialData
```

#### Optional types

```ts
type MinOfficialPerson = Person | OfficialData | ID
```

## Interfaces

Next, we have interfaces, it's like a type, but can't be composed like the above types

> Note that an interface doesn't use `=` like a `type`

```ts
interface BasePerson {
  name: string
  location: {
    streetName: string
    streetNumber: number
  }
}
```

### Interfaces can be extended

Interface extension is similar to type merging, but with a bit of a different syntax

```ts
interface AppUser extends BasePerson {
  websiteUrl: string
  twitterHandle?: string
  instagramHandle?: string
}
```

## Type helpers

Typescript provides us with some base types that we can use to achieve interesting compositions

### Arrays

Array types, can use `Array` or `[]` (both are the same)

```ts
type MyArray1 = Array<ID>
type MyArray2 = ID[]
```

> MyArray1 and MyArray2 are the same

### Partial

`Partial` makes all top-level properties of a type optional

```ts
type PartialAppUser = Partial<AppUser>
```

The equivalent of the above with interfaces, where we extend a partial type to add an `id` property

```ts
interface CreateAppUser extends Partial<AppUser> {
  id: ID
}
```

### Required

We can also have the `Required` type, where all top-level props are required

```ts
type FullAppUser = Required<AppUser>
```

### Records

Another useful one is the `Record` type. which lets us specify an object's key and value type. Usually one or both of these are an option type

```ts
type Contacts = Record<PersonType, ID>

const myContacts: Contacts = {
  work: 1234,
  social: 'hello',
  other: 0,
}
```

We can also have both values be option types

```ts
const associations: Record<PersonType, PersonType> = {
  work: 'other',
  social: 'work',
  other: 'other',
}
```

### Generics

In the above examples, the helper types are using generics. Below is a generic that allows us to specify a user with type of an `id`

```ts
type AUser<T> = {
  id: T
}
```

And similarly, an interface based implementation

```ts
interface BUser<T> {
  id: T
}
```

Although we can use `T` for the generic, (or any other letter), we usually give it something more meaningful. e.g. Key/Value pairs, use `K` and `V, or a type of Data may be `TData`

```ts
const bUser: BUser<number> = {
  // below, id must be a number
  id: 1234,
}
```

We can also use generics with multiple parameters like so:

```ts
interface Thing<TID, TData> {
  id: TID
  data: TData
}
```

### Values

Values are (an object or function which matches the type). We can use the above defs in order to define a value

```ts
const person: Person = {
  name: 'Bob',
  location: {
    streetName: 'My Street',
    streetNumber: 24,
  },
}
```

Also note that you cannot log or use a type as data, e.g. the following will be an error

```ts
console.log(Person)
```

This is because types don't exist at runtime. they're just a developer tool

### Functions

Types can also be used to defined functions (interfaces can't do this)

```ts
type GetPerson = (id: ID) => Person
type GetPersonAsync = (id: ID) => Promise<Person>
```

We can also use generics for function definitions like so

```ts
type GetThing<TID, TThing> = (id: TID) => TThing
```

In the below function, we say that the entire function is of type `GetPerson`

```ts
const getPerson: GetPerson = (id) => person
```

In the below function, `ID` is the type of the params, `Promise<Person>` is the return type

```ts
const getPersonAsync = async (id: ID): Promise<Person> => {
  return person
}
```

### Classes

In general, we can also implement class properties like so

```ts
class MyRespository {
  // below is a class member
  private data: Person[]

  // below is a constructir
  constructor(data: Person[]) {
    this.data = data
  }
}
```

However, it's often desirable to create an interface that a class should amtch, for example

```ts
interface IDRepository {
  get(id: ID): Promise<ID>
}
```

`TID` below has a defualt value of `ID`

```ts
interface Repository<TData, TID = ID> {
  ids: Array<TID>
  get(id: TID): Promise<TData>
}
```

A class can use that interface like so

```ts
class PersonRepository implements Repository<Person, ID> {
  ids = [1, 2, 3]

  async get(id) {
    return {
      name: 'Bob',
      location: {
        streetName: 'My Street',
        streetNumber: 24,
      },
    }
  }

  // we can use access modifiders on members
  public getIds = () => this.ids
}
```

### Examples

Below is a link to the runnable Repl.it that has the above code defined

[Repl.it link](https://replit.com/@nabeelvalley/TypesScript-Playground?v=1)

<iframe frameborder="0" width="100%" height="500px" src="https://replit.com/@nabeelvalley/TypesScript-Playground?embed=true"></iframe>

### Other Relevant Docs

- [Template Literal Types](/blog/2021/16-08/typescript-template-literal-types)
- [Type Narrowing](/blog/2022/31-05/type-guard)
- [Type Guards and Unions](/blog/2023/26-06/type-guards-and-unions-typescript)
