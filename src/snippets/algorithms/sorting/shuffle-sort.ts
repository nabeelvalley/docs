const random = (end: number) => Math.floor(Math.random() * (end + 1))

export const shuffleSort = <T>(array: Array<T>): Array<T> => {
  const swap = (indexI: number, indexJ: number) => {
    const replaced = array[indexI]

    array[indexI] = array[indexJ]
    array[indexJ] = replaced
  }

  for (let i = 0; i < array.length; i++) {
    const r = random(i)
    swap(r, i)
  }

  return array
}
