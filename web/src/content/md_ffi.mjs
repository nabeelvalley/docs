import {marked} from 'marked'

/**
 * @param {string} md
 */
export function parse(md){
    return marked(md, {async: false, gfm: true})
}
