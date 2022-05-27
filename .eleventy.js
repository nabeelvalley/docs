const { markdownLibrary } = require('./_11ty/lib/markdown')

const linkGridShortcode = (content, columns = 2) => {
  return `<section class="link__grid" style="grid-template-colums: repeat(${columns}, 1fr);"> 
    ${content}
  </section>
  `
}

const linkShortcode = (
  content = '',
  name,
  link,
  description,
  headingLevel = 3
) => {
  const subheadingLevel = headingLevel - 1 || 2
  return `
    <a class="link__card" href="${link}" target="_blank" rel="noopener noreferrer">
      <h${headingLevel} class="link__title">${name}</h${headingLevel}>
      <h${subheadingLevel} class="link__subtitle">${description}</h${subheadingLevel}>
      <div class="link__content">${content}</div>
    </a>
  `
}

const linkTagShortcode = (tag) => {
  return `<li class="link__tag">${tag}</li>`
}

const titleShortcode = (title, headingLevel = 1) => {
  return `<h${headingLevel} class="title__wrapper"><span class="title__text">${title}</span></h${headingLevel}>`
}

module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy('assets')
  eleventyConfig.addPassthroughCopy('content', '.')

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

  eleventyConfig.addPairedShortcode('linkGrid', linkGridShortcode)
  eleventyConfig.addPairedShortcode('link', linkShortcode)
  eleventyConfig.addShortcode('linkTag', linkTagShortcode)
  eleventyConfig.addShortcode('title', titleShortcode)

  eleventyConfig.setLibrary('md', markdownLibrary)

  return {
    dir: {
      input: 'content',
      includes: '../_11ty/includes',
      data: '../_11ty/data',
    },
  }
}
