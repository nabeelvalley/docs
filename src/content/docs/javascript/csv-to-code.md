---
published: true
title: Code Generation using CSV Files
---

---
published: true
title: Code Generation using CSV Files
---

# Generating code from a CSV file

At times it may be necessary to generate a script or some code from a CSV File, this can be done using Node.js with a structure as follows:

```js
const buildCode = ({param1. param2, param3}) => `
  console.log(${param1}, ${param2 + param3})
`

const extractData = (line) => {
  const items = line.split(',')
  return {
    param1: items[0],
    param2: items[1],
    param3: items[2]
  }
}

const fs = require('fs')

const code = fs
   .readFileSync('file.csv', 'utf8')
   .split('\n')
   .map(extractData)
   .map(buildCode)
   .join('')

fs.writeFileSync('newFile.js', code)

console.log('done')
```
