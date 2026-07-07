import { Comparison, type Compare } from './definition'

export const less = <T>(compare: Compare<T>, ...args: Parameters<Compare<T>>) =>
  compare(...args) === Comparison.Less

export const compareNumbers: Compare<number> = (v, w) => {
  if (v > w) return Comparison.Greater

  if (v < w) return Comparison.Less

  return Comparison.Equal
}
