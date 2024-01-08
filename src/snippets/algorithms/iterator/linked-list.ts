import { type Bag } from "./bag";

interface Item<T> {
  value: T;
  next?: Item<T>;
}

const getSize = <T>(item?: Item<T>, count: number = 0): number => {
  if (!item) {
    return count;
  }

  const innerSize = getSize(item.next, count + 1);
  return innerSize;
};

class LinkedListBagIterator<T> implements Iterator<T> {
  constructor(private current?: Item<T>) {}

  next(): IteratorResult<T> {
    if (!this.current) {
      return {
        value: undefined,
        done: true,
      };
    }

    const value = this.current.value;
    this.current = this.current.next;

    return {
      value,
      done: false,
    };
  }
}

export class LinkedListBag<T> implements Bag<T> {
  private first?: Item<T> = undefined;

  add(value: T): void {
    const oldFirst = this.first;

    this.first = {
      value,
      next: oldFirst,
    };
  }

  size(): number {
    return getSize(this.first);
  }

  [Symbol.iterator](): Iterator<T, any, undefined> {
    return new LinkedListBagIterator(this.first);
  }
}
