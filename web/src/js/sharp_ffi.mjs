import Sharp from 'sharp'


import { Result$Ok, Result$Error }
  // @ts-expect-error relative this file's location in build/dev/javascript/web
  from "../../prelude.mjs";


/**
 * @param {string} inputFile
 * @param {string} outputFile
 * @param {number} width
 */
export async function generate(inputFile, outputFile, width) {
  try {
    const sharp = new Sharp(inputFile)

    await sharp.resize({
      width
    }).toFormat('webp')
    .toFile(outputFile)

    return Result$Ok()
  } catch (err) {
    return Result$Error(`${err}`)
  }
}

