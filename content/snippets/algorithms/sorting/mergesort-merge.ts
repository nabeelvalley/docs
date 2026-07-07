import { type Compare, Comparison } from './definition'

/**
 * Merges the data in the range `lo` to `hi` into `a`. Assumes that the two
 * halfs of `a` are already sorted as provided by the `lo`, `mid` and `hi`
 * indexes
 *
 * Copies the provided range into `aux` in order to track the original item
 * positions
 */
export const merge = <T>(
  compare: Compare<T>,
  array: Array<T>,
  aux: Array<T>,
  lo: number,
  mid: number,
  hi: number
) => {
  const lessThan = (a: T, b: T) => compare(a, b) === Comparison.Less

  // Copy items into the auxillary array
  for (let i = lo; i <= hi; i++) aux[i] = array[i]

  let l = lo
  let h = mid + 1

  for (let i = lo; i <= hi; i++) {
    if (l > mid) array[i] = aux[h++]
    else if (h > hi) array[i] = aux[l++]
    else if (lessThan(aux[h], aux[l])) array[i] = aux[h++]
    else array[i] = aux[l++]
  }
}
