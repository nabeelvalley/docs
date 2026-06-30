export const fib = (n: number): number => {
  const table = new Array(n + 1).fill(0);
  table[1] = 1;

  // A possible footgun here is increasing the size of the table
  // accidentially in the body and still refering to it in the for
  // condition, hence why we are referencing the input value of n instead
  for (let index = 0; index <= n; index++) {
    const element = table[index];

    const index1 = index + 1;
    if (index1 in table) table[index1] += element;

    const index2 = index + 2;
    if (index2 in table) table[index2] += element;
  }

  return table[n];
};
