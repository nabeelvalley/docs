export const canConstruct = (target: string, subs: string[]): boolean => {
  const table = new Array<boolean>(target.length + 1).fill(false);
  table[0] = true;

  for (let index = 0; index <= target.length; index++) {
    if (table[index]) {
      for (const sub of subs) {
        const fromIndex = target.slice(index);
        if (fromIndex.startsWith(sub)) {
          const nextIndex = index + sub.length;
          table[nextIndex] = true;
        }
      }
    }
  }

  return table[target.length];
};
