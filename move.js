var fs = require('fs')

const glob = require('glob')

const move = (path) => {
  const dir = './' + path.split('/').slice(0, -1).join('/')

  const newPath = './' + path
  console.log(dir, newPath)

  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true })
  }

  fs.renameSync(path, newPath)
}

glob.glob('content/**/*.png', (err, files) => {
  console.log(files)
  files.forEach(move)
})
glob.glob('content/**/*.jpg', (err, files) => {
  console.log(files)
  files.forEach(move)
})
glob.glob('content/**/*.jpeg', (err, files) => {
  console.log(files)
  files.forEach(move)
})
glob.glob('content/**/*.svg', (err, files) => {
  console.log(files)
  files.forEach(move)
})
