---
title: A NodeJS Playground for the Browser
description: Creating a development environment in the browser using Web Containers and React
subtitle: 20 May 2023
published: false 
---

<!-- Temporarily marked as .md since the playground component does not render currently -->

import Playground from '../../../../components/Playground.astro'

[WebContainers](https://webcontainers.io/) are a cool tech by StackBlitz that let you run a Node.js development environment in your browser

> This will be a bit of an ongoing series as I play around with WebContainers and implement a sort of IDE that I can use to make the code samples on this website interactive

The current state of my implementation can be seen below

<Playground
  name="web-containers-and-react"
  initialCommand="pnpm install"
  startCommand="pnpm dev"
/>

The idea is to turn the above into a little code editor that will also let me pull out code snippets that can be interactive and runnable

This is especially useful for more complex snippets that sprawl over multiple files and require dependencies to run

The following are some features that I would like to implement over time:

- [x] Load up the container with files that can be run
- [x] A way to define the core editor state for a post - contained in `window.webcontainerFiles`
- [x] Notify user when a server is up so they can open it
- [ ] Extract snippets from the editor so that they can be rendered inline
- [ ] Make the editor full-screen-capable so that longer code samples can be viewed in their totality
- [ ] Run commands by pressing a button and allow a user to modify small snippets of code
- [ ] Make it look not so bad
