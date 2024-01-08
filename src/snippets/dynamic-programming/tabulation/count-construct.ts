export const countConstruct = (target: string, subs: string[]): number => {
  const table = new Array<number>(target.length + 1).fill(0);
  table[0] = 1;

  for (let index = 0; index <= target.length; index++) {
    if (table[index]) {
      for (const sub of subs) {
        const fromIndex = target.slice(index);
        if (fromIndex.startsWith(sub)) {
          const nextIndex = index + sub.length;
          table[nextIndex] += table[index];
        }
      }
    }
  }

  return table[target.length];
};
