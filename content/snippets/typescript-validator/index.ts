export type Primitive = string | number | boolean | Symbol | Date

/** * Define a formatter that can take in a generic object type and format each entry of that object */
export type FormatterSchema<T> = {
  [K in keyof T]?: T[K] extends Primitive
    ? // if the value is primitive then we can just transform it using a simple function
      (val: T[K]) => T[K]
    : // if it's an object then it should either be a formatter schema or a transformer function
      FormatterSchema<T[K]> | ((val: T[K]) => T[K])
}

type Formatter<T> = (val: T) => T
const isFormatterFn = <T>(
  formatter: FormatterSchema<T>[keyof T]
): formatter is Formatter<T[keyof T]> => typeof formatter === 'function'

const isFormatterObj = <T>(
  formatter: FormatterSchema<T>[keyof T]
): formatter is Exclude<Formatter<T[keyof T]>, Function> =>
  typeof formatter === 'object'

export const interpret =
  <T>(schema: FormatterSchema<T>): Formatter<T> =>
  (val) => {
    const keys = Object.keys(schema) as Array<keyof T>
    return keys.reduce<T>((prev, key) => {
      const keySchema = schema[key]
      const keyVal = val[key]

      const isSchemaFn = isFormatterFn(keySchema)
      if (isSchemaFn) {
        return {
          ...prev,
          [key]: keySchema(keyVal),
        }
      }

      const isSchemaObj = isFormatterObj(keySchema)
      if (isSchemaObj) {
        return {
          ...prev,
          [key]: interpret(keySchema)(keyVal),
        }
      }

      return prev
    }, val)
  }

console.log(interpret)

const trunc = Math.trunc

const round = Math.round

const length = (len: number) => (val: string) => val.slice(0, len)

const trim = (val: string) => val.trim()

const constant =
  <T>(val: T) =>
  () =>
    val

const optional =
  <T>(fn: (val: T) => T) =>
  (val?: T) =>
    val === undefined ? undefined : fn(val)

export const formatter = {
  trunc,
  round,
  length,
  trim,
  constant,
  optional,
}

type User = {
  name: string
  location: {
    address: string
    city: string
    gps?: [number, number]
  }
}

const isValidGPS = (val?: [number, number]) => false

const format = interpret<User>({
  name: formatter.length(10),
  location: {
    city: (val) => (['Home', 'Away'].includes(val) ? val : 'Other'),
    gps: (val) => (isValidGPS(val) ? val : undefined),
  },
})

const user: User = {
  name: 'Bob Smithysmithson',
  location: {
    city: 'Somewhere secret',
    address: '123 Secret street',
    gps: [123, 456],
  },
}

const result = format(user)

console.log(result)

const validate = interpret<User>({
  name: (val) => {
    if (val.length > 5) {
      throw 'Length too long'
    }

    return val
  },
})

// throws with name too long
validate(user)
