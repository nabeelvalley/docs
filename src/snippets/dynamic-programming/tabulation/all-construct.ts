export const countConstruct = (target: string, subs: string[]): string[][] => {
  const table = new Array(target.length + 1)
    .fill(undefined)
    .map<string[][]>(() => []);

  table[0] = [[]];

  for (let index = 0; index <= target.length; index++) {
    const element = table[index];
    for (const sub of subs) {
      const fromIndex = target.slice(index);
      if (fromIndex.startsWith(sub)) {
        const nextIndex = index + sub.length;
        const newValues = element.map((el) => [...el, sub]);

        table[nextIndex].push(...newValues);
      }
    }
  }

  return table[target.length];
};
