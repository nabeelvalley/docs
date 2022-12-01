import getPages from '../../_11ty/data/pages.js'

import fs from 'fs'

const data = await getPages()

try {
  fs.mkdirSync('./_cache/data', { recursive: true })
  fs.mkdirSync('./_cache/feed', { recursive: true })
} catch {}

const summary = data.allPages.map((page) => ({
  title: page.title,
  subtitle: page.subtitle,
  description: page.description,
  url: page.url,
  route: page.route,
}))

fs.writeFileSync('./_cache/data/pages.json', JSON.stringify(data))
fs.writeFileSync('./_cache/data/summary.json', JSON.stringify(summary))
fs.writeFileSync(
  './_cache/data/groupedDocs.json',
  JSON.stringify(data.groupedDocs)
)

fs.writeFileSync('./_cache/feed/rss.xml', data.rss.rss)
fs.writeFileSync('./_cache/feed/atom.xml', data.rss.atom)
fs.writeFileSync('./_cache/feed/feed.json', data.rss.json)

data.allPages.forEach((data) => {
  const json = JSON.stringify(data)
  // need to write sync because for some reason the pages may be duplicated which can cause an issue
  // in which the same file is overwritten while the previous write is in progress
  return fs.writeFileSync(
    `./_cache/data/${data.route.replace(/\//g, '__')}.json`,
    json
  )
})
