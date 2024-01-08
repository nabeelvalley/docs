export class QuickUnion {
  /*
   * Track the parent associated with each items.
   * The element is a root node if the parent is the same as the node
   */
  parents: number[];

  /* Initially each item is identified by a parent
   * that is the same as its own index
   */
  constructor(size: number) {
    this.parents = new Array(size).fill(0).map((_, i) => i);
  }

  /*
   * Get the root of a given node
   */
  root(a: number) {
    let parent = a;
    while (parent !== this.parents[a]) {
      parent = this.parents[parent];
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
   */
  union(a: number, b: number) {
    const root = this.root(a);
    this.parents[b] = root;
  }
}
