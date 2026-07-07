/** The result of a comparison */
export enum Comparison {
  /** v > w */
  Greater = 1,
  /** v < w */
  Less = -1,
  /** v = w */
  Equal = 0,
}

/**
 * The comparison function that tells us the relation between `v is ____ than w`
 */
export type Compare<T> = (v: T, w: T) => Comparison

/**
 * Definition of a sorting function
 */
export type Sort<T> = (compare: Compare<T>, array: Array<T>) => Array<T>
