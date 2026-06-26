import Sharp from 'sharp'
import { join } from 'node:path'


import { Result$Ok, Result$Error }
  // @ts-expect-error relative this file's location in build/dev/javascript/web
  from "../../prelude.mjs";


/**
 * @param {string} inputFile
 * @param {string} outDir
 * @param {number} width
 * @param {(result: unknown) => void} cb
 */
export async function generate(inputFile, outDir, width, cb) {
  try {
    const fileName = inputFile.replace(/[\W_]+/g, "_");
    const outPath = join(outDir, fileName + '.webp')

    const sharp = new Sharp(inputFile)

    await sharp.resize({
      width
    }).toFormat('webp').toFile(outPath).catch(console.error)

    cb(Result$Ok(outPath))
  } catch (err) {
    cb(Result$Error(`${err}`))
  }
}

