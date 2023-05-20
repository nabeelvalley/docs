import { readFile, writeFile, rm } from 'fs/promises'
import getPages from './src/data/pages.js'

import fs from 'fs'

const data = await getPages()

const summary = data.allPages.map((page) => ({
  title: page.title,
  subtitle: page.subtitle,
  description: page.description,
  url: page.url,
  route: page.route,
}))

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

data.allPages
  .filter((page) => page.path.endsWith('.md'))
  .forEach(async (data) => {
    console.log(data.path)
    const contents = (await readFile(data.path)).toString()
    const header = toHeader(data)
    const newContent = `${header}\n\n${contents}`

    const jsonPath = data.path.slice(0, -3) + '.json'
    try {
      await rm(jsonPath)
    } catch (err) {
      console.log('did not delete', jsonPath)
    }

    await writeFile(data.path, newContent)
  })
