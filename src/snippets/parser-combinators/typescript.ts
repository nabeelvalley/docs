type Err<Expected extends string, Found extends string> = {
  expected: Expected;
  found: Found;
};

/**
 * Parse the given string
 */
type Str<T extends string, S extends string> = T extends `${S}${infer R}`
  ? [S, R]
  : Err<S, T>;

/**
 * A parser can be defined as a generic that has the following result: `Parser<T> => [Parsed, Rest] | Err`
 */
type ParseA<T extends string> = Str<T, "hello">;

type Parsed = ParseA<"hello world!">;
