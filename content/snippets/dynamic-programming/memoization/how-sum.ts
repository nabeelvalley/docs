export const howSum = (target: number, nums: number[]): number[] | null => {
  if (target == 0) return [];
  if (target < 0) return null;

  for (const num of nums) {
    const remainder = target - num;
    const result = howSum(remainder, nums);

    if (result) return [...result, num];
  }

  return null;
};
