/**
 * An array with at least 1 item in it
 */
export type NonEmptyArray<T> = [T, ...T[]]

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
  array: T[],
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
  : []

/**
 * Reverses the input tuple
 */
export type Reverse<T extends Array<unknown>> = T extends [
  infer First,
  ...infer Rest,
]
  ? [...Reverse<Rest>, First]
  : []

/**
 * Remove first value from array
 */
export type Eat<T extends unknown[]> = T extends [infer _, ...infer R]
  ? R
  : never

/**
 * Remove last value from array
 */
export type EatLast<T extends unknown[]> = T extends [...infer R, infer _]
  ? R
  : never
