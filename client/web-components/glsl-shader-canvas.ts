import { Canvas } from 'glsl-canvas-js'

const canvases = new Map()
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

const showCanvas = (root: HTMLElement) => {
  const instance = getCanvas(root)
  instance.play()
}

/**
 * Destroys the rendering instance as well as the overall canvas to ensure that
 * the entire canvas WebGL instance is reinitialized
 */
const destroyCanvas = (root: HTMLElement) => {
  const instance = canvases.get(root)

  // Handle instance checking
  instance?.pause()
  instance?.destroy()
  canvases.delete(root)

  const canvas = root.querySelector('canvas') as HTMLCanvasElement
  const newCanvas = canvas.cloneNode() as HTMLCanvasElement
  console.log(canvas, canvas.parentElement)

  canvas.replaceWith(newCanvas)
}

const observer = new IntersectionObserver((entries) => {
  console.log(entries)
  return entries.forEach((entry) => {
    const target = entry.target as HTMLElement
    if (entry.isIntersecting) {
      showCanvas(target)
    } else {
      destroyCanvas(target)
    }
  })
})

document
  .querySelectorAll('site-glsl-shader-canvas')
  .forEach((el) => observer.observe(el))
