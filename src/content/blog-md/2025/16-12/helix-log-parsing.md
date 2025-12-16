---
title: Parsing Helix logs in Nushell
subtitle: 16 December 2025
published: true
---

A super quick one today - I was doing some debugging on a [Language Server](/blog/2025/26-03/the-language-server-protocol) for [Helix](https://helix-editor.com/) and it was getting really annoying trying to find the data I was looking for so I wrote this quick [Nushell](https://www.nushell.sh/) command:

```sh
cat ~/.cache/helix/helix.log | 
    lines | 
    parse "{date} helix_lsp::transport [{type}] {source} <- {data}"
```

This will parse the Helix logs using the given format.

The `data` portion is also JSON, so adding the JSON parsing can be done with:

```sh
cat ~/.cache/helix/helix.log | 
    lines | 
    parse "{date} helix_lsp::transport [{type}] {source} <- {data}" |
    each {update data {|e| $e.data | from json}}
```

I also prefer normal JSON to the helix data view for this kind of data, so you can tac on `| to json | jq` to pipe it to [jq](https://jqlang.org/) for some nice JSON rendering and querying:

```sh
cat ~/.cache/helix/helix.log | 
    lines | 
    parse "{date} helix_lsp::transport [{type}] {source} <- {data}" |
    each {update data {|e| $e.data | from json}} |
    to json | jq
```