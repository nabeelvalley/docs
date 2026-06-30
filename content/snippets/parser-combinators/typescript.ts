// Library

/**
 * A parser can be defined as a generic that has the following result: `Parser<T> = [Parsed, Rest] | Err`
 */

type Err<Expected extends string, Found extends string> = {
  expected: Expected;
  found: Found;
};

type Parsed<Label extends string, Value> = {
  label: Label;
  value: Value;
};

/**
 * Parse the given string
 */
export type Str<
  Input extends string,
  Match extends string,
  Label extends string = Match
> = Input extends `${Match}${infer R}`
  ? [Parsed<Label, Match>, R]
  : Err<Match, Input>;

// Tests

// example of a parser
type ParseA<T extends string> = Str<T, "a", "lowercase a">;

type ParsesSingleCharacter = Expect<
  Equal<
    ParseA<"abc">,
    [
      {
        label: "lowercase a";
        value: "a";
      },
      "bc"
    ]
  >
>;

// Test utils
// > From https://github.com/type-challenges/type-challenges/blob/main/utils/index.d.ts
type Expect<T extends true> = T;

type Equal<X, Y> = (<T>() => T extends X ? 1 : 2) extends <T>() => T extends Y
  ? 1
  : 2
  ? true
  : false;
