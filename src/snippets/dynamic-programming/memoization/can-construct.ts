export const canConstruct = (target: string, parts: string[]): boolean => {
  if (target == "") return true;

  for (let part of parts) {
    if (target.startsWith(part)) {
      const restOfWord = target.slice(part.length);

      const result = canConstruct(restOfWord, parts);

      if (result) return true;
    }
  }

  return false;
};
