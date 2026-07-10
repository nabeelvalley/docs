import Sharp from 'sharp'


import { Result$Ok, Result$Error }
  // @ts-expect-error relative this file's location in build/dev/javascript/web
  from "../../prelude.mjs";

import { Metadata }
  // @ts-expect-error relative points to the compiled version of sharp.gleam
  from "./sharp.mjs";


/**
 * @param {string} inputFile
 * @param {string} outputFile
 * @param {number} size
 */
export async function generate(inputFile, outputFile, size) {
  try {
    const sharp = new Sharp(inputFile, {
      autoOrient: true,
    })

    await sharp.resize({
      height: size,
      width: size,
      fit: 'inside',
    })
      .rotate()
      .toFormat('webp', {
        quality: 95
      })
      .toFile(outputFile)

    return Result$Ok()
  } catch (err) {
    return Result$Error(`Sharp Error for file: ${inputFile} \n${err}`)
  }
}

/**
 * @param {string} inputFile
 */
export async function meta(inputFile) {
  try {
    const sharp = new Sharp(inputFile, {
      autoOrient: true,
    })

    const meta = await sharp.rotate().metadata()
    const {width, height} = meta.autoOrient

    const result = new Metadata(width, height)
    return Result$Ok(result)
  } catch (err) {
    return Result$Error(`${err}`)
  }
}

