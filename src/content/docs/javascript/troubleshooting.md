[[toc]]

# Node-gyp

If you run into the node-gyp issue, look at the installation instructions on the [node-gyp documentation](https://github.com/nodejs/node-gyp#on-windows) that tell you the prereqs and how to install the build tools for windows and set the python version

```bash
npm install --global --production windows-build-tools
node-gyp --python /path/to/python2.7
npm config set python /path/to/executable/python2.7
```

For more information you can also look at the [`Node on Windows` Guidelines](https://github.com/Microsoft/nodejs-guidelines/blob/master/windows-environment.md)

Alternatively an easier solution is to just run things in a Docker container if possible

# MSBuild

If you run into the `MSBuild version` error, let me know how you fixed it otherwise just switch to Ubuntu and start over

# EAI_AGAIN Error

If when running `npm install` you see the following error

```
npm ERR! code EAI_AGAIN
npm ERR! errno EAI_AGAIN
```

It means there is a problem with your internet connection, not NPM (or Docker)
