---
published: true
title: Generic Object Property Formatter and Validator using Typescript
subtitle: 09 May 2023
description: A statically typed, generic method for formatting and validating javascript objects for interchange across system boundaries
---

---
title: Generic Object Property Formatter and Validator using Typescript
subtitle: 09 May 2023
description: A statically typed, generic method for formatting and validating javascript objects for interchange across system boundaries
published: true
---

At times there's a need for transforming specific object properties from an input format to some specific output, this can be done using the following code in some generic means

# The Concept of a Schema

The concept of a schema to be used for formatting some data can be defined as follows

```ts
export type Primitive = string | number | boolean | Symbol | Date;

 /** * Define a formatter that can take in a generic object type and format each entry of that object */
export type FormatterSchema<T> = {
  [K in keyof T]?: T[K] extends Primitive
    // if the value is primitive then we can just transform it using a simple function
    ? (val: T[K]) => T[K]
    // if it's an object then it should either be a formatter schema or a transformer function
    : FormatterSchema<T[K]> | ((val: T[K]) => T[K]);
};
```

# An Interpreter

The implementation of an interpreter that satisfies the above can done as follows:

```ts
type Formatter<T> = (val: T) => T;
const isFormatterFn = <T>(
  formatter: FormatterSchema<T>[keyof T]
): formatter is Formatter<T[keyof T]> => typeof formatter === 'function';

const isFormatterObj = <T>(
  formatter: FormatterSchema<T>[keyof T]
): formatter is Exclude<Formatter<T[keyof T]>, Function> => typeof formatter === 'object';

export const interpret =
  <T>(schema: FormatterSchema<T>): Formatter<T> =>
  (val) => {
    const keys = Object.keys(schema) as Array<keyof T>;
    return keys.reduce<T>((prev, key) => {
      const keySchema = schema[key];
      const keyVal = val[key];

      const isSchemaFn = isFormatterFn(keySchema);
      if (isSchemaFn) {
        return {
          ...prev,
          [key]: keySchema(keyVal),
        };
      }

      const isSchemaObj = isFormatterObj(keySchema);
      if (isSchemaObj) {
        return {
          ...prev,
          [key]: interpret(keySchema)(keyVal),
        };
      }

      return prev;
    }, val);
  };
```

# Transformers

We can define some general transformers, for example:

```ts
const trunc = Math.trunc;

const round = Math.round;

const length = (len: number) => (val: string) => val.slice(0, len);

const trim = (val: string) => val.trim();

const constant =
  <T>(val: T) =>
  () =>
    val;

const optional =
  <T>(fn: (val: T) => T) =>
  (val?: T) =>
    val === undefined ? undefined : fn(val);

export const formatter = {
  trunc,
  round,
  length,
  trim,
  constant,
  optional,
};
```

# Usage

For the sake of example we can define a data type to use

```ts
type User = {
  name: string,
  location: {
    address: string,
    city: string,
    gps?: [number, number]
  }
}

const user : User = {
  name: 'Bob Smithysmithson',
  location: {
    city: 'Somewhere secret',
    address: '123 Secret street',
    gps: [123, 456]
  }
}
```

## Using as a Transformer

We can use the above by defining the transformer and using it to transform the input data according to the defined schema

```ts
const format = interpret<User>({
  name: formatter.length(10),
  location: {
    city: (val) => ['Home', 'Away'].includes(val) ? val : 'Other',
    gps: (val) => isValidGPS(val) ? val : undefined,
  }
})

const result = format(user)

console.log(result)
// {
//   name: 'Bob Smithy',
//   location: {
//     city: 'Other',
//     adddtess: '123 Secret street',
//     gps: undefined,
//   }  
// }
```


## Using as a Validator

Using the same principal as above we can use it for validaing data. Validation can be done by throwing in the transformer function

```ts
const validate = interpret<User>({
  name: (val) => {
    if (val.length > 5) {
      throw "Length too long"
    }

    return val
  }
})

// throws with Length too long
validate({
  name: "Jack Smith"
})
```

# Exploration

It may be worth taking the concept and expanding it into a more fully fledged library with a way to handle validations more simply or to provide more builtin transformers and validators but for the moment it can be stated that there are enough javascript libraries for validation and the formatter alone is likely of limited value but may be worth exploring further if gaps in the existing technology are found

Regardless of the utility of the particular type above I think the concept and types give some insight into how one can build out a library as the ones discussed above

# Working Example

> A working playground with the code from here can be found at [The Typescript Playground](https://www.typescriptlang.org/play?jsx=0&module=1#code/KYDwDg9gTgLgBDAnmYcAKUCWBbTNMBuqAvHAM4xYB2A5nAD5xUCu2ARsFA3GxBADbAAhlW4BlROwHcAIkJjAA3AChlcAPQAqTXB0zgAM0xVUQuAejZ5CrjAAW8uAGMRCIQGtUxuGZrATWE5wEGwAVsBO8EgoPlQAJuaWjsJOdnD+lIjBBggO8CHhkbrqyqCQsAjIqABiSTA2YqnAVgA8ACoAfHCkAN5qcADaANJw3p6IEDltALoA-ABccG3D0+kgCvFk6Fi4+ET9cBrqozn2qARC-MxeW2A7eISoZ6IA7qguoqHMFAhQImQWKDYUbwb7GOhmMg4MCCczMKiRTAQKgHOCzOAACgu-EWyyG0wAlN0unjpqj1MdMDk8AByLauAoRKJ2fwg8h2CDMfgJYB4FlcDg+RJA6ycchNKzBLhmSj-QHYMUGeGI5Goxa1EX1TiNFmtUldRgYrGXXErInEElmlQAXxUymiNTqNnaXVIxpxS3NJJUTmRP0wZA1Vi1UGqolILox-Xloqg6qd2olQhdA3GkyWZIJixjIdGWyDsfaqeAEym01dXQd6ZzNm6xFINKVCPwyJpdt9VH9gYTUAA8mFunBI9Ge-HNQ0kym02XlFnhcHawG4ABREBOK5xYAtAshovTjMdAA0cGqypbVArlRQ1Z7dYbjMibdUZWg8A7-qoNjuwHgxH6kbIJMxwXRNdWTTo5x3Z1OmJfp3S9OA+kOQ533gcYtlIftChgAA6dCMUAsCiSELYAEEoD+RAWn3ToVGQuAoB-ZgoFEdCcMYuJmCcLdOiNb8CGPcYEKQ+jnD9NCSx1ZozFIQjpOLRBpjo0TULgcYADVLkHbEFKU1RRLEzt4ADKSrDDQcAygzgwwxcZTKEAllPoqlMRMpMwyJESDMYmBmNELyDLgHDgv4w9UQM3TFjspNbJLTT+AJMLArgW1wpS-SVPEvN7Kwizu3HTgsNixB7MctKXIxNywKwzy0sOHy-MQurkOCnDQuaw5ItGT9OG-GBitK4r4sS5rUoM60MvohqWLgfinJS49sTKw5Uv6d8BGAHD+AgGhKp6qA+oJVRVMoZVBwAWXkOwcNOhF2yyqBOXiC6rvYp64nuoy4EEWh7EHDEfsWFh2E4BD3UWChqBoBDsRwsh+EwbiMQABmPH6yuUE6dn+7EIcocEYcuG6dgxDHVNQkRf3-Xjcc9WDDlJ+nkOxT6fggMBzy0v9DkjAwqEWcG6YtIWOjg7EFhF1FsTvOB4U3IwTASdE5cMYxgASbMqHgu0XwqVSazFXp+lupwkoY96zZ+mh7DN-HsDNinPzN9nOf4MLVodOAAFUyENprDioIQFTxqHLYgFxz0WAKhDiOJGLIMgQ-BM2ULwRAk9oFO4BoMAyAlgZgY4KBj0LzgyRW5QJsxrKA3izA4gAcTQMQccufPS+LphWCLwliXMS5fdZ+Acws-a+paH3OA6DERMD4P51jLb-GtuwMQARmRkbDm2iOkX5-3kKcNOBaWvuBhpAAJCAFRpY8aVIl4hEQGlphw4x12YTcyHgtE4GlxYaS9jOFAW+qIc6J0xKfYWtdLj1ybmIH+6J-6y3iKrRWZsJrWiOtXL63wxSLEnlwI2Acg7AAAQAIRCHAMQuw7CIDILQsgrYw672RFHVER8kAALENfYALx+SoF9k4HyoD6IxzjsABOAC14ACYADM1CIg+XIJQYAP5RHIXAYsAYsi5HHgACwAFYABs5d0pV1UvHLkv4F79TwVAbB61BBbR2hiKx-AYCOKytieu8gSDdS-D5CevsoDT1nqQk+lxhKogqrDK2f0uiGNqgZewj0XhwAAEQABll5-RgHwb6yIaAZNRFXKaTEZrYn6Jg7BFJchpK2C8PkTBSEIAKdtWgygfFxD8RiexBIgA)


<iframe height="600px" width="100%" src="https://www.typescriptlang.org/play?jsx=0&module=1#code/KYDwDg9gTgLgBDAnmYcAKUCWBbTNMBuqAvHAM4xYB2A5nAD5xUCu2ARsFA3GxBADbAAhlW4BlROwHcAIkJjAA3AChlcAPQAqTXB0zgAM0xVUQuAejZ5CrjAAW8uAGMRCIQGtUxuGZrATWE5wEGwAVsBO8EgoPlQAJuaWjsJOdnD+lIjBBggO8CHhkbrqyqCQsAjIqABiSTA2YqnAVgA8ACoAfHCkAN5qcADaANJw3p6IEDltALoA-ABccG3D0+kgCvFk6Fi4+ET9cBrqozn2qARC-MxeW2A7eISoZ6IA7qguoqHMFAhQImQWKDYUbwb7GOhmMg4MCCczMKiRTAQKgHOCzOAACgu-EWyyG0wAlN0unjpqj1MdMDk8AByLauAoRKJ2fwg8h2CDMfgJYB4FlcDg+RJA6ycchNKzBLhmSj-QHYMUGeGI5Goxa1EX1TiNFmtUldRgYrGXXErInEElmlQAXxUymiNTqNnaXVIxpxS3NJJUTmRP0wZA1Vi1UGqolILox-Xloqg6qd2olQhdA3GkyWZIJixjIdGWyDsfaqeAEym01dXQd6ZzNm6xFINKVCPwyJpdt9VH9gYTUAA8mFunBI9Ge-HNQ0kym02XlFnhcHawG4ABREBOK5xYAtAshovTjMdAA0cGqypbVArlRQ1Z7dYbjMibdUZWg8A7-qoNjuwHgxH6kbIJMxwXRNdWTTo5x3Z1OmJfp3S9OA+kOQ533gcYtlIftChgAA6dCMUAsCiSELYAEEoD+RAWn3ToVGQuAoB-ZgoFEdCcMYuJmCcLdOiNb8CGPcYEKQ+jnD9NCSx1ZozFIQjpOLRBpjo0TULgcYADVLkHbEFKU1RRLEzt4ADKSrDDQcAygzgwwxcZTKEAllPoqlMRMpMwyJESDMYmBmNELyDLgHDgv4w9UQM3TFjspNbJLTT+AJMLArgW1wpS-SVPEvN7Kwizu3HTgsNixB7MctKXIxNywKwzy0sOHy-MQurkOCnDQuaw5ItGT9OG-GBitK4r4sS5rUoM60MvohqWLgfinJS49sTKw5Uv6d8BGAHD+AgGhKp6qA+oJVRVMoZVBwAWXkOwcNOhF2yyqBOXiC6rvYp64nuoy4EEWh7EHDEfsWFh2E4BD3UWChqBoBDsRwsh+EwbiMQABmPH6yuUE6dn+7EIcocEYcuG6dgxDHVNQkRf3-Xjcc9WDDlJ+nkOxT6fggMBzy0v9DkjAwqEWcG6YtIWOjg7EFhF1FsTvOB4U3IwTASdE5cMYxgASbMqHgu0XwqVSazFXp+lupwkoY96zZ+mh7DN-HsDNinPzN9nOf4MLVodOAAFUyENprDioIQFTxqHLYgFxz0WAKhDiOJGLIMgQ-BM2ULwRAk9oFO4BoMAyAlgZgY4KBj0LzgyRW5QJsxrKA3izA4gAcTQMQccufPS+LphWCLwliXMS5fdZ+Acws-a+paH3OA6DERMD4P51jLb-GtuwMQARmRkbDm2iOkX5-3kKcNOBaWvuBhpAAJCAFRpY8aVIl4hEQGlphw4x12YTcyHgtE4GlxYaS9jOFAW+qIc6J0xKfYWtdLj1ybmIH+6J-6y3iKrRWZsJrWiOtXL63wxSLEnlwI2Acg7AAAQAIRCHAMQuw7CIDILQsgrYw672RFHVER8kAALENfYALx+SoF9k4HyoD6IxzjsABOAC14ACYADM1CIg+XIJQYAP5RHIXAYsAYsi5HHgACwAFYABs5d0pV1UvHLkv4F79TwVAbB61BBbR2hiKx-AYCOKytieu8gSDdS-D5CevsoDT1nqQk+lxhKogqrDK2f0uiGNqgZewj0XhwAAEQABll5-RgHwb6yIaAZNRFXKaTEZrYn6Jg7BFJchpK2C8PkTBSEIAKdtWgygfFxD8RiexBIgA" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>