export interface Bag<T> extends Iterable<T> {
  add(item: T): void;
  size(): number;
}
