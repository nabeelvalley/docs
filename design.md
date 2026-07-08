# Redesign Tasks

Some tasks/ideas to keep in mind for the redesign

## Bugs

- Relative images don't work, see `/talks/2025/09-10/ai`

## Architecture

- [ ] Figure out bundling - ssr component detection?
- [ ] Script inlining?
- [ ] Reorganize images?

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

- [ ] Home - A really nice home landing page
- [x] Blog
- [x] Docs
- [ ] About
- [ ] Gallery - A really nice gallery landing page
- [ ] OG cover image per post
- [ ] Sitemap!!!
- [ ] RSS!!!

## Content Improvements

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
