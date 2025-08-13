// helper type just for prettifying things
export type Simplify<T> = T extends any[] | Date
    ? T
    : {
        [K in keyof T]: T[K];
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
type Step<Name extends string = string, Data = unknown> = {
    name: Name,
    data: Data
}

type InitialStep = Step<'initial', {}>

type AmountStep = Step<'amount', Pick<TransferForm, 'amount'>>
//   ^? { name: 'amount', data: { amount: TransferAmount } }

type AccountStep = Step<'account', Pick<TransferForm, 'accountFrom' | 'accountTo'>>
//   ^? { name: 'account', data: { accountFrom : AccountRef, accountTo: AccountRef } }

type ConfirmationStep = Step<'confirmation', Pick<TransferForm, 'confirmation'>>
//   ^? { name: 'confirmation', data: { confirmation: Confirmation } }

const amount = euro(10)
assertTransferAmount(amount)

const accountFrom: AccountModel = {
    id: 'ACC-1'
}

const accountTo: AccountModel = {
    id: 'ACC-1'
}

const step0: TransferFormState = {
    name: 'initial',
    data: {}
}

const step1: TransferFormState = {
    name: 'amount',
    data: {
        ...step0.data,
        amount,
    }
}

const step2: TransferFormState = {
    name: 'account',
    data: {
        ...step1.data,
        accountFrom: accountReference(accountFrom),
        accountTo: accountReference(accountTo),
    }
}

const step3: TransferFormState = {
    name: 'confirmation',
    data: {
        ...step2.data,
        confirmation: 'accepted'
    }
}

const state = step3

// we can now do state name checks
if (state.name === 'confirmation') {
    // valid states mean we don't need to re-validate
    console.log("form is completely filled", state)
}

type MergeSteps<Current extends Step, Previous extends Step> = {
    // the name is for the step we're currently on
    name: Current['name'],
    // data adds onto the previous step
    data: Previous['data'] & Current['data']
}

// the distinct states for our form
type MultiStepFormStates<Current extends Step, Steps extends Step[]> =
    // infer to extract the steps
    Steps extends [infer Next, ...infer Rest]
    // verify that the inferred steps are defined
    ? Next extends Step
    ? Rest extends Step[]
    // merge Current State with Next State
    ? Current | MultiStepFormStates<MergeSteps<Next, Current>, Rest>
    // no next state, return currrent state
    : Current
    : Current
    // steps is empty, return current
    : Current

type TransferFormState = MultiStepFormStates<InitialStep, [
    AmountStep,
    AccountStep,
    ConfirmationStep
]>
