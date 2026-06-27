// @ts-check

import 'https://unpkg.com/glsl-canvas-js@0.2.4/dist/umd/glsl-canvas.js'

const Canvas = glsl.Canvas

const canvases = new Map()
const getCanvas = (/** @type {HTMLElement} */ root) => {

  const script = root.querySelector('script')
  const canvas = root.querySelector('canvas')

  const existing = canvases.get(root)
  if (existing) {
    return existing
  }

  canvas.dataset['fragment'] = script.innerText
  const instance = new Canvas(canvas)
  canvases.set(root, instance)

  return instance
}

const showCanvas = (/** @type {HTMLElement} */ canvas) => {
  const instance = getCanvas(canvas)
  instance.play()
}

/**
 * Destroys the rendering instance as well as the overall canvas to ensure that
 * the entire canvas WebGL instance is re-intialized
 */
const destroyCanvas = (
    /** @type {IntersectionObserver} */ obs,
    /** @type {HTMLCanvasElement} */ canvas
) => {
  const instance = canvases.get(canvas)
  if (!instance) {
    return
  }

  // handle instance checking
  instance.pause()
  instance.destroy()
  canvases.delete(canvas)

  // handle the cloning of the node

  const parent = canvas.parentElement
  
  const newCanvas = /** @type {HTMLCanvasElement} */ (canvas.cloneNode())

  obs.unobserve(canvas)
  obs.observe(newCanvas)

  parent.removeChild(canvas)
  parent.appendChild(newCanvas)
}

const observer = new IntersectionObserver((entries) =>
  entries.forEach((entry) => {

    const target = /** @type {HTMLCanvasElement} */ (entry.target)
    if (entry.isIntersecting) {
      showCanvas(target)
    } else {
      destroyCanvas(observer, target)
    }
  })
)

document
  .querySelectorAll('site-glsl-shader-canvas')
  .forEach((el) => observer.observe(el))
