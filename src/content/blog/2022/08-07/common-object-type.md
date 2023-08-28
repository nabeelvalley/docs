---
published: true
title: A type for getting properties common in all objects from a union
subtitle: 08 June 2022
description: Using typescript type conditions and Exclude to get keys commmon in parts of a union and an object with only common keys from that union
---

---
published: true
title: A type for getting properties common in all objects from a union
subtitle: 08 June 2022
description: Using typescript type conditions and Exclude to get keys commmon in parts of a union and an object with only common keys from that union
---

# Overview

Something that may come up in practice is a use for a type that allows us to enforce that an object has only the common properties for a given object

For example, given the two objects below:

```ts
type AThing = {
  name: string
  age: number
  email: string
  phone: number
}

type BThing = {
  businessName: string[]
  email: string
  phone: string
}
```

I would like a type that contains only the things that these objects have in common, namely `phone` and `email`

# A Type for Common Object Keys

This isn't something that typescript has out-of-the-box, however it can be implemented by using some type juggling

First, we define a type called `CommonKeys` which gets us all the keys which are common in the two objects

```ts
type CommonKeys<T, R = {}> = R extends T
  ? keyof T & CommonKeys<Exclude<T, R>>
  : keyof T
```

The `CommonKeys` type makes use of a condition to check if `R` which is the recursive type extends `T` which is the input type. Based on this, we cut down `T` one type at a time until there is no more object that can extend `R`, then for an input type `T` which is the same as `R` (an empty object) the result of `CommonKeys<{}>` will be `never` since `{}` has no keys, and will end the recursion

Applying this to the above types, we get:

```ts
type ABCommonKeys = CommonKeys<AThing | BThing>
// type ABCommonKeys = "email" | "phone"
```

And as a sanity check, we can also apply this to `{}`:

```ts
type Basic = CommonKeys<{}>
// type Basic = never
```

# A Type for Common Object

Next, we can use the `CommonKeys` type defined above to create a `Common` type which wne used with the intersection will result in a type that has all the keys common in all types from the intersection

```ts
type Common<T> = Pick<T, CommonKeys<T>>
```

We can apply this now to a type of `AThing | BThing` like so:

```ts
type ABCommonObject = Common<AThing | BThing>
// type ABCommonObject = {
//   email: string;
//   phone: string | number;
// }
```

And we can see that we have the desired result which is an object with the properties that are common between both input object types

# Final Solution

We can put the code from above together into the final solution which is just the two above types:

```ts
/** Gets the keys common to any type/union of `T` */
type CommonKeys<T, R = {}> = R extends T
  ? keyof T & CommonKeys<Exclude<T, R>>
  : keyof T

/** Gets an object type containing all keys that exist within a type/union `T` */
type Common<T> = Pick<T, CommonKeys<T>>
```
