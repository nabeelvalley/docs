// @ts-check

/**
 * Pattern element based on Sashiko/Kakinohana Patterns
 *
 * @example
 * A simple pattern can be created with the following HTML
 *
 * ```html
 * <site-pattern scale="20" pattern-x="0 1 0 0 1 0 1 1" pattern-y="1 0 0">
 *   <svg style="width: 100%; aspect-ratio: 3/2" />
 * </site-pattern>
 * ```
 */
class PatternElement extends HTMLElement {
  static observedAttributes = ['scale', 'pattern-x', 'pattern-y']

  /** @type {MutationObserver} */
  #observer

  /** @type {SVGElement | undefined} */
  #svg

  constructor() {
    super()
    this.#observer = new MutationObserver(() => this.#initialize())
    this.#observer.observe(this, { childList: true })
  }

  disconnectedCallback() { }

  connectedCallback() {
    this.#initialize()
  }

  #initialize() {
    if (this.#svg) {
      return
    }

    const svg = this.querySelector('svg')
    if (!svg) {
      return
    }

    const scale = toInt(this.getAttribute('scale'))
    const patternX = toInts(this.getAttribute('pattern-x'))
    const patternY = toInts(this.getAttribute('pattern-y'))

    const defs = document.createElementNS("http://www.w3.org/2000/svg", "defs");
    const dash = createDashSymbol()
    defs.appendChild(dash)

    const svgPatternX = createDashes(dash, patternX, 0, scale)
    const rectX = createFillRect(`url(#${svgPatternX.id})`)

    defs.appendChild(svgPatternX)
    svg.appendChild(rectX)

    const svgPatternY = createDashes(dash, patternY, 90, scale)
    const rectY = createFillRect(`url(#${svgPatternY.id})`)

    defs.appendChild(svgPatternY)
    svg.appendChild(rectY)

    svg.appendChild(defs)
    this.#svg = svg
  }

  setupPatternX() {

  }
}

customElements.define('site-pattern', PatternElement)

/**
 * @param {string | null} value 
 * @returns {number}
 */
function toInt(value) {
  return +(value || 0)
}

/**
 * @param {string | null} values
 * @returns {number[]}
 */
function toInts(values) {
  return (values || '')
    .split(' ')
    .filter(Boolean)
    .map(toInt)
}

/**
 * @param {string} fill
 */
function createFillRect(fill) {
  const rect = document.createElementNS("http://www.w3.org/2000/svg", "rect");

  rect.setAttribute('fill', fill)
  rect.setAttribute('width', '100%')
  rect.setAttribute('height', '100%')

  return rect
}

/**
 * @param {SVGSymbolElement} symbol required by the pattern for correct overflow behavior
 * @param {number[]} pattern in the form of '0 1 1 0 0' where the 0/1 is the start position for the line segment
 */
function createDashes(symbol, pattern, rotate = 0, scale = 10) {
  const width = 2
  const height = pattern.length

  const el = document.createElementNS("http://www.w3.org/2000/svg", "pattern");

  el.id = `pattern-${pattern.join('_')}-${Math.random()}`
  el.setAttribute('patternUnits', 'userSpaceOnUse')

  el.setAttribute('width', width.toString())
  el.setAttribute('height', height.toString())

  for (let i = 0; i < pattern.length; i++) {
    const startPos = pattern[i]

    const use = document.createElementNS("http://www.w3.org/2000/svg", "use");

    use.setAttribute('href', `#${symbol.id}`)
    use.setAttribute('x', startPos.toString())
    use.setAttribute('y', i.toString())

    el.appendChild(use)
  }

  el.setAttribute("patternTransform", `rotate(${rotate}) scale(${scale})`)

  return el
}

function createDashSymbol(strokeWidth = 0.2) {
  const symbol = document.createElementNS("http://www.w3.org/2000/svg", "symbol");
  const dash = document.createElementNS("http://www.w3.org/2000/svg", "line");

  symbol.id = `dashes-${Math.random()}`

  dash.setAttribute('x1', "0")
  dash.setAttribute('y1', "0")

  dash.setAttribute('x2', "1")
  dash.setAttribute('y2', "0")

  dash.setAttribute('overflow', "true")

  dash.style.stroke = "black"
  dash.style.strokeWidth = strokeWidth.toString()

  symbol.appendChild(dash)
  return symbol
}
