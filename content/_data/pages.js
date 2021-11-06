const { readFile } = require('fs').promises
const glob = require('glob')
const { resolve } = require('path')
const _ = require('lodash')

const ipynb = require('ipynb2html')
const jsdom = require('jsdom')

const getFiles = (ext) => {
  const g = `content/**/*.${ext}`

  return new Promise((res, rej) => {
    glob(g, (err, matches) => {
      if (err) rej(err)
      else {
        const extRx = new RegExp(`\.${ext}$`)
        const result = matches.map((m) => ({
          path: m,
          route: m.replace('content', '').replace(extRx, ''),
        }))
        res(result)
      }
    })
  })
}

const readMeta = async (data) => {
  const fullPath = resolve(__dirname, '../', './' + data.route + '.json')
  const content = await readFile(fullPath)

  const meta = JSON.parse(content.toString())
  return { ...meta, ...data }
}

const readNotebook = async (path) => {
  const fullPath = resolve(__dirname, '../../', path)
  const content = await readFile(fullPath)

  const window = new jsdom.JSDOM().window
  const document = window.document

  const renderNotebook = ipynb.createRenderer(document)
  const notebook = JSON.parse(content)

  const renderedContent = renderNotebook(notebook)

  renderedContent
    .querySelectorAll('style')
    .forEach((el) => el.parentNode.removeChild(el))

  const html = renderedContent.innerHTML
    .replace(/class="dataframe"/g, '')
    .replace(/border="1"/g, '')

  return html
}

module.exports = async function () {
  const md = await getFiles('md')
  const ipynb = await getFiles('ipynb')

  const content = [...md, ...ipynb]

  const json = await getFiles('json')

  const pages = content.filter((c) => json.find((j) => j.route === c.route))

  const meta = await Promise.all(pages.map(readMeta))

  const docs = meta.filter((m) => m.route.startsWith('/docs'))
  const stdout = meta.filter((m) => m.route.startsWith('/stdout'))
  const blog = meta.filter((m) => m.route.startsWith('/blog'))
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

  console.log(docs)

  return { pages, meta, docs, stdout, blog, notebooks }
}
