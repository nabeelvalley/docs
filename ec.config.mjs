import { defineEcConfig } from 'astro-expressive-code'
import { pluginLineNumbers } from '@expressive-code/plugin-line-numbers'
import { pluginCollapsibleSections } from '@expressive-code/plugin-collapsible-sections'

export default defineEcConfig({
  themes: ['dracula-soft', 'rose-pine-dawn'],
  plugins: [pluginLineNumbers(), pluginCollapsibleSections()],
  styleOverrides: {
    codeBackground: 'var(--color-base)',
    borderColor: 'var(--color-brand)',
    textMarkers: {
      delDiffIndicatorContent: '',
      insDiffIndicatorContent: '',
    },
  },
})
