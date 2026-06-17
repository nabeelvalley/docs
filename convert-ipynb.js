import sanitize from 'sanitize-html'
import { writeFileSync, readFileSync } from 'fs'

const clean = (html) =>
  sanitize(html || '', {
    allowedTags: sanitize.defaults.allowedTags.concat(['img']),
    allowedAttributes: {
      img: ['src', 'alt'],
    },
    allowedSchemes: ['data', 'http', 'https'],
  })

const nbImageExt = '.png'

const renderJupyterNotebook =  (slug) => {
  const file =  readFileSync(`${slug}.ipynb`)
  const ipynb = JSON.parse(file.toString())

  const markdownTasks = ipynb.cells.map( (cell, cellInd) => {
    const type = cell.cell_type

    if (type === 'markdown' && cell.source.join) {
      return cell.source.join('')
    }

    if (type === 'code') {
      const code = cell.source.join
        ? '```py\n' + cell.source.join('') + '\n```\n'
        : ''

      const outputTasks = cell.outputs.map( (out, outInd) => {
        if (!out.data) {
          return ''
        }

        const data = out.data

        let content = ''

        if (data['text/html']) {
          content += clean(
            data['text/html'].join
              ? data['text/html'].join('')
              : data['text/html']
          )
        } else if (data['text/plain']) {
          content += '\n```\n' + data['text/plain'] + '\n```\n'
        }

        if (data['image/png']) {
          const filePath = `${slug.replaceAll(
            '/',
            '__'
          )}-${cellInd}-${outInd}${nbImageExt}`

           writeFileSync(`public/jupyter/${filePath}`, data['image/png'], 'base64')

          content += `<img src="/jupyter/${filePath}" />`
        }

        return content
      })

      const output =  outputTasks

      return code + output.join('\n\n')
    }
  })

  const markdown = markdownTasks.join('\n\n')

  return writeFileSync(slug+ ".md", markdown)
}

const paths = [
  "src/content/blog-ipynb/2020/14-10/position-legend-in-seaborn",
  "src/content/blog-ipynb/2020/25-11/linear-regression-model-with-sklearn",
  "src/content/docs-ipynb/data-science/labs/1-From-Problem-to-Approach",
  "src/content/docs-ipynb/data-science/labs/2-Requirements-to-Collection-R",
  "src/content/docs-ipynb/data-science/labs/2-Requirements-to-Collection-py",
  "src/content/docs-ipynb/data-science/labs/3-Understanding-to-Preparation-R",
  "src/content/docs-ipynb/data-science/labs/3-Understanding-to-Preparation-py",
  "src/content/docs-ipynb/data-science/labs/4-Modeling-to-Evaluation-R",
  "src/content/docs-ipynb/data-science/labs/4-Modeling-to-Evaluation-py",
  "src/content/docs-ipynb/data-science-with-python/deep-learning-with-keras",
  "src/content/docs-ipynb/data-science-with-python/handle-class-imbalances",
  "src/content/docs-ipynb/data-science-with-python/image-classification-with-keras",
  "src/content/docs-ipynb/data-science-with-python/labs/data-analysis/1-Import-Export-Data",
  "src/content/docs-ipynb/data-science-with-python/labs/data-analysis/2-Data-Wrangling",
  "src/content/docs-ipynb/data-science-with-python/labs/data-analysis/3-Exploratory-Data-Analysis",
  "src/content/docs-ipynb/data-science-with-python/labs/data-analysis/4-Review-Model-Development",
  "src/content/docs-ipynb/data-science-with-python/labs/data-analysis/5-Model-Evaluation-and-Refinement",
  "src/content/docs-ipynb/data-science-with-python/labs/deep-learning-with-tensorflow/1-1-TensorFlow-Hello-World",
  "src/content/docs-ipynb/data-science-with-python/labs/deep-learning-with-tensorflow/1-2-LinearRegressionwithTensorFlow",
  "src/content/docs-ipynb/data-science-with-python/labs/deep-learning-with-tensorflow/1-4-LogisticRegressionwithTensorFlow",
  "src/content/docs-ipynb/data-science-with-python/labs/deep-learning-with-tensorflow/1-5-ActivationFunctions",
  "src/content/docs-ipynb/data-science-with-python/labs/deep-learning-with-tensorflow/2-1-Understanding_Convolutions",
  "src/content/docs-ipynb/data-science-with-python/labs/deep-learning-with-tensorflow/2-2-CNN-MNIST-Dataset",
  "src/content/docs-ipynb/data-science-with-python/labs/deep-learning-with-tensorflow/3-1-LSTM-basics",
  "src/content/docs-ipynb/data-science-with-python/labs/deep-learning-with-tensorflow/3-4-LSTM-MNIST-Database",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/2-1-Simple-Linear-Regression",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/2-2-Non-Linear-Regression",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/3-1-KNN",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/3-2-Decision Trees",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/3-3-Logistic-Regression",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/3-4-Suport-Vector-Machines",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/4-1-K-Means",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/4-2-Hierachical Clustering",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/4-3-DBSCAN",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/5-1-Content-Based-Filtering",
  "src/content/docs-ipynb/data-science-with-python/labs/machine-learming/5-2-Collaborative-Filtering",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/1-1-Types",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/1-2-Strings",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/2-1-Tuples",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/2-2-Lists",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/2-3-Sets",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/2-4-Dictionaries",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/3-1-Conditions",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/3-2-Loops",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/3-3-Functions",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/3-4-Objects-and-Classes",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/4-1-Reading-Files",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/4-2-Writing-and-Saving-Files",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/4-3-Loading-Data-and-Viewing-Data",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/5-1-Numpy1d",
  "src/content/docs-ipynb/data-science-with-python/labs/python-basics/5-2-Numpy2d",
  "src/content/docs-ipynb/data-science-with-python/machine-learning-with-python",
  "src/content/docs-ipynb/data-science-with-python/notebooks/data-analysis-with-python",
  "src/content/docs-ipynb/data-science-with-python/notebooks/deep-learning-with-tensorflow-1",
  "src/content/docs-ipynb/data-science-with-python/notebooks/deep-learning-with-tensorflow-2",
  "src/content/docs-ipynb/data-science-with-python/notebooks/deep-learning-with-tensorflow-3",
  "src/content/docs-ipynb/data-science-with-python/xgboost-and-pipelines",
  "src/content/docs-ipynb/time-series-data-analysis/change-point-detection-with-ruptures",
  "src/content/docs-ipynb/time-series-data-analysis/forecasting-with-sktime",
  "src/content/docs-ipynb/time-series-data-analysis/time-series-analysis-with-stumpy",
  "src/content/docs-ipynb/time-series-data-analysis/time-series-classification-with-sktime",
  "src/content/docs-ipynb/time-series-data-analysis/time-series-stationarity",
]

paths.forEach(p => renderJupyterNotebook(p))
