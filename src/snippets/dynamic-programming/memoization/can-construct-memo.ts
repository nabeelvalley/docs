type Memo = Record<string, boolean>;

export const canConstruct = (
  target: string,
  parts: string[],
  memo: Memo = {}
): boolean => {
  if (target in memo) return memo[target];
  if (target == "") return true;

  for (let part of parts) {
    if (target.startsWith(part)) {
      const restOfWord = target.slice(part.length);

      const result = canConstruct(restOfWord, parts, memo);

      if (result) {
        memo[target] = result;
        return true;
      }
    }
  }

  memo[target] = false;
  return false;
};
