const { readFile } = require('fs').promises
const glob = require('glob')
const { resolve } = require('path')
const _ = require('lodash')

const getFiles = (ext) => {
  const g = `content/**/*.${ext}`

  return new Promise((res, rej) => {
    glob(g, (err, matches) => {
      if (err) rej(err)
      else {
        const extRx = new RegExp(`\.${ext}$`)
        const result = matches.map((m) =>
          m.replace('content', '').replace(extRx, '')
        )
        res(result)
      }
    })
  })
}

const readMeta = async (path) => {
  const fullPath = resolve(__dirname, '../', './' + path + '.json')
  const content = await readFile(fullPath)

  const meta = JSON.parse(content.toString())
  return { ...meta, path }
}

module.exports = async function () {
  const md = await getFiles('md')
  const json = await getFiles('json')

  const pages = _.intersection(md, json)

  const meta = await Promise.all(pages.map(readMeta))

  const docs = meta.filter((p) => p.path.startsWith('/docs'))
  const stdout = meta.filter((p) => p.path.startsWith('/stdout'))
  const blog = meta.filter((p) => p.path.startsWith('/blog'))

  return { pages, meta, docs, stdout, blog }
}
