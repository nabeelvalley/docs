# Redesign Tasks

Some tasks/ideas to keep in mind for the redesign

## Bugs

- [x] Relative images don't work, see `/talks/2025/09-10/ai` and `/blog/2024/24-08/unintentionally-made-a-programming-language`
- [ ] Fix incorrect filenames in snippets (missing first few chars)
- [ ] SVG images not scaling correctly in Safari, see `/projects`

## Architecture

- [ ] Figure out bundling - ssr component detection?
- [ ] Script inlining?
- [ ] Reorganize images?
- [ ] Use strongly typed paths everywhere: Remote, LocalRelative, LocalAbsolute, others?

## Libification

- [ ] Caching
- [ ] Watch mode + client build
- [ ] More flexible/generic structure for front matter and renderers
- [ ] Clean separation of "content" and "dynamic pages"
- [ ] Significantly improve file system resolution

## Rebuild Astro Components

- Client
  - [x] slides/About
  - [x] slides/Note
  - [x] slides/Presentation
  - [x] slides/Slide
  - [x] slides/SlideOnly
- Server
  - [x] ShaderSnippet
  - [x] Shader
  - [x] Gallery
  - [x] Snippet
  - [x] CSSSnippet
  - [x] HTMLSnippet
  - [-] CSSPreview - Not implementing this for now, it's going to need a custom TweakPane component and is only really used in a few places

## Rendering

- [x] Home
- [ ] Home - A really nice home landing page
- [x] Blog
- [x] Docs
- [x] About
- [x] Gallery
- [ ] Gallery - A really nice gallery page + page per picture
- [ ] OG cover image per post?
- [ ] Sitemap - Not that important actually
- [x] RSS!!!

## Content Improvements

- [ ] axe-core checks for each page
- [ ] Performance - Critical CSS inlining
- [ ] Consistent way to do paths/file names for code blocks (```type path="something/like.this"?)
- [ ] Think about how we can continue to use tweakpane for snippets
- [ ] Remove all dependencies for markdown to HTML conversion?
- [ ] Remove dependency on Astro components
  - [ ] Use Web Components (progressive enhancements)
  - [ ] Figure out SSR
- [ ] Better use of asides (+ render in "side section")
- [ ] Better use of footers
- [ ] Header links (simplify sharing)
- [ ] Full bleed images
- [ ] Better use of figures/figcaptions
- [x] Get rid of conversion step for ipynb files (what to do about content?)
  - Converted to md and archived

## Data Management

- [ ] Easier way to manage links + automatic creation of weekly reading summaries
- [ ] Full content search (database?)
- [ ] Pages-cms friendly content
