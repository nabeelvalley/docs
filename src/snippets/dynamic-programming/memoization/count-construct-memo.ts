type Memo = Record<string, number>;

export const countConstruct = (
  target: string,
  parts: string[],
  memo: Memo = {}
): number => {
  if (target in memo) return memo[target];
  if (target == "") return 1;

  let permutationCount = 0;

  for (let part of parts) {
    if (target.startsWith(part)) {
      const restOfWord = target.slice(part.length);

      const currentCount = countConstruct(restOfWord, parts, memo);
      permutationCount += currentCount;
    }
  }

  memo[target] = permutationCount;
  return permutationCount;
};
