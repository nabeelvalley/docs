import { ResizingArrayStack } from "./resizing-array";

const operate = {
  "+": (a: number, b: number) => a + b,
  "-": (a: number, b: number) => a - b,
  "*": (a: number, b: number) => a * b,
  "/": (a: number, b: number) => a / b,
};

type Operator = keyof typeof operate;

const isDefined = <T>(val: T | undefined): val is T => val !== undefined;

const openParen = "(";
const closeParen = ")";

export const twoStackArithmetic = (strs: string[]) => {
  const values = new ResizingArrayStack<number>();
  const operators = new ResizingArrayStack<Operator>();

  for (const str of strs) {
    switch (str) {
      case openParen:
        break;

      case "+":
      case "-":
      case "*":
      case "/":
        operators.push(str);
        break;

      case closeParen:
        const b = values.pop();
        const a = values.pop();
        const op = operators.pop();

        const valid = isDefined(a) && isDefined(b) && isDefined(op);

        if (!valid) throw new Error("Invalid state");
        const result = operate[op](a, b);

        values.push(result);
        break;

      default:
        const value = parseInt(str);
        values.push(value);
        break;
    }
  }

  return values.pop();
};
