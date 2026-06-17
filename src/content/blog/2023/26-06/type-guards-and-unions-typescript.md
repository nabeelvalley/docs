---
published: true
title: Using Type Guards and Unions to prevent bugs and increase maintainability
subtitle: 26 June 2023
description: A practical introduction to type guards and union types
---

When working with a dynamic language, like Javascript, a problem that we can often run into is one where a variable may be of multiple possible types in a given place in our code. Due to this, we often run into a need to check the type of an object

## The Scene

For the sake of introducing the need for type guards, we're going to consider an imaginary news site in which users can read articles posted to the site. For our site, we want to enable users to add comments and interact with articles. For this purpose, we require that each user is logged in and exists in our database

The object we use for representing a user who just reads our site is as follows:

```ts
const reader = {
  username: 'john',
  email: 'john@email.com',
}
```

After some time, we decide to make it such that certain users can create articles on the website. To do this, we add a value on the user that states that the user is a writer:

```ts
const writer = {
  username: 'smith',
  email: 'smith@email.com',
  isWriter: true,
}
```

This is great, our data now reflects that we have a user type that can post articles to the website.

The site is growing well and the content available is flourishing, by we seem to be getting a frequent complaints from users that some articles are not appropriate for the site or may be incorrect or misleading

So, to mitigate this issue, we decide that for our website we want to add a new type of permission that defines users that are responsible for moderating content. However, to prevent a conflict of interest - moderators are not allowed to write articles for the site

So we choose to add a field for that indicates a user is a moderator:

```ts
const moderator = {
  username: 'bob',
  email: 'bob@email.com',
  isWriter: false,
  isModerator: true,
}
```

Based on this, we update the application types to account for the new field, and we have the following:

```ts
interface User {
  username: string
  email: string
  isWriter: boolean
  isModerator: boolean
}
```

We update the application to handle the above solution. We even add a few helper methods in our code that allow us to determine if a user is a writer or moderator

```ts
const isWriter = (user: User): boolean => user.isWriter

const isModerator = (user: User): boolean => user.isModerator
```

Fantastic! We're happy with our implementation and we release the code into production

Everything is going great, our moderators are keeping the content quality up and our writers are writing great content

## The Bug

After a few weeks though, readers start to notice a problem - some articles that are taken down by moderators seem to be reappearing - it looks as if some malicious moderator is re-enabling bad articles

Upon some further investigation, the team notices that all these articles are ones in which the moderator is the writer of the article - but this shouldn't have happened right? We said that each moderator should not be able to also function as a writer

Eventually, we track down the bug that made this possible, it was in the function called `convertUserToModerator`:

```ts
const convertUserToModerator = (user: User): User => {
  user.isModerator = true

  return user
}
```

The issue was caused by us not setting the `isWriter` field to `false` in the above function, cool - so we just fix that:

```ts
const convertUserToModerator = (user: User): User => {
  user.isModerator = true
  user.isWriter = false

  return user
}
```

Great - we deploy the fix and migrate to ensure that `isWriter` is set to `false` for all existing moderators. The issue seems to be fixed, but after a while users start reporting that the problem is happening again

The cause seems to be the same - it looks like users are somehow still having `isWriter` and `isModerator` simultaneously set to `true` and ending up with a permission that shouldn't be possible in our system

## Impossible States

So we decide to investigate the problem and determine that the reason we are running into this bug seems to be due to some fundamental way that the data has been defined

Since each user can have `true` or `false` for any combination of `isWriter` and `isModerator` we end up representing something unintended which can be seen in the table of possible combinations below:

| User Type               | `isWriter === true` | `isWriter === false` |
| ----------------------- | ------------------- | -------------------- |
| `isModerator === true`  | Unknown             | Moderator            |
| `isModerator === false` | Writer              | Reader               |

From the above, we can see that we have a state that is not handled in the current code - this "Unknown" state. In this state, the `isModerator` and `isWriter` functions return `true`

We want this state to be impossible in our code. This is not a state that our application should ever have to consider. From a type-design perspective, it's not enough to handle these impossible states, we need to prevent them from existing in the first place

## The Solution

The problem above stems from the fact that we're using two different states to represent something that should be a single state. From the above diagram, we can resolve the following valid types of users in our system

- Reader - reads and adds comments to articles
- Writer - writes articles
- Moderator - moderates articles, does not write articles

Using these user types, we can update the `User` definition from above:

```ts
interface User {
  type: 'reader' | 'writer' | 'moderator'

  username: string
  email: string
}
```

The `type` field allows us to determine the type of a user. We can then use this value to check the type of a user and use this to inform how we use the object down the line

## Extending the Moderator

Our solution is running well and we have managed to fully eliminate the bug.

But now, the moderators are a little bored with their duties and would like some way that they can compete with each other on the quality of their content moderation - so they decide to create a leaderboard in which they look at how many articles they have read and approved or denied - as interest goes however, the moderators reach out to the development team and ask if it would be possible to add the number of approvals and denials so that the moderators don't need to calculate this manually every month for their leaderboard

The development team has the idea to add these scores into the `User` definition type:

```ts
interface User {
  type: 'reader' | 'writer' | 'moderator'

  username: string
  email: string

  approvedArticles: number
  deniedArticles: number
}
```

During a PR review session, the team decides that this is a bit weird since it implies that any user can have some approved or denied articles - this doesn't make sense, so someone suggests to use a **Discriminated Union** in which only users of the `moderator` type can have these properties - the developer also says that this will make it easier later to add additional fields to any role without having to worry about the implication of this on other roles

The team decides that they want to have a `Base` user which has some shared properties and a union which adds additional fields

The `BaseUser` user has a generic parameter called `Type` which is the `type` for the user, since we want to ensure that each possible user type has this:

```ts
interface BaseUser<Type extends string> {
  type: Type

  username: string
  email: string
}
```

Each specialized user type can inherit from `BaseUser` with a specific type applied, for the `writer` and `reader` types, these can just be aliases to the base interface

```ts
type ReaderUser = BaseUser<'reader'>
type WriterUser = BaseUser<'writer'>
```

The `moderator` however, will need to extend this to add the additional properties:

```ts
interface ModeratorUser extends BaseUser<'moderator'> {
  approvedArticles: number
  deniedArticles: number
}
```

Lastly, the three types above can be used to define a single type called `User` which has the same functionality as the `User` interface we've been using until now:

```ts
type User = ReaderUser | WriterUser | ModeratorUser
```

The code above is the Typescript syntax for defining a **Union** which is a type that can be one of multiple types. Each type in the Union is separated by the `|`. The union we have above is a special type of union called a **Discriminated Union** which is a special type of Union that has a field called a **discriminator** which uniquely identifies each element of the union - in our case this is the `type` field of `BaseUser` which used the generic `Type` parameter

In our backend code, we can now use the `type` property of our user to conditionally fetch the data needed to populate the moderator object

## Checks, Checks

As the codebase grows, the team writes some functions to check the type of the user so that specific computations can be done, for example checking the total number of articles a moderator has been reviewed. An example of one of these checks can be seen below:

```ts
const isModerator = (user: User): boolean => user.type === 'moderator'
```

The above check is used in quite a few places, like when counting the total number of articles reviewed:

```ts
const getTotalArticlesReviewed = (user: User): number | undefined => {
  if (isModerator(user)) {
    const moderatorUser = user as ModeratorUser

    return moderatorUser.approvedArticles + moderatorUser.deniedArticles
  }

  return undefined
}
```

Similar casting patterns as above seem to be cropping up in a lot of places, another example is when listing the moderators that a user follows:

```ts
const moderatorUsers = users.filter(isModerator) as ModeratorUser[]
```

## Type Guards

The above solutions use **Type Assertions** which allow a user to override the Typescript Compiler's type system to manually state the type of an object - this is dangerous because it essentially means that we give up type checking at that point in the code

The type assertions around user types are leading to lots of bugs, the team has a discussion about how this problem can be solved and someone suggests using a **Type Guard**. Type Guards are functions that can be used to check if a given variable meets a specific criterion under which it can be considered a narrower type that the input type. The difference between a Type Guard in this context and a regular function is that a Type Guard returns type information that can be used to inform the Typescript compiler about the state of a variable

The proposed example is to convert the `isModerator` function into an **Assertion Function** by converting the return type from `boolean` to `user is ModeratorUser` - this assertion tells the compiler that within the scope that the check is `true`, the value is of the stated type and not the original type

For example, `isModerator` can be updated as such:

```ts
const isModerator = (user: User): user is ModeratorUser =>
  user.type === 'moderator'
```

This means that when using the code above, we no longer need to cast since Typescript can infer the variable appropriately

```ts
const getTotalArticlesReviewed = (user: User): number | undefined => {
  if (isModerator(user)) {
    // within the scope of this condition the `user` type is known to be `ModeratorUser`
    return user.approvedArticles + user.deniedArticles
  }

  return undefined
}

// the `.filter` function accepts the type guard and can now infer that moderatorUsers is `ModeratorUser[]`
const moderatorUsers = users.filter(isModerator)
```

## Conclusion

Discriminated Unions and type Guards are a powerful methods that can be used for working with complex object types and encoding application rules into your type system to minimize bugs and make code easier to extend

## Further Reading

On this site the following posts contain content relative to this one:

- [Type Narrowing](/blog/2022/31-05/type-narrowing)
- [Typescript Basics](/docs/javascript/typescript-basics)

The Typescript documentation also mentions the above topics in a few different places:

- [Assertion Functions](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-7.html#assertion-functions)
- [Discriminated Unions](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions)
- [Unions and Intersection Types](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#discriminating-unions)

And the following series from [F# for Fun and Profit](https://fsharpforfunandprofit.com/) is something I often find myself coming back to on the topic of type design:

- [Designing with types: Introduction](https://fsharpforfunandprofit.com/posts/designing-with-types-intro/)
- [Designing with types: Making illegal states unrepresentable](https://fsharpforfunandprofit.com/posts/designing-with-types-making-illegal-states-unrepresentable/)
