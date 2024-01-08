import { expect, test } from "vitest";
import { threeSumBruteFoce } from "./brute-force";

import { withPerf, randomArr, getLgRatio, average } from "../../../test-utils";

test("Brute Force Impl", () => {
  const nums = [30, -40, -20, -10, 40, 0, 10, 5];
  const result = threeSumBruteFoce(nums);

  expect(result).toEqual(4);
});

test.each([100, 200, 400])("Brute Force Perf %s", (count) => {
  const nums = randomArr(count, 50);

  withPerf(`Count: ${count}`, () => threeSumBruteFoce(nums));
});

test("Brute Force approx power", () => {
  const perfs = [100, 200, 400, 800].map((count) => {
    const nums = randomArr(count, 50);

    const [_, time] = withPerf(`Count: ${count}`, () =>
      threeSumBruteFoce(nums)
    );
    return time;
  });

  const b = getLgRatio(perfs);
  expect(b > 2 && b < 4).toBeTruthy();
});
