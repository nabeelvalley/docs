export interface Graph {
  /**
   * Add an edge v-w 
   */
  addEdge(v: number, w: number): void  

  /**
   * Vertices adjacent to v
   */
  adj(v:number): Iterable<number>

  /**
   * Number of vertices
   */
  V:number

  /**
   * Number of edges
   */
  E:number
}
