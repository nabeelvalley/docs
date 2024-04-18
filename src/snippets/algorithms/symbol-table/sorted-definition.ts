import type { Compare } from '../sorting/definition'
import type { Key, SymbolTable } from './definition'

export interface SortedSymbolTable<K extends Key, V> extends SymbolTable<K, V> {
  /**
   * In order to be sortable keys must be comparable
   */
  compare: Compare<K>

  /**
   * Get the key with the lowest comparable value
   */
  min(): K | undefined

  /**
   * Get the key with the highest comparable value
   */
  max(): K | undefined

  /**
   * Get the ranked position of a key
   */
  rank(key: K): number | undefined

  /**
   * Get the largest key that is less than or equal to `key`
   */
  floor(key: K): Key | undefined

  /**
   * Get the smallest key that is greater than or equal to `key`
   */
  ceiling(key: K): Key | undefined

  /**
   * Get the key at the given rank
   */
  select(rank: number): K | undefined

  /**
   * Delete the key with the lowest comparable value
   */
  deleteMin(): void

  /**
   * Delete the key with the highest comparable value
   */
  deleteMax(): void

  /**
   * Get the number of keys in the range `[lo, hi]`
   */
  sizeInRange(lo: K, hi: K): number

  /**
   * Get the keys in the range `[lo, hi]`
   */
  keysInRange(lo: K, hi: K): Iterator<K>
}
