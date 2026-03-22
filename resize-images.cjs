/**
 * Utility module for resizing images using sharp for pages
 *
 * > Note that images will be resized in place
 *
 * @example
 *
 * ```sh
 * node resize-images.cjs `src/photography/blog/my-post-folder/**`
 * ```
 */
const Sharp = require('sharp')
const fg = require('fast-glob')
const fs = require('fs/promises')

async function main() {
  const glob = process.argv[process.argv.length - 1]

  console.log('resizing images at glob: ', glob)

  const paths = await fg(glob)

  console.log(paths)

  const tasks = paths.map(async p => {
    const sharp = new Sharp(p)
    const buffer = await sharp.resize({
    width: 2000,
  }).toBuffer(p)

  await fs.writeFile(p, buffer)
})

  await Promise.all(tasks).then(console.log)

  console.log('resized images')
}

main()
