import type { Compare } from './definition'
import { merge } from './mergesort-merge'

export const mergeSortBottomUp = <T>(
  compare: Compare<T>,
  array: Array<T>
): Array<T> => {
  const length = array.length
  const aux = new Array<T>(length)

  for (let size = 1; size < length; size += size) {
    for (let low = 0; low < length - size; low += 2 * size) {
      const mid = low + size - 1
      const high = Math.min(low + 2 * size - 1, length - 1)

      merge(compare, array, aux, low, mid, high)
    }
  }

  return array
}
