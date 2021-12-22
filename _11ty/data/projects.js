const { readFile } = require('fs').promises
const { resolve } = require('path')

module.exports = async () => {
  const path = resolve(process.cwd(), 'content/projects.json')
  console.log(path)
  const file = await readFile(path, 'utf-8')

  const projects = JSON.parse(file)

  return projects
}
