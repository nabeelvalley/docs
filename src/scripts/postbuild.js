import fse from 'fs-extra'

fse.copySync('./_cache/data', './_site/data', { overwrite: true })
fse.copySync('./_cache/feed', './_site/feed', { overwrite: true })
