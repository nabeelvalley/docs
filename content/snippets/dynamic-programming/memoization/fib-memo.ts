export const fib = (n: number, memo: Record<number, number> = {}): number => {
  if (n in memo) return memo[n];

  // rest of existing implementation with passing the memo
  if (n <= 2) return 1;
  const result = fib(n - 1, memo) + fib(n - 1, memo);

  // memoize the existing value and return it
  memo[n] = result;
  return result;
};
