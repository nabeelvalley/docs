import { type Compare, Comparison } from './definition'
import { merge } from './mergesort-merge'

const CUTOFF = 8

export const insertionSortRange = <T>(
  compare: Compare<T>,
  array: Array<T>,
  s: number,
  e: number
) => {
  const swap = (indexI: number, indexJ: number) => {
    const replaced = array[indexI]

    array[indexI] = array[indexJ]
    array[indexJ] = replaced
  }

  for (let i = s; i <= e; i++) {
    for (let j = i; j > 0; j--) {
      if (compare(array[j], array[j - 1]) === Comparison.Less) swap(j, j - 1)
      else break
    }
  }
}

export const mergeSortWithInsertion = <T>(
  compare: Compare<T>,
  a: Array<T>
): Array<T> => {
  const aux = new Array<T>(a.length)

  const sort = (lo: number, hi: number) => {
    if (hi <= lo + CUTOFF - 1) {
      insertionSortRange(compare, a, lo, hi)
      return
    }

    const mid = lo + Math.floor((hi - lo) / 2)
    sort(lo, mid)
    sort(mid + 1, hi)
    merge(compare, a, aux, lo, mid, hi)
  }

  sort(0, a.length - 1)

  return a
}
