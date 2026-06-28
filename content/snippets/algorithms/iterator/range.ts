class RangeIterator implements Iterator<number, number, number> {
  current: number;
  constructor(
    readonly start: number,
    private readonly end: number,
    private readonly step: number
  ) {
    // step back so we can include the initial value
    this.current = start - this.step;
  }

  next(): IteratorResult<number> {
    const outOfBounds = this.current > this.end;
    const canNotIterate = this.current + this.step > this.end;

    const isDone = outOfBounds || canNotIterate;

    if (isDone) {
      return {
        // this return value will be ignored as the iterator is done
        value: undefined,
        done: true,
      };
    }

    this.current += this.step;
    return {
      value: this.current,
      done: false,
    };
  }
}

export class Range implements Iterable<number> {
  constructor(
    private readonly start: number,
    private readonly end: number,
    private readonly step = 1
  ) {}

  [Symbol.iterator]() {
    return new RangeIterator(this.start, this.end, this.step);
  }
}
