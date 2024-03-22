import { describe, expect, test } from 'vitest'
import { isSorted } from './is-sorted'
import { Compare, Comparison } from './definition'
import { selectionSort } from './selection-sort'
import { insertionSort } from './insertion-sort'
import { shellSort } from './shell-sort'
import { mergeSort } from './mergesort'
import { mergeSortInsertionBase } from './mergesort-insertion-base'

const builtinSort = (compare: Compare<number>, array: number[]) =>
  array.sort(compare)

const implementations = [
  builtinSort,
  selectionSort,
  insertionSort,
  shellSort,
  mergeSort,
  mergeSortInsertionBase,
]

const compareNumbers: Compare<number> = (v, w) => {
  if (v > w) return Comparison.Greater

  if (v < w) return Comparison.Less

  return Comparison.Equal
}

test.each(implementations)('Sort Numbers: %o', (sut) => {
  const data = [5, 3, 4, 1, 2, 7, 6, 8, 9, 0]

  const sorted = sut(compareNumbers, data)

  expect(sorted).toEqual([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
})

test.each(implementations)('Sort Larger Array: %o', (sut) => {
  const data = new Array(20).fill(0).map(() => Math.random())

  const sorted = sut(compareNumbers, data)

  expect(isSorted(compareNumbers, sorted)).toBe(true)
})

describe('isSorted', () => {
  test('returns true for sorted', () => {
    const result = isSorted(compareNumbers, [1, 2, 3, 4, 5])

    expect(result).toBe(true)
  })

  test('returns false for unsorted', () => {
    const result = isSorted(compareNumbers, [1, 2, 3, 5, 4])

    expect(result).toBe(false)
  })
})
