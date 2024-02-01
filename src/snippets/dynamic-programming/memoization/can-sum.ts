export const canSum = (target: number, nums: number[]): boolean => {
  if (target === 0) return true;
  if (target < 0) return false;

  for (let num of nums) {
    const remainder = target - num;

    if (canSum(remainder, nums)) return true;
  }

  return false;
};
