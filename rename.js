const fs = require('fs')

const root = '.'

const dirs = fs.readdirSync(root)

dirs.forEach(dir => {
  const newName = dir.toLowerCase().replace(/ /g, '-')
  console.log(`git mv "${dir}" "temp/${newName}"`)
  // fs.renameSync(`${root}/${dir}`,`${root}/temp/${newName}`)
});