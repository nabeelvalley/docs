import { defineConfig } from 'astro/config'
import sitemap from '@astrojs/sitemap'
import { remarkModifiedTime } from './src/lib/markdownit-last-modified'
import mdx from '@astrojs/mdx'
import expressiveCode from 'astro-expressive-code'
import rehypeKatex from 'rehype-katex'
import remarkMath from 'remark-math'

import react from '@astrojs/react'

// https://astro.build/config
export default defineConfig({
  outDir: '_site',
  site: 'https://nabeelvalley.co.za/',
  markdown: {
    remarkPlugins: [remarkModifiedTime, remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  integrations: [
    expressiveCode(),
    mdx({
      extendMarkdownConfig: true,
    }),
    sitemap(),
    react(),
  ],
})