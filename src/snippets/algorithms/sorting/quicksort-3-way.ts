import { Comparison, type Compare } from './definition'
import { swap } from './quicksort-partitioning'
import { shuffle } from './shuffle'

export const quickSort3Way = <T>(compare: Compare<T>, array: T[]) => {
  const sort = (lo: number, hi: number) => {
    if (hi <= lo) return

    let lt = lo
    let gt = hi
    let i = lo
    let v = array[lo]

    while (i <= gt) {
      let cmp = compare(array[i], v)

      if (cmp === Comparison.Less) swap(array, lt++, i++)
      else if (cmp === Comparison.Greater) swap(array, i, gt--)
      else i++
    }

    sort(lo, lt - 1)
    sort(gt + 1, hi)
  }

  shuffle(array)
  sort(0, array.length - 1)
}
