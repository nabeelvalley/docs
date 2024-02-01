export const canSum = (target: number, nums: number[]): boolean => {
  const table = new Array<boolean>(target + 1).fill(false);
  table[0] = true;

  for (let index = 0; index <= target; index++) {
    if (table[index]) {
      for (const num of nums) {
        const nextIndex = index + num;
        if (nextIndex in table) table[nextIndex] = true;
      }
    }
  }

  return table[target];
};
