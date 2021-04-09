<details>
  <summary>Contents</summary>

- [Stage Files Using Glob](#stage-files-using-glob)
- [Revert Commits](#revert-commits)
  - [Revert Single Commit](#revert-single-commit)
  - [Revert Multiple Commits](#revert-multiple-commits)
- [Submodules](#submodules)
  - [Set Up a Test Repo](#set-up-a-test-repo)
  - [Add a Submodule](#add-a-submodule)
  - [Cloning a Project with Submodules](#cloning-a-project-with-submodules)
- [Pull Latest Changes from Submodule](#pull-latest-changes-from-submodule)
- [Clean Ignored Files](#clean-ignored-files)
- [Create an Orphan/Unrelated Branch](#create-an-orphanunrelated-branch)
- [Using Git from Another Tool](#using-git-from-another-tool)
- [Consistent Line Endings](#consistent-line-endings)
- [Locate your SSH Key on Windows](#locate-your-ssh-key-on-windows)

</details>

# Stage Files Using Glob

Git allows the use of globbing to work with files, using this knowledge we're able to do something like stage files based on a glob pattern, so we can do something like stage all `.js` and `.ts` files with:

```
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

```
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

# Using Git from Another Tool

Sometimes it's useful to use git from another tool/application. To get a more standard/parseable output from git commands you can add the `--porcelain` flag. For example, with `git status` below:

```sh
> git status --porcelain

 M Random/git.md
?? Random/wsl.json
?? Random/wsl.md
```

As opposed to:

```
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

You can setup consistent line endings for repositories that are shared between Windows and *nix systems by adding the following to a `.gitattributes` file

`.gitattributes`

```
* text=auto eol=lf
*.{cmd,[cC][mM][dD]} text eol=crlf
*.{bat,[bB][aA][tT]} text eol=crlf
```

# Locate your SSH Key on Windows

When using `git` with SSH you may have difficulties finding the location for the SSH keys to use, to find the SSH Key you need to navigate to `%HOMEDRIVE%%HOMEPATH%\.ssh\` To figure out where this folder is you can do the following: `start > run > %HOMEDRIVE%%HOMEPATH%`. The SSH Keys being used should be located in here
