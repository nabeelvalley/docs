import { format } from 'date-fns'

export default () => {
  return {
    buildDate: format(new Date(), 'dd MMMM yyyy'),
  }
}
