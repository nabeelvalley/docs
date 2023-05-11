`index.js`

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Web Workers</title>
    <script type="module" src="./simple-worker-launcher.js"></script>
  </head>
  <body>
    <input id="input" />
    <button id="button">Send Message</button>
    <button id="blocking">Do Blocking Thing</button>
    <div>
      <img src="placeholder?height=400&width=500" />
      <img src="placeholder?height=200&width=500" />
    </div>
    <div id="messages"></div>

    <script type="module" src="./main.js"></script>
    <script type="module" src="./register-service-worker.js"></script>
  </body>
</html>
```

`register-service-worker.js`

```js
navigator.serviceWorker.register("service-worker.js").then(console.log);
```

`service-worker.js`

```js
console.log("i am still here2");

self.addEventListener("install", () => console.log("installed"));

self.addEventListener("activate", () => console.log("activated"));

self.addEventListener("fetch", (event) => {
  console.log(event.request.url);

  if (event.request.url.includes("placeholder")) {
    const url = new URL(event.request.url);

    const height = url.searchParams.get("height") || 200;
    const width = url.searchParams.get("width") || 500;

    console.log("image requested");
    event.respondWith(
      fetch(
        `https://placehold.co/${height}x${width}?text=This image does not exist`
      )
    );
  }
});
```

`simple-worker-launcher.js`

```js
const worker = new Worker("./simple-worker.js");
console.log({ worker });

worker.postMessage("");

setTimeout(() => {
  worker.terminate();
  worker.postMessage("");
}, 1000);
```

`simple-worker.js`

```js
console.log("launched simple worker");

self.addEventListener("message", () => console.log("got event"));
```

`worker.js`

```js
// in the worker state `self` is an instance of `DedicatedWorkerGlobalScope` which is like `window`
// `window` is also not defined in this scope
console.log({ self, typeofWindow: typeof window });

const doIntensiveThing = () => {
  console.log("started intensive thing");
  const start = Date.now();
  const end = start + 3000;

  // do nothing, just block the tread for 10 seconds
  while (Date.now() < end) {}
};

// some events we can also listen for are on the `self` object
self.addEventListener("message", (ev) => {
  // messages passed from the service worker will arrive here
  console.log({ dataToWorker: ev.data });

  // if the message is the word `slow` then we will do some intensive thing
  if (ev.data === "slow") {
    self.postMessage("start processing slow thing");
    doIntensiveThing();
    self.postMessage("done processing slow thing");
  } else {
    self.postMessage("done processing fast thing");
  }
});
```