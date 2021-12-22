const { readFile } = require('fs').promises
const glob = require('glob')
const { resolve } = require('path')
const _ = require('lodash')
const { convertJupyterToHtml } = require('../lib/markdown')

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
  const fullPath = resolve(cwd, './content' + data.route + '.json')
  const content = await readFile(fullPath)

  const meta = JSON.parse(content.toString())
  return { ...meta, ...data }
}

const readNotebook = async (path) => {
  const fullPath = resolve(__dirname, '../../', path)
  const content = await readFile(fullPath)

  return convertJupyterToHtml(content)
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

  const json = await getFiles('json')

  const pages = content.filter((c) => json.find((j) => j.route === c.route))

  const meta = await Promise.all(pages.map(readMeta))

  const docs = meta
    .filter((m) => m.route.startsWith('/docs'))
    .map(populatePaging)
  const groupedDocs = Object.values(_.groupBy(docs, 'directory'))

  const stdout = meta
    .filter((m) => m.route.startsWith('/stdout'))
    .sort(sortByDate)
    .map(populatePaging)

  const blog = meta
    .filter((m) => m.route.startsWith('/blog'))
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

  const allPages = [...blog, ...stdout, ...docs]

  return { pages, meta, docs, stdout, blog, notebooks, groupedDocs, allPages }
}
