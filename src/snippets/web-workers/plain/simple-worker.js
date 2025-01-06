console.log("launched simple worker");

self.addEventListener("message", () => console.log("got event"));