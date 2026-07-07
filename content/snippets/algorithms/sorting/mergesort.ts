import type { Compare } from './definition'
import { merge } from './mergesort-merge'

export const mergeSort = <T>(compare: Compare<T>, array: Array<T>) => {
  const aux = new Array<T>(array.length)

  const sort = (lo: number, hi: number) => {
    if (hi - lo < 1) {
      return
    }

    const mid = lo + Math.floor((hi - lo) / 2)

    sort(lo, mid)
    sort(mid + 1, hi)
    merge(compare, array, aux, lo, mid, hi)
  }

  sort(0, array.length - 1)
}
