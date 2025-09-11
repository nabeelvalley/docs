// helper type just for prettifying things
export type Simplify<T> = T extends any[] | Date | string | number | boolean
  ? T
  : {
    [K in keyof T]: Simplify<T[K]>;
  } & {};

declare const EuroBrand: unique symbol

type Euro = number & { [EuroBrand]: true }

declare const TransferAmounBrand: unique symbol

type TransferAmount = Euro & { [TransferAmounBrand]: true }

// We can create a Euro value from any number
function euro(value: number): Euro {
    return value as Euro
}

// We can check if a Euro value is a Valid Transfer Amount
function isTransferAmount(amount: Euro): amount is TransferAmount {
    return amount > 0 && amount < 1_000_000
}

// We can use the existing implementation of `isTransferAmount`
function assertTransferAmount(amount: Euro): asserts amount is TransferAmount {
    if (amount > 0 && amount < 1_000_000) {
        return
    }

    throw new Error("Invalid amount received")
}

function doSomething(amount: Euro) {
    if (isTransferAmount(amount)) {
        // No Error
        const valid: TransferAmount = amount
    }

    // @ts-expect-error Error: Type 'Euro' is not assignable to type 'TransferAmount'
    const invalid: TransferAmount = amount
}

function doSomethingOrThrow(amount: Euro) {
    assertTransferAmount(amount)

    // would have thrown if not a valid TransferAmount
    const valid: TransferAmount = amount

    console.log(valid.toFixed(2))
}

// a model is something with an id
interface Model {
    id: unknown
}

// a "reference" is based on the type of the id of a Model
// the `extends` keyword here works as a constraint
type Reference<M extends Model> = M['id']

// very similar to a generic function that would do the same
function reference<M extends Model>(model: M): Reference<M> {
    return model.id
}

type AccountModel = {
    id: `ACC-${number}`
}

type AccountRef = Reference<AccountModel>

// similarly we can preload the generic function
const accountReference = reference<AccountModel>
//    ^? (model: AccountModel) => Reference<AccountModel>

type Confirmation = 'pending' | 'accepted' | 'denied'

type TransferForm = {
    amount: TransferAmount
    accountFrom: AccountRef
    accountTo: AccountRef
    confirmation: Confirmation
}

type TransferFormFields = keyof TransferForm
//   ^? 'amount' | 'accountFrom' | 'accountTo' | 'confirmation'

type TransferFormLabels = {
    // consists of mapping some set of keys to some set of values
    [K in keyof TransferForm]: Capitalize<K>
}

// this is the only valid value for `labels` according to this type definition
const labels: TransferFormLabels = {
    amount: 'Amount',
    accountFrom: 'AccountFrom',
    accountTo: 'AccountTo',
    confirmation: 'Confirmation'
}

type IsNumber<X> = X extends number ? 'yes' : 'no'
// kind of like:   x => typeof x == 'number' ? 'yes' : 'no' 

type Is5Number = IsNumber<5>
//   ^? 'yes'

type IsTrueNumber = IsNumber<true>
//   ^? 'no'

type PrefixOf<S> = S extends `${infer S}_${string}` ? S : never
// like asking the compiler:                    ^ what goes here to make this true

type HelloPrefix = PrefixOf<"hello_world">
//   ^? "hello"
// 
type ByePrefix = PrefixOf<"bye_world">
//   ^? "bye"

function hasX(arr: string[]): boolean {
    if (arr.length > 0) {
        const [first, ...rest] = arr

        return first === 'x' ? true : hasX(rest)
    } else {
        return false
    }
}

const axcHasX = hasX(['a', 'x', 'c'])
//    ?^ true

const abcHasX = hasX(['a', 'b', 'c'])
//    ?^ false

type HasX<Arr> =
    Arr extends [infer First, ...infer Rest]
    ? First extends 'x'
    ? true
    : HasX<Rest>
    : false

type AXCHasX = HasX<['a', 'x', 'c']>
//   ?^ true

type ABCHasX = HasX<['a', 'b', 'c']>
//   ?^ false

// multi step form

// Each step has the name of the step + the data that results from that step
// if the data is not present it means the step is not complete
export type Step<
  Label extends string = string,
  Data extends Record<string, unknown> = Record<string, unknown>,
> =
  {
    label: Label;
    data: Data
  }

export type InitStep = Step<'Init', {}>
export type AmountStep = Step<'Amount', Pick<TransferForm, 'amount'>>;
export type AccountStep = Step<'Accounts', Pick<TransferForm, 'accountFrom' | 'accountTo'>>;
export type ConfirmationStep = Step<'Confirmation', Pick<TransferForm, 'confirmation'>>;
export type CompleteStep = Step<'Complete', {}>

type EndTransition<P, N> =
  P extends Step
  ? N extends Step
  ? ({
    label: N['label'];
    data: P['data'] & N['data'];
  })
  : never
  : never

type StartTransition<P, N> =
  P extends Step
  ? N extends Step
  ? ({
    label: N['label'];
    data: P['data']
  })
  : never
  : never

const amount = euro(10)
assertTransferAmount(amount)

const accountFrom: AccountModel = { id: 'ACC-1' }
const accountTo: AccountModel = { id: 'ACC-2' }
const confirmation: Confirmation = 'pending'

const initStep: InitStep = {
  label: 'Init',
  data: {}
}
const amountStep: AmountStep = {
  label: 'Amount',
  data: {
    amount,
  }
}
const accountStep: AccountStep = {
  label: 'Accounts',
  data: {
    accountFrom: accountReference(accountFrom),
    accountTo: accountReference(accountTo),
  }
}
const confirmationStep: ConfirmationStep = {
  label: 'Confirmation',
  data: {
    confirmation,
  }
}
const completeStep: CompleteStep = {
  label: 'Complete',
  data: {}
}

function multiStepFormStates(steps: Step[], merged: Step[] = [steps[0]]) {
  // we have no more states to merge, so we just return what we currently have
  if (steps.length < 2) {
    return merged
  }

  const [current, next, ...rest] = steps

  // each state starts off with only the data from a previous state
  const start: Step = {
    label: next.label,
    data: {
      ...current.data,
    }
  }

  // each step builds on the end state of the next state
  const end: Step = {
    label: next.label,
    data: {
      ...current.data,
      ...next.data
    }
  }

  return multiStepFormStates(
    [end, ...rest],
    [...merged, start]
  )
}

console.log("possible steps", multiStepFormStates(
  [
    initStep,
    amountStep,
    accountStep,
    confirmationStep,
    completeStep
  ],
))

// [
//   {
//     "label": "Init",
//     "data": {}
//   },
//   {
//     "label": "Amount",
//     "data": {}
//   },
//   {
//     "label": "Accounts",
//     "data": {
//       "amount": 100
//     }
//   },
//   {
//     "label": "Confirmation",
//     "data": {
//       "amount": 100,
//       "accountFrom": "ACC-1",
//       "accountTo": "ACC-2"
//     }
//   },
//   {
//     "label": "Complete",
//     "data": {
//       "amount": 100,
//       "accountFrom": "ACC-1",
//       "accountTo": "ACC-2"
//     }
//   }
// ]


type MultiStepFormStates<Steps extends Step[], Merged extends Step[] = [Steps[0]]> = Steps extends [
  infer Current,
  infer Next,
  ...infer Rest,
]
  ? Rest extends Step[]
    // recursive "call" to the "type function"
    ? MultiStepFormStates<
      // use the completed state of the current phase as the starting point for the next
      [EndTransition<Current, Next>, ...Rest],
      // store the start of each step as this is what the step will have
      [...Merged, StartTransition<Current, Next>]
    >
    // rest does not contain steps, this should `never` happen
    : never
  // processed all items, return final result
  : Merged[number]

export type TransferFormState = MultiStepFormStates<
  [InitStep, AmountStep, AccountStep, ConfirmationStep, CompleteStep]
>;

export type FormSteps = TransferFormState['label'][]

