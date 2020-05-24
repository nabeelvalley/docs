Essentially I'm trying to do something like `nodemon` and `forever` but just a lot simpler and that will suit my needs better

# Running Dev

Clone the GitHub Repo, and then install the app dependencies and install the application globally

```powershell
npm i 
npm i -g
```

Next we can link NPM to our actual package instead of the global version with

```powershell 
npm link
```

# What's Happening Here 

## Getting Started  

We have a simple node app that is running globally, but linked to our application's `index.js` file with the following 

```powershell 
npm i -g 
npm link 
``` 

## Define Run Command 

Next we the `startover` command linked in our `package.json` as follows 

```json 
{
  "name": "startover",
  "version": "0.0.0",
  "description": "Rerun scripts on file change",
  "main": "index.js",
  "scripts": { ... },
  "bin": {
    "startover": "./index.js"
  },
	... 
}
```

This will allow us to run th `index.js` file which is done by simply running the following command 

```powershell 
startover 
```

## Parsing Command Line Arguments 

We make use of the `commander` package to parse CLI arguments, we do this from the 	`index.js` file and parses the various parameters

```js 
const app = require('commander')

const split = val => val.split(',')

app.version('0.1.0')
    .option('-d, --dirs [directories]', 'List of directories to watch', split)
    .option(
        '-c, --commands [directory]',
        'List of Commands to run when files change',
        split
    )
    .option(
        '-f, --exclude-files [files to exclude]',
        'List of Files to Exclude from Watch',
        split
    )
    .option(
        '-e, --exclude-extensions [extensions to exclude]',
        'List of Extensions to Exclude from Watch',
        split
    )
    .option(
        '-D, --exclude-directories [directories to exclude]',
        'List of Directories to Exclude from Watch',
        split
    )
    .parse(process.argv)

console.log('Called with the following Options')

if (app.dirs) console.log('dirs:', app.dirs)
if (app.commands) console.log('commands:', app.commands)
if (app.excludeFiles) console.log('excluded files:', app.excludeFiles)
if (app.excludeExtensions)
    console.log('excluded extensions:', app.excludeExtensions)
if (app.excludeDirectories)
    console.log('excluded directories:', app.excludeDirectories)
```

We can also get help and information on the commands with

```powershell
startover -h 
```

# Watcher Events

I then defined the events for the file watcher as well as the configuration

```js 
// Initialize watcher.
var watcher = chokidar.watch('.', {
    ignored: new Array().concat(
        app.excludeDirectories,
        app.excludeFiles,
        new RegExp(app.excludeExtensions.map(el => '.' + el).join('|'))
    ),
    persistent: true
})

// Something to use when events are received.
var log = console.log.bind(console)

// Add event listeners.
var ready = false;

watcher
    .on('add', path => console.log(`File ${path} has been added`))
    .on('change', path => {
        if (ready) execute()
        log(`File ${path} has been changed`)
    })
    .on('unlink', path => {
        if (ready) execute()
        log(`File ${path} has been removed`)
    })
    .on('addDir', path => {
        if (ready) execute()
        log(`Directory ${path} has been added`)
    })
    .on('unlinkDir', path => {
        if (ready) execute()
        log(`Directory ${path} has been removed`)
    })
    .on('error', error => log(`Watcher error: ${error}`))
    .on('ready', () => {
        ready = true;
        log('Initial scan complete. Ready for changes')
    })
```

And finally added a function to carry out the custom command that I need to be run 

```js
const child_process = require('child_process')

// Utility functions
const split = val => val.split(',')

const execute = () => {
    app.commands.forEach(command => {
        child_process.exec(command, function(error, stdout, stderr) {
            if (stdout) console.log('command out:\n ' + stdout)
            if (stderr) console.log('stderr:\n' + stderr)
            if (error !== null) console.log('exec error: ' + error)
        })
    })
}
```

# Run Startover 

We can run startover once it is installed with the following command

```powershell 
startover -d myapp -f hello.js,"bye world.html" -e css,md -c "npm run build" -D test,
```
It is important to remember that the command/commands we are running from the `-c` option must be compatible with the system/shell we are running `startover` in and they will run one after the other

# Resources 

I've made use of a few different resources for the application as follows

## Articles 
- [Building command line tools with Node.js](https://developer.atlassian.com/blog/2015/11/scripting-with-node/) by Tim Pettersen

## Libraries 
- Parsing Commands : [Commander](https://npmjs.org/package/commander)
- Watching File System : [Chokidar](https://www.npmjs.com/package/chokidar)