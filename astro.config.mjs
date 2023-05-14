import { ContentEntryType } from 'astro'
import { defineConfig } from 'astro/config'

import react from '@astrojs/react'
import sitemap from '@astrojs/sitemap'
import { fileExists, readMeta } from './src/lib/meta'
import { convertJupyterToHtml } from './src/lib/markdown'
import { fileURLToPath } from 'node:url'
import { join, resolve, sep } from 'node:path'
import ipynb from './src/integrations/ipynb.mjs'

// type SetupHookParams = HookParameters<'astro:config:setup'> & {
// 	// `contentEntryType` is not a public API
// 	// Add type defs here
// 	addContentEntryType: (contentEntryType: ContentEntryType) => void;
// };

// https://astro.build/config
export default defineConfig({
  outDir: '_site',
  site: 'https://nabeelvalley.co.za/',
  integrations: [react(), sitemap()],
})
