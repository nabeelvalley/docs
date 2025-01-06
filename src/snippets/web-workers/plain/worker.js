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
