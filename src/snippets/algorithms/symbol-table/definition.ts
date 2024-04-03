type Key = string | number

export interface SymbolTable<K extends Key, V> {
  put(key: K, value: V): void

  get(key: K): V | undefined

  delete(key: K): void

  contains(key: K): boolean

  isEmpty(): boolean

  size(): number

  keys(): Iterator<K>
}
