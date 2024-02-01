export const countConstruct = (target: string, parts: string[]): number => {
  if (target == "") return 1;

  let permutationCount = 0;

  for (let part of parts) {
    if (target.startsWith(part)) {
      const restOfWord = target.slice(part.length);

      const currentCount = countConstruct(restOfWord, parts);
      permutationCount += currentCount;
    }
  }

  return permutationCount;
};
