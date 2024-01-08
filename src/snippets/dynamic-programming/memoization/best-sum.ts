export const bestSum = (target: number, nums: number[]): number[] | null => {
  if (target == 0) return [];
  if (target < 0) return null;

  let shortest: number[] | null = null;

  for (let num of nums) {
    const remainder = target - num;
    const remainderCombination = bestSum(remainder, nums);

    if (remainderCombination) {
      const combination = [...remainderCombination, num];

      if (shortest == null || shortest.length > combination.length)
        shortest = combination;
    }
  }

  return shortest;
};
