import { z, defineCollection } from 'astro:content'

export const collections = {
  blog: defineCollection({}),
  photography: defineCollection({}),
  random: defineCollection({}),
  docs: defineCollection({}),
}
