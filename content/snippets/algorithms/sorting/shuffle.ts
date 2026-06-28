const random = (end: number) => Math.floor(Math.random() * (end + 1))

/**
 * Knuth Shuffle implementation. Shuffles an array in place.
 */
export const shuffle = <T>(array: Array<T>) => {
  const swap = (i: number, j: number) => {
    const replaced = array[i]

    array[i] = array[j]
    array[j] = replaced
  }

  for (let k = 0; k < array.length; k++) {
    const r = random(k)
    swap(r, k)
  }
}
