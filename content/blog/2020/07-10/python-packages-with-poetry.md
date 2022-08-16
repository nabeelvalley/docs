[[toc]]

> [Poetry Docs](https://python-poetry.org/docs/)

Python package management is typically quite a mess. Managing packages with `pip` often requires additional management of things like virtual environments and python version management

Poetry is a package manager that abstracts a lot of the typical Python dependency and environment management away from the user

# Install Poetry

Before you can install `poetry` you need to have Python installed

To install `poetry` you can do one of the following depending on your OS:

## Windows Powershell

```ps1
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -
```

## Bash

```sh
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
```

# Initialize Poetry

## Create a New Project

If you're starting a new project, you can run the following:

```sh
poetry new my-project
```

The above will generate a `pyproject.toml` file with the project settings. Alternatively you can use the following to add `poetry` to an existing project

## Add to Existing Project

To add `poetry` to an existing project, run the following:

```sh
poetry init
```

# Using Poetry

## Add Dependency

To manage dependencies you can use the `poetry add` command. For example, if we would like to install `flask`

```sh
poetry add flask
```

## Run Application

To run an application using the virtual environment created by `poetry` you can use the `poetry run` command, followed by the command you want to run:

```sh
poetry run python app.py
```

Running a `flask` app would look something like this:

```sh
poetry run flask run
```

# Create a Shell

To create a shell in the `poetry` virtual environment run:

```sh
poetry shell
```

The above will open a `poetry` shell with the virtual environment. You can then do something like run the `python` command to open a `python` shell in the environment
