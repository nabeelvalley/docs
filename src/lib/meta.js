import { readFile, stat } from 'fs/promises'

export const fileExists = async (path) => {
  try {
    const result = await stat(path)
    return result.isFile()
  } catch {
    return false
  }
}

export const readMeta = async (path) => {
  try {
    const exists = fileExists(path)
    if (!exists) {
      return {}
    }
    const data = await readFile(path)
    return JSON.parse(data)
  } catch {
    return {}
  }
}
