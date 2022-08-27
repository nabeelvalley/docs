const matter = require('gray-matter')
const { readFile } = require('fs').promises
const glob = require('glob')
const { resolve, format } = require('path')
const _ = require('lodash')
const {
  convertJupyterToHtml,
  convertMarkdownToHtml,
} = require('../lib/markdown')
const { createRssFeed } = require('../lib/rss')

const getDirectoryName = (dir) => {
  const split = dir.split('/')
  const directory = split[split.length - 2]
  return directory
    .split('-')
    .map((d) => _.upperFirst(d))
    .join(' ')
}

const populatePaging = (meta, index, arr) => {
  return {
    ...meta,
    previous: arr[index - 1],
    next: arr[index + 1],
  }
}

const replaceYamlHeader = (content) => {
  content.replace(/^---(.|\n)*?---/gm, '')
}

const getFiles = (ext) => {
  const g = `content/**/*.${ext}`

  return new Promise((res, rej) => {
    glob(g, (err, matches) => {
      if (err) rej(err)
      else {
        const extRx = new RegExp(`\.${ext}$`)
        const result = matches
          .map((m) => ({
            path: m,
            directory: getDirectoryName(m),
            url: m.replace('content', '').replace(extRx, '') + '/',
            route: m.replace('content', '').replace(extRx, ''),
          }))
          .filter((m) => !m.route.endsWith('index'))
        res(result)
      }
    })
  })
}

const cwd = process.cwd()

const readMeta = async (data) => {
  const jsonPath = resolve(cwd, './content' + data.route + '.json')
  const mdPath = resolve(cwd, './content' + data.route + '.md')

  try {
    const content = await readFile(jsonPath)
    const meta = JSON.parse(content.toString())
    // if we have a json file then assume published
    return { published: true, ...meta, ...data }
  } catch {
    // do nothing
  }

  try {
    const content = await readFile(mdPath)
    const meta = matter(content)
    if (Object.keys(meta.data) < 1) {
      throw 'no meta'
    }
    // if we have frontmatter then assume published unless overwritten
    return { published: true, ...meta.data, ...data }
  } catch {
    // do nothing
  }

  return { ...data, published: false }
}

const readNotebook = async (path) => {
  const fullPath = resolve(__dirname, '../../', path)
  const content = await readFile(fullPath)

  return convertJupyterToHtml(content.toString())
}

const readMarkdown = async (path) => {
  const fullPath = resolve(__dirname, '../../', path)
  const content = await readFile(fullPath)

  return convertMarkdownToHtml(content.toString())
}

const sortByDate = (a, b) => {
  const dateA = new Date(a.subtitle)
  const dateB = new Date(b.subtitle)

  return dateB - dateA
}

module.exports = async function () {
  const md = await getFiles('md')
  const ipynb = await getFiles('ipynb')

  const content = [...md, ...ipynb]

  const parsed = await Promise.all(content.map(readMeta))
  const meta = parsed.filter((f) => f.published)

  const docs = meta
    .filter((m) => m.route.startsWith('/docs'))
    .map(populatePaging)
  const groupedDocs = Object.values(_.groupBy(docs, 'directory'))

  const blog = meta
    .filter((m) => m.route.startsWith('/blog'))
    .sort(sortByDate)
    .map(populatePaging)

  const random = meta
    .filter((m) => m.route.startsWith('/random'))
    .sort(sortByDate)
    .map(populatePaging)

  const photography = meta
    .filter((m) => m.route.startsWith('/photography'))
    .sort(sortByDate)
    .map(populatePaging)

  const nbPromises = meta
    .filter((m) => m.path.endsWith('.ipynb'))
    .map(async (m) => {
      const html = await readNotebook(m.path)

      return {
        ...m,
        html,
      }
    })

  const notebooks = await Promise.all(nbPromises)

  const allPages = [...blog, ...docs, ...photography]

  const rssPageTasks = blog.sort(sortByDate).map(async (m) => {
    const html = await readMarkdown(m.path)

    return {
      ...m,
      html,
    }
  })

  const rssPages = await Promise.all(rssPageTasks)

  await createRssFeed(rssPages)

  return {
    pages: meta,
    meta,
    docs,
    blog,
    notebooks,
    groupedDocs,
    allPages,
    random,
    photography,
  }
}
