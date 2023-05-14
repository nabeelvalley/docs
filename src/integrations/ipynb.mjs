// @ts-check
// based on https://github.com/manzt/anywidget/blob/main/docs/scripts/utils.mjs
import { join, resolve, sep } from 'node:path'
import { fileURLToPath } from 'node:url'

import { normalizePath } from 'vite'
import { fileExists, readMeta } from '../lib/meta'

let astroJsxRuntimeModulePath = normalizePath(
  fileURLToPath(
    new URL('../node_modules/astro/dist/jsx-runtime/index.js', import.meta.url)
  )
)

export function createAstroComponentString({
  frontmatter,
  fileId,
  fileUrl,
  raw,
  headings,
  html,
}) {
  let { layout } = frontmatter

  return `
	import { Fragment, jsx as h } from ${JSON.stringify(astroJsxRuntimeModulePath)};
	${layout ? `import Layout from ${JSON.stringify(layout)};` : ''}

  console.log("executing vite plugin");

	const html = ${JSON.stringify(html)};
	export const frontmatter = ${JSON.stringify(frontmatter)};
	export const file = ${JSON.stringify(fileId)};
	export const url = ${JSON.stringify(fileUrl)};
	export function rawContent() {
		return ${JSON.stringify(raw)};
	}
	export function compiledContent() {
		return html;
	}
	export function getHeadings() {
		return ${JSON.stringify(headings)};
	}
	export async function Content() {
		const { layout, ...content } = frontmatter;
		content.file = file;
		content.url = url;
		content.astro = {};
		const contentFragment = h(Fragment, { 'set:html': html });
		return ${
      layout
        ? `h(Layout, {
			file,
			url,
			content,
			frontmatter: content,
			headings: getHeadings(),
			rawContent,
			compiledContent,
			'server:root': true,
			children: contentFragment
		})`
        : `contentFragment`
    };
	}
	Content[Symbol.for('astro.needsHeadRendering')] = ${layout ? 'false' : 'true'};
	export default Content;
`
}

const contentPath = join(process.cwd(), 'src', 'content')

/**
 * @param {{ execute?: boolean, config: import("astro").AstroConfig }} options
 * @returns {import('vite').Plugin}
 */
function vitePlugin(options) {
  console.log('vite plugin options', options)
  return {
    name: 'ipynb',
    enforce: 'pre',
    async transform(_, id) {
      const filePath = id.split('?')[0]
      const isNotebook = filePath.endsWith('.ipynb')
      console.log('vite plugin transform id:', filePath, isNotebook)
      if (!id.endsWith('.ipynb')) return

      console.log('processing', filePath)

      const jsonPath = fileURLToPath(fileUrl.href.replace(/ipynb$/, 'json'))

      const exists = await fileExists(jsonPath)
      console.log({ exists, jsonPath })
      if (!exists) {
        return
      }

      const frontmatter = await readMeta(jsonPath)
      const base = process.cwd()
      const slug = fileURLToPath(fileUrl)
        .replace(/\.ipynb$/, '')
        .replace(contentPath, '')
        .split(sep)
        .join('/')
        .slice(1)

      console.log({ frontmatter, slug, base })

      return {
        code: createAstroComponentString({
          html,
          frontmatter,
          raw: contents,
          headings: [],
          fileId: id,
          fileUrl: slug,
        }),
        meta: {
          astro: {
            hydratedComponents: [],
            clientOnlyComponents: [],
            scripts: [],
            propagation: 'none',
            pageOptions: {},
          },
          vite: {
            lang: 'js',
          },
        },
      }
    },
  }
}
/**
 * @return {import('astro').AstroIntegration}
 */
export default function ipynb() {
  console.log('set up extension')
  return {
    name: 'ipynb',
    hooks: {
      'astro:config:setup': async (options) => {
        console.log('astro config setup', options)
        console.log({ addPageExtension: options.addPageExtension })
        // @ts-ignore
        options.addPageExtension('.ipynb')
        options.updateConfig({
          vite: { plugins: [vitePlugin(options)] },
        })
      },
    },
  }
}
