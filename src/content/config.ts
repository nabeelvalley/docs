import { z, defineCollection } from 'astro:content'

const schema = z.object({
  title: z.string().optional(),
  subtitle: z.string().optional(),
  description: z.string().optional(),
  published: z.boolean().optional(),
})

export const collections = {
  blog: defineCollection({ schema }),
  photography: defineCollection({ schema }),
  random: defineCollection({ schema }),
  docs: defineCollection({ schema }),
}
