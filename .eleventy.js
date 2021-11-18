const showdown = require('showdown')
const { convertMarkdownToHtml } = require('./lib/markdown')

module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy('assets')
  eleventyConfig.setLibrary('md', { render: convertMarkdownToHtml })

  eleventyConfig.addCollection('search', (collection) => {
    const result = collection.getAll().map((c) => {
      return {
        title: c.data && c.data.title,
        subtitle: c.data && c.data.subtitle,
        content: c.template && c.template.inputContent,
        url: c.url,
      }
    })

    return result
  })

  return {
    dir: {
      input: 'content',
    },
  }
}
