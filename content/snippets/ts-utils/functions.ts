import { Reverse } from './arrays'

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

/**
 * Returns a function with the arguments reversed
 */
export type ReverseArguments<T extends (...args: any[]) => any> = (
  ...args: Reverse<Parameters<T>>
) => ReturnType<T>
