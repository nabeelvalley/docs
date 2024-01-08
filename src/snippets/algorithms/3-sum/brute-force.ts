/**
 * Counnt how many triplet sums of an input will be equal to 0
 */
export const threeSumBruteFoce = (nums: number[]) => {
  let counter = 0;

  for (let i = 0; i < nums.length; i++) {
    for (let j = i + 1; j < nums.length; j++) {
      for (let k = j + 1; k < nums.length; k++) {
        const sum = nums[i] + nums[j] + nums[k];

        if (sum === 0) {
          counter++;
        }
      }
    }
  }

  return counter;
};
