
---
title: r7.0 - Housekeeping
description: Some cleanup before the new site redesign can begin
feature: true
published: true
---

> This is the 0th post in series about my website redesign, I'll add links to the other parts here as they become available

## Context

My website has been around for quite some time. Having a space on the internet is really important to me and over the years it's been home to countless experiments and attempts at self expression

As such, what I need from this website is constantly evolving. Converging in some ways, diverging in others

I've build support for numerous data formats, abandoned or restructured others, and standardized along the way. Walking through flexibility, expression, and maintainability

Through the previous iterations of this website I've been mostly concerned with adding new things. Features, data, flair. But through this constant upward climb, the weight I'm carrying becomes ever more burdensome

I've been meaning to do a redesign for a few months now at least. The previous version of my site had been active since 2023. It was built with [Astro](https://astro.build/) which is a JavaScript framework for building static sites. Astro's biggest selling point being its [islands architecture](https://docs.astro.build/en/concepts/islands/) that lets you opt into using different libraries or frameworks as you need. You can drop in a [React](https://react.dev/) component for your search box, and let authors write content in [MDX](https://mdxjs.com/) that embeds any components from any myriad of other frameworks

Over the years I've grown weary of tools that do much more than you need. The problem with doing too much is that it is often at the expense of doing those things well. Along with the ability to do lots of stuff, you also get the downside of doing all those things

For example, deep MDX integration makes it difficult to author content anywhere other than a code editor, or complex build processes make it difficult to fix issues that come up when you inevitably need to update some random dependency

## Taking Account

The primary challenges of updating my website come from some complex content support I built quite early, and a few Astro components that do server-side stuff that I built along the way

Some formats I don't want to support anymore are:

1. MDX - Between editor syntax highlighting messiness from using every framework as once and the complexity it adds to the build process this is something I don't want anymore
2. [Jupyter Notebooks](https://jupyter.org/) - I used to do a lot of python programming when I just started out and this was a pretty sizable chunk of my notes but that hasn't been the case for years. Jupyter notebooks are also just not something that most static site generators support out of the box. So I've always have had to implement my own parser and renderer for them which just isn't what I want to spend my time doing
3. Web frameworks in general - I've always had some framework to carry along, this always comes with a lot of build complexity and a mountain of dependencies. I just don't want to deal with frameworks if I don't have to - and in this case I don't have. For cases where I need some interactivity I'm going to stick to plain old [web components](https://developer.mozilla.org/en-US/docs/Web/API/Web_components)

## Planning Ahead

Before I could just delete everything though, I needed to figure out what I want my new site to have and come up with a plan for cleaning up my content

I skimmed my codebase and found a few categories of stuff that needed to be migrated and came up with a plan accordingly:

1. Jupyter Notebooks - I'll adapt my script that renders them to HTML to instead output Markdown versions of the notebook files that will work as-is with my site. Managing images would be a bit messy but it's a relatively minor detail
2. Client side components - These are either Astro or JSX. Depending on the component I'll do one of the following:
	1. If I have an existing web-component, I'll update all instances to use that - e.g. [my presentation components](/talks)
	2. If it's a simple Astro component that I want to keep I'll rewrite it as a web component like - e.g. [my shader renderer](/intro-to-shaders)
	3. If it's a component that's just used in a few places I'll inline it where needed
3. Server side components - These are the most complex and are used a lot. These will be discussed in a later blog post in this series
4. Random JSON data for some pages - This should be relatively simple to handle and is mostly just "effort" so I'll pick that up later and use hardcoded HTML for now

## Site Requirements

Based on an analysis of what I want to keep, the new site architecture has some hard requirements:

1. Markdown support for pages
2. Web component support 
	- For the sake of using TypeScript here, a compiler/bundler will also be needed
3. Server-side components of some kind
4. Some dynamic routes - like the [blog](/blog) and [docs](/docs) index as well as [RSS feed](/feed/rss.xml)
5. No dependency on frontend frameworks (more of an anti-requirement I guess)

I also really wanted to use [Gleam](https://gleam.run/) because I like it and would like to stress-test my functional programming abilities. A secondary goal of this project is to create a small library that I can use to create other sites

Additionally, since I've been a bit more involved with web accessibility recently, I'm going pay attention to this on the new site and try to deliver the best experience I can

## Next Up

Since this is the 0th part, that perhaps implies that there are other posts to come. My plan for this series is as follows:

- Part 0 - Housekeeping (this post)
- Part 1 - Architecture
- Part 2 - Creating Pages
- Part 3 - Server Components
- Part 4 - A Library

The site is currently live and is a little ahead of what we've talked about so far, so look around and have a peek at what's to come

## Closing

I don't expect this site to last forever. Just as how its predecessors didn't. I would however like to focus on decoupling some of the bits that make it possible so that I can upgrade them more iteratively

I don't plan to have a giant all-features-at-once release. The new site will come up in pieces any it's not a goal to ever have feature parity with the old version. I'd like to put focus on having more well thought-out and interestingly designed features. And, well … that takes time

Lastly a shout out to [Andy Bell's](https://bell.bz/) personal site redesign [series on Piccalilli](https://piccalil.li/projects/personal-site/) which is the inspiration for this series
