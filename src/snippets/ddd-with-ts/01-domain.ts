type User = {
  username: string

  email: string
  isEmailVerified: boolean

  points: number

  isManager: boolean
}

type Message = {
  created: Date
  message: string
  points: number

  from: User
  to: User
}

type SendMessage = (message: Message) => void

export default {}
