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

type Message = {
  created: Date
  message: string
  points: number

  from: Sender
  to: Receiver
}

type SendMessage = (message: Message) => void

export default {}
