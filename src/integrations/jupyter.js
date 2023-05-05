const check = (...args) => {
  console.log('check', args)

  return true
}

const renderToStaticMarkup = (...args) => {
  console.log('renderstatic', args)

  return 'Hello World'
}

export default {
  check,
  renderToStaticMarkup,
}
