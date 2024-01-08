import { type Queue } from "./definition";

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

export class LinkedListQueue<T> implements Queue<T> {
  private first?: Item<T> = undefined;
  private last?: Item<T> = undefined;

  queue(value: T): void {
    const newNode = {
      value,
    };

    if (this.last) {
      this.last.next = newNode;
    }

    if (this.first === undefined) {
      // if nothing in queue then init to input item
      this.first = newNode;
    }

    this.last = newNode;
  }

  dequeue(): T | undefined {
    const item = this.first;

    this.first = item?.next;

    if (this.first === undefined) {
      // if nothing in queue then we should remove ref to last item
      this.last = undefined;
    }

    return item?.value;
  }

  empty(): boolean {
    return this.first === undefined;
  }

  size(): number {
    return getSize(this.first);
  }
}
