import { Compare, Comparison } from './definition'

export const shellSort = <T>(
  compare: Compare<T>,
  array: Array<T>
): Array<T> => {
  const swap = (indexI: number, indexJ: number) => {
    const replaced = array[indexI]

    array[indexI] = array[indexJ]
    array[indexJ] = replaced
  }

  let maxH = 1
  let hs: number[] = [maxH]
  while (maxH <= array.length / 3) {
    maxH = maxH + 3 * maxH
    hs.push(maxH)
  }

  while (hs.length > 0) {
    const h = hs.pop() as number

    for (let i = 0; i < array.length; i++) {
      for (let j = i; j >= h; j--) {
        if (compare(array[j], array[j - h]) === Comparison.Less) swap(j, j - 1)
        else break
      }
    }
  }

  return array
}
