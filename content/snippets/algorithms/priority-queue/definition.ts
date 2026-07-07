export interface PriorityQueue<T> {
  insert(value: T): void
  delMax(): T

  empty(): boolean
  size(): number
}
