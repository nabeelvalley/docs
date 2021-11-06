const showdown = require('showdown')
const { convertMarkdownToHtml } = require('./lib/markdown')

module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy('assets')
  eleventyConfig.setLibrary('md', { render: convertMarkdownToHtml })

  return {
    dir: {
      input: 'content',
    },
  }
}
