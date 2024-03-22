import type { Compare } from './definition'
import { merge } from './mergesort-merge'

export const mergeSort = <T>(compare: Compare<T>, a: Array<T>): Array<T> => {
  const aux = new Array<T>(a.length)

  const sort = (lo: number, hi: number) => {
    if (hi <= lo) {
      return
    }

    const mid = lo + (hi - lo) / 2
    sort(lo, mid)
    sort(mid + 1, hi)
    merge(compare, a, aux, lo, mid, hi)
  }

  sort(0, a.length - 1)

  return a
}
