import { codeToHtml, bundledLanguages } from 'shiki'

import { Result$Ok, Result$Error }
  // @ts-expect-error relative this file's location in build/dev/javascript/web
  from "../../../prelude.mjs";

/**
 * @param {string} code
 * @param {string} lang
 *
 * @returns {Promise<string>} HTML content
 */
export async function highlight(code, lang) {

  try {
    const resolvedLang = lang in bundledLanguages ? lang : "text"

    const result = await codeToHtml(code, {
      lang: resolvedLang,
      themes: {
        light: 'github-light-high-contrast',
        dark: 'github-dark-high-contrast',
      }
    })

    return Result$Ok(result)
  } catch (err) {
    return Result$Error(`${err}`)
  }
}
