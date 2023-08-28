---
published: true
title: GitHub CLI
description: Quick tips for using the GitHub CLI
---

---
published: true
title: GitHub CLI
description: Quick tips for using the GitHub CLI
---

> [GitHub CLI Website](https://cli.github.com)

# Setup

For MacOS the CLI can be installed with:

```sh
brew install gh
```

Once installed, you will need to log in using the CLI with:

```sh
gh auth login
```

# Help

For help on any command, as usual, you can append `--help` to the command you're trying to use for more details

# Working with Repos

PR functionality is contained under `gh repo`

## Create a Repo

To create a repo you can use:

```sh
gh repo create
```

And then follow the prompts

## Clone a Repo

To clone a repo you can use the `gh repo clone` command with the name of the repo, for example to clone the repo that this file is in:

```sh
gh repo clone nabeelvalley/docs
```

# Working with Pull Requests

PR functionality is contained under `gh pr`

## Create a PR

You can create a pull request using:

```sh
gh pr create
```

If you don't give it any args with the required data then the CLI open the interactive menu to select any required data

Some of the params that I use frequently when creating a PR are `--title`, `--labels`, and `--reviewer`

A PR with the above may look like so:

```sh
gh pr create --title "Add some cool feature" --labels feature,cool --reviewer nabeelvalley
```

A draft PR can also be created by appending `--draft` to an PR related command, e.g.

```sh
gh pr create  --draft
```

Or

```sh
gh pr create --title "Add some cool feature" --labels feature,cool --reviewer nabeelvalley --draft
```

## List PRs

You can list PRs using

```sh
gh pr list
```

Additionally, you can do things like searching and the like using the various flags, e.g. to check for PRs with a specific labels:

```sh
gh pr list --labels feature,cool
```

Or a more complex version which looks for only closed PRs and limits the output to 100

```sh
gh pr list -s closed --limit 100
```

Which will get PRs that have both the `feature` and `cool` label

# Working with JSON

Each of the CLI commands that output data let you get the data in JSON format along with specific fields

To use the JSON output, append the `--json` flag followed by a list of the JSON fields you'd like to see

The following is an example that uses one of the PR commands above with the JSON output with author and pr labels

```sh
gh pr list -s closed --limit 100 --json author,labels
```
