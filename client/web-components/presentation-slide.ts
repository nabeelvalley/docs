class PresentationSlide extends HTMLElement {
  static observedAttributes = ['centered', 'highlight', 'large']
}

customElements.define('site-presentation-slide', PresentationSlide)
