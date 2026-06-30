import { expect, test } from "vitest";
import { QuickFind } from "./quick-find";
import type { UnionFind } from "./interface";
import { WeightedQuickUnionPathCompression } from "./weighted-quick-union-path-comp";
import { WeightedQuickUnion } from "./weighted-quick-union";
import { QuickUnion } from "./quick-union";

const exec = (impl: UnionFind) => {
  impl.union(4, 3);
  impl.union(3, 8);
  impl.union(6, 5);
  impl.union(9, 4);
  impl.union(2, 1);
  impl.union(8, 9);
  impl.union(5, 0);
  impl.union(7, 2);
  impl.union(6, 1);
  impl.union(1, 0);
  impl.union(6, 7);
};

test("Quick Find", () => {
  const impl = new QuickFind(10);
  exec(impl);

  expect(impl.groups).toMatchInlineSnapshot(`
    [
      6,
      6,
      6,
      9,
      9,
      6,
      6,
      6,
      9,
      9,
    ]
  `);
});

test("Quick Union", () => {
  const impl = new QuickUnion(10);
  exec(impl);

  expect(impl.parents).toMatchInlineSnapshot(`
    [
      6,
      6,
      7,
      4,
      9,
      6,
      6,
      6,
      4,
      4,
    ]
  `);

  expect(impl.parents).toMatchInlineSnapshot(`
    [
      6,
      6,
      7,
      4,
      9,
      6,
      6,
      6,
      4,
      4,
    ]
  `);
});

test("Weighted Quick Union", () => {
  const impl = new WeightedQuickUnion(10);
  exec(impl);

  expect(impl.parents).toMatchInlineSnapshot(`
    [
      6,
      2,
      6,
      4,
      4,
      6,
      6,
      2,
      4,
      4,
    ]
  `);
  expect(impl.sizes).toMatchInlineSnapshot(`
    [
      1,
      1,
      3,
      1,
      4,
      1,
      12,
      1,
      1,
      1,
    ]
  `);
});

test("Weighted Quick Union with Path Compression", () => {
  const impl = new WeightedQuickUnionPathCompression(10);
  exec(impl);

  expect(impl.parents).toMatchInlineSnapshot(`
    [
      6,
      2,
      6,
      4,
      4,
      6,
      6,
      2,
      4,
      4,
    ]
  `);
  expect(impl.sizes).toMatchInlineSnapshot(`
    [
      1,
      1,
      3,
      1,
      4,
      1,
      6,
      1,
      1,
      1,
    ]
  `);
});
