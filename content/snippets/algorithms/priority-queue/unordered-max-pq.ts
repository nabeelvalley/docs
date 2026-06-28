import { Comparison, type Compare } from '../sorting/definition'
import type { PriorityQueue } from './definition'

export class UnorderedMaxPQ<T> implements PriorityQueue<T> {
  private N = 0
  private pq: T[]

  constructor(private compare: Compare<T>, capacity: number = 10) {
    this.pq = new Array(capacity)
  }

  private swap(i: number, j: number) {
    const replaced = this.pq[i]
    this.pq[i] = this.pq[j]
    this.pq[j] = replaced
  }

  public insert(value: T): void {
    this.pq[this.N++] = value
  }

  public delMax(): T {
    let m = 0
    for (let i = 0; i < this.N; i++) if (this.less(m, i)) m = i

    this.swap(m, this.N)
    return this.pq[this.N--]
  }

  public size(): number {
    return this.N
  }

  public empty(): boolean {
    return this.N === 0
  }

  private less(i: number, j: number) {
    return this.compare(this.pq[i], this.pq[j]) === Comparison.Less
  }
}
