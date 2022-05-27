[[toc]]

![Build Action Dist](https://github.com/nabeelvalley/twitter-bio-update/workflows/Build%20Action%20Dist/badge.svg)
![Run Twitter Bio Action](https://github.com/nabeelvalley/twitter-bio-update/workflows/Run%20Twitter%20Bio%20Action/badge.svg)

> You can take a look at the Action we build in this post [here on GitHub](https://github.com/nabeelvalley/twitter-bio-update/actions). I've also included an action that's responsible for building and updating the action `dist` which may also be of interest. It's all in [this Repository](https://github.com/nabeelvalley/twitter-bio-update)

A few weeks ago I was playing around with GitHub actions and the recently introduced GitHub Account README functionality and wanted a way to make this "static" file a bit more dynamic

Enter GitHub Actions. GitHub actions are a way for you to define and run programmatic tasks. If you can put it in code, then you can run it as an action

Usually, you'll be using actions that have been defined by GitHub or another developer for common tasks, such as running your application CI or deployment processes. However, since actions are **extremely** generic, we're going to do something a little different - update our Twitter bio?

In this post, we're going create a GitHub action that uses the Twitter API to update our bio, as well as make the action we created run automatically on GitHub

1. Create a GitHub Repository for us to work in
2. Set up Twitter Developer Credentials
3. Write a Node.js script that uses the Twitter API
4. Configure our GitHub Action Metadata
5. Add our Twitter Secrets in GitHub
6. Configure a GitHub Action that will run our script (an action, within an action)

# Prerequisites

- [Git](https://git-scm.com/downloads)
- [Node.js](http://nodejs.org/)
- [Visual Studio Code](https://code.visualstudio.com/) or any other Code Editor

# Create a GitHub Repo

For us to run our action we'll need a GitHub Repository to use, to create a Repo go to [GitHub](https://github.com/) and sign in, thereafter go the ['Create a new repository page'](https://github.com/new) and fill in the details, be sure to select `Initialize this repository with a README`, pick `Node` as the `.gitignore` file, and select a license if you'd like to

Once you've done that, click `Create repository` and you should see the initial files we added to the Repo. Next, click on the `Code` button and copy the URL in the text box

Now, from a terminal, you will need to clone the repository. Run the following command and make sure to paste the link you just copied in place of `<YOUR URL>` below:

```sh
git clone <YOUR URL>
```

Next, open the folder you just cloned in your code editor and create a new file called `.env` in the folder root directory. We'll keep our Twitter credentials in this file for testing. For now, just add the following to the file:

`.env`

```sh
TWITTER_CONSUMER_KEY=
TWITTER_CONSUMER_SECRET=
TWITTER_ACCESS_KEY=
TWITTER_ACCESS_SECRET=
```

In the next step, we're going to get the credentials from Twitter, we'll add them into the file above when we're done

# Get Some Twitter Cred.

Twitter exposes the Twitter Developer API that allows us to do all kinds of useful and pointless things by interacting with Twitter's data

For us to consume the Twitter API we require credentials for the API. To set these up we'll need to do a few things

First, open your browser on [the Twitter Developer Portal](https://developer.twitter.com/) and click the sign-in button. Then, once you've signed in, you should see your name on the top right of the page, click on the dropdown arrow and select `Apps` to go to the App Dashboard

On the App Dashboard, click `Create an app` and fill in the **required** information. For the `Website URL` you can put the URL of your GitHub repository that you copied previously into this field. Once you've filled in all the details click `Create` at the bottom of the page

You should now see the Details Page for the app we just created. Next, click on the `Keys and Tokens` tab and click `Generate` then copy and paste each token after the `=` in the `.env` file we created without any spaces before or after the key

When you've pasted your tokens into their places, your `.env` file should look something like this:

> Note that using the template for `.gitignore` that we chose, the `.env` file will be automatically ignored. Don't publically upload this data just anywhere as it can potentially give someone access to your Twitter account

`.env`

```sh
TWITTER_CONSUMER_KEY=xxxxxxxxxxxxxxxxxxxxxx
TWITTER_CONSUMER_SECRET=xxxxxxxxxxxxxxxxxxx
TWITTER_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxx
TWITTER_ACCESS_SECRET=xxxxxxxxxxxxxxxxxxxxx
```

(With the actual keys, and not just `xxxx`)

Now that we've got our credentials set up, we can start to work on the application

# Using the Twitter API

We're going to be writing a script that runs on Node.js (JavaScript) and makes use of the Twitter API using the `twit` library for Node.js and the GitHub libraries for working with GitHub actions

To get started, run the following command from a terminal within your repository's directory to initialize a new Node.js project and select the defaults for all the questions:

```sh
npm init -y
```

Next, we'll add the dependencies that our application is going to need to run:

- `@actions/core` allows us to interact with the data provided to our action by GitHub
- `twit` is used to interact with the Twitter API
- `dotenv` enables us to load in our `.env` file so our application can use it

```sh
npm install @actions/core twit dotenv
```

Once the application is done installing we'll create an `index.js` file inside of our repo folder and we can get started on our code

Inside of the `index.js` the first thing we'll want to do is import our environment variables from the `.env` file we configured, we'll do that using the `dotenv` NPM Package we installed previously:

`index.js`

```js
require('dotenv').config()
```

Next, we'll configure a new `Twitter` API Client using our environment variables. The `twitter` Package exports a `Twitter` class that we can create an instance of, do to this we will use the `Twitter` constructor and get our environment variables that are all stored in the `process.env` variable:

`index.js`

```js
const Twitter = require('twitter')

const client = new Twitter({
  consumer_key: process.env.TWITTER_CONSUMER_KEY,
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
  access_token_key: process.env.TWITTER_ACCESS_KEY,
  access_token_secret: process.env.TWITTER_ACCESS_SECRET,
})
```

Now that we've got an instance of a `Twitter` client that we can use to interact with the API we'll want to use it

The Twitter API Client runs asynchronously, for us to work with it correctly we have two options:

1. Using the `callback` method, which means that we give the `client` a function to run when it's done sending the data to Twitter. While this is easier in our specific circumstance it can become difficult to keep track of when we have many different callback functions
2. The second option is to use `async` and `await` syntax, which allows us to write our code more sequentially and makes it easier for us to control our sequence and flow

To use the `async/await` functionality, we need the code that we need to `await` to be inside of an `async` function. In this one function, we can `await` as many tasks as we want sequentially without worrying about callbacks

We'll create a `main` function that is `async` in which we will do any asynchronous interactions, in our case - interact with Twitter

After the code we've already got in our `index.js` file, define the `main` function as follows:

`index.js`

```js
const main = async () => {
  // this is where we'll work with the twitter client
}
```

Next, we'll add the code to interact with the Twitter API inside of this function. To update our Profile Bio (or `description` as it's called in the Twitter API) we'll make use of the `account/update_profile` endpoint

The data we send the Twitter API will need to be an object with a `description` property for what we want to set our Twitter Bio as. We'll `await` this function call by adding it within our `main` function:

`index.js`

```js
const main = async () => {
  const response = await client.post('account/update_profile', {
    description: 'Hello, World!',
  })

  console.log(response)
}
```

The above code will set our Twitter `description` to `Hello, World!` and then print our the `response` we get back from Twitter

The way we've written the above code is a little bit dangerous as we aren't handling any potential errors/failures that may happen when interacting with the Twitter API

When working with an API via an HTTP Request there's always the chance that there could be an error. Errors can be caused by anything ranging from poor network connections, incorrect credentials, or a system outage on the API host itself

For our application to give us a bit more information about what happened, we may want to handle the error before passing it on to the process that kicked off our script. We'll make use of a `try/catch` to handle this error:

`index.js`

```js
const main = async () => {
  try {
    const response = await client.post('account/update_profile', {
      description: 'Hello, World!',
    })

    console.log(response)
  } catch (error) {
    console.error(error)
    throw new Error(
      `The Twitter API Responded with an Error: ${error[0].code}, ${error[0].message}`
    )
  }
}
```

You can see above that we're just doing some cleanup of the error message before throwing the exception to the process

Now that we've fully defined our `client` and `main` functions we can call the function as the last line of the script:

`index.js`

```js
main()
```

This should make a request to the Twitter API and print our the `response` or `error` if there is one

So, the above function will always set our Twitter Bio to the same value, this isn't interesting. Next, we'd like to get some data from the workflow that's going to be running our action. The way we would do this is with an `input`

Our action is going to take an `input` called `bio`. We can use the `@actions/core` library to get the value of the `input`. We can do this with the following:

`index.js`

```js
const core = require('@actions/core')

const bio = core.getInput('bio') || 'Hello, World!'
```

The above code also sets a default value of `Hello, World!` to the description, this will allow us to also run the action without throwing an exception on our local machine as well as if the `bio` is not provided to the action

Furthermore, instead of just throwing errors, we can rather set the error-status using the `core.setFailed` function. Updating our `main` function to do this we now have:

`index.js`

```js
const main = async () => {
  try {
    const response = await client.post('account/update_profile', {
      description: bio,
    })

    console.log(response)
  } catch (error) {
    console.error(error)
    core.setFailed(
      `The Twitter API Responded with an Error: ${error[0].code}, ${error[0].message}`
    )
  }
}
```

Finally, our full `index.js` file should look like this:

`index.js`

```js
re('dotenv').config()

const Twitter = require('twitter')
const core = require('@actions/core')

const bio = core.getInput('bio') || 'Hello, World!'

const client = new Twitter({
  consumer_key: process.env.TWITTER_CONSUMER_KEY,
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
  access_token_key: process.env.TWITTER_ACCESS_KEY,
  access_token_secret: process.env.TWITTER_ACCESS_SECRET,
})

const main = async () => {
  try {
    const response = await client.post('account/update_profile', {
      description: bio,
    })

    console.log(response)
  } catch (error) {
    console.error(error)
    core.setFailed(
      `The Twitter API Responded with an Error: ${error[0].code}, ${error[0].message}`
    )
  }
}

main()
```

Now that we've written the functionality for our action we'll want to turn it into an action

# Configure the Action Metadata

For GitHub to recognise our code as an action, we need to create an `action.yml` file that contains a description of our action. Our `action.yml` file needs to have the following information:

- `name` for our action
- `description` of the action itself
- an `input` parameter of `bio` that will be used by our application
- `runs` which states the script to run

The `action.yml` file for our action looks like the following:

`action.yml`

```yml
name: 'Twitter Bio Update'
description: 'Update your Twitter Account Bio'
inputs:
  bio:
    description: 'Text that you would like to set as your Twitter Bio'
    required: true
    default: 'Hello, World!'
runs:
  using: 'node12'
  main: 'index.js'
```

The fields we've got above are all pretty much required. The above fields are the simplest configuration for a Node.js action. The [GitHub Docs](https://docs.github.com/en/actions) have a lot more information on more complex configurations and actions

Now that we've defined our action, we will want to configure it to run. But before we can do that, we'll want to set up our secrets

# Setting Up Secrets in GitHub

Now that we've got our action defined, we're almost ready to write a Workflow that will use this action. However, our action requires environment variables (that we've got saved in our `.env` file) but we don't want these to be pushed to GitHub as part of our source code. The way to set up these environment variables in GitHub is called a `secret`

To add our environment variables in GitHub you'll need to open your Repo on GitHub and navigate to `Settings > Secrets` then click `New secret` and add your first secret. If we use our `.env` file as a reference we'll want to create a secret for each line in the file. To do this look at the name of the environment variable (everything before the `=`) and set this as the `Name` for the secret, then look at the value (everything after the `=`) and set this as the `Value` for the secret then click `Add secret`. Do this for every line in your `.env` file (every environment variable`

# Create a Workflow

Workflows are GitHub's way of tying together a bunch of actions to run. Often, we will want to run multiple actions. We place these into what's called a `step` in a `job`. Each Workflow can have multiple `steps` and `jobs` and a repository can have multiple workflows

The structure of a workflow is something like this:

```
workflow
|-- Job 1
|   |-- Step 1
|   |-- Step 2
|-- Job 2
    |-- Step 1
```

A Workflow can have any number of jobs and steps

We're going to create a Workflow with a single job with the goal of running our script. For us to do this, the job will need to do the following:

1. Checkout our code
2. Configure Node.js and NPM
3. Install Dependencies
4. Run our Action

To do Steps 1 and 2 we're going to use actions that are defined by GitHub. We're going to go through our Workflow file working from the top-down as this is the order in which everything will be run

Firstly, we'll need to create a new directory in our Repository named `.github` and inside of this another called `workflows`. Inside of the `.github/workflows` directory create a file named `main.yml` (this can be any name so long as it's a `yml` file)

Next, on the first line of this file we will define a name for our workflow like so:

`main.yml`

```yml
name: Run Twitter Bio Action
```

This is the name that will be displayed when the workflow runs. Actions are run when a specific GitHub event happens (more about that [in the Docs](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)). We're going to configure our action to run manually only, so we will use the `workflow_dispatch` event. After the `name` in the `main.yml` file, add the following:

`main.yml`

```yml
on:
  workflow_dispatch:
    inputs:
      bio:
        description: 'Twitter Bio'
        required: true
```

In the above, we set an `on` event for `workflow_dispatch` with an `input` for `bio` that we're going to pass on to our action

Now that we've got the workflow metadata defined, we're going to add a `job`. To do this, we'll add a `jobs` object with a name of `update-bio`, a specification on what OS it needs to run on, and the `steps` that will be a part of it:

`main.yml`

```yml
jobs:
  update-bio:
    runs-on: ubuntu-latest
    name: Update Twitter Bio
    steps:
      # we'll add the steps here in a moment
```

We can see above that we're running on the `ubuntu-latest` OS. Next, we'll add the first step for checking out our code in the action. This will use `actions/checkout`:

`main.yml`

```yml
steps:
  - name: Checkout
    uses: actions/checkout@v2
```

In the above, we give our step a `name` which is for display purposes, and a `uses` which says what action this step should use. In our case, we're checking out our code using the `actions/checkout@v2` action

Next, we'll want to configure Node.js and NPM because our action needs these to run. We can use the `actions/setup-node@v1` for this:

`main.yml`

```yml
- name: Setup Node.js
  uses: actions/setup-node@v1
  with:
    node-version: 12.x
```

In this action, we use the `with` to state an `input` that the action needs. In this case, we specify that we want to use a `node-version` of `12.x`

Now we've got Node.js and NPM, we need to install the dependencies for our action to run. We do this with the `npm install` command like so:

`main.yml`

```yml
- name: Install Dependencies
  run: npm install
```

And lastly, we will configure our action to run with the following:

`main.yml`

```yml
- name: Run Action
  uses: ./
  env:
    TWITTER_CONSUMER_KEY: ${{ secrets.TWITTER_CONSUMER_KEY }}
    TWITTER_CONSUMER_SECRET: ${{ secrets.TWITTER_CONSUMER_SECRET }}
    TWITTER_ACCESS_KEY: ${{ secrets.TWITTER_ACCESS_KEY }}
    TWITTER_ACCESS_SECRET: ${{ secrets.TWITTER_ACCESS_SECRET }}
  with:
    bio: ${{ github.event.inputs.bio }}
```

In this last step we're doing quite a few things:

1. We're setting a `name` for our action
2. We set a `uses` to be `./` which means we want to run the action at the root of our Repo (our `action.yml`)
3. We set the `env`, these are the different environment variables we want to pass to the application. We use `${\{ ... }\}` to mean that it's a variable, and we use `secrets.variable` to access the variable from the secrets we configured in the repository
4. We use the `with` to set the `bio` from the input we give to the workflow on our `workflow_dispatch` event. GitHub exposes this in the `github.event.inputs.bio` variable

With the `Run Action` step added, we've got a full workflow. The overall `main.yml` file should have the following:

`main.yml`

```yml
name: Run Twitter Bio Action
on:
  workflow_dispatch:
    inputs:
      bio:
        description: 'Twitter Bio'
        required: true

jobs:
  update-bio:
    runs-on: ubuntu-latest
    name: Update Twitter Bio
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v1
        with:
          node-version: 12.x
      - name: Install Dependencies
        run: npm install
      - name: Run Action
        uses: ./
        env:
          TWITTER_CONSUMER_KEY: ${{ secrets.TWITTER_CONSUMER_KEY }}
          TWITTER_CONSUMER_SECRET: ${{ secrets.TWITTER_CONSUMER_SECRET }}
          TWITTER_ACCESS_KEY: ${{ secrets.TWITTER_ACCESS_KEY }}
          TWITTER_ACCESS_SECRET: ${{ secrets.TWITTER_ACCESS_SECRET }}
        with:
          bio: ${{ github.event.inputs.bio }}
```

# Run the Action

To run the action, we first need to get everything to GitHub. From Repo directory, in the terminal, run the following commands:

```sh
git add .
git commit -m "I made a GitHub Action!"
git push
```

Then, go to your repository on GitHub and click on the `Actions` tab. You should then see your Workflow listed. Click on your workflow name, and then the `Run workflow` dropdown. Fill in your `Twitter Bio`, wait for the workflow to complete and look at your Twitter profile!

From GitHub, you are also able to inspect and view any logs or errors from a Workflow run. If the workflow fails you can also take a look at the output that was thrown by the step that resulted in the failure

# Summary

And that's about it. We've taken a look at how you can use GitHub actions to automate a pretty silly task, but there's a lot more to using GitHub Actions, and the sky's the limit in terms of what you can use them for

Overall, GitHub actions aren't too different from similar options like Azure Pipelines, Jenkins, or any other CI service. What makes them so useful is how easily they hook into the source control system and how well they work and are supported within the GitHub ecosystem

That all being said, they're not the easiest things to configure and it can take a while to get them right if you're doing something especially complex. Overall they're pretty cool and are a pretty good place to get started with automating tasks and working with things like continuous integration and deployments and I'd definitely recommend giving them a shot
