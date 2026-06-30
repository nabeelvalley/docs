import { type Compare, Comparison } from './definition'

export const insertionSort = <T>(compare: Compare<T>, array: Array<T>) => {
  const swap = (indexI: number, indexJ: number) => {
    const replaced = array[indexI]

    array[indexI] = array[indexJ]
    array[indexJ] = replaced
  }

  for (let i = 0; i < array.length; i++) {
    for (let j = i; j > 0; j--) {
      if (compare(array[j], array[j - 1]) === Comparison.Less) swap(j, j - 1)
      else break
    }
  }
}
