export interface Paths {
  /**
   * Does a path exist from source to v
   */
  hasPathTo(v: number): boolean

  /**
   * Get the path from the start of the graph to v
   */
  pathTo(v: number): Iterable<number> | undefined
}
