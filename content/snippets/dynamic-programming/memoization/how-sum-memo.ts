type Memo = Record<number, number[] | null>;

export const howSum = (
  target: number,
  nums: number[],
  memo: Memo = {}
): number[] | null => {
  if (target in memo) return memo[target];

  if (target == 0) return [];
  if (target < 0) return null;

  for (const num of nums) {
    const remainder = target - num;
    const remainderSum = howSum(remainder, nums, memo);

    if (remainderSum) {
      const returnValue = [...remainderSum, num];
      memo[target] = returnValue;

      return returnValue;
    }
  }

  memo[target] = null;
  return null;
};
