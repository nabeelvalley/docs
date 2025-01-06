import { animate } from "./canvas"
import CanvasWorker from './canvas.worker?worker'
import type { InvokeParams } from './canvas.worker'

const app = document.querySelector<HTMLDivElement>('#app')!


const onScreenCanvas = document.createElement('canvas')
const offScreenCanvas = document.createElement('canvas')

app.appendChild(onScreenCanvas)
app.appendChild(offScreenCanvas)


const counter = document.createElement("p")
app.appendChild(counter)


animate(onScreenCanvas)

const worker = new CanvasWorker()

const offscreen = offScreenCanvas.transferControlToOffscreen()

worker.postMessage({ canvas: offscreen } satisfies InvokeParams, [offscreen])

setTimeout(() => {
  let i = 0
  while (i < 1e12) { i++; counter.innerHTML = i.toString() }
}, 5000)
