import { Compare, Comparison } from './definition'

export const isSortedRange = <T>(
  compare: Compare<T>,
  array: Array<T>,
  s: number,
  e: number
) => {
  const range = e - s

  if (range < 1) {
    console.error({ s, e, range })
    throw new Error('Invalid Array Given')
  }

  if (range < 2) {
    return true
  }

  for (let index = s; index < e; index++) {
    const v = array[index]
    const w = array[index + 1]

    const result = compare(v, w)
    if (result === Comparison.Greater) {
      return false
    }
  }

  return true
}

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
  a: Array<T>,
  aux: Array<T>,
  lo: number,
  mid: number,
  hi: number
) => {
  // Assert that the input arrays are sorted
  console.assert(
    isSortedRange(compare, a, lo, mid),
    'First half of array not sorted',
    { a, lo, mid, hi }
  )
  console.assert(
    isSortedRange(compare, a, mid + 1, hi),
    'Second half of array not sorted',
    { a, lo, mid, hi }
  )

  // Copy items into the auxillary array
  for (let k = lo; k <= hi; k++) aux[k] = a[k]

  let i = lo
  let j = mid + 1

  for (let k = lo; k <= hi; k++) {
    if (i > mid) a[k] = aux[j++]
    else if (j > hi) a[k] = aux[i++]
    else if (compare(aux[j], aux[i]) === Comparison.Less) a[k] = aux[j++]
    else a[k] = aux[i++]
  }
}
