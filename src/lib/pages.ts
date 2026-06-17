import { getCollection, type CollectionEntry } from 'astro:content'

export type Collection = Parameters<typeof getCollection>[0]

export const slugSegments: Partial<Record<Collection, string>> = {
  random: 'random',
  photography: 'photography',
  'blog-md': 'blog',
  'docs-md': 'docs',
  talks: 'talks',
}

export const collections: Collection[] = [
  'random',
  'photography',
  'blog-md',
  'docs-md',
  'talks',
]

export const getPathParts = (
  entry: CollectionEntry,
  collection: Collection,
) => {
  const [path, extension] = entry.id.split('.')
  const base = slugSegments[collection] || collection
  const slug = `${base}/${path}`

  return [slug, extension]
}
