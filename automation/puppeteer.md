# Browser Automation with Puppeteer

To get started with Puppeteer you will need to install it to your package `npm i puppeteer` this will install the required packages as well as a Google Chrome instance for Puppeteer

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

Some of the settings that are available when creating a browser are the `headless:false` and the slow-down speed `slowMo`:

```js
const browser = await puppeteer.launch({
  headless: false,
  slowMo: 250
})
```

To navigate, type, and take some screenshots you can see the following:

```js
const puppeteer = require('puppeteer')
const fs = require('fs')

const run = async () => {
  const browser = await puppeteer.launch({
    headless: false,
    slowMo: 150,
    defaultViewport: null
  })
  const page = await browser.newPage()
  await page.goto('https://www.google.com')
  await page.screenshot({ path: 'google/index.png' })

  await page.type('input[type = text]', 'Hello World')
  await page.keyboard.press('Enter')
  await page.screenshot({ path: 'google/search.png' })

  const searchText = await page.$eval('*', el => el.innerText)
  fs.writeFileSync('google/text.txt', searchText)

  await browser.close()
}

run()
```
