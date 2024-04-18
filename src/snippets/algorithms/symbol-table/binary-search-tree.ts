import { Comparison, type Compare } from '../sorting/definition'
import type { Key } from './definition'

class Node<K extends Key, V> {
  readonly key: K
  val: V

  /**
   * Reference to smaller keys
   */
  left?: Node<K, V>

  /**
   * Reference to larger keys
   */
  right?: Node<K, V>

  constructor(key: K, val: V) {
    this.key = key
    this.val = val
  }
}

export class BinarySearchTree<K extends Key, V> {
  private root?: Node<K, V>

  private readonly compare: Compare<K>

  constructor(compare: Compare<K>) {
    this.compare = compare
  }

  public get(key: K): V | undefined {
    let x: Node<K, V> = this.root

    while (x !== undefined) {
      const cmp = this.compare(key, x.key)

      if (cmp === Comparison.Less) x = x.left
      else if (cmp === Comparison.Greater) x = x.right
      else return x.val
    }

    return undefined
  }

  private putAtNode(
    x: Node<K, V> | undefined,
    key: K,
    val: V,
  ): Node<K, V> | undefined {
    if (x === undefined) return new Node(key, val)

    const cmp = this.compare(key, x.key)

    if (cmp === Comparison.Less) x.left = this.putAtNode(x.left, key, val)
    else if (cmp === Comparison.Greater)
      x.right = this.putAtNode(x.right, key, val)
    else x.val = val

    return x
  }

  public put(key: K, val: V): void {
    this.root = this.putAtNode(this.root, key, val)
  }

  public max(): K | undefined {
    let x = this.root
    while (x.right) x = x.right

    return x.key
  }

  public min(): K | undefined {
    let x = this.root
    while (x.left) x = x.left

    return x.key
  }

  private floorOfNode(
    x: Node<K, V> | undefined,
    key: K,
  ): Node<K, V> | undefined {
    if (x === undefined) {
      return undefined
    }

    const cmp = this.compare(key, x.key)
    if (cmp === Comparison.Equal) return x

    if (cmp === Comparison.Less) return this.floorOfNode(x.left, key)

    const t = this.floorOfNode(x.right, key)
    if (t) return t
    else return x
  }

  public floor(key: K): K | undefined {
    const x = this.floorOfNode(this.root, key)
    return x?.key
  }

  private ceilOfNode(
    x: Node<K, V> | undefined,
    key: K,
  ): Node<K, V> | undefined {
    if (x === undefined) {
      return undefined
    }

    const cmp = this.compare(key, x.key)
    if (cmp === Comparison.Equal) return x

    if (cmp === Comparison.Greater) return this.ceilOfNode(x.right, key)

    const t = this.ceilOfNode(x.left, key)
    if (t) return t
    else return x
  }

  public ceil(key: K): K | undefined {
    const x = this.ceilOfNode(this.root, key)
    return x?.key
  }
}
