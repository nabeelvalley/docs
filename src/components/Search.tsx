import {
  KBarProvider,
  KBarAnimator,
  KBarPortal,
  KBarPositioner,
  KBarSearch,
  useMatches,
  KBarResults,
  Action,
} from 'kbar'

import summary from '../../_cache/data/summary.json'

const baseActions: Action[] = [
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
    id: 'code',
    name: 'Code',
    subtitle: "Some projects I'm currently working on",
    perform: () => (window.location.pathname = '/code'),
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

const routeActions: Action[] = summary.map((page) => ({
  id: page.route,
  name: page.title,
  subtitle: page.description || page.subtitle,
  perform: () => (window.location.pathname = page.route),
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
            <h2 className="kbar__result__title">{item.name}</h2>
            <p className="kbar__result__subtitle">{item.subtitle}</p>
          </div>
        )
      }}
    />
  )
}

export const Search = () => (
  <KBarProvider actions={actions}>
    <KBarPortal>
      <KBarPositioner>
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
