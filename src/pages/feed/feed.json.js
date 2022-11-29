import getPages from '../../../_11ty/data/pages'

export const get = async () => {
  const { rss } = await getPages()

  return rss.json
}
