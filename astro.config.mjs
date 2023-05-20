import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import sitemap from '@astrojs/sitemap';

// import mdx from '@astrojs/mdx'

import mdx from "@astrojs/mdx";

// https://astro.build/config
export default defineConfig({
  outDir: '_site',
  site: 'https://nabeelvalley.co.za/',
  markdown: {
    shikiConfig: {
      // Choose from Shiki's built-in themes (or add your own)
      // https://github.com/shikijs/shiki/blob/main/docs/themes.md
      theme: 'dracula-soft',
      // Add custom languages
      // Note: Shiki has countless langs built-in, including .astro!
      // https://github.com/shikijs/shiki/blob/main/docs/languages.md
      langs: []
      // Enable word wrap to prevent horizontal scrolling
      // wrap: true,
    }
  },

  integrations: [react(), sitemap(), mdx()]
});