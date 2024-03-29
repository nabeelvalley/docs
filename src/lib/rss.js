import { Feed } from 'feed'
import { resolve } from 'path'
import { promises } from 'fs'
const { writeFile, mkdir, rm } = promises

const link = 'https://nabeelvalley.co.za'
const me = 'Nabeel Valley'

const author = {
  name: me,
  link,
}

export const createRssFeed = async (posts) => {
  const feed = new Feed({
    link,
    author,
    id: link,
    title: me,
    image: `${link}/images/home/code.jpg`,
    favicon: `${link}/favicon.png`,
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

    if (isNaN(date)) {
      return
    }

    try {
      feed.addItem({
        date,
        id: post.url,
        author: [author],
        link: `${link}${post.url}`,
        title: post.title,
        description: post.description,
        content: post.html,
      })
    } catch (err) {
      console.error('error adding item', err)
    }
  }

  const rss = feed.rss2()
  const atom = feed.atom1()
  const json = feed.json1()

  return { rss, atom, json }
}
