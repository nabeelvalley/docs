import { defineConfig } from 'astro/config'

// https://astro.build/config
import react from '@astrojs/react'

// https://astro.build/config
import sitemap from '@astrojs/sitemap'

// https://astro.build/config
export default defineConfig({
  outDir: '_site',
  site: 'https://nabeelvalley.co.za',
  integrations: [react(), sitemap()],
})
