import { defineConfig } from 'astro/config'
import react from '@astrojs/react'
import sitemap from '@astrojs/sitemap'

import mdx from '@astrojs/mdx'

// https://astro.build/config
export default defineConfig({
  outDir: '_site',
  site: 'https://nabeelvalley.co.za/',
  integrations: [react(), sitemap(), mdx()],
})
