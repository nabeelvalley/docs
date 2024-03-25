import type { Compare } from './definition'
import { partition } from './quicksort-partitioning'
import { shuffle } from './shuffle'

/**
 * Get the `k`th element from an array (mutates the input `array`)
 */
export const quickSelect = <T>(compare: Compare<T>, array: T[], k: number) => {
  shuffle(array)

  let lo = 0
  let hi = array.length - 1

  while (hi > lo) {
    let j = partition(compare, array, lo, hi)

    if (j < k) lo = j + 1
    else if (j > k) hi = j - 1
    else return array[k]
  }

  return array[k]
}
