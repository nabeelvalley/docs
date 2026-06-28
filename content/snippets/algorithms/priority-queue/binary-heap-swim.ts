import { Comparison, type Compare } from '../sorting/definition'
import { swap } from '../sorting/swap'

/**
 * Swims the value at the index `k` up the binary tree inplace
 *
 * @param array A 1-based array representing a complete binary tree with
 * position `k` out of order
 *
 * @param k The index of the item that is out of order
 */
export const swim = <T>(compare: Compare<T>, array: T[], k: number) => {
  const less = (i: number, j: number) =>
    compare(array[i], array[j]) === Comparison.Less

  const p = (i: number) => Math.floor(i / 2)

  while (k > 1 && less(p(k), k)) {
    swap(array, k, p(k))
    k = p(k)
  }
}
