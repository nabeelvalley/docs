class PresentationNote extends HTMLElement {
  static observedAttributes = ['slide-only']
}

customElements.define('site-presentation-note', PresentationSlide)
