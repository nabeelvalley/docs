<details>
  <summary>Contents</summary>

- [Submodules](#submodules)
	- [Set Up a Test Repo](#set-up-a-test-repo)
	- [Add a Submodule](#add-a-submodule)
	- [Cloning a Project with Submodules](#cloning-a-project-with-submodules)
- [Pull Latest Changes from Submodule](#pull-latest-changes-from-submodule)
- [Clean Ignored Files](#clean-ignored-files)

</details>

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
