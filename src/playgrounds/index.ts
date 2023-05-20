// import { globSync } from 'glob'
import { readFileSync, statSync, readdirSync } from 'fs'
import { FileSystemTree } from '@webcontainer/api'
import { join, resolve } from 'path'

const getFiles = (dir): FileSystemTree => {
  console.log(dir)
  const subdirs = readdirSync(dir)
  console.log(subdirs)
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
      [subdir]: {
        directory: {
          ...Object.assign({}, files),
        },
      },
    }
  }, {})
}

export const importPlayground = (path: string): FileSystemTree => {
  const files = getFiles('src/playgrounds/' + path)
  console.log(files)

  return files
  // return {
  //   'index.js': {
  //     file: {
  //       contents: "console.log('hello world')",
  //     },
  //   },
  //   'README.md': {
  //     file: {
  //       contents: 'Jack Smith',
  //     },
  //   },
  // }
}
