import type { Stack } from "./definition";

export class FixedSizeArrayStack<T> implements Stack<T> {
  private stack: Array<T>;
  private n = 0;

  constructor(capacity = 10) {
    this.stack = new Array<T>(capacity);
  }

  push(value: T): void {
    this.stack[this.n] = value;
    this.n++;
  }

  pop(): T | undefined {
    this.n--;
    const item = this.stack[this.n];

    return item;
  }

  empty(): boolean {
    return this.n === 0;
  }

  size(): number {
    return this.n;
  }
}
