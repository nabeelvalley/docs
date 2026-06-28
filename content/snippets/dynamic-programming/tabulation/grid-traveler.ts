export const gridTraveler = (m: number, n: number): number => {
  const table = new Array(m + 1)
    .fill(undefined)
    .map(() => new Array<number>(n + 1).fill(0));

  table[1][1] = 1;

  for (let indexM = 0; indexM <= m; indexM++) {
    for (let indexN = 0; indexN <= n; indexN++) {
      const element = table[indexM][indexN];

      if (indexM < m) table[indexM + 1][indexN] += element;
      if (indexN < n) table[indexM][indexN + 1] += element;
    }
  }

  return table[m][n];
};
