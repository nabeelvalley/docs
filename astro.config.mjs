import { ContentEntryType } from 'astro'
import { defineConfig } from 'astro/config'

import react from '@astrojs/react'
import sitemap from '@astrojs/sitemap'
import { fileExists, readMeta } from './src/lib/meta'
import { convertJupyterToHtml } from './src/lib/markdown'
import { fileURLToPath } from 'node:url'
import { join, resolve, sep } from 'node:path'

// type SetupHookParams = HookParameters<'astro:config:setup'> & {
// 	// `contentEntryType` is not a public API
// 	// Add type defs here
// 	addContentEntryType: (contentEntryType: ContentEntryType) => void;
// };

// https://astro.build/config
export default defineConfig({
  outDir: '_site',
  site: 'https://nabeelvalley.co.za/',
  integrations: [
    react(),
    sitemap(),
    {
      name: 'jupyter-notebook',
      hooks: {
        'astro:config:setup': (params) => {
          const {
            config: astroConfig,
            addContentEntryType,
            addRenderer,
          } = params

          addRenderer({
            name: 'jupyter-renderer',
            serverEntrypoint: './src/integrations/jupyter.js',
          })

          console.log({ addContentEntryType })
          // Look at this search for where/how the mdx extension is defined
          // https://github.com/search?q=repo%3Awithastro%2Fastro+.mdx+path%3Apackages%2Fintegrations%2Fmdx%2Fsrc&type=code

          /** @type {import('astro').ContentEntryType} */
          const contentEntryType = {
            extensions: ['.ipynb'],
            getEntryInfo: async ({ contents, fileUrl }) => {
              const contentPath = join(process.cwd(), 'src', 'content')
              console.log(contentPath)

              const jsonPath = fileURLToPath(
                fileUrl.href.replace(/ipynb$/, 'json')
              )

              const exists = await fileExists(jsonPath)
              console.log({ exists, jsonPath })
              if (!exists) {
                return {
                  body: '',
                  data: {},
                  rawData: '',
                  slug: '',
                }
              }

              const meta = await readMeta(jsonPath)
              const base = process.cwd()
              const slug = fileURLToPath(fileUrl)
                .replace(/\.ipynb$/, '')
                .replace(contentPath, '')
                .split(sep)
                .join('/')
                .slice(1)

              console.log({ meta, slug, base })
              return {
                slug,
                data: {
                  ...meta,
                  slug,
                },
                body: convertJupyterToHtml(contents),
                rawData: contents,
              }
            },
            getRenderModule: async (this, { entry, viteId }) => {
              return {
                code: entry.body,
              }
            },
            // contentModuleTypes:
            //             `
            // declare module 'astro:content' {
            // 	interface Render {
            // 		'.ipynb': Promise<{
            // 			Content(props: Record<string, any>): import('astro').MarkdownInstance<{}>['Content'];
            // 		}>;
            // 	}
            // }`
          }
          addContentEntryType(contentEntryType)
        },
      },
    },
  ],
})
