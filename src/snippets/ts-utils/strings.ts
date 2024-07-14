import { NonEmptyArray, Reverse } from './arrays'

/**
 * Types that can be cleanly/predictably converted into a string
 */
export type Stringable = Exclude<string | number, ''>

/**
 * String type that will show suggestions but accept any string
 *
 * @param TSugg the strings that you want to appear as IDE suggestions
 */
export type SuggestedStrings<TSugg> = TSugg | (string & {})

/**
 * Joins stringable members into a single, typed, string
 */
export type Join<TSep extends string, T extends Array<Stringable>> = T extends [
  infer El,
  ...infer Rest,
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
  TBase extends string[] = [],
> = TStr extends `${infer El}${TSep}${infer Rest}`
  ? [...TBase, El, ...Split<TSep, Rest>]
  : [TStr]

/**
 * Get the chars of a strongly typed string as an array
 */
export type Chars<
  TStr extends string,
  TBase extends string[] = [],
> = TStr extends `${infer El}${''}${infer Rest}`
  ? Rest extends ''
    ? [TStr]
    : [...TBase, El, ...Chars<Rest>]
  : never

/**
 * Get the length of a string
 */
export type Length<TStr extends string> = Chars<TStr>['length']

/**
 * Get the first character of a string
 */
export type First<T extends string> = T extends `${infer F}${string}`
  ? F
  : never

/**
 * Get the last character of a string
 */
export type Last<TStr extends string> = Reverse<Chars<TStr>>[0]

/**
 * Get a string with the first character omitted
 */
export type Eat<T extends string> = T extends `${string}${infer E}` ? E : never
