import { Comparison, type Compare } from '../sorting/definition'
import { swap } from '../sorting/swap'

/**
 * Sinks the value at the index `k` down a binary tree as far as needed
 * prefering to promote the child with the higher value
 *
 * @param array A 1-based array representing a complete binary tree with
 * position `k` out of order
 *
 * @param N Number of items in the heap (length -1)
 *
 * @param k The index of the item that is out of order
 */
export const sink = <T>(
  compare: Compare<T>,
  array: T[],
  N: number,
  k: number
) => {
  const less = (i: number, j: number) =>
    compare(array[i], array[j]) === Comparison.Less

  while (2 * k <= N) {
    // First child index
    let j = 2 * k

    // Make sure we are still in the heap and increase j if right child is larger
    if (j < N && less(j, j + 1)) j++

    // If k is greater than the child we are comparing then we are done
    if (!less(k, j)) break

    // Swap k with the larger child j
    swap(array, k, j)

    // Assign k to the value it was swapped to j
    k = j
  }
}
