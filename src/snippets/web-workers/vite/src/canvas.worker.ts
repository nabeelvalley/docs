import { animate } from "./canvas"

export interface InvokeParams {
  canvas: OffscreenCanvas
}

// setup if in worker
addEventListener('message', e => run(e.data))

function run({ canvas }: InvokeParams) {
  animate(canvas)
}
