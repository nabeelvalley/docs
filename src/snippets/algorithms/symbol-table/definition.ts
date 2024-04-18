export type Key = string | number

export interface SymbolTable<K extends Key, V> {
  /**
   * Put a value at a given key
   */
  put(key: K, value: V): void

  /**
   * Get a value given a key
   */
  get(key: K): V | undefined

  /**
   * Delete the value with the given key
   */
  delete(key: K): void

  /**
   * Check if the key/value exists in the symbol table
   */
  contains(key: K): boolean

  /**
   * Check if the symbol table is empty
   */
  isEmpty(): boolean

  /**
   * Get the total number of key value pairs in the symbol table
   */
  size(): number

  /**
   * Iterate through all keys in the table
   */
  keys(): Iterator<K>
}
