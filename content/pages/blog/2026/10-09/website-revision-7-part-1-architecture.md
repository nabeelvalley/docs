---
title: r7.1 - Architecture (or "How Not to Build a Static Site")
description: The initial site architecture and What I learnt from it
feature: true
published: true
---

It's been a pretty hectic couple of months and though I've taken [loads of pictures](/photography) and worked a lot on this site, I haven't quite gotten around to writing

## Parts in This Series

> This is post is part of a series about my website redesign, I'll add links to the other parts here as they become available

- [Part 0 - Housekeeping](/blog/2026/08-07/website-revision-7-part-0-housekeeping)
- Part 1 - Architecture (or "How Not to Build a Static Site") (this post)
- Part 2 - Creating Pages
- Part 3 - Server Components
- Part 4 - A Library

## Foreword and Warnings

This post discusses the very early, experimental version of my website in Gleam. The goal of this post is to share the high level process as well as - importantly - to identify the pitfalls with the initial approach which helped better define the direction I later chose to go

## Recap

[The previous post in this series](/blog/2026/08-07/website-revision-7-part-0) discussed a high level plan for my website's content and what the functional requirements are for the site

As a recap, the site needs to support:

- Markdown pages
- Web components with TypeScript
- Server-rendered components
- Dynamic routes

Additional focus is also on the site's accessibility to ensure that at the very least we're following [WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) to a reasonable extent

## High Level Architecture

The rewrite uses [Gleam](https://gleam.run/) which is a functional programming language that compiles to JavaScript and Erlang which makes it pretty neat for interoperability with the JS ecosystem

In terms of general structure I settled on a sort of pipeline flow for rendering

The idea is that the site generator would consist of stages where each stage transforms the output from the previous one

This structure makes it relatively easy to isolate and test individual bits of functionality with a high level of certainty that they will work when attached to the rest of the app

As a first-pass I chose to implement the following top-level stages:

1. Load content - reads files from disk and converts them to some kind of standard format that later steps can manipulate
2. Render pages - takes the content and applies various sub-stages to get the fully-rendered HTML page or other assets
3. Write files - take the rendered pages and assets and write them to disk


This sounds pretty simple, and that's kind of the point. I wanted a brute force scaffolding at this point to play around with. The relatively loose structure makes duplication and poor structure apparent which makes defining the final API easier

## A Naive Implementation

### Top-Level Pipeline

Given these hand-wavy ideas, at the top-level, the pipeline looks like this:

```gleam
// load content
use content <- util.try_resolve(content.load_content())

// render pages
use pages <- util.try_resolve(rendering.render(content))

// copy static assets
use _ <- util.try_resolve(fs.delete(consts.out_dir))
use _ <- util.try_resolve(fs.copy_dir(consts.public_dir, consts.out_dir))

// write generated pages
use result <- promise.await(assets.write_pages(pages))
```

Since everything is immutable we don't need to worry about a step breaking some data that came from a previous step.This makes it possible for the pipeline to load data from multiple places and have multiple unrelated rendering steps, the results of which can be written independently without impacting other data

The downside of this immutability is increased memory usage since there are always potentially multiple copies of data hanging around - but I don't think this is the biggest bottleneck in the overall process so I can live with it

### Loading Content

```gleam
use content <- util.try_resolve(content.load_content())
```

Content in this context refers to the source files such as Markdown files, JSON files, images, etc. that the actual site pages will be based on

Since all the content in my site is based on a source Markdown file, loading content is pretty much just consists of reading some files and parsing them into a `MarkdownFile` object which has the following data structure:

```gleam
pub type MarkdownDocument {
  MarkdownDocument(path: String, frontmatter: Frontmatter, html: String)
}
```

The actual implementation that reads the files is fairly straightforward and consists of:

1. A `Collection` data type that stores a few lists of `MarkdownDocument`. The idea was to be able to more generally load any data that the site needs into an object that can be shared across the rendering pipeline

```gleam
pub type Collection {
  Collection(
    blog: List(md.MarkdownDocument),
    docs: List(md.MarkdownDocument),
    talks: List(md.MarkdownDocument),
  )
}
```

2. Content loaded from disk (or potentially other places) is read into a `Collection` by reading the relevant files and doing any relevant preprocessing, e.g. parsing Markdown into HTML and reading any associated metadata

```gleam
pub fn load_content() -> Result(Collection, String) {
  use blog <- result.try(load_markdown_content("blog"))
  use docs <- result.try(load_markdown_content("docs"))
  use talks <- result.try(load_markdown_content("talks"))

  Ok(Collection(blog:, docs:, talks:))
}

fn load_markdown_content(rel: String) {
  let rel_dir = fs.join([consts.content_dir, rel])
  use rel_files <- result.try(fs.load_content(rel_dir))
  Ok(result.values(list.map(rel_files, md.parse_markdown_file)))
}
```

The above snippet skips over some details but is effectively this - we read all the content (whatever that might mean), handle any parsing or preprocessing that's needed, and load it into some data that's shared across the pipeline

### Rendering Content

```gleam
use pages <- util.try_resolve(rendering.render(content))
```

Rendering is where things become a little more interesting. At the top-level, this consists of taking a `Collection` and getting a list of ready-to-print HTML pages

In terms of actual implementation, this consists of the following sub-stages

1. Get HTML content from Markdown 
2. Replace any server-side content as needed
3. Output HTML content with output file path

#### Getting HTML from Markdown

This really came down to using an off-the-shelf Markdown to HTML library. I used a thin wrapper around the great [`marked`](https://marked.js.org/) library which is written in JavaScript

Gleam has a pretty straightforward way to call into JavaScript, but for the sake of the wrapper, the code really ends up being:

1. A JavaScript file that calls the `marked` library named `marked_ffi.mjs` that exports a function called `marked`

```js
import {marked} from 'marked'

/**
 * @param {string} md
 */
export function parse(md){
    return marked(md, {async: false, gfm: true})
}
```

2. Then, a bit of Gleam that defines an external function from `marked_ffi.mjs` named `parse`. This Gleam binding specifies the types returned from the JavaScript code

```gleam
@external(javascript, "./marked_ffi.mjs", "parse")
pub fn parse(_md: String) -> String {
  panic as "not supported for the given target"
}
```
The Gleam implementation will also crash if called in a non-JavaScript environment as per the function body

The `parse` function takes a Markdown `String` and returns an HTML `String`, this isn't the ideal representation but at this point in the implementation it was fine to work from

#### Replacing Server-Side Content (aka Server-Components)

The high level way in which this works is:

1. Function takes some HTML
2. HTML is parsed for anything of interest
3. Aforementioned things-of-interest are converted into new HTML
4. New HTML replaces the bits needed in the original HTML

This process is then repeated for every server-rendering function

The actual implementation of this gets a little chaotic in my initial code so I won't share it here (but you can look at [an example server-side component on GitHub](https://github.com/nabeelvalley/docs/blob/f8babd9f2b2808fadb42640a482113896b8caf95/web/src/rendering/components/script_raw.gleam) if you're interested)

During this process, I also wanted a somewhat elegant way to compose these _server-components_ sequentially. This is effectively a `fold` and the function I assembled for this was kind of pretty:

```gleam
fn process_page(base, processors) {
  list.try_fold(processors, base, fn(page, proc) { proc(page) })
}
```

In the above, `base` is the initial HTML, and `processors` is a list of these conversion functions that look like `fn(page: Page) -> Result<Page, Err>` - the `Result` bit indicates that this function can fail with some `Err`

Using this on a page to render all the components ends up looking like this:

```gleam
fn render_md_page(base: String, doc: md.MarkdownDocument) {
  // ... creating metadata objects, resolving slug, and other unimportant stuff

  use processed <- result.try(
    Page(slug, meta, doc.html, [])
    |> process_page([
	  // some server-components that are rendered
      snippet.render_all,
      gallery.render_all,
      script_raw.render_all,
    ]),
  )
```

Now, why might we want these _server-components_? For my use case, this helps separate Markdown authoring from being unnecessarily repetitive. For example, instead of putting a giant blob of HTML for an image gallery, I can do something like `<gallery path="path/to/my/images" />` and then trust that it will be rendered on the page

I've used HTML instead of typical [shortcodes](https://www.markdownlang.com/advanced/shortcodes.html) because I have both client-side and server-side components and I don't think when a component gets rendered should affect my writing process. As long as the component appears where it needs to on the page I'm happy

### A Little Bit of Layout

Now we've got a little website where all pages are simple HTML content. This might be okay for some uses, but generally we want to have a little more layout involved for the sake of **✨ our readers ✨** 

I chose to use a Gleam library called [Lustre](https://lustre.hexdocs.pm/) for writing HTML since HTML strings everywhere would have been gross

Once we have the `Page` object, rendering it to the desired HTML looks a bit like so:

```gleam
fn render_md_page(base: String, doc: md.MarkdownDocument) {
  // ... previous server-side rendering bits
  
  let html =
    html.main([], [
      element.unsafe_raw_html(
        "",
        "article",
        [],
        processed.html,
      ),
    ])
    |> layout.page(meta)
    |> element.to_document_string

  Ok(Page(..processed, html:))
}
```

Lustre defines functions in it's `html` namespace that usually take two parameters, namely a list of attributes, and a list of child elements. These functions return a single HTML element that can then be passed around as needed

Since the content from `marked` and our _server-components_ is just a `String` we need to wrap it using Lustre's `unsafe_raw_html` function which needs

- An element namespace - an empty string means it's just a normal HTML element
- A wrapping tag name, in this case `article`
- Any attributes for the wrapping tag, in this case none (`[]`)
- The HTML content to be placed inside of the new element

This can then be treated as a normal Lustre element, and passed onto functions that expect that, like the `html.main` function above

Next, this gets passed to the `layout.page` function that renders a bunch more Lustre elements to get the overall page:

```gleam
pub fn page(body, meta: Meta) {
  let title = case meta.title {
    option.Some(t) -> t <> " - " <> base_title
    option.None -> base_title
  }

  let description = option.unwrap(meta.description, base_description)

  html.html([], [
    html.head([], [
      html.title([], title),

      html.meta([attribute.charset("UTF-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.content("width=device-width, initial-scale=1.0"),
      ]),
      html.meta([
        attribute.name("description"),
        attribute.content(description),
      ]),
    ]),
    body,
  ])
}
```

Lastly, since we need a `String` to write to disk, we use the `element.to_document_string` function to create the fully-formed `Page`

### Output Rendered HTML

```gleam
use result <- promise.await(assets.write_pages(pages))
```

Once we've got the final `Page`, we're pretty much done with the site and it's just a matter of getting it from memory to disk

A `Page` groups together some data that is needed for creating a final HTML file, including some metadata in the form of a `Meta` object:

```gleam
pub type Page {
  Page(slug: String, meta: Meta, html: String)
}

pub type Meta {
  Meta(title: Option(String), description: Option(String), date: Option(String))
}
```

From this point, it's pretty simple to take the `slug`, append a `.html` to it, and write the file to a disk:

```gleam
pub fn write_pages(pages: List(Page)) -> Result(Nil, String) {
    pages
    |> list.try_each(write_page)
}

fn write_page(page: Page) {
  let path = consts.out_dir <> "/" <> page.slug <> ".html"
  fs.write(path, page.html)
}
```
We're using `list.try_each` since these writes may fail and we want to propagate that error upwards to the `main` function so we can handle any errors appropriately

## Pitfalls and ... Other Places to Fall

The implementation I've shared above technically works for really simple use cases. However, some challenges come about when adding more complex features such as image optimization, RSS feeds, and syntax highlighting

The main problem with the above structure ends up being orchestration. Each of these steps are relatively simple, but there's a lot of accidental complexity in stitching them together. This becomes particularly apparent when having to deal with things like lists of async, fallible tasks (`List(Promise(Result(A,B)))`) and all its various forms. The underlying code too quickly falls into the natural shape of the task at hand which makes composition kind of gross since there are subtle differences which require different mapping strategies

Lustre is for building interactive applications and isn't a templating library. As a result, HTML is also not being handled appropriately. Lustre makes it easy to author HTML but doesn't have any builtin ways to parse or manipulate existing HTML which means you spend a lot of time doing string gymnastics. 

Marked is great and is exactly what I want from a Markdown parser, but the layer between plain text and a manipulable data structure don't quite exist

The initial Gleam rewrite was pretty fun, and although the code ended up being pretty gross. If you're interested, you can look at [the site generator at the point of the rewrite we've discussed so far]([https://github.com/nabeelvalley/docs/tree/f8babd9f2b2808fadb42640a482113896b8caf95](https://github.com/nabeelvalley/docs/tree/f8babd9f2b2808fadb42640a482113896b8caf95/web))

## Spoilers

Based on the main issues I ran into, I chose spend some time solving the two main problems I encountered:

1. HTML Parsing and Manipulation - I couldn't find a good Gleam library that supported parsing transformation in a straightforward way so I built [`mellie`](https://mellie.hexdocs.pm/). `mellie` works on JavaScript and Erlang and uses the [`htmgrrrl`](https://htmgrrrl.hexdocs.pm/) and [`htmlparser2`](https://www.npmjs.com/package/htmlparser2) libraries on their respective targets to support HTML parsing anywhere that Gleam (currently) runs
2. Composition - The composition problem was big enough that I ended up making [`charge`](https://charge.hexdocs.pm/) which is composable, component-based static site generator for Gleam (with Node.js runtime)

I've since re-written the site to use my new libraries. My current challenge is trying to make it fast enough and create some kind of dev-server that is able to reload the site generator pipeline and run it when files (content or source code) are changed

## Next Up

As outlined before, I plan to have a few posts in this series. My immediate next post will talk about how to actually create a page using `charge` so keep an eye out for that

## Closing

Static site generators can get complicated it turns out. Features need to be well thought out before being dropped in. A lot of time gets spent evaluating different options and libraries until one that fits well enough that it can be used

I've always thought "I'll never build a framework, that would suck" but it looks like I'm here building one. And it sort of does suck. However, it's an interesting design problem and I'm keen to see just how far I end up taking this little static site framework I've started on

And it's also great getting to spend a lot of time just looking at code and thinking "is this the best way I can represent this"
