import rss, { type RSSFeedItem } from '@astrojs/rss'
import { getCollection } from 'astro:content'
import MarkdownIt from 'markdown-it'

const parser = new MarkdownIt()

const rssPrefix =
  "> Shh ... you've found an [RSS Club](https://daverupert.com/rss-club/) post. I'll be using this to post small ideas or share things from around the web that I find interesting but don't intend to write an entire post about\n\n"

export const GET = async (context) => {
  // For simplicity just including the Markdown posts for now
  const blog = await getCollection('blog')
  const items = blog
    .filter((post) => post.data.published !== false || post.data.rssOnly)
    .map<RSSFeedItem>((post) => {
      let prefix = post.data.rssOnly ? rssPrefix : ''

      const link = `/blog/${post.slug}/`

      if (post.id.endsWith('.mdx')) {
        prefix += `This post contains interactive content and is best viewed [on my website](${link})\n\n`
      }

      return {
        title: post.data.title,
        pubDate: new Date(post.data.date),
        description: post.data.description,
        link,
        content: parser.render(prefix + post.body),
      }
    })
    .sort((postA, postB) => (postA.pubDate - postB.pubDate > 0 ? -1 : 1))

  return rss({
    title: 'Nabeel Valley',
    description: 'Software develpment, Photography and Design',
    site: context.site,
    items,
  })
}
