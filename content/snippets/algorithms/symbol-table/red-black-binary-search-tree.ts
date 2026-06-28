import { BinarySearchTree } from './binary-search-tree'
import { Comparison, type Compare } from '../sorting/definition'
import type { Key } from './definition'

type Color = 'red' | 'black'

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

  /**
   * Color of parent link
   */
  color: Color

  constructor(key: K, val: V, color: Color) {
    this.key = key
    this.val = val
    this.color = color
  }
}

const red = <K extends Key, V>(node?: Node<K, V>): node is (Node<K, V> & { color: 'red' }) => node?.color === 'red'

export class RedBlackBinarySearchTree<K extends Key, V> extends BinarySearchTree<K, V> {
  protected override root?: Node<K, V> = undefined

  private rotateLeft(h: Node<K, V>) {
    const x = h.right
    console.assert(red(x))

    h.right = x.left
    x.left = h
    x.color = h.color
    h.color = 'red'

    return x
  }

  private rotateRight(h: Node<K, V>) {
    const x = h.left
    console.assert(red(x))

    h.left = x.right
    x.right = h
    x.color = h.color
    h.color = 'red'

    return x
  }

  private flipColors(h: Node<K, V>) {
    console.assert(!red(h))
    console.assert(red(h.left))
    console.assert(red(h.right))

    h.color = 'red'
    h.left.color = 'black'
    h.right.color = 'black'
  }

  private redBlackPutAtNode(h: Node<K, V> | undefined, key: K, val: V): Node<K, V> {
    if (h === undefined) return new Node(key, val, 'red')

    if (key < h.key)
      h.left = this.redBlackPutAtNode(h.left, key, val)
    else if (key > h.key)
      h.right = this.redBlackPutAtNode(h.right, key, val)
    else if (key === h.key)
      h.val = val


    // Lean left
    if (red(h.right) && !red(h.left))
      h = this.rotateLeft(h)

    // Balance 4-node
    if (red(h.left) && red(h.left?.left))
      h = this.rotateRight(h)

    // Split 4-node
    if (red(h.left) && red(h.right))
      this.flipColors(h)

    return h
  }

  public override put(key: K, val: V): void {
    this.root = this.redBlackPutAtNode(this.root, key, val)
  }
}
