---
published: true
title: Template Literal Types with Typescript
subtitle: 16 August 2021
description: Defining type combinations using Template Literal types
---

---
published: true
title: Template Literal Types with Typescript
subtitle: 16 August 2021
description: Defining type combinations using Template Literal types
---

Template literal types provide us a way to combine `string types` or `enums` in Typescript.

In the below example, we can make use of a `string type` called `Action` and an `enum` called `Resource` to define a type which is a combination of an action combined with a resource

```ts
type Action = 'UPDATE' | 'CREATE' | 'DELETE'

enum Resource {
  Person = 'Person',
  Product = 'Product',
  Sale = 'Sale',
}

// the `Lowercase` type concerts all string type options to lowercase
type ResourceAction = `${Resource}.${Action}`
```

Such that the `ResourceAction` type is now defined as:

```ts
type ResourceAction =
  | 'Person.UPDATE'
  | 'Person.CREATE'
  | 'Person.DELETE'
  | 'Product.UPDATE'
  | 'Product.CREATE'
  | 'Product.DELETE'
  | 'Sale.UPDATE'
  | 'Sale.CREATE'
  | 'Sale.DELETE'
```

Now, if you're like me - you probably want your types to be consistent in some way. For this purpose, we can use the `Lowercase` type as follows:

```ts
type ResourceActionLowercase = Lowercase<`${Resource}.${Action}`>
```

Which results in the following types:

```ts
type ResourceActionLowercase =
  | 'person.update'
  | 'person.create'
  | 'person.delete'
  | 'product.update'
  | 'product.create'
  | 'product.delete'
  | 'sale.update'
  | 'sale.create'
  | 'sale.delete'
```
