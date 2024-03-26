import { Comparison, type Compare } from './definition'
import { swap } from './swap'

export const partition = <T>(
  compare: Compare<T>,
  array: T[],
  lo: number,
  hi: number
) => {
  const lessThan = (a: T, b: T) => compare(a, b) === Comparison.Less

  let i = lo
  let j = hi + 1
  while (true) {
    while (lessThan(array[++i], array[lo])) if (i === hi) break

    while (lessThan(array[lo], array[--j])) if (j === lo) break

    if (i >= j) break

    swap(array, i, j)
  }

  swap(array, lo, j)
  return j
}
