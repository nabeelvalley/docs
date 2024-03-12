type Email = `${string}@${string}.${string}`

type User<T extends string> = {
  type: T

  username: string
  email: Email
}

type UnverifiedUser = User<'unverified'>

type Employee = User<'employee'> & {
  points: number
}

type Manager = User<'manager'> & {
  points: number
}

type Sender = Manager | Employee
type Receiver = Employee

type PendingMessage = {
  message: string
  points: number

  from: Sender
  to: Receiver
}

type Validated<T> = { validated: T }

type ValidationResult<T> = Validated<T> | undefined

type ValidatedMessage = {
  message: string

  points: Validated<number>
  from: Validated<Sender>
  to: Validated<Receiver>
}

type SendMessage = (message: ValidatedMessage) => void

const validated = <T>(value: T): Validated<T> => ({ validated: value })

const validatePoints = (points: number): ValidationResult<number> => {
  if (points <= 0) {
    return undefined
  }

  return validated(points)
}

const validateSender = (
  points: number,
  sender: Sender
): ValidationResult<Sender> => {
  if (sender.points < points) {
    return undefined
  }

  return validated(sender)
}

const validateReceiver = (receiver: Employee): ValidationResult<Receiver> => {
  return validated(receiver)
}

const validateMessage = (
  message: PendingMessage
): ValidationResult<ValidatedMessage> => {
  const points = validatePoints(message.points)
  const sender = validateSender(message.points, message.from)
  const receiver = validateReceiver(message.to)

  const allValid = points && sender && receiver
  if (!allValid) {
    return undefined
  }

  return validated({
    message: message.message,
    points,
    from: sender,
    to: receiver,
  })
}

export default {}
