import { type Compare, Comparison } from './definition'

export const isSorted = <T>(compare: Compare<T>, array: Array<T>): boolean => {
  if (array.length < 2) {
    return true
  }

  for (let index = 0; index < array.length; index++) {
    const v = array[index]
    const w = array[index + 1]

    const result = compare(v, w)
    if (result === Comparison.Greater) {
      return false
    }
  }

  return true
}
