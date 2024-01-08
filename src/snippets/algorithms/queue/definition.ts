export interface Queue<T> {
  queue(value: T): void;
  dequeue(): T | undefined;
  empty(): boolean;
  size(): number;
}
