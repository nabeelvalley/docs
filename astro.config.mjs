import { defineConfig } from 'astro/config'
import react from '@astrojs/react'
import sitemap from '@astrojs/sitemap'
import mdx from '@astrojs/mdx'

// https://astro.build/config
export default defineConfig({
  outDir: '_site',
  site: 'https://nabeelvalley.co.za/',
  server: {
    headers: {
      // Cross-Origin Headers needed for Web Containers
      'Cross-Origin-Embedder-Policy': 'require-corp',
      'Cross-Origin-Opener-Policy': 'same-origin',
    },
  },
  vite: {
    optimizeDeps: {
      exclude: ['fs', 'path'],
    },
  },
  markdown: {
    shikiConfig: {
      // Choose from Shiki's built-in themes (or add your own)
      // https://github.com/shikijs/shiki/blob/main/docs/themes.md
      theme: 'dracula-soft',
      // Add custom languages
      // Note: Shiki has countless langs built-in, including .astro!
      // https://github.com/shikijs/shiki/blob/main/docs/languages.md
      langs: [],
      // Enable word wrap to prevent horizontal scrolling
      // wrap: true,
    },
  },

  integrations: [react(), sitemap(), mdx()],
})
