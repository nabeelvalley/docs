export const allConstruct = (target: string, parts: string[]): string[][] => {
  // for the base case there is one way to return the combination and that is the empty solution;
  if (target == "") return [[]];

  let permutations: string[][] = [];

  for (let part of parts) {
    if (target.startsWith(part)) {
      const restOfWord = target.slice(part.length);

      const current = allConstruct(restOfWord, parts);
      const joint = current.map((arr) => [part, ...arr]);
      permutations = [...permutations, ...joint];
    }
  }

  return permutations;
};
