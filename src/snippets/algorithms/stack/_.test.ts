import { describe, expect, test } from "vitest";

import { LinkedListStack } from "./linked-list";
import { FixedSizeArrayStack } from "./fixed-size-array";
import { ResizingArrayStack } from "./resizing-array";
import { twoStackArithmetic } from "./dijkstras-two-stack-arithmetic";

interface Data {
  id: number;
}

const implementations = [
  LinkedListStack,
  FixedSizeArrayStack,
  ResizingArrayStack,
];

describe.each(implementations)("Impl: %o", (Sut) => {
  test("pushes and pops items in the expected order", () => {
    const sut = new Sut<Data>();

    expect(sut.empty()).toStrictEqual(true);

    sut.push({ id: 1 });
    sut.push({ id: 2 });
    sut.push({ id: 3 });
    sut.push({ id: 4 });
    sut.push({ id: 5 });

    expect(sut.size()).toBe(5);

    expect(sut.empty()).toStrictEqual(false);

    expect(sut.pop()).toStrictEqual({ id: 5 });
    expect(sut.pop()).toStrictEqual({ id: 4 });
    expect(sut.pop()).toStrictEqual({ id: 3 });
    expect(sut.pop()).toStrictEqual({ id: 2 });
    expect(sut.pop()).toStrictEqual({ id: 1 });

    expect(sut.empty()).toBe(true);
    expect(sut.size()).toBe(0);
  });
});

describe(twoStackArithmetic, () => {
  test("handles valid input as expected", () => {
    const input = "( ( ( 1 + ( ( 2 + 3 ) * ( 4 * 5 ) ) ) - 1 ) / 10 )".split(
      " "
    );

    const result = twoStackArithmetic(input);

    expect(result).toBe(10);
  });
});
