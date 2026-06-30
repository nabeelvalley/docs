type Memo = Record<number, number[] | null>;

export const bestSum = (
  target: number,
  nums: number[],
  memo: Memo = {}
): number[] | null => {
  if (target in memo) return memo[target]
  if (target == 0) return [];
  if (target < 0) return null;

  let shortest: number[] | null = null;

  for (let num of nums) {
    const remainder = target - num;
    const remainderCombination = bestSum(remainder, nums, memo);

    if (remainderCombination) {
      const combination = [...remainderCombination, num];

      if (shortest == null || shortest.length > combination.length)
        shortest = combination;
    }
  }

  memo[target] = shortest;
  return shortest;
};
