const { format } = require('date-fns')

module.exports = () => {
  return {
    buildDate: format(new Date(), 'dd MMMM yyyy'),
  }
}
