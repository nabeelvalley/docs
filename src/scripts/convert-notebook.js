import { getFiles, readMeta, readNotebook } from '../data/pages.js'
import { convertJupyterToHtml } from '../lib/markdown.js'
import { promises } from 'fs'
const { writeFile, mkdir, rm, readFile } = promises

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

      const markdown = ipynb.cells
        .map((cell) => {
          const type = cell.cell_type

          if (type === 'markdown' && cell.source.join) {
            return cell.source.join('')
          }

          if (type === 'code') {
            const code = cell.source.join
              ? '```py\n' + cell.source.join('') + '\n```\n'
              : ''

            const output = cell.outputs.map((out) => {
              if (!out.data) {
                return ''
              }

              const data = out.data

              let content = ''

              if (data['text/html']) {
                content += data['text/html'].join
                  ? data['text/html'].join('')
                  : data['text/html']
              } else if (data['text/plain']) {
                content += '\n```\n' + data['text/plain'] + '\n```\n'
              }

              if (data['image/png']) {
                content += `<img src="data:image/png;base64,${data['image/png']}" />`
              }

              return content
            })

            return output.join('\n\n')
          }
        })
        .join('\n\n')

      await writeFile(
        meta.path + '.out.md',
        `---
title: ${meta.title || ''}
subtitle: ${meta.subtitle || ''}
date: ${meta.data || ''}
description: ${meta.description || ''}
published: ${meta.published || ''}
---

${markdown || ''}

      `
      )
    })
)
