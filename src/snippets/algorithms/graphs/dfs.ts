import type { Paths } from './path-definition'
import type { Graph } from './definition'
import { LinkedListStack } from '../stack/linked-list'

export class DFS implements Paths {
  #s: number
  #marked: boolean[]
  #edgeTo: number[]

  constructor(
    graph: Graph,
    source: number
  ) {
    this.#s = source
    this.#marked = new Array(graph.V).fill(false)
    this.#edgeTo = new Array(graph.V)

    this.dfs(graph, source)
  }

  private dfs(G: Graph, v: number): void {
    this.#marked[v] = true
    for (let w of G.adj(v)) {
      if (!this.#marked[w]) {
        this.dfs(G, w)
        this.#edgeTo[w] = v
      }
    }
  }

  hasPathTo(v: number): boolean {
    return this.#marked[v]
  }

  pathTo(v: number): Iterable<number> | undefined {
    if (!this.hasPathTo(v)) {
      return undefined
    }

    const path = Array<number>()

    for (let x = v; x !== this.#s; x = this.#edgeTo[x]) {
      path.push(x)
    }

    return path
  }
}
