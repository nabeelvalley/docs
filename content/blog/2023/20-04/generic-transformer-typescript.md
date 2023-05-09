```ts
/**
 * Define a formatter that can take in a generic object type and format each entry of that object
 */
export type PropertyFormatter<T> = {
  [K in keyof T]?: T[K] extends Primitive
    ? (val: T[K]) => T[K]
    : PropertyFormatter<T[K]> | ((val: T[K]) => T[K]);
};

type FormatBuilder<T> = (formatter: PropertyFormatter<T>) => (val: T) => T;

type Person = {
  name: {
    first: string;
    last: string;
    yearOfBirth: number;
  };
  complex: {
    thing: boolean;
  };
  age: number;
};

type PersonFormatter = PropertyFormatter<Person>;

export const personProperyFormatter: PersonFormatter = {
  age: (age) => age,
  name: {
    last: (val) => val.trim(),
    first: (val) => val.trim(),
  },
  complex: (val) => ({
    thing: !val.thing,
  }),
};

// implementation of format builder/executor left as an excercise to the reader
export const personFormatBuilder = {} as FormatBuilder<Person>;
export const personFormatter = personFormatBuilder(personProperyFormatter);

export const formatted = personFormatter({
  name: {
    first: '',
    last: '',
    yearOfBirth: 12,
  },
  complex: {
    thing: true,
  },
  age: 12,
});
```