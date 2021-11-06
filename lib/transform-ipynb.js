module.exports = (content, outputPath) => {
  console.log({ outputPath })
  if (!outputPath.endsWith('.ipynb')) return content

  console.log(outputPath)
  console.log(content)

  // console.log(content)
}
