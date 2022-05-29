const dateLen = (num) => {
  if (num < 9) {
    return '0' + num
  }

  return num
}

module.exports = (plop) => {
  const folder = {
    type: 'input',
    name: 'folder',
    message: 'docs folder to add file to',
  }

  const slug = {
    type: 'input',
    name: 'slug',
    message: 'slug for the docs file',
  }

  const title = {
    type: 'input',
    name: 'title',
    message: 'page title',
  }

  const description = {
    type: 'input',
    name: 'description',
    message: 'page description',
  }

  const date = new Date()

  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ]

  const day = dateLen(date.getDate())
  const month = dateLen(date.getMonth() + 1)
  const monthName = months[date.getMonth()]
  const year = date.getFullYear()

  const mdTemplate = '[[toc]]'
  const jsonTemplate = JSON.stringify(
    {
      title: '{{title}}',
      subtitle: `${day} ${monthName} ${year}`,
      description: '{{description}}',
    },
    null,
    2
  )

  plop.setGenerator('docs', {
    description: 'Create a new docs page',
    prompts: [folder, slug, title, description],
    actions: [
      {
        type: 'add',
        path: 'src/content/docs/{{folder}}/{{slug}}.md',
        template: mdTemplate,
      },
      {
        type: 'add',
        path: 'src/content/docs/{{folder}}/{{slug}}.json',
        template: jsonTemplate,
      },
    ],
  })

  plop.setGenerator('stdout', {
    description: 'Create a new stdout page',
    prompts: [slug, title, description],
    actions: [
      {
        type: 'add',
        path: `src/content/stdout/${year}/${day}-${month}/{{slug}}.md`,
        template: mdTemplate,
      },
      {
        type: 'add',
        path: `src/content/stdout/${year}/${day}-${month}/{{slug}}.json`,
        template: jsonTemplate,
      },
    ],
  })

  plop.setGenerator('blog', {
    description: 'Create a new blog page',
    prompts: [slug, title, description],
    actions: [
      {
        type: 'add',
        path: `src/content/blog/${year}/${day}-${month}/{{slug}}.md`,
        template: mdTemplate,
      },
      {
        type: 'add',
        path: `src/content/blog/${year}/${day}-${month}/{{slug}}.json`,
        template: jsonTemplate,
      },
    ],
  })
}
