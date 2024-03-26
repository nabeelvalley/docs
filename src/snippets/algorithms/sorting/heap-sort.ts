import { Comparison, type Compare } from './definition'

export const heapSort = <T>(compare: Compare<T>, a: T[]) => {
  const p = (i: number) => Math.floor(i / 2)
  let N = a.length - 1

  const less = (i: number, j: number) => compare(a[i], a[j]) === Comparison.Less

  const swap = (i: number, j: number) => {
    const ref = a[i]
    a[i] = a[j]
    a[j] = ref
  }

  const sink = (k: number) => {
    while (2 * k <= N) {
      let j = 2 * k
      if (j < N && less(j, j + 1)) j++
      if (!less(k, j)) break
      swap(k, j)
      k = j
    }
  }

  for (let k = p(N); k >= 0; k--) {
    sink(k)
  }

  while (N > 0) {
    swap(0, N)

    N--
    sink(0)
  }
}
