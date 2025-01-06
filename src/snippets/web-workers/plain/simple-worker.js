console.log("launched simple worker");

self.addEventListener("message", (e) => console.log("got event", e.data));