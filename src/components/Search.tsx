import { getCollection } from 'astro:content'
import {
  KBarProvider,
  KBarAnimator,
  KBarPortal,
  KBarPositioner,
  KBarSearch,
  useMatches,
  KBarResults,
  type Action,
  useKBar,
} from 'kbar'
import { getPathParts } from '../lib/pages'

const baseActions: Action[] = [
  {
    id: 'posts',
    name: 'Search posts',
    subtitle: 'Blog, Docs, and Photography',
  },
  {
    id: 'github',
    name: 'GitHub',
    subtitle: '@nabeelvalley',
    perform: () => window.open('https://github.com/nabeelvalley'),
  },
  {
    id: 'twitter',
    name: 'Twitter',
    subtitle: '@not_nabeel',
    perform: () => window.open('https://twitter.com/not_nabeel'),
  },
  {
    id: 'instagram',
    name: 'Instagram',
    subtitle: '@nabeelvalley',
    perform: () => window.open('https://instagram.com/nabeelvalley'),
  },
  {
    id: 'portfolio',
    name: 'Portfolio',
    subtitle: 'My Photography Portfolio',
    perform: () => window.open('https://photography.nabeelvalley.co.za'),
  },
  {
    id: 'home',
    name: 'Home',
    subtitle: 'Nabeel Valley',
    perform: () => (window.location.pathname = '/'),
  },
  {
    id: 'blog',
    name: 'Blog',
    subtitle:
      'Rants and Ramblings. Random thoughts on Web Development, Photography, Design, and Life',
    perform: () => (window.location.pathname = '/blog'),
  },
  {
    id: 'docs',
    name: 'Docs',
    subtitle: 'Personal notes on software development and similar topics',
    perform: () => (window.location.pathname = '/docs'),
  },
  {
    id: 'projects',
    name: 'Projects',
    subtitle: "Some projects I'm currently working on",
    perform: () => (window.location.pathname = '/projects'),
  },
  {
    id: 'photography',
    name: 'Photography',
    subtitle: 'My portfolio, writing, and filters',
    perform: () => (window.location.pathname = '/photography'),
  },
  {
    id: 'about',
    name: 'Me',
    subtitle: 'About me',
    perform: () => (window.location.pathname = '/about'),
  },
]

const collections = [
  'blog-md',
  'blog-ipynb',
  'docs-md',
  'docs-ipynb',
  'photography',
  'random',
] as const

const summary = await Promise.all(
  collections.map(async (collection) => {
    const entries = await getCollection(collection)

    return entries.map((entry) => ({ collection, entry }))
  })
)

const routeActions: Action[] = summary.flat().map((page) => ({
  parent: 'posts',
  // need to do this in some more unified way
  id: page.id,
  name: page.entry.data.title,
  subtitle: page.entry.data.description || page.entry.data.subtitle,
  perform: () =>
    (window.location.pathname = getPathParts(page.entry, page.collection)[0]),
}))

const actions = [...baseActions, ...routeActions]

const RenderResults = () => {
  const { results } = useMatches()

  return (
    <KBarResults
      items={results}
      onRender={({ item, active }) => {
        if (typeof item === 'string') {
          return <div className="kbar__section">{item}</div>
        }

        return (
          <div
            className={`kbar__result ${active ? 'kbar__result--active' : ''}`}
          >
            <h2 className="kbar__result__title link">{item.name}</h2>
            <p className="kbar__result__subtitle">{item.subtitle}</p>
          </div>
        )
      }}
    />
  )
}

const Button = () => {
  const { query } = useKBar()

  return (
    <button className="link" onClick={query.toggle}>
      Search
    </button>
  )
}

export const Search = () => (
  <KBarProvider actions={actions}>
    <Button />
    <KBarPortal>
      <KBarPositioner className="kbar__positioner" style={{ paddingLeft: 0 }}>
        <KBarAnimator>
          <div className="kbar__wrapper">
            <KBarSearch className="kbar__search" />
            <RenderResults />
          </div>
        </KBarAnimator>
      </KBarPositioner>
    </KBarPortal>
  </KBarProvider>
)
