---
title: Typescript Utilities
subtitle: 12 December 2022
description: Some general purpose typescript utilities
published: true
---

[[toc]]

Here's  a collection of some typescript utility functions I've put together

# Functions

```ts
/**
 * A function with defined input and output
 */
export type Fn<TParams, TResult> = (params: TParams) => TResult;

/**
 * A function that returns a result or undefined
 */
export type OptionFn<TParams, TResult> = Fn<TParams, TResult | undefined>;

/**
 * A function that returns void
 */
export type VoidFn<TParams> = (params: TParams) => void;

/**
 * Convert a function type into an async version of that function
 */
export type Async<TFn extends (...args: any[]) => any> = (
  ...args: Parameters<TFn>
) => Promise<ReturnType<TFn>>;

/**
 * Create an async version of `Fn`
 */
export type AsyncFn<TParams, TResult> = Async<Fn<TParams, TResult>>;

/**
 * Create an async version of `OptionFn`
 */
export type AsyncOptionFn<TParams, TResult> = Async<OptionFn<TParams, TResult>>;

/**
 * Create an async version of `VoidFn`
 */
export type AsyncVoidFn<TParams> = Async<VoidFn<TParams>>;

/**
 * Create a version of a function that may either be sync or async
 */
export type SyncOrAsync<TFn extends (...args: any[]) => any> = (
  ...args: Parameters<TFn>
) => ReturnType<TFn> | Promise<ReturnType<TFn>>;

/**
 * Create a version of `Fn` that may either be sync or async
 */
export type SyncOrAsyncFn<TParams, TResult> = SyncOrAsync<Fn<TParams, TResult>>;

/**
 * Create a version of `OptionFn` that may either be sync or async
 */
export type SyncOrAsyncOptionFn<TParams, TResult> = SyncOrAsync<OptionFn<TParams, TResult>>;

/**
 * Create a version of `VoidFn` that may either be sync or async
 */
export type SyncOrAsyncVoidFn<TParams> = SyncOrAsync<VoidFn<TParams>>;
```

# Arrays

```ts
/**
 * Array filter type, used to filter an array via the `.filter` method
 */
export type ArrayFilter<T> = (value: T, index: number, array: T[]) => boolean;

/**
 * Array map type, used to map an array via the `.map` method
 */
export type ArrayMap<T, U> = (value: T, index: number, array: T[]) => U;

/**
 * Array reduce type, used to reduce an array via the `.reduce` method
 */
export type ArrayReducer<T, U> = (
  previousValue: U,
  currentValue: T,
  currentIndex: number,
  array: T[]
) => U;
```

# Objects

```ts
/**
 * Create a type where the provided keys are optional
 */
export type WithOptional<T extends {}, O extends keyof T> = Omit<T, O> & Partial<Pick<T, O>>;

/**
 * Create a type where the provided keys are optional
 */
export type WithRequired<T extends {}, R extends keyof T> = T & Required<Pick<T, R>>;

/**
 * Definition for a type guard that checks if a value is of a specific type
 */
export type Guard<TResult, TOther = unknown> = (value: TResult | TOther) => value is TResult;

```