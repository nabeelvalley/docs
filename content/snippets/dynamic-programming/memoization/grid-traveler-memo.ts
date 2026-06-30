const getKey = (m: number, n: number) => `${m},${n}`;

export const gridTraveler = (
  m: number,
  n: number,
  memo: Record<string, number> = {}
): number => {
  const key = getKey(m, n);

  if (key in memo) return memo[key];

  if (m == 1 && n == 1) return 1;
  if (m == 0 || n == 0) return 0;

  const result = gridTraveler(m - 1, n, memo) + gridTraveler(m, n - 1, memo);

  memo[key] = result;
  return result;
};
