import {marked} from 'marked'
import katex from 'marked-katex-extension'

marked.use(katex({
  output: 'mathml'
}))

/**
 * @param {string} md
 */
export function parse(md){
    return marked(md, {async: false, gfm: true})
}
