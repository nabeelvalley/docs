import { expect, test } from 'vitest'
import { LinkedListQueue } from './linked-list'

interface Data {
  id: number
}

const implementations = [LinkedListQueue]

test.each(implementations)('Impl: %o', (Sut) => {
  const sut = new Sut<Data>()

  expect(sut.empty()).toStrictEqual(true)

  sut.queue({ id: 1 })
  sut.queue({ id: 2 })
  sut.queue({ id: 3 })
  sut.queue({ id: 4 })
  sut.queue({ id: 5 })

  expect(sut.size()).toBe(5)

  expect(sut.empty()).toStrictEqual(false)

  expect(sut.dequeue()).toStrictEqual({ id: 1 })
  expect(sut.dequeue()).toStrictEqual({ id: 2 })
  expect(sut.dequeue()).toStrictEqual({ id: 3 })
  expect(sut.dequeue()).toStrictEqual({ id: 4 })
  expect(sut.dequeue()).toStrictEqual({ id: 5 })

  expect(sut.empty()).toBe(true)
  expect(sut.size()).toBe(0)
})
