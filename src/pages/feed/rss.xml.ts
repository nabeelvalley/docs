import rss, { type RSSFeedItem } from '@astrojs/rss'
import { getCollection } from 'astro:content'
import MarkdownIt from 'markdown-it'

const parser = new MarkdownIt()

export const GET = async (context) => {
  // FOr simplicity just including the markdown posts for now
  const blog = await getCollection('blog-md')
  const items = blog
    .filter((post) => post.data.published)
    .map<RSSFeedItem>((post) => ({
      title: post.data.title,
      pubDate: new Date(post.data.subtitle),
      description: post.data.description,
      // Compute RSS link from post `slug`
      // This example assumes all posts are rendered as `/blog/[slug]` routes
      link: `/blog/${post.slug}/`,
      content: parser.render(post.body),
    }))

  console.log(items)

  return rss({
    title: 'Nabeel Valley',
    description: 'Software develpment, Photography and Design',
    site: context.site,
    items,
  })
}
