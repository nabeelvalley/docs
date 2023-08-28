---
published: true
title: Puppeteer
subtitle: Browser Automation using Node.js and Puppeteer
---

---
published: true
title: Puppeteer
subtitle: Browser Automation using Node.js and Puppeteer
---

# Installing

To get started with Puppeteer you will need to install it to your package `npm i puppeteer` this will install the required packages as well as a Google Chrome instance for Puppeteer

# Basic Usage

In general, you will create a new `browser` instance, and interact with that instance using the `puppeteer api`. A basic example of using Puppeteer to take a screenshot can be seen below which will run a headless browser instance

```js
const puppeteer = require('puppeteer')

;(async () => {
  const browser = await puppeteer.launch()
  const page = await browser.newPage()
  await page.goto('https://www.google.com')
  await page.screenshot({ path: 'google/index.png' })

  await browser.close()
})()
```

# Non-Headless Mode

Some of the settings that are available when creating a browser are the `headless:false` and the slow-down speed `slowMo`:

```js
const browser = await puppeteer.launch({
  headless: false,
  slowMo: 250,
})
```

# Screenshots

To navigate, type, and take some screenshots you can see the following:

```js
const puppeteer = require('puppeteer')
const fs = require('fs')

const run = async () => {
  const browser = await puppeteer.launch({
    headless: false,
    slowMo: 150,
    defaultViewport: null,
  })
  const page = await browser.newPage()
  await page.goto('https://www.google.com')
  await page.screenshot({ path: 'google/index.png' })

  await page.type('input[type = text]', 'Hello World')
  await page.keyboard.press('Enter')
  await page.screenshot({ path: 'google/search.png' })

  const searchText = await page.$eval('*', (el) => el.innerText)
  fs.writeFileSync('google/text.txt', searchText)

  await browser.close()
}

run()
```

# Running JS Code in the Browser

It can sometimes be useful to execute arbitrary code in browser window that interacts with the DOM, for example replacing some text in the HTML. This can be done by using the `.evaluate` function:

```js
await page.evaluate(() => {
  document.body.innerHTML = 'Hello World' // this will update the DOM
})
```

Alternatively, the `.evaluate` function can also take data to share from the Node.js process to the browser process as a second argument, like so:

```js
const name = 'Bob'
const age = 32

await page.evaluate(
  (props) => {
    console.log(props.name, props.age) // this will be logged in the browser console
  },
  { name, age }
)
```

# Connect to a Running Chrome Instance

To connect to a chrome instance, you can start chrome from your terminal and pass it the following argument:

```sh
chrome.exe --remote-debugging-port=9222
```

The above will work on Windows, use the following for MacOS

```sh
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  --remote-debugging-port=9222
```

You can also switch out port `9222` for any other port you want, thereafter use `puppeteer.connect` instead of `puppeteer.launch` like so:

```js
const browser = await puppeteer.connect({
  browserURL: `http://localhost:9222`,
  slowMo: 250,
})
```

> Again, note that the port can be any port you like
