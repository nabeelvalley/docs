import { Comparison, type Compare } from '../sorting/definition'
import { sink } from './binary-heap-sink'
import { swim } from './binary-heap-swim'
import type { PriorityQueue } from './definition'

export class BinaryHeapPQ<T> implements PriorityQueue<T> {
  private N = 0
  private pq: Array<T>

  constructor(private compare: Compare<T>, capacity: number = 10) {
    this.pq = new Array<T>(capacity + 1)
  }

  private swap(i: number, j: number) {
    const replaced = this.pq[i]
    this.pq[i] = this.pq[j]
    this.pq[j] = replaced
  }

  private swim(k: number) {
    swim(this.compare, this.pq, k)
  }

  private sink(k: number) {
    sink(this.compare, this.pq, this.N, k)
  }

  public insert(value: T): void {
    this.pq[++this.N] = value
    this.swim(this.N)
  }

  public delMax(): T {
    const max = this.pq[1]
    this.swap(1, this.N--)

    this.sink(1)

    // Remove the reference to the element
    delete this.pq[this.N + 1]

    return max
  }

  public size(): number {
    return this.N
  }

  public empty(): boolean {
    return this.N === 0
  }
}
