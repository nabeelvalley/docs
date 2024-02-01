import type { UnionFind } from "./interface";

export class QuickFind implements UnionFind {
  /*
   * Track the group associated with each item based on its index
   */
  groups: number[];

  /* Initially each item is identified by a group
   * that is the same as its own index
   */
  constructor(size: number) {
    this.groups = new Array(size).fill(0).map((_, i) => i);
  }

  /*
   * If two items are connected their groups will be the same
   */
  connected(a: number, b: number) {
    const groupA = this.groups[a];
    const groupB = this.groups[b];

    return groupA === groupB;
  }

  /*
   * Joins two items by setting all items of the one group
   * to the same as the other group
   */
  union(a: number, b: number) {
    const groupA = this.groups[a];
    const groupB = this.groups[b];

    /*
     * Iterate through each item and if they are the same as B
     * then update them to be A
     */
    for (let index = 0; index < this.groups.length; index++) {
      const group = this.groups[index];
      if (group === groupB) {
        this.groups[index] = groupA;
      }
    }
  }
}
