import { describe, expect, test } from 'vitest'
import { compareNumbers } from '../sorting/compare'
import { BinarySearchTree } from './binary-search-tree'
import { RedBlackBinarySearchTree } from './red-black-binary-search-tree'

const implementations = [
  BinarySearchTree,
  RedBlackBinarySearchTree
] as const

describe.each(implementations)("Impl: %o", (Sut) => {
  test('should put items into tree', () => {
    const sut = new Sut<number, string>(compareNumbers)

    const nums = [5, 2, 7, 6, 8, 4]

    for (const num of nums) {
      sut.put(num, num.toString())
    }

    for (const num of nums) {
      const res = sut.get(num)
      expect(res).toBe(num.toString())
    }
  })

  test('should get the max value', () => {
    const sut = new Sut<number, string>(compareNumbers)

    const nums = [5, 2, 7, 6, 8, 4]

    for (const num of nums) {
      sut.put(num, num.toString())
    }

    const max = sut.max()
    expect(max).toBe(8)
  })

  test('should get the min value', () => {
    const sut = new Sut<number, string>(compareNumbers)

    const nums = [5, 2, 7, 6, 8, 4]

    for (const num of nums) {
      sut.put(num, num.toString())
    }

    const min = sut.min()
    expect(min).toBe(2)
  })

  test('should get the floor value', () => {
    const sut = new Sut<number, string>(compareNumbers)

    const nums = [5, 2, 7, 6, 8, 4]

    for (const num of nums) {
      sut.put(num, num.toString())
    }

    const floor = sut.floor(6.5)
    expect(floor).toBe(6)
  })

  test('should get the ceil value', () => {
    const sut = new Sut<number, string>(compareNumbers)

    const nums = [5, 2, 7, 6, 8, 4]

    for (const num of nums) {
      sut.put(num, num.toString())
    }

    const ceil = sut.ceil(6.5)
    expect(ceil).toBe(7)
  })
})
