module.exports = function (config) {
  config.addPassthroughCopy("assets")

  return {
    dir: {
      input: "content",
    },
  }
}
