// import { globSync } from 'glob'
import { readFileSync, statSync, readdirSync } from 'fs'
import { FileSystemTree } from '@webcontainer/api'
import { join, resolve } from 'path'

const getFiles = (dir): FileSystemTree => {
  const subdirs = readdirSync(dir)
  return subdirs.reduce<FileSystemTree>((curr, subdir) => {
    const res = resolve(dir, subdir)

    const isDir = statSync(res).isDirectory()

    if (!isDir) {
      return {
        ...curr,
        [subdir]: {
          file: {
            contents: readFileSync(res),
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

export const importPlayground = (path: string): FileSystemTree => {
  const files = getFiles('src/playgrounds/' + path)
  return files
}
