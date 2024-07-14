/**
 * Relevant schema structure for inferring type definition
 */
interface PartialJSONSchema<T extends Properties = Properties> {
  type: 'object'
  properties: T
  required?: Array<keyof T>
}

type TypeMap = {
  string: string
  boolean: boolean
}

type Type = TypeMap[keyof TypeMap]

type Properties = Record<string, { type: keyof TypeMap; default?: unknown }>

/**
 * Create a type where the provided keys are required
 *
 * @param T the base type
 * @param R the keys to make required
 */
type WithRequired<T, R extends keyof T> = T & Required<Pick<T, R>>

/**
 * Keys that have been defaulted by the
 */
type DefaultedKeys<T extends Properties> = {
  [K in keyof T]: T[K]['default'] extends Type ? K : never
}[keyof T]

/**
 * A field is required if its default value is in the list of required keys
 */
type Structure<T extends PartialJSONSchema> = WithRequired<
  {
    [K in keyof T['properties']]?: TypeMap[T['properties'][K]['type']]
  },
  DefaultedKeys<T['properties']>
>

/**
 * Extracts inner resultant type to make IDE inferrence/display better
 */
type Simplify<T> = {
  [KeyType in keyof T]: T[KeyType]
}

/**
 * Get the typescript type inferred by a JSON Schema
 */
export type FromJSONSchema<T extends PartialJSONSchema> = Simplify<
  T['required'] extends Array<keyof T['properties']>
    ? WithRequired<Structure<T>, T['required'][number]>
    : Structure<T>
>
