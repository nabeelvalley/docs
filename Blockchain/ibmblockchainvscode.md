> Note: Just use Ubuntu, you shouldn't run into all the build issues that you will with Windows for Node

# VSCode Extension

Download the VSCode Extension from the Extensions Tab named `IBM Blockchain`, when that is done click `Reload` to reload your VSCode. Next you will see that the IBM Blockchain extension has been added on your extensions menu

# Connecting to a Blockchain on the Cloud

## Configuration

Before you can connect to your IBM Cloud Blockchain, you will need the following

1. Connection Profile
2. Certificate
3. Private Key

## Connection Profile

From your IBM Blockchain Dashboard navigate to `Overview > Connection > Download` to download your Connection Profile `json` file

## Certificate and Private Key

From the IBM Blockchain Dashboard navigate to `Certificate Authority > Generate Certificate (Admin)`

Copy the `Certificate` into a text file, and do the same for the `Private Key`. Be sure to store these in a secure place and to not expose them publicly

## Add Your Certificate

Next add your certificate by navigating to `Members > Certificates > Add Certificate` and enter a `Name` for your certificate and your `Certificate` that was generated previously and `Submit`, then click on `Restart` to restart all your peers


## Configure the Extension

Now click on the IBM Blockchain extension on your extensions panel, and in the panel hover beside the `Blockchain Connections` and click the `+` button. You will then be directed to give a name to the connection and select your `Connection Profile`, `Certificate` and `Private Key` files that you had previously downloaded/created

# Create a Smart Contract

From the VSCode Command Palatte (Can be accessed with `Ctrl + Shift + P`) search for `Create Smart Contract Package` and click on the command

You will then be asked to choose a language, I'll be using Typescript

Then you will need to choose a folder for the project, create a folder called `smartcontracts` and select that and you can chose to `open in new window` or `add to workspace`

The smart contract files will then be generated

To the `.gitignore` add `node_modules` if you plan on using git

# Install Dependencies

Install dependencies with `npm i`

## Python Versions and Path

If you get a `Can't find Python executable "python"` error, you can read [this page](https://docs.anaconda.com/anaconda/user-guide/tasks/integration/python-path/) about adding python to your path with Anaconda

You will need to be running `Python 2.7`, so make sure that you configure your environment to be such. You can add new environments from the Anaconda Navigator. Check your Python version from a new terminal with `python --version`

You can configure a new Anaconda environment with Python 2.7  (I named mine `python2.7`) and you can then modify your Python Path to be `C:\tools\Anaconda3\envs\python2.7` instead to reference your new environment

> If you run into the node-gyp issue, look at the installation instructions on the [node-gyp documentation](https://github.com/nodejs/node-gyp#on-windows)

For more information you can also look at the [`Node on Windows` Guidelines](https://github.com/Microsoft/nodejs-guidelines/blob/master/windows-environment.md)

## MSBuild

If you run into the `MSBuild version` error, let me know how you fixed it otherwise just switch to Ubuntu and start over

# Test the build

We can test the build to make sure we don't have any problems with the current setup

```bash
npm run build
```

# Run the Tests

```bash
npm run test
```

