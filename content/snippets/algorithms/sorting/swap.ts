/**
 * Swap elements of array in place
 */
export const swap = <T>(array: T[], i: number, j: number) => {
  const replaced = array[i]
  array[i] = array[j]
  array[j] = replaced
}
