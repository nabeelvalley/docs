export const canSum = (
  target: number,
  nums: number[],
  memo: Record<number, boolean> = {}
): boolean => {
  if (target in memo) return memo[target];

  if (target === 0) return true;
  if (target < 0) return false;

  for (let num of nums) {
    const remainder = target - num;
    const result = canSum(remainder, nums, memo);

    if (result) {
      memo[target] = true;
      if (result) return true;
    }
  }

  memo[target] = false;
  return false;
};
