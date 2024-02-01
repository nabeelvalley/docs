type Memo = Record<string, string[][]>;

export const allConstruct = (
  target: string,
  parts: string[],
  memo: Memo = {}
): string[][] => {
  if (target in memo) return memo[target];

  // for the base case there is one way to return the combination and that is the empty solution;
  if (target == "") return [[]];

  let permutations: string[][] = [];

  for (let part of parts) {
    if (target.startsWith(part)) {
      const restOfWord = target.slice(part.length);

      const current = allConstruct(restOfWord, parts, memo);
      const joint = current.map((arr) => [part, ...arr]);
      permutations = [...permutations, ...joint];
    }
  }

  memo[target] = permutations;
  return permutations;
};
