import { z, defineCollection } from 'astro:content'

const schema = z.object({
  title: z.string().optional(),
  subtitle: z.string().optional(),
  description: z.string().optional(),
  published: z.boolean().optional(),
})

export const collections = {
  photography: defineCollection({ type: 'content', schema }),
  random: defineCollection({ type: 'content', schema }),

  'blog-md': defineCollection({ type: 'content', schema }),
  'blog-ipynb': defineCollection({ type: "data", schema }),

  'docs-md': defineCollection({ type: 'content', schema }),
  'docs-ipynb': defineCollection({ type: "data", schema }),
}
