---
published: true
title: Git
subtitle: Miscellaneous Git Concepts
description: Git tips and tricks
---

# Stage Files Using Glob

Git allows the use of globbing to work with files, using this knowledge we're able to do something like stage files based on a glob pattern, so we can do something like stage all `.js` and `.ts` files with:

```sh
git add **/*.{js,ts}
```

> You can create and test glob patterns on [GlobTester](https://globster.xyz/)

# Revert Commits

> From [StackOverflow](https://stackoverflow.com/questions/1463340/how-to-revert-multiple-git-commits)

## Revert Single Commit

Say we have a commit with id `b` below, and we would like undo changes that were introduced in that commit but still retain our history as is, something like:

We want to go from this state:

```
a -> b -> c -> d -> e
```

To this state:

```
a -> b -> c -> d -> e -> b'
```

Such that `b'` undoes the changes introduced by `b`, then we can use the following git command:

```sh
git revert --no-commit HEAD~4
```

Where `HEAD~4` means the 4th last commit from the current `HEAD` (latest commit)

## Revert Multiple Commits

Say we have a commit with id `b` below, and we would like undo changes that were introduced in that all changes since that commit but still retain our history as is, something like:

We want to go from this state:

```
a -> b -> c -> d -> e
```

To this state:

```
a -> b -> c -> d -> e -> (bcde)'
```

Such that `(bcde)'` undoes the changes introduced by all commits from `b` to `e`, then we can use the following git command:

```
git revert --no-commit HEAD~4..
```

Where `HEAD~4` means the 4th last commit from the current `HEAD` (latest commit) and the `..` means a commit range till the latest commit

# Submodules

Submodules allow you to include one git repository in another, for instance if we want to include a library in our codebase

## Set Up a Test Repo

We can get started on a new test repository, just create a folder with some files and other folders in it and run:

```bash
git init
```

Thereafter add and commit all the files in the repo:

```bash
git add .
git commit -m "initial commit"
```

## Add a Submodule

Next, from the directory into which you want the submodule to be cloned into, you can run the following command:

```bash
git submodule add https://github.com/nabeelvalley/YourRepository.git
```

If we would like to change the name of the folder being cloned from the default, we can add a new name for the folder by adding it at the end of the clone command

```bash
git submodule add https://github.com/nabeelvalley/YourRepository.git NewNameForSubmoduleDirectory
```

This will clone the repository into a directory called `NewNameForSubmoduleDirectory`

You will also see a new `.gitmodules` file in your parent repo's root directory created with the following:

```
[submodule "MySubmodules/YourRepository"]
	path = MySubmodules/YourRepository
	url = https://github.com/nabeelvalley/YourRepository.git

[submodule "MySubmodules/NewNameForSubmoduleDirectory"]
	path = MySubmodules/NewNameForSubmoduleDirectory
	url = https://github.com/nabeelvalley/YourRepository.git
```

You can see above an example of a submodule created with the default name as well as a renamed one

Next you will see that the new files need to be committed, you can do that with

```bash
git add .
git commit -m "add submodules"
```

## Cloning a Project with Submodules

When cloning a project that has submodules you can do either of the following:

```bash
git clone https://github.com/nabeelvalley/MyNewRepository.git
```

And then updating the submodules with:

```bash
git submodule init
git submodule update
```

If you want to init and update all nested submodules of the repository at once you can use:

```bash
git submodule update --init
```

And if you want to also update any further embedded submodules you can do:

```bash
git submodule update --init --recursive
```

Alternatively if you are cloning the project for the first time you should be able to pull everything including the submodules with `--recurse-submodules`

```bash
git clone --recurse-submodules https://github.com/nabeelvalley/MyNewRepository.git
```

# Pull Latest Changes from Submodule

To pull the latest changes from a submodule into the repository you can make use of the following command:

```bash
git submodule update --remote --merge
```

There's a lot more you can do with submodules but these are the basics, more information is in [the Git docs](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

It's also relevant to note that when working on submodules you can kind of treat them as a normal git repository and work on them like you would if they were such

# [Clean Ignored Files](http://www.codeblocq.com/2016/01/Untrack-files-already-added-to-git-repository-based-on-gitignore/)

To remove files that are in your `.gitignore` but are not ignored by your repo, you can do the following:

```bash
git rm -r --cached .
```

Which will clean out the repo, and then you can restage and commit all the files that should be tracked with

```bash
git add .
git commit -m ".gitignore fix"
```

# Create an Orphan/Unrelated Branch

> Information from [this Stack Overflow Answer](https://stackoverflow.com/a/4288660)

Sometimes it's useful to start a completely fresh segment of work without carrying around previous changes, e.g. to test out a totally new application architecture

We can do this by using the following:

```bash
git checkout --orphan NEW_BRANCH_NAME
git rm -rf .
```

Then you can remove all old files, or do whatever work is required and then:

```bash
git add .
git commit -m 'Initial commit on new branch'
```

# Using Git Flow

To init Git Flow in a repo use `git flow` for the help menu:

```sh
> git flow

usage: git flow <subcommand>

Available subcommands are:
   init      Initialize a new git repo with support for the branching model.
   feature   Manage your feature branches.
   bugfix    Manage your bugfix branches.
   release   Manage your release branches.
   hotfix    Manage your hotfix branches.
   support   Manage your support branches.
   version   Shows version information.
   config    Manage your git-flow configuration.
   log       Show log deviating from base branch.

Try 'git flow <subcommand> help' for details.
```

To init a new Git Flow project:

```sh
git flow init
```

This will then ask you to update the naming convention for your branching system, it uses the defaults as listed in the help menu above

The full log when runing the above command will look something like this:

```sh
> git flow init

Initialized empty Git repository in C:/Users/NVALLEY/source/repos/gitglow/.git/
No branches exist yet. Base branches must be created now.
Branch name for production releases: [master]
Branch name for "next release" development: [develop]

How to name your supporting branch prefixes?
Feature branches? [] feature/
Bugfix branches? [] bugfix/
Release branches? [] release/
Hotfix branches? [] hotfix/
Support branches? [] support/
Version tag prefix? []
Hooks and filters directory? [<REPO PATH/.git/hooks]
```

> When using `init` you will also automatically be switched to the `develop` branch if you're working on an existing project

Now you can use the `git flow <BRANCH TYPE> start <FUNCTION NAME>` command to start a new feature branch for something like so:

```sh
> git flow feature start save-user

Switched to a new branch 'feature/save-user'

Summary of actions:
- A new branch 'feature/save-user' was created, based on 'develop'
- You are now on branch 'feature/save-user'
Now, start committing on your feature. When done, use:
git flow feature finish save-user

```

The above will then add you to a feature called `feature/save-user` and you can then make some changes and commits on this branch

When you're done with that you can use `git flow <BRANCH TYPE> finish <FUNCTION NAME>` to merge the work to develop

```sh
>  git flow feature finish save-user

Switched to branch 'develop'
Updating 012cac2..ecfd049
Fast-forward
 stuff.txt | Bin 0 -> 28 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 stuff.txt
Deleted branch feature/save-user (was ecfd049).

Summary of actions:
- The feature branch 'feature/save-user' was merged into 'develop'
```

You can then continue to use the above methodology to manage branching, releases, etc.

# Using Git from Another Tool

Sometimes it's useful to use git from another tool/application. To get a more standard/parseable output from git commands you can add the `--porcelain` flag. For example, with `git status` below:

```sh
> git status --porcelain

 M Random/git.md
?? Random/wsl.json
?? Random/wsl.md
```

As opposed to:

```sh
> git status

On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   git.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        wsl.json
        wsl.md
```

# Consistent Line Endings

You can setup consistent line endings for repositories that are shared between Windows and \*nix systems by adding the following to a `.gitattributes` file

```.gitattributes title=".gitattributes"
* text=auto eol=lf
*.{cmd,[cC][mM][dD]} text eol=crlf
*.{bat,[bB][aA][tT]} text eol=crlf
```

# Locate your SSH Key on Windows

When using `git` with SSH you may have difficulties finding the location for the SSH keys to use, to find the SSH Key you need to navigate to `%HOMEDRIVE%%HOMEPATH%\.ssh\` To figure out where this folder is you can do the following: `start > run > %HOMEDRIVE%%HOMEPATH%`. The SSH Keys being used should be located in here

# Delete All Branches other than Master

Using `grep` and `xargs` you can do this using:

```sh
git branch | grep -v "master" | xargs git branch -D
```

# Get File From Specific Branch or Commit

## Show File

> From this [StackOverflow](https://stackoverflow.com/questions/7856416/view-a-file-in-a-different-git-branch-without-changing-branches) answer

If you'd simply like to view a file as it stands in another branch you can use:

```sh
git show other_branch:path/to/file
```

So for example, we can do the following to view a specific file from a specific branch

```sh
git show feature/new-user:src/users/user.page.ts
```

You can also pipe this into `bat` for example to view the file with syntax highlighting

```sh
git show feature/new-user:src/users/user.page.ts | bat -l ts
```

## Checkout File

If you'd like to checkout the file from into your current working tree you can use the following instead:

> From this [StackOverflow](https://stackoverflow.com/questions/307579/how-do-i-copy-a-version-of-a-single-file-from-one-git-branch-to-another) answer

To basically copy a version of a file from one branch or commit to another you can use `git checkout` with either providing the branch name or commit from which you want to get the file

```sh
git checkout branch_or_commit_sha path/to/file
```

So to get a specific file from a `develop` branch

```sh
git checkout develop src/my-file.ts
```

Or from a specific commit

```sh
git checkout 211512 src/my-file.ts
```

## View Diff

If you'd like to compare the file to what you have in your current branch you can use `git diff` like so:

```sh
git diff other_branch -- path/to/file
```

So this may look like so:

```sh
git diff feature/stuff -- src/stuff/my-stuff.html
```

# Checkout Previous Branch

When switching branches, we can easily go to the last branch we were on using:

```sh
git checkout -
```

# Get Commit Changes from another Branch (Cherry Picking)

Cherry picking allows us to get a specific commit from one branch and bring it into our current branch

```sh
git cherry-pick commit_sha
```

For example, if we want to take the changes from commit `211512` into our branch you can use

```sh
git cherry-pick 211512
```

# Automatically Set Upstream

When using git it can be annoying when pushing a new branch since it will always request that you setup the upstream/origin. You can configure git to do this automatically using the following command:

```sh
git config --global push.autoSetupRemote true
```

# Enable Case Sensitivity

To ensure that git is case sensitive on non-case-sensitive systems (Windows) you can use the following command:

```sh
git config core.ignorecase false
```

# Find Bad Commits using Bisect

1. Checkout the branch where the bad commit exists
2. Run `git bisect start` to start a bisect session. If you're looking for a PR you can also use the `--first-parent` flag here which will make it easier to find merges only for example
3. Checkout a commit that is known to be bad and run `git bisect bad`
4. Checkout a commit that is known to be good and run `git bisect good`
5. Then the bisect tool will automatically checkout another commit

- Do your checks
- If good then run `git bisect good`, otherwise run `git bisect bad`

The overall flow for this will be something like

```sh
git bisect start # or git bisect start --first-parent
git bisect good # to label a commit as good
git bisect bad # to label a commit as bad
# the tool will checkout another commit, you then mark this as good or bad
```

6. The process will run until you find the last bad commit, you can then try to figure out what was changed in that commit.

If you need to view the changes made you can do `git bisect log`. You can also save this to a file with something like `git bisect log | my-log-file.txt`. You can then edit that file to make changes to the log if you made a mistake along the way and you can replay the changes using `git bisect replay my-log-file.txt`

Like so:

```sh
git bisect log | my-log-file.txt
# edit the my-log-file.txt` to correct a mislabeling, etc.
git bisect replay my-log-file.txt
```

# Git User Configs

> Refer to [this StackOverflow for more information](https://stackoverflow.com/questions/4220416/can-i-specify-multiple-users-for-myself-in-gitconfig/43654115#43654115)

Often when using git you may need to have multiple accounts on the same machine and would like more specific control over config for different repositories - Often I would like to be able to set my email address differently for a specific repo or group of repos

To do this, you can use two solutions depending on your usecase:

## Single Repository

For a repository you can update the `.git/config` file for that repository using the following command:

`~/repos/my-repo/.git/config`

```sh
git config set user.email "repo@email.com"
```

## For a Subdirectory

Sometimes you may have multiple subdirectories in which you would like repositories within it to inherit a specific config, you can do this by:

1. Adding a conditional includes in your global git config `~/.gitconfig` file

`~/.gitignore`

```toml
# default value to be used outside of subdirectory
[user]
    name = Nabeel Valley
    email = nabeel@email.com

# link to subdirectory config
[includeIf "gitdir:~/repos/my-other-repos/"]
    path = ~/repos/my-other-repos/.gitconfig
```

> Note that for Windows you have to include the path as `C:/Users/my-user/repos/my-other-repos.` in the `includeIf` section and the `path` section

2. In the subdirecroty create a `.gitconfig` file that has specifies the config for the entire subdirectory:

`~/repos/my-other-repos/.gitconfig`

```toml
# override value that applies to this subdirectory only
[user]
    email = other@email.com
```

# Rebasing

Rebasing lets us modify and restructure commits. It's can get kind of messy but is handy for cleaning up commit history for example

Interactive rebasing is the easiest way to go about it in my opinion, this is done by starting a rebase session

Say I've got a branch with the following history:

```sh
f1d5c91 (HEAD -> example-feature) fix typo
b5cb5c3 add initial notes
9ab331d (main) initial commit
```

And I want to squash the last two commmits. I can do this using `git rebase`. When rebasing like this we can provide the branch we want to rebase on top of:

```sh
git rebase main -i
```

Or the commit from which we'd like to start rebasing:

```sh
git rebase 9ab331d0 -i # this is the first commit, we want to rebase on top of this
```

We can also reference this hash using:

```sh
git rebase HEAD~2 -i
```

Once the rebase session has started, you'll see an editor open with some content like this followed by some instruction on what the different keywords do:

```sh
pick b5cb5c3 # add initial notes
pick f1d5c91 # fix typo

# Rebase 9ab331d..f1d5c91 onto 9ab331d (2 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
#                    commit's log message, unless -C is used, in which case
#                    keep only this commit's message; -c is same as -C but
#                    opens the editor
# ...
```

In our case, let's say we want to combine the `fix typo` commit into the previous commit, we can do this by editing the rebase file with the relevant command. For this we can use `fixup` which will squash the commit into the previous one and keep the previous message. We can edit the rebase file to look like this:

```sh
pick b5cb5c3 # add initial notes
fixup f1d5c91 # fix typo
```

Then, save and close this file - the rebase process will run automatically and prompt you if required, e.g. for doing things like updating the commit messaage

Once we're done rebasing, our log now looks like this:

```sh
7814a0e (HEAD -> example-feature) add initial notes
9ab331d (main) initial commit
```

# Newer Git Stuff

> From [Git Tips and Tricks](https://blog.gitbutler.com/git-tips-and-tricks/)

## Log changes to specific part of file

Log changes to a specific part of a file using:

```sh
git log -L FROM,TO:path/to/file
```

For example:

```sh
git log -L 10,20:my/file.js
```

You can also do this using the name of some symbol in your code and it will try to figure that out for you:

```sh
git log -L SymbolName:path/to/file
```

## Git Maintenance

Run the following in a repo to make git maintain the repo and keep things fast in the background using a CRON job (just run this in every repo)

```sh
git maintenance start
```

## Searching for Specific Change

> [StackOverflow Question](https://stackoverflow.com/questions/2839253/git-history-find-lost-line-by-keyword/2839319#2839319)

To search for a specific piece of text that was changed at some point in history (e.g. find some deleted text) you can use:

```sh
git log -p --all -S 'search term here'
```

Or with a Regex:

```sh
git log -p --all -G 'some regex here'
```

## Speeding things Up

> Some general commands that should help speed up git as per [this GitTower Post](https://www.git-tower.com/blog/git-performance/)

Running the following in a repo should speed up the behaviour of git in general

```sh
git config feature.manyFiles true
git update-index --index-version 4
git config core.fsmonitor true
git fsmonitor--daemon status
git config core.untrackedcache true
git config core.commitgraph true
git config fetch.writeCommitGraph true
```

For more details for dealing with Large Git Repos there's some nice info on [the GitButler Site](https://blog.gitbutler.com/git-tips-3-really-large-repositories/) y

## Automatically Applying Git Diffs/Patches

> [StackOverflow on Git patches](https://stackoverflow.com/questions/2249852/how-to-apply-a-patch-generated-with-git-format-patch)

Sometimes it's handy to take a git diff/patch from one place and apply it to another. A simple way to do this is using the following method:

1. Pipe the git diff into a file: `git diff 12345..67890 --no-ext-diff | mychanges.patch` (`--no-ext-diff` uses the default git diff format)
2. You can then apply the changes using `git apply` like: `cat mychanges.patch | git apply`

Other handy commands here are `git apply --stat mychanges.patch` to get the status of the patch or `git apply --check mychanges.patch` to dry run/detect errors

# Worktrees

Worktrees help to separate work by effectively having multiple copies of the repository on your drive while maintaining a single git index

## Create a Worktree

Creating a worktree is done from the main repo directory, you can optionally give it a branch name with `-b`. If not provided this will just be the name of the worktree

```sh
git worktree add ../experiments -b experiment/thing-im-trying
```

You can then navigate to that directory with

```sh
cd ../experiments
```

> Note that you cannot have the same branch on multiple worktrees at the same time - each tree is linked to a specific branch

Since the worktrees are also using the same git index, it's easy to do things like `cherry-pick` commits from branches in other worktrees without pushing it to a remote

## Listing Worktrees

Git can let us view the worktree and will provide us with information about the path and branch checkout out at each tree

```sh
git worktree list
```

## Removing Worktrees

Removing a worktree will delete the directory but not the associated branches, this can be done with:

```sh
git worktree remove ../experiments
```

# Reflog

> Some good examples of using the reflog can be found [in this tutorial](https://www.datacamp.com/tutorial/git-reflog)

The reflog tracks all operations that were done in a repository and it enables us to move between those operations

We can use the following command to view the reflog

```sh
git reflog
```

And the log will look something like this:

```sh
692a778 (HEAD -> example-feature) HEAD@{7}: commit: some content
d834109 (main) HEAD@{8}: checkout: moving from main to example-feature
d834109 (main) HEAD@{9}: merge example-feature: Fast-forward
7814a0e HEAD@{10}: checkout: moving from example-feature to main
d834109 (main) HEAD@{11}: rebase (finish): returning to refs/heads/example-feature
d834109 (main) HEAD@{12}: rebase (fixup): Add content for special notes
00e23a8 HEAD@{13}: rebase (reword): Add content for special notes
0c6d933 HEAD@{14}: rebase: fast-forward
7814a0e HEAD@{15}: rebase (start): checkout main
```

We can then move between different points in the history using the `checkout` command:

```sh
git checkout HEAD@{9}
```

Which will get the state of the repository at that specific point in time

You can also checkout using time, like so:

```sh
git checkout HEAD@{1.day.ago}
```

# Tools on Top of Git

## LazyGit

[LazyGit](https://github.com/jesseduffield/lazygit) is a terminal UI for Git. Using it can be done by running the `lazygit` command and it's the default git UI in LazyVim so it fits pretty well together

Additionally, lazygit allows for a custom difftool to be configured, this can be done through the `lazygit` config and can be done as per [the docs on configuring a custom pager](https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md)

Some diff tools that can be used with LazyGit (or even just your normal git installation)

- [Difftastic](https://github.com/Wilfred/difftastic) provides syntax-based diffs and has the nicest output of any of the diff tools I've found so far
- [Diff so Fancy](https://github.com/so-fancy/diff-so-fancy) provides syntax-based diffs, similar to Difftastic
- [Delta](https://github.com/dandavison/delta) is a "pretty" diff tool and can do syntax-based diffing using `diff-so-fancy` with the `delta --diff-so-fancy` flag provided

> Note that the above diff tools can modify your global diff, to get this to work as normal you can stick on the `--no-ext-diff` flag, e.g. `git diff HEAD --no-ext-diff` will get you back to the normal git diff
