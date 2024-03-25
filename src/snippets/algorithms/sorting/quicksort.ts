import type { Compare } from './definition'
import { partition } from './quicksort-partitioning'
import { shuffle } from './shuffle'

export const quickSort = <T>(compare: Compare<T>, array: T[]) => {
  const sort = (lo: number, hi: number) => {
    if (hi <= lo) return

    let k = partition(compare, array, lo, hi)

    sort(lo, k - 1)
    sort(k + 1, hi)
  }

  shuffle(array)
  sort(0, array.length - 1)
}
