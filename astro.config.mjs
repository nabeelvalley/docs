import { defineConfig } from 'astro/config'
import react from '@astrojs/react'
import sitemap from '@astrojs/sitemap'
import { remarkModifiedTime } from './src/lib/markdownit-last-modified';
import mdx from '@astrojs/mdx';
import polyfillNode from "rollup-plugin-polyfill-node";


export default defineConfig({
  build: {
    rollupOptions: {
      plugins: [polyfillNode()],
    }
  },
  outDir: '_site',
  site: 'https://nabeelvalley.co.za/',
  markdown: {
    remarkPlugins: [remarkModifiedTime],
    shikiConfig: {
      theme: 'dark-plus',
    },
  },
  integrations: [react(), mdx({
    extendMarkdownConfig: true
  }), sitemap()],
})
