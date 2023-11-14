---
title: HTML Custom Elements
description: An example custom element showing the basic structure and how it can be used with JSDoc
published: true
---

Below is a small example showing an HTML Custom Element that works as a markdown input and preview. The HTML file renders the element using the respective tag: 

`index.html`

```html
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Web Components Playground</title>
		<!-- Custom element script needs to be deferred due to the initialization lifecycle -->
		<script src="main.js" defer></script>
		<!-- Showdown used for markdown conversion -->
		<script src="https://cdn.jsdelivr.net/npm/showdown@2.1.0/dist/showdown.min.js"></script>
	</head>
	<body>
		<h1>A little markdown editor</h1>

		<app-contenteditable
			onchange="console.log(event)"
			label="Custom Element Input"
		></app-contenteditable>
	</body>
</html>
```

And the Javascript implementation is as follows:

- TS Check declaration used to get type checking on the JS file with the relevant JSDoc
- JS Doc used to provide better class level type intferrence
- Private class members in JS using `#`
- The HTML `html=String.raw` used for syntax highlighting of HTML strings

`main.js`

```javascript
// @ts-check

const html = String.raw

/**
 * @typedef {Object} Converter
 * @property {(markdown: string) => string} makeHtml
 */

/**
 * @typedef {new () => Converter} ConverterConstructor
 */

/**
 * @typedef {Object} Showdown
 * @property {ConverterConstructor} Converter
 */

/** @type {Showdown} */
const showdown = window["showdown"]

class MarkdownPreviewElement extends HTMLElement {
	static selector = "app-contenteditable"

	#converter = new showdown.Converter()

	/** @type {string} */
	get #label() {
		return this.getAttribute("label") || ""
	}

	/** @type {string | undefined} */
	get #value() {
		return this.getAttribute("value") || ""
	}

	/** @type {HTMLDivElement} */
	#wrapper

	get #input() {
		const el = /** @type {HTMLTextAreaElement} */ (
			this.shadowRoot?.getElementById("input")
		)

		return el
	}

	get #output() {
		const el = /** @type {HTMLDivElement} */ (
			this.shadowRoot?.getElementById("output")
		)

		return el
	}

	#onchange() {
		const markdown = this.#input.value
		const html = this.#converter.makeHtml(markdown)

		this.#output.innerHTML = html

		const event = new CustomEvent("change", {
			detail: {
				markdown,
				html,
			},
		})

		this.onchange?.(event)
	}

	/** @type {string} */
	get #content() {
		return html`
			<h2>Markdown</h2>
			<textarea id="input" value="${this.#value}"></textarea>
			<h2>HTML</h2>
			<div id="output"></div>
		`
	}

	constructor() {
		super()
		this.#wrapper = document.createElement("div")
		this.#wrapper.className = MarkdownPreviewElement.selector

		this.#wrapper.innerHTML = this.#content

		const shadow = this.attachShadow({ mode: "open" })
		shadow.appendChild(this.#wrapper)

		this.#input.addEventListener("input", () => this.#onchange())
		this.#output.innerHTML = this.#converter.makeHtml(this.#value || "")
	}
}

customElements.define(MarkdownPreviewElement.selector, MarkdownPreviewElement)
```

