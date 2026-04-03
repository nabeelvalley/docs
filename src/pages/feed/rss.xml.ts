import rss, { type RSSFeedItem } from '@astrojs/rss'
import { getCollection } from 'astro:content'
import MarkdownIt from 'markdown-it'

const parser = new MarkdownIt()

const rssPrefix =
  "> Shh ... you've found an [RSS Club](https://daverupert.com/rss-club/) post. I'll be using this to post small ideas or share things from around the web that I find interesting but don't intend to write an entire post about\n\n"

export const GET = async (context) => {
  // For simplicity just including the Markdown posts for now
  const blog = await getCollection('blog-md')
  const items = blog
    .filter((post) => post.data.published !== false || post.data.rssOnly)
    .map<RSSFeedItem>((post) => {
      const prefix = post.data.rssOnly ? rssPrefix : ''

      return {
        title: post.data.title,
        pubDate: new Date(post.data.subtitle),
        description: post.data.description,
        // Compute RSS link from post `slug`
        // This example assumes all posts are rendered as `/blog/[slug]` routes
        link: `/blog/${post.slug}/`,
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
