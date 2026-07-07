const worker = new Worker("./simple-worker.js");
console.log({ worker });

worker.postMessage("hello there");

setTimeout(() => {
  worker.terminate();
  worker.postMessage("hello again");
}, 1000);
