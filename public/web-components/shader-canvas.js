// @ts-check
import { setupCanvas } from './shader.js'

class ShaderCanvas extends HTMLElement {
  static observedAttributes = ['centered', 'highlight', 'large']

  /** @type {MutationObserver} */
  #observer

  /** @type {HTMLCanvasElement} */
  #canvas

  /** @type {HTMLScriptElement} */
  #script

  constructor() {
    super()
    this.#observer = new MutationObserver(() => this.#initialize())
    this.#observer.observe(this, { childList: true })
  }

  disconnectedCallback() {
    this.#observer.disconnect()
  }

  connectedCallback() {
    this.#initialize()
  }

  async #initialize() {
    console.log('here')
    const initialized = this.#canvas && this.#script
    if (initialized) {
      return
    }

    const canvas = this.querySelector('canvas')

    /** @type {HTMLScriptElement} */
    const script = this.querySelector('script[type="text/wgsl"]')

    if (!(script && canvas)) {
      return
    }

    this.#observer.disconnect()

    this.#canvas = canvas
    this.#script = script

    console.log(canvas, script)

    const render = await setupCanvas(this.#canvas, this.#script.innerText)

    function renderLoop() {
      requestAnimationFrame(() => {
        render?.()
        renderLoop()
      })
    }

    renderLoop()
  }
}

customElements.define('site-shader-canvas', ShaderCanvas)
