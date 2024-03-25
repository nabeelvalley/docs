import { describe, expect, test } from 'vitest'
import { isSorted } from './is-sorted'
import { type Compare, Comparison } from './definition'
import { selectionSort } from './selection-sort'
import { insertionSort } from './insertion-sort'
import { shellSort } from './shell-sort'
import { mergeSort } from './mergesort'
import { mergeSortWithInsertion } from './mergesort-with-insertion'
import { mergeSortBottomUp } from './mergesort-bottom-up'
import { quickSort } from './quicksort'
import { quickSelect } from './quicksort-selection'
import { shuffle } from './shuffle'
import { quickSort3Way } from './quicksort-3-way'

const builtinSort = (compare: Compare<number>, array: number[]) =>
  array.sort(compare)

const implementations = [
  builtinSort,
  selectionSort,
  insertionSort,
  shellSort,
  mergeSort,
  mergeSortWithInsertion,
  mergeSortBottomUp,
  quickSort,
  quickSort3Way,
]

const compareNumbers: Compare<number> = (v, w) => {
  if (v > w) return Comparison.Greater

  if (v < w) return Comparison.Less

  return Comparison.Equal
}

test.each(implementations)('Sort Numbers: %o', (sort) => {
  const data = [5, 3, 4, 1, 2, 7, 6, 8, 5, 9, 0]

  sort(compareNumbers, data)

  expect(data).toEqual([0, 1, 2, 3, 4, 5, 5, 6, 7, 8, 9])
})

test.each(implementations)('Sort Larger Array: %o', (sort) => {
  const data = new Array(20).fill(0).map(() => Math.random())

  sort(compareNumbers, data)

  expect(isSorted(compareNumbers, data)).toBe(true)
})

describe(isSorted, () => {
  test('returns true for sorted', () => {
    const result = isSorted(compareNumbers, [1, 2, 3, 4, 5])

    expect(result).toBe(true)
  })

  test('returns false for unsorted', () => {
    const result = isSorted(compareNumbers, [1, 2, 3, 5, 4])

    expect(result).toBe(false)
  })
})

describe(quickSelect, () => {
  test.each([0, 1, 2, 3, 4, 5])(
    'returns the kth largest element (k=%i)',
    (k) => {
      const input = [0, 1, 2, 3, 4, 5]

      const result = quickSelect(compareNumbers, input, k)
      expect(result).toBe(k)
    }
  )
})
