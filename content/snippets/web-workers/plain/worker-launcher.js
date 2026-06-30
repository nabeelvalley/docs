const worker = new Worker("./worker.js");
console.log({ worker });

worker.postMessage("hello there");

worker.addEventListener("message", (e) =>
  console.log("message from worker", e.data)
);
