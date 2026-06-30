import { type Stack } from './definition'

interface Item<T> {
  value: T
  next?: Item<T>
}

const getSize = <T>(item?: Item<T>, count: number = 0): number => {
  if (!item) {
    return count
  }

  const innerSize = getSize(item.next, count + 1)
  return innerSize
}

export class LinkedListStack<T> implements Stack<T> {
  private first?: Item<T> = undefined

  push(value: T): void {
    const oldFirst = this.first

    this.first = {
      value,
      next: oldFirst,
    }
  }

  pop(): T | undefined {
    const item = this.first

    this.first = item?.next

    return item?.value
  }

  empty(): boolean {
    return this.first === undefined
  }

  size(): number {
    return getSize(this.first)
  }
}
