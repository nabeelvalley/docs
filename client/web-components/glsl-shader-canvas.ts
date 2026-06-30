import { Canvas } from 'glsl-canvas-js'

const canvases = new WeakMap()
const getCanvas = (root: HTMLElement) => {
  const script = root.querySelector('script')
  const canvas = root.querySelector('canvas')

  const existing = canvases.get(root)
  if (existing) {
    return existing
  }

  if (!(script && canvas)) {
    return
  }

  canvas.dataset['fragment'] = script.innerText
  const instance = new Canvas(canvas)
  canvases.set(root, instance)

  return instance
}

const showCanvas = (canvas: HTMLElement) => {
  const instance = getCanvas(canvas)
  instance.play()
}

/**
 * Destroys the rendering instance as well as the overall canvas to ensure that
 * the entire canvas WebGL instance is reinitialized
 */
const destroyCanvas = (
  obs: IntersectionObserver,
  canvas: HTMLCanvasElement,
) => {
  const instance = canvases.get(canvas)
  if (!instance) {
    return
  }

  // Handle instance checking
  instance.pause()
  instance.destroy()
  canvases.delete(canvas)

  // Handle the cloning of the node

  const parent = canvas.parentElement

  const newCanvas = canvas.cloneNode() as HTMLCanvasElement

  obs.unobserve(canvas)
  obs.observe(newCanvas)

  parent?.removeChild(canvas)
  parent?.appendChild(newCanvas)
}

const observer = new IntersectionObserver((entries) =>
  entries.forEach((entry) => {
    const target = entry.target as HTMLCanvasElement
    if (entry.isIntersecting) {
      showCanvas(target)
    } else {
      destroyCanvas(observer, target)
    }
  }),
)

document
  .querySelectorAll('site-glsl-shader-canvas')
  .forEach((el) => observer.observe(el))
