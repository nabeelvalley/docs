const worker = new Worker("./simple-worker.js");
console.log({ worker });

worker.postMessage("");

setTimeout(() => {
  worker.terminate();
  worker.postMessage("");
}, 1000);