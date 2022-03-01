> Taken from [this StackOverflow answer](https://stackoverflow.com/questions/38004148/another-git-process-seems-to-be-running-in-this-repository)

```
Another git process seems to be running in this repository, e.g.
an edirot opened by 'git commit'. Please make sure all processes
are terminated then try again. If it still fails, a git process
may have crashed in this repository earlier:
remove the file manually to continue
```

Sometimes when using Jenkins a Git process may crash or timeout resulting in an error message like the above one. This can result in issues when running later Git steps or running other Git steps in the repository in the Jenkins workspace

The simplest way I've found to fix this is to simply delete the `.git/index.lock` or `.git/shallow.lock` file from the workspace that's giving the issue and run again