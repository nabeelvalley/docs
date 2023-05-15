---
published: true
title: Typescript Utilities
subtitle: 12 December 2022
description: Some general purpose typescript utilities
---

---

title: Typescript Utilities
subtitle: 12 December 2022
description: Some general purpose typescript utilities
published: true

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
  ? TKeep
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
```
