import { expect, test } from 'vitest'
import { UnorderedMaxPQ } from './unordered-max-pq'
import { compareNumbers } from '../sorting/compare'
import { swim } from './binary-heap-swim'
import { sink } from './binary-heap-sink'
import { BinaryHeapPQ } from './binary-heap'

const implementations = [UnorderedMaxPQ, BinaryHeapPQ]

test.each(implementations)('Impl: %o', (Sut) => {
  const sut = new Sut(compareNumbers)

  expect(sut.empty()).toStrictEqual(true)

  sut.insert(1)
  sut.insert(4)
  sut.insert(5)
  sut.insert(3)
  sut.insert(2)

  expect(sut.size()).toBe(5)

  expect(sut.empty()).toStrictEqual(false)

  expect(sut.delMax()).toStrictEqual(5)
  expect(sut.delMax()).toStrictEqual(4)
})
