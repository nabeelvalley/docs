---
published: false 
title: Type Guards and Unions stop the bugs from getting through
subtitle: 26 June 2023
description: A practical introduction to type guards and union types
---

When working with a dynamic language, like Javascript, a problem that we can often run into is one where a variable may be of multiple possible types in a given place in our code. Due to this, we often run into a need to check the type of an object

# The Scene

For the sake of introcuding the need for type guards we're going to consider an imaginary news site in which users can read articles posted to the site. For our site we want to enable users to add comments and interact with articles. For this purpose, we require that each user is logged in and exists in our database

The object we use for representing a user is as follows:

```ts
const user = {
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

# Bad States

So we decide to investigate the problem and determine that the reason we are running into this bug seems to due to some fundemental way that the data has been defined

Since each user can have `true` or `false` for any combination of `isWriter` and `isModerator` we and up representing something unintented which can be seen in the table of possible combinations below:

| User Type               | `isWriter === true` | `isModerator === false` |
| ----------------------- | ------------------- | ----------------------- |
| `isModerator === true`  |                     |                         |
| `isModerator === false` |                     |                         |


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

