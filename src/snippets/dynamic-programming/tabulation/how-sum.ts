export const howSum = (target: number, nums: number[]): number[] | null => {
  const table = new Array<number[] | null>(target + 1).fill(null);
  table[0] = [];

  for (let index = 0; index <= target; index++) {
    const element = table[index];

    if (element) {
      for (const num of nums) {
        const nextIndex = index + num;
        if (nextIndex in table) {
          const nextValue = [...element, num];
          table[nextIndex] = nextValue;
        }
      }
    }
  }

  return table[target];
};
