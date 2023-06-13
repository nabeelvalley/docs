---
title: Nvim Error when using Plugins
subtitle: 13 June 2023
description: Fix NVim Error Executing Lua with Plugins
---

When trying to use an NVim plugin you may run into the following error message:

```
Error executing lua ...path/to/some/vim/file.lua
```

This can happen due to a plugin update that was run or another plugin being installed that caused the working tree of the plugin to be out of date or in an invalid state

To fix this, you may want to try updating and cleaning your plugins. In my case, I am using `VimPlug` so the commands are:

```
:PlugUpdate
:PlugClean
```

Thereafter, quitting and reopening vim seems to usually fix the issue, if not then you may need to investigate the plugin itself