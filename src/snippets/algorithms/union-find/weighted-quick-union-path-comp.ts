import type { UnionFind } from "./interface";

export class WeightedQuickUnionPathCompression implements UnionFind {
  /*
   * Track the parent associated with each items.
   * The element is a root node if the parent is the same as the node
   */
  parents: number[];

  /*
   * The number of elements in each tree
   */
  sizes: number[];

  /* Initially each item is identified by a parent
   * that is the same as its own index
   */
  constructor(size: number) {
    this.parents = new Array(size).fill(0).map((_, i) => i);

    this.sizes = new Array(size).fill(1);
  }

  /*
   * Get the root of a given node
   */
  root(a: number) {
    let parent = a;
    while (parent !== this.parents[parent]) {
      // since we're already at this node we can just move it up a level
      parent = this.parents[this.parents[parent]];
      this.parents[parent] = parent;
    }

    return parent;
  }

  /*
   * If two items have the same root they are connected
   */
  connected(a: number, b: number) {
    return this.root(a) === this.root(b);
  }

  /*
   * Joins a node by setting its root to that of the other node
   *
   * Differs from Quick Union by checking tree sizes and prefering a
   * smaller tree where possible
   */
  union(a: number, b: number) {
    const rootA = this.root(a);
    const rootB = this.root(b);

    if (rootA === rootB) {
      return;
    }

    const sizeA = this.sizes[rootA];
    const sizeB = this.sizes[rootB];
    if (sizeA < sizeB) {
      this.parents[rootA] = rootB;
      this.sizes[rootB] += sizeA;
    } else {
      this.parents[rootB] = rootA;
      this.sizes[rootA] += sizeB;
    }
  }
}
