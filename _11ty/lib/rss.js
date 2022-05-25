const { Feed } = require('feed')
const { resolve } = require('path')
const { writeFile, mkdir, rm } = require('fs').promises

const link = 'https://nabeelvalley.co.za'
const me = 'Nabeel Valley'

const author = {
  name: me,
  link,
}

const createRssFeed = async (posts) => {
  const feed = new Feed({
    link,
    author,
    id: link,
    title: me,
    copyright: 'All rights reserved, Nabeel Valley',
    description: 'Personal website, blog, and code snippets',
    language: 'en',
  })

  for (let index = 0; index < posts.length; index++) {
    const post = posts[index]

    if (!(post.url && post.title && post.subtitle && post.html)) {
      console.log('missing data', post)
      return
    }

    const date = new Date(post.subtitle)

    const { content, next, previous, ...d } = post

    if (isNaN(date)) {
      return
    }

    try {
      feed.addItem({
        date,
        id: post.url,
        author: [author],
        link: post.url,
        title: post.title,
        description: post.description,
        content: post.html,
      })
    } catch (err) {
      console.error('error adding item', err)
    }
  }

  try {
    await rm(resolve('_site/feed'), {
      force: true,
      recursive: true,
    })
    await mkdir(resolve('_site/feed'), {
      recursive: true,
    })
  } catch {
    // okay then
  }

  const rss = feed.rss2()
  await writeFile(resolve('_site/feed/rss.xml'), rss)

  const atom = feed.atom1()
  await writeFile(resolve('_site/feed/atom.xml'), atom)

  const json = feed.json1()
  await writeFile(resolve('_site/feed/feed.json'), json)
}

module.exports = { createRssFeed }
