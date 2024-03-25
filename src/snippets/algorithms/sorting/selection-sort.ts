import { type Compare, Comparison } from './definition'

export const selectionSort = <T>(
  compare: Compare<T>,
  array: Array<T>
): Array<T> => {
  const swap = (indexI: number, indexJ: number) => {
    const replaced = array[indexI]

    array[indexI] = array[indexJ]
    array[indexJ] = replaced
  }

  for (let i = 0; i < array.length; i++) {
    let min = i

    for (let j = i + 1; j < array.length; j++) {
      const comparison = compare(array[j], array[min])

      if (comparison === Comparison.Less) min = j
    }

    swap(i, min)
  }

  return array
}
