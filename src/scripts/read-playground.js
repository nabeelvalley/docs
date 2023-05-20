import {
  readFileSync,
  statSync,
  readdirSync,
  writeFile,
  writeFileSync,
} from 'fs'
import { join, resolve } from 'path'
import { sep } from 'path'

const getFiles = (dir) => {
  const subdirs = readdirSync(dir)
  return subdirs.reduce((curr, subdir) => {
    const res = resolve(dir, subdir)

    const isDir = statSync(res).isDirectory()

    if (!isDir) {
      return {
        ...curr,
        [subdir]: {
          file: {
            contents: readFileSync(res, 'utf-8').toString(),
          },
        },
      }
    }

    const files = getFiles(res)
    return {
      ...curr,
      [subdir]: {
        directory: Object.assign({}, files),
      },
    }
  }, {})
}

const importPlayground = (path) => {
  console.log({ path })
  const files = getFiles('src/playgrounds/' + path)
  return files
}

const main = () => {
  const paths = readdirSync('src/playgrounds')
  const playgrounds = paths.reduce((acc, path) => {
    const parts = path.split(sep)
    const name = parts[parts.length - 1]

    return {
      ...acc,
      [name]: importPlayground(name),
    }
  }, {})

  writeFileSync('public/playgrounds.json', JSON.stringify(playgrounds), 'utf-8')
}

main()
