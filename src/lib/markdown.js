import markdownIt from 'markdown-it'
import markdownItAnchor from 'markdown-it-anchor'
import markdownItHljs from 'markdown-it-highlightjs'
import markdownItKatex from 'markdown-it-katex'
import markdownItToc from 'markdown-it-table-of-contents'

import { JSDOM } from 'jsdom'
import { createRenderer } from 'ipynb2html'
import { promises } from 'fs'


import sanitize from 'sanitize-html'
import { readMeta } from './meta'

const { writeFile, mkdir, rm, readFile } = promises


const lib = markdownIt({
  html: true,
})
  .use(markdownItAnchor)
  .use(markdownItHljs)
  .use(markdownItKatex)
  .use(markdownItToc, {
    includeLevel: [1, 2, 3, 4],
    containerHeaderHtml: `<details><summary>Contents</summary>`,
    containerFooterHtml: `</details>`,
  })

export const convertMarkdownToHtml = (markdown) => {
  const base = lib.render(markdown)

  return base
    .replace(/<table /g, '<div class="scrollable"><table ')
    .replace(/<\/table> /g, '</table><div>')
}

export const markdownLibrary = {
  render: convertMarkdownToHtml,
}


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

export const renderJupyterNotebook = async (slug) => {
  const file = await readFile(`${slug}.ipynb`)
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
          const filePath = `${slug.replaceAll(
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


  const html = convertMarkdownToHtml(markdown)

  return html
}

