---
title: Dev Tools Update
subtitle: 03 August 2022
description: Software development tools and languages I'm using at the moment
published: true
---

# Programming Languages

I've primarily switched over to Typescript as my language for building applications, but I've also been learning Rust for the purpose of building some low-level libraries

For Typescript, something I've been finding to be really informative is the [Type Challenges Repository](https://github.com/type-challenges/type-challenges) which has a lot of challenges along with solutions for modeling and solving complex problems using Typescript's type system

For Rust, the [Rust Book](https://doc.rust-lang.org/book/) along with the [No Boilerplate YouTube Channel](https://www.youtube.com/c/NoBoilerplate) have been really informative

# Frameworks

The current version of my website is built using [11ty](https://www.11ty.dev) which is a static site generator which uses Javascript and templates for generating HTML from a variety of data sources - in my case just JSON and Markdown files

A lot of the work I do still revolves around the React ecosystem, however I've moved on from Gatsby due to the slow build times as a static site builder - for now I'm just using 11ty since I tend to keep my static sites pretty light on Javascript. But other than that I would like to give the [Remix Framework](https://remix.run) a shot and will probably be using it on my next big personal project

# Code Editor

I'm back to VSCode after a short stint with [NeoVim](http://neovim.io).

My reasons for leaving NeoVim were mostly due to the amount of setup when switching devices as well as the issues I experienced on Windows where configuration management was a bit inconsistent as well as the dependency management for some plugins became a lot of admin. Even preconfigured solutions like [LunarVim](https://github.com/LunarVim/LunarVim) and [AstroNvim](https://github.com/AstroNvim/AstroNvim) didn't work well due to lots of compat issues on Windows

As far as VSCode is concerned, some things I've been using are:

- [The GitHub Online Editor](https://github.dev/)
- The GitHub Colorblind Theme (GitHub.github-vscode-theme)
- Code Spell Checker Extension (streetsidesoftware.code-spell-checker)
- GitLens Extension (eamodio.gitlens)
- Hex Editor (ms-vscode.hexeditor)
- Rust Analyzer Extension (rust-lang.rust-analyzer)
- Fix Extension (withfig.fig)

# Terminal

Some terminal tools I've been enjoying recently are:

- [Hyper](https://hyper.is) - An alternative terminal that's so far been less sluggish and more customizable than the Windows Terminal application
- [Fig](https://fig.io) - Provides autocomplete for commands and integrates with loads of CLI tools to provide detailed suggestions and documentations
- [NuShell](http://nushell.sh) - A shell that works with the idea of command output as data that can be manipulated and transformed which adds a lot of cool data processing functionality on top of your normal shell comands