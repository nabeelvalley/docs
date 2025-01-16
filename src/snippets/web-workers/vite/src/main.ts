import CanvasWorker from "./canvas.worker?worker";
import type { InvokeParams } from "./canvas.worker";

const app = document.querySelector<HTMLDivElement>("#app")!;

const offScreenCanvas = document.createElement("canvas");

app.appendChild(offScreenCanvas);

const counter = document.createElement("p");
app.appendChild(counter);

const worker = new CanvasWorker();

const offscreen = offScreenCanvas.transferControlToOffscreen();

worker.postMessage({ canvas: offscreen } satisfies InvokeParams, [offscreen]);

setInterval(() => {
  alert("Block main thread now");
}, 5000);
