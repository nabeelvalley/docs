import { getFiles, readMeta, readNotebook } from '../data/pages.js'
import { convertJupyterToHtml } from '../lib/markdown.js'
import { promises } from 'fs'
const { writeFile, mkdir, rm, readFile } = promises
import path from 'path'

import sanitize from 'sanitize-html'

const toHeader = (data) => {
  const lines = ['---', 'published: true']
  const keys = ['title', 'subtitle', 'description', 'date']

  keys.forEach((key) => {
    if (data[key]) {
      lines.push(`${key}: ${data[key]}`)
    }
  })

  lines.push('---')

  return `${lines.join('\n')}`
}

const clean = (html) =>
  sanitize(html || '', {
    allowedTags: sanitize.defaults.allowedTags.concat(['img']),
    allowedAttributes: {
      img: ['src', 'alt'],
    },
    allowedSchemes: ['data', 'http', 'https'],
  })

const nbImageExt = '.nb-out.png'

const notebooks = await getFiles('ipynb', 'src/content')
await Promise.all(
  notebooks
    .map((nb) => ({
      ...nb,
      route: nb.route.replace('src//', 'src/content/'),
      url: nb.url.replace('src//', 'src/content/'),
    }))
    .map(async (nb) => {
      const meta = await readMeta(nb)
      const file = await readFile(nb.path)
      const ipynb = JSON.parse(file.toString())

      const markdownTasks = ipynb.cells.map(async (cell, cellInd) => {
        const type = cell.cell_type

        if (type === 'markdown' && cell.source.join) {
          return cell.source.join('')
        }

        if (type === 'code') {
          const code = cell.source.join
            ? '```py\n' + cell.source.join('') + '\n```\n'
            : ''

          const outputTasks = cell.outputs.map(async (out, outInd) => {
            if (!out.data) {
              return ''
            }

            const data = out.data

            let content = ''

            if (data['text/html']) {
              content += clean(
                data['text/html'].join
                  ? data['text/html'].join('')
                  : data['text/html']
              )
            } else if (data['text/plain']) {
              content += '\n```\n' + data['text/plain'] + '\n```\n'
            }

            if (data['image/png']) {
              const filePath = `${nb.path.replaceAll(
                '/',
                '__'
              )}-${cellInd}-${outInd}${nbImageExt}`

              await writeFile(`public/${filePath}`, data['image/png'], 'base64')

              content += `<img src="/${filePath}" />`
            }

            return content
          })

          const output = await Promise.all(outputTasks)

          return code + output.join('\n\n')
        }
      })

      const markdown = (await Promise.all(markdownTasks)).join('\n\n')

      const header = toHeader(meta)

      await writeFile(meta.path + '.out.md', `${header}\n\n${markdown}`)
    })
)
