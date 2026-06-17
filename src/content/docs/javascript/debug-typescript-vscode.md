---
published: true
title: Debug Typescript with VSCode
subtitle: Typescript Debugging using Visual Studio Code and ts-node
---

It's possible to debuge any TS file without compiling using `ts-node` from VSCode

First, init a new npm project with typescript (normally you should already have one):

```sh
npm init -y
npm install typescript
npx tsc --init # this isn't needed, but really you should have a tsconfig
```

Now - time to start: install `ts-node`:

```sh
npm install ts-node
```

Next, create a `.ts` file to debug, e.g:

`log.ts`

```ts
const log = (name: string) => {
  console.log('hello ' + name)
}

log('bob')
```

Then create a `.vscode/launch.json` file:

`.vscode/launch.json`

```json
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Current TS File",
      "type": "node",
      "request": "launch",
      "args": ["${relativeFile}"],
      "runtimeArgs": ["--nolazy", "-r", "ts-node/register"],
      "sourceMaps": true,
      "cwd": "${workspaceRoot}",
      "protocol": "inspector"
    }
  ]
}
```

And that's about it, you should be able to use the debug config on whatever TS file you're looking at without any added effort
