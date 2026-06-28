import type { Stack } from "./definition";

export class ResizingArrayStack<T> implements Stack<T> {
  private stack: Array<T>;
  private n = 0;

  constructor() {
    this.stack = new Array<T>(1);
  }

  push(value: T): void {
    if (this.full()) {
      this.resize();
    }

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

  private full() {
    return this.n >= this.stack.length;
  }

  private resize(): void {
    const size = this.size();
    const newStack = new Array(size * 2);

    for (let i = 0; i < this.stack.length; i++) {
      newStack[i] = this.stack[i];
    }

    this.stack = newStack;
  }
}
