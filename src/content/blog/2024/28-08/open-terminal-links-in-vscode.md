---
title: An unexpected way to open links in the terminal
description: A little shortcut for opening terminal links in VSCode
subtitle: 28 August 2024
---

I accidentally hit `cmd + shift + o` while in the terminal on VSCode which popped open a little window to navigate to the links to files that were currently printed out in my terminal - this seems like a more keyboard friendly way to do `cmd + click` on a link in the terminal

Upon further investigation it looks like the following is a thing:

1. When in the terminal, after running some command
2. Find a link (URL or file) that you want to open
3. Use the command pallette with `cmd + shift + p` and use the `Terminal: Open Detected Link ...` command
4. Browse the links, if it's a file you'll automatically preview the file, click enter to select a file or link to open

Tadaa, that's about it - an accidental shortcut that I'll most definitely be using in the future