// @ts-check
import { setupCanvas } from './shader.js'

class ShaderCanvas extends HTMLElement {
  static observedAttributes = ['centered', 'highlight', 'large']

  #observer: MutationObserver

  #canvas?: HTMLCanvasElement

  #script?: HTMLScriptElement

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
    const initialized = this.#canvas && this.#script
    if (initialized) {
      return
    }

    const canvas = this.querySelector('canvas')
    const script = this.querySelector(
      'script[type="text/wgsl"]',
    ) as HTMLScriptElement

    if (!(script && canvas)) {
      return
    }

    this.#observer.disconnect()

    this.#canvas = canvas
    this.#script = script

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
