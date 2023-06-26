---
published: false 
title: Type Guards and Unions stop the bugs from getting through
subtitle: 26 June 2023
description: A practical introduction to type guards and union types
---

When working with a dynamic language, like Javascript, a problem that we can often run into is one where a variable may be of multiple possible types in a given place in our code. Due to this, we often run into a need to check the type of an object

# The Scene

For the sake of introcuding the need for type guards we're going to consider an imaginary news site in which users can read articles posted to the site. For our site we want to enable users to add comments and interact with articles. For this purpose, we require that each user is logged in and exists in our database

The object we use for representing a user who just reads our site as follows:

```ts
const reader = {
  "username": "john",
  "email": "john@email.com"
}
```

After some time, we decide to make it such that certain users are able to create articles on the website. To do this, we add a value on the user that states that the user is a writer:

```ts
const writer = {
  "username": "smith",
  "email": "smith@email.com",
  "isWriter": true,
}
```

This is great, our data now reflectst that we have a user type that is able to post articles to the website.

The site is growing well and the content available is flourishing, by we seem to be getting a frequent complaint from users that some articles are not appropriate for the site or may be incorrect or misleading

So, in order to mitigate this issue, we decide that for our website we want to add a new type of permission that defines users that are responsible for moderating content. However, in order to prevent a conflict of interest - moderators are not allowed to write articles for the site

So we choose to add a field fod that indicates a user is a moderator:

```ts
const moderator = {
  "username": "bob",
  "email": "bob@email.com",
  "isWriter": false,
  "isModerator": true
}
```

Based on this, we update the application types to account for the new field, and we have the following:

```ts
type User = {
  username: string
  email: string
  isWriter: boolean
  isModerator: boolean
}
```

We update the application to handle the above solution. We even add a few helper methods in our code that allows us to determine if a user is a writer or moderator

```ts
const isWriter = (user: User): boolean => user.isWriter

const isModerator = (user: User): boolean => user.isModerator
```

Fantastic! We're happy with our implementation and we release the code into production

Everthing is going great, our moderators are keeping the content quality up and our writers are writing great content

# The Downfall

After a few weeks though, readers start to notice a problem - some articles that are taken down by moderators seem to be reappearing - it looks as if some malicious moderator is re-enabling bad articles

Upon some further investigation, the team notices that all these articles are ones in which the moderator is is the writer of the article - but this shouldn't have happened right? We said that each moderator should not be able to also function as a writer

Eventually we track down the bug that made this possible, it was in the function called `convertUserToModerator`:


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

  return true
}
```

Great - we deploy the fix and do a migration to ensure that `isWriter` is set to `false` for all existing moderators. The issue seems to be fixed, but aftrer a while users start reporting that the problem is happening again

The cause seems to be the same - it looks like users are somehow still having `isWriter` and `isModerator` simultaneously set to `true` and ending up with a permission that shouldn't be possible in our system

# Impossible States

So we decide to investigate the problem and determine that the reason we are running into this bug seems to due to some fundemental way that the data has been defined

Since each user can have `true` or `false` for any combination of `isWriter` and `isModerator` we and up representing something unintented which can be seen in the table of possible combinations below:

| User Type               | `isWriter === true` | `isWriter === false` |
| ----------------------- | ------------------- | -------------------- |
| `isModerator === true`  | Unknown             | Moderator            |
| `isModerator === false` | Writer              | Reader               |


From the above, we can see that we have a state that is not handled in the current code - this "Unknown" state. In this state, the `isModerator` and `isWriter` functions return `true`

We want this state to be impossible in our code. This is not a state that our application should ever have to consider. From a type-design perspective, it's not enough to handle these impossible states, we need to prevent them from existing in the first place

# The Solution

The problem above stems from the fact that we're using two different states to represent something that should be a single state. From the above diagram we can resolve the following valid types of users in our system

- Reader - reads and adds comments to articles
- Writer - writes articles
- Moderator - moderates articles, does not write articles

Using these user types, we can update the `User` definition from above:

```ts
type User = {
  type: "reader" | "writer" | "moderator"

  username: string
  email: string
}
```

The `type` field allows us to determine the type of a user. We can then use this value to check the type of a user and use this to inform how we use the object down the line

# Adding Complexity

Our solution is running well and we have managed to fully eliminate the bug. 

But now, the moderators are a little bored with their duties and would like some way that they can compete with each other on the quality of their content moderation - so they decide to create a leaderboard in which they look at how many articles they have read and approved or denied - as interest goes however, the moderators reach out to the development team and ask if it would be possible to add the number of approvals and denials so that the moderators don't need to calculate this manually every month for their leaderboard

The development team has the idea to add these scores into the `User` definition type:

```ts
type User = {
  type: "reader" | "writer" | "moderator"

  username: string
  email: string

  approvedArticles: number
  deniedArticles: number
}
```

During a PR review session, the team decides that this is a bit weird since it implies that any user can have a number of approved or denied articles - this doesn't really make sense, so someone makes the suggestion to use a "Discriminated Union" in which only users of the `moderator` type can have these properties - the developer also says that this will make it easier later to add additional fields to any role without having to worry about the implication of this on other roles



```ts
const bobs = ["bob", "Bob", "BOB", "boB"] as const;

type Bob = typeof bobs[number];

const isBobKindOf = (thing: string): boolean => bobs.includes(thing as Bob);

const isBob = (thing: string): thing is Bob => bobs.includes(thing as Bob);

const people = ["bob", "smith", "boB", "smITH"];

const bobPeople = people.filter(isBobKindOf);
const bobPeople2 = people.filter(isBob);

const isKindOfFirstBob = people.find(isBobKindOf);
const firstBob = people.find(isBob);


const first = people[0];

if (isBob(first)) {
  console.log(first)
} else {
  console.log(first, 'not bob')
}
```

# Further Reading

- [Designing with Types - Making illegal states unrepresentable](https://fsharpforfunandprofit.com/posts/designing-with-types-making-illegal-states-unrepresentable/)
- [Typescript Handbook - Unions and Intersections](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#discriminating-unions)