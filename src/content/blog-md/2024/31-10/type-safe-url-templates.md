---
title: Type safe URL templates
description: Making URL template replacements safe
subtitle: 31 October 2024
---

> I do not support doing the below, but I keep seeing people do it so I thought it's at least a fun little excercise to make it safe

Something I see as a sort of recurring pattern is people doing template replacements in URLs, particularly something like this:

```ts
const template = '/users/{userId}/projects/{projectId}'
```

Now, while you can more simply make this template a function like so:

```ts
const template = (userId:string, projectId:string) => `/users/${userId}/projects/${projectId}`
```

For some reason people don't like to do that, I think it's that it looks like a lot of duplication and perhaps they just don't believe in making their own (who am I to know)

More often than I'd like, I instead see people doing this:

```ts
const template = '/users/{userId}/projects/{projectId}'

// later
const url = template.replace('{userId}', userId).replace('{projectId}', projectId)
```

I think this is horrible, and while it works, it's quite brittle and unless it's got some tests or other means of verifying that this works it's a really quick source of bugs for when things change, for example if you add or remove a parameter from the URL

Now, I'm a huge fan of using the compiler to derive as much correctness as possible, even before even really thinking about tests, so when looking at something like this all I can think is that the TypeScript compiler can solve this

I'm not saying that you should do what I'm about to present here, I think you're probably better off using the method of a template being a simple function above, but I think it's a fun little mental excercise

# The Typescriptssss

Firstly, we need to parse this URL template things, this is simple enough using a little recursive type:

```ts
/**
 * Extracts the keys from the URL
 */
type PathKeys<TUrl extends string> = 
    TUrl extends `${string}{${infer Param}}${infer Rest}` 
    ? Param | PathKeys<Rest> 
    : never
```

Next, since in a URL all keys need to be a string at the end, we can define an object for URLs that uses this to define a record:

```ts
/**
 * Uses the keys to define a record in which each key of the URL can be assigned to a string
 */
type PathParams<TUrl extends string> = Record<PathKeys<TUrl>, string>
```

A little test of the above types shows us:

```ts
type Keys = PathKeys<'/users/{userId}/projects/{projectId}'>
//   ^? type Keys = "userId" | "projectId"

type Params = PathParams<'/users/{userId}/projects/{projectId}'>
//   ^? type Params = { userId: string; projectId: string; }
```

So great, that works and we can use that as the basis for building up more general function for creating these "safe urls"

Before we go there though, let's take a moment to think about the result of this URL. Now we could return the URL as a `string` but since we're being strict it would be nice to inform downstream consumers of what this string is made up of. Using a very similar method to how the `PathKeys` type was done we can create a type for the result of a URL where the params have been replaced

```ts
/**
 * Represents a URL in which all params have been substituted
 */
type ReplacedUrl<TUrl extends string> = 
    TUrl extends `${infer Base}{${infer _}}${infer Rest}` 
    ? `${Base}${string}${ReplacedUrl<Rest>}` 
    : TUrl
```

Lastly, we can define the implementation of the URL replacer which is effectively just calling the `String.replace` method on an input URL while using a strong type for the URL:

```ts
const createTypedUrl = <const TUrl extends string>(url: TUrl) => (params: PathParams<TUrl>) => {
    return url.replace(/\{\w+\}/g, (val) => {
        const key = val.slice(1,-1)
        return  (params as Record<string, string>)[key] || val
    }) as ReplacedUrl<TUrl>
}
```

Using this looks like so:

```ts
const template = '/users/{userId}/projects/{projectId}' as const

/**
 * A little factory for making typed URLs from the given template
 */
const typedUrl = createTypedUrl(template)
//    ^? const typedUrl: (params: PathParams<"/users/{userId}/projects/{projectId}">) => string

const url = typedUrl({
    userId: '123',
    projectId: '456'
})
// ^? const url: `/users/${string}/projects/${string}`

console.log(url) // '/users/123/projects/456'
```

Now, is this better than random string replacements? Yes. Is it better than just using string interpolation? No.

While this isn't something I recommend using I think the idea about thinking of underlying structure of common data types is important and something that's worth thinking about in order to define more complete solutions 

Lastly, if you're into this type of thing, take a look at some of my other TS shenanigans:

- [Parameters, but only sometimes](/blog/2024/16-08/optional-parameters-and-overloads-in-typescript)
- [More generic than it should be](/blog/2024/15-08/handling-complex-typescript-generics)
- [Typescript Utilities](/blog/2022/13-12/typescript-utilities)
- [Generic Object Property Formatter and Validator using Typescript](/blog/2023/09-05/generic-transformer-typescript)