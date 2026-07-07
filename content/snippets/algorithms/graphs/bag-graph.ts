import type { Graph } from "./definition"
import { LinkedListBag } from '../iterator/linked-list'
import type { Bag } from '../iterator/bag'


/**
 * Adjacency list implementation of a Graph using a Bag
 */
export class BagGraph implements Graph {
  #adj: Bag<number>[]

  V: number
  E: number = 0

  constructor(V: number) {
    this.V = V
    this.#adj = new Array(V)

    for (let v = 0; v < V; v++) {
      this.#adj[v] = new LinkedListBag()
    }
  }

  addEdge(v: number, w: number): void {
    this.#adj[v].add(w)
    this.#adj[w].add(v)

    this.E++
  }

  adj(v: number): Iterable<number> {
    return this.#adj[v]
  }
}