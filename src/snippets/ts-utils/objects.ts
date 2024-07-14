/**
 * Definition for a type guard that checks if a value is of a specific type
 */
export type Guard<TResult, TOther = unknown> = (
  value: TResult | TOther,
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
  [K in keyof T]: T[K] extends Cond ? K : never
}[keyof T]

/**
 * Get the primitive keys of a given object
 */
type PrimitiveKeys<T> = ConditionalKeys<Primitive, T>

/**
 * Pick the keys of an object where the property value is a primitive
 */
type PickPrimitive<T> = Pick<T, PrimitiveKeys<T>>

/**
 * Pick the keys of an object where the property value is not primitive
 */
type ObjectKeys<T> = Exclude<keyof T, PrimitiveKeys<T>>

/**
 * Join two keys using a separator
 */
type JoinKeys<
  TSep extends string,
  P extends string,
  K extends string,
> = `${P}${TSep}${K}`

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
        [key in JoinKeys<Sep, P, K>]: T[K]
      }
    : ExpandPathsRec<T[K], JoinKeys<Sep, P, K>, Sep>
}[keyof T & string]

/**
 * Create the resultant nested object using the given keys of the input object
 *
 * @param T the object to un-nest
 * @param P the keys to keep when un-nesting
 */
type ExpandPaths<T, P extends keyof T, Sep extends string> = P extends string
  ? ExpandPathsRec<T[P], P, Sep>
  : {}

/**
 * Bring all object properties to the top-level recursively
 *
 * @param T the object to expand
 * @param Sep the separator to use when expanding
 */
type Pathify<T, Sep extends string> = PickPrimitive<T> &
  ExpandPaths<T, ObjectKeys<T>, Sep>

/**
 * Get object with only keys that are an array
 */
export type PickArrays<T> = {
  [K in keyof T as T[K] extends Array<any> ? K : never]: T[K]
}

/**
 * Get the keys of the object `Obj` that start with the given string `P`
 *
 * @param P the string that a key should be prefixed with
 * @param Obj the object from which to take the matching keys
 */
export type KeysStartingWith<P extends string, Obj> = keyof Obj &
  `${P}${string}`

/**
 * Get the keys of the object `Obj` that end with the given string `S`
 *
 * @param S the string that a key should be suffixed with
 * @param Obj the object from which to take the matching keys
 */
export type KeysEndingWith<S extends string, Obj> = keyof Obj & `${string}${S}`

/**
 * Get a type or else a fallback if it is `never`
 *
 * @param T the base type
 * @param F the fallback to use if `T extends never`
 */
export type OrElse<T, F> = T extends never ? F : T
