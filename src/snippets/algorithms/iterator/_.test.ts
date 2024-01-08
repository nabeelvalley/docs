import { describe, expect, test } from "vitest";

import { Range } from "./range";
import { LinkedListBag } from "./linked-list";

describe(Range, () => {
  test("iterates with a for-of loop", () => {
    const range = new Range(1, 6, 2);

    const results: number[] = [];
    for (const value of range) {
      results.push(value);
    }

    expect(results).toStrictEqual([1, 3, 5]);
  });

  test("converts to an array", () => {
    const range = new Range(1, 6, 2);
    const arr = Array.from(range);

    expect(arr).toStrictEqual([1, 3, 5]);
  });

  test("does not iterate over an invalid range", () => {
    const range = new Range(1, -5, 2);

    const results: number[] = [];
    for (const value of range) {
      results.push(value);
    }

    expect(results).toStrictEqual([]);
  });
});

describe(LinkedListBag, () => {
  test("iterates with a for-of loop", () => {
    const bag = new LinkedListBag<number>();

    const items = [1, 2, 3, 4, 5];
    for (const item of items) {
      bag.add(item);
    }

    const results: number[] = [];
    for (const value of bag) {
      results.push(value);
    }

    expect(results.length).toBe(5);

    for (const item of items) {
      const found = results.includes(item);
      expect(found).toBeDefined();
    }
  });
});
