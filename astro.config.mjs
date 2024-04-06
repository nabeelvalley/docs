import { defineConfig } from 'astro/config'
import sitemap from '@astrojs/sitemap'
import { remarkModifiedTime } from './src/lib/markdownit-last-modified'
import mdx from '@astrojs/mdx'

import expressiveCode from 'astro-expressive-code'

// https://astro.build/config
export default defineConfig({
  outDir: '_site',
  site: 'https://nabeelvalley.co.za/',
  markdown: {
    remarkPlugins: [remarkModifiedTime],
  },
  integrations: [
    expressiveCode({
      themes: ['houston', 'github-light'],
    }),
    mdx({
      extendMarkdownConfig: true,
    }),
    sitemap(),
  ],
})
