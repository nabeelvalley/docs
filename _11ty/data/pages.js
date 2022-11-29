import matter from 'gray-matter'
import { promises } from 'fs'
const { readFile } = promises
import glob from 'glob'
import { resolve, format } from 'path'
import _ from 'lodash'
import {
  convertJupyterToHtml,
  convertMarkdownToHtml,
  markdownLibrary,
} from '../lib/markdown'
import { createRssFeed } from '../lib/rss'

const { upperFirst, groupBy } = _

const getDirectoryName = (dir) => {
  const split = dir.split('/')
  const directory = split[split.length - 2]
  return directory
    .split('-')
    .map((d) => upperFirst(d))
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
  const fullPath = path
  const content = await readFile(fullPath)

  return convertJupyterToHtml(content.toString())
}

const removeYamlHeader = (md) => md.replace(/^---(.|\n|(\r\n))*?---/gm, '')

const readMarkdown = async (path, removeHeader = false) => {
  const fullPath = path
  const content = await readFile(fullPath)
  const contentStr = content.toString()

  if (!removeHeader) {
    return convertMarkdownToHtml(contentStr)
  }

  const sanitized = removeYamlHeader(contentStr)
  return convertMarkdownToHtml(sanitized)
}

const sortByDate = (a, b) => {
  const dateA = new Date(a.subtitle)
  const dateB = new Date(b.subtitle)

  return dateB - dateA
}

export default async function () {
  const md = await getFiles('md')
  const ipynb = await getFiles('ipynb')

  const content = [...md, ...ipynb]

  const parsed = await Promise.all(content.map(readMeta))
  const meta = parsed.filter((f) => f.published)

  const docs = meta
    .filter((m) => m.route.startsWith('/docs'))
    .map(populatePaging)
  const groupedDocs = Object.values(groupBy(docs, 'directory'))

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

  const allPages = await Promise.all(
    [...blog, ...docs, ...notebooks, ...photography, ...random].map(
      async (page) => {
        if (page.html) {
          return page
        }

        const html = await readMarkdown(page.path, true)

        return {
          ...page,
          html,
        }
      }
    )
  )

  const rssPageTasks = blog.sort(sortByDate).map(async (m) => {
    const html = await readMarkdown(m.path, true)

    return {
      ...m,
      html,
    }
  })

  const rssPages = await Promise.all(rssPageTasks)

  const rss = await createRssFeed(rssPages)

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
    rss,
  }
}
