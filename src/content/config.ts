import { z, defineCollection } from 'astro:content'

const schema = z.object({
  title: z.string().optional(),
  subtitle: z.string().optional(),
  description: z.string().optional(),
  published: z.boolean().optional(),
})

const bookSchema = z.object({
  title: z.string(),
  author: z.string(),
  date: z.string(),
  isbn: z.string(),
  published: z.number(),
  status: z.enum(['complete', 'in-progress', 'abandoned']),
})

export const collections = {
  photography: defineCollection({ type: 'content', schema }),
  random: defineCollection({ type: 'content', schema }),

  'blog-md': defineCollection({ type: 'content', schema }),
  'blog-ipynb': defineCollection({ type: 'data', schema }),

  'docs-md': defineCollection({ type: 'content', schema }),
  'docs-ipynb': defineCollection({ type: 'data', schema }),

  books: defineCollection({ type: 'data', schema: bookSchema }),
}
