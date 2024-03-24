---
published: true
title: Typescript Utilities
subtitle: 12 December 2022
description: Some general purpose typescript utilities
---

Here's a collection of some typescript utility functions I've put together

# Functions

```ts
/**
 * A function with defined input and output
 */
export type Fn<TParams, TResult> = (params: TParams) => TResult

/**
 * A function that returns a result or undefined
 */
export type OptionFn<TParams, TResult> = Fn<TParams, TResult | undefined>

/**
 * A function that returns void
 */
export type VoidFn<TParams> = (params: TParams) => void

/**
 * Convert a function type into an async version of that function
 */
export type Async<TFn extends (...args: any[]) => any> = (
  ...args: Parameters<TFn>
) => Promise<ReturnType<TFn>>

/**
 * Create an async version of `Fn`
 */
export type AsyncFn<TParams, TResult> = Async<Fn<TParams, TResult>>

/**
 * Create an async version of `OptionFn`
 */
export type AsyncOptionFn<TParams, TResult> = Async<OptionFn<TParams, TResult>>

/**
 * Create an async version of `VoidFn`
 */
export type AsyncVoidFn<TParams> = Async<VoidFn<TParams>>

/**
 * Create a version of a function that may either be sync or async
 */
export type SyncOrAsync<TFn extends (...args: any[]) => any> = (
  ...args: Parameters<TFn>
) => ReturnType<TFn> | Promise<ReturnType<TFn>>

/**
 * Create a version of `Fn` that may either be sync or async
 */
export type SyncOrAsyncFn<TParams, TResult> = SyncOrAsync<Fn<TParams, TResult>>

/**
 * Create a version of `OptionFn` that may either be sync or async
 */
export type SyncOrAsyncOptionFn<TParams, TResult> = SyncOrAsync<
  OptionFn<TParams, TResult>
>

/**
 * Create a version of `VoidFn` that may either be sync or async
 */
export type SyncOrAsyncVoidFn<TParams> = SyncOrAsync<VoidFn<TParams>>
```

# Arrays

```ts
/**
 * Array filter type, used to filter an array via the `.filter` method
 */
export type ArrayFilter<T> = (value: T, index: number, array: T[]) => boolean

/**
 * Array map type, used to map an array via the `.map` method
 */
export type ArrayMap<T, U> = (value: T, index: number, array: T[]) => U

/**
 * Array reduce type, used to reduce an array via the `.reduce` method
 */
export type ArrayReducer<T, U> = (
  previousValue: U,
  currentValue: T,
  currentIndex: number,
  array: T[]
) => U

/**
 * Defines a step type that may contain different data types as an array such
 * that each step adds or removes from the current input but should always
 * result in the same final object that can be validated by just verifying the
 * final length assuming all steps have been validated prior
 */
export type StepsOf<Final extends Readonly<any[]>> = Final extends [
  ...infer Next,
  infer _,
]
  ? StepsOf<Next> | Final
  : [];
```

# Objects

```ts
/**
 * Definition for a type guard that checks if a value is of a specific type
 */
export type Guard<TResult, TOther = unknown> = (
  value: TResult | TOther
) => value is TResult

/**
 * Create a type where the provided keys are optional
 *
 * @param T the base type
 * @param O the keys to make optional
 */
export type WithOptional<T extends {}, O extends keyof T> = Omit<T, O> &
  Partial<Pick<T, O>>

/**
 * Create a type where the provided keys are required
 *
 * @param T the base type
 * @param R the keys to make required
 */
export type WithRequired<T extends {}, R extends keyof T> = T &
  Required<Pick<T, R>>

/**
 * Create a type where all all properties and sub-properties are recursively partial unless they are
 * of the type specified in TKeep
 *
 * @param T the base type
 * @param TKeep types to not make partial
 */
export type DeepPartial<T, TKeep = never> = T extends TKeep
  ? T
  : T extends object
  ? {
      [P in keyof T]?: DeepPartial<T[P], TKeep>
    }
  : T

/**
 * Returns a specific subset of `keyof T`
 *
 * The resulting types can be used with utilities like `Omit` or `Pick` in a reusable manner
 *
 * @param T the base type
 * @param K keys of T
 */
export type Keys<T, K extends keyof T> = K

export type Primitive = string | number | boolean | Symbol | Date

/**
 * Create a type where all direct properties are optional if they're Primitive otherwise it will be
 * a partial of the property
 *
 * @param T the base type
 * @param TKeep the types to not partialize
 */
export type FlatPartial<T, TKeep = Primitive> = {
  [K in keyof T]: T[K] extends TKeep ? T[K] | undefined : Partial<T[K]>
}

/**
 * Gets all keys of an object where the property at that key in the object extends a condition
 *
 * @param Cond the condition that properties need to  extend
 * @param T the object with the keys of interest
 */
type ConditionalKeys<Cond, T> = {
  [K in keyof T]: T[K] extends Cond ? K : never;
}[keyof T];

/**
 * Get the primitive keys of a given object
 */
type PrimitiveKeys<T> = ConditionalKeys<Primitive, T>;

/**
 * Pick the keys of an object where the property value is a primitive
 */
type PickPrimitive<T> = Pick<T, PrimitiveKeys<T>>;

/**
 * Pick the keys of an object where the property value is not primitive
 */
type ObjectKeys<T> = Exclude<keyof T, PrimitiveKeys<T>>;

/**
 * Join two keys using a separator
 */
type JoinKeys<
  TSep extends string,
  P extends string,
  K extends string,
> = `${P}${TSep}${K}`;

/**
 * Create an object with all keys prepended with some prefix
 *
 * @param T the type with the keys of interest
 * @param P the prefix to prepend keys with
 * @param Sep the separator to use for nesting keys
 */
type ExpandPathsRec<T, P extends string, Sep extends string> = {
  [K in keyof T & string]: T[K] extends Primitive
    ? {
        [key in JoinKeys<Sep, P, K>]: T[K];
      }
    : ExpandPathsRec<T[K], JoinKeys<Sep, P, K>, Sep>;
}[keyof T & string];

/**
 * Create the resultant nested object using the given keys of the input object
 *
 * @param T the object to un-nest
 * @param P the keys to keep when un-nesting
 */
type ExpandPaths<T, P extends keyof T, Sep extends string> = P extends string
  ? ExpandPathsRec<T[P], P, Sep>
  : {};

/**
 * Bring all object properties to the top-level recursively
 *
 * @param T the object to expand
 * @param Sep the separator to use when expanding
 */
type Pathify<T, Sep extends string> = PickPrimitive<T> &
  ExpandPaths<T, ObjectKeys<T>, Sep>;

/**
 * Get object with only keys that are an array
 */
export type PickArrays<T> = {
  [K in keyof T as T[K] extends Array<any> ? K : never]: T[K]
}
```

# Strings

```ts
/**
 * Types that can be cleanly/predictably converted into a string
 */
type Stringable = Exclude<string | number, ''>

type NonEmptyArray<T> = [T, ...T[]]

/**
 * Joins stringable members into a single, typed, string
 */
export type Join<TSep extends string, T extends Array<Stringable>> = T extends [
  infer El,
  ...infer Rest
]
  ? El extends Stringable
    ? Rest extends NonEmptyArray<Stringable>
      ? `${El}${TSep}${Join<TSep, Rest>}`
      : El
    : ''
  : ''

/**
 * Split a strongly typed string into its parts
 */
export type Split<
  TSep extends string,
  TStr extends string,
  TBase extends string[] = []
> = TStr extends `${infer El}${TSep}${infer Rest}`
  ? [...TBase, El, ...Split<TSep, Rest>]
  : [TStr]
```
