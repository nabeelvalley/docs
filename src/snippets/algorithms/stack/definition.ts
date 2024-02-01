export interface Stack<T> {
  push(value: T): void;
  pop(): T | undefined;
  empty(): boolean;
  size(): number;
}
