const nextClass = 'presentation-next'
const currClass = 'presentation-current'
const prevClass = 'presentation-prev'

const transitionClasses = [nextClass, currClass, prevClass]

class Presentation extends HTMLElement {
  constructor() {
    super()
  }

  listenersInitialized = false
  slide = 0
  slides = []

  presenter = false
  presenting = false

  presentationId = window.location.href
  syncWriter = createSyncWriter(this.presentationId)

  connectedCallback() {
    this.button = document.createElement('button')
    this.button.id = 'presentation-button'
    this.button.className = 'presentation-hidden'
    this.button.type = 'button'
    this.button.innerText = 'Start Presentation'
    this.appendChild(this.button)

    const progress = document.createElement('div')
    progress.className = 'presentation-progress'
    this.appendChild(progress)

    this.slides = Array.from(
      document.querySelectorAll('site-presentation-slide'),
    )

    // If there is no presentation on the page then we don't initialize
    if (this.slides.length) {
      this.button.classList.remove('presentation-hidden')
      this.button.addEventListener('click', this.startPresentation)
      createSyncReader(this.presentationId, this.slide, this.transition)
    }
  }

  displaySlides = () => {
    const slides = this.slides
    for (let i = 0; i < slides.length; i++) {
      slides[i].classList.remove('active', 'inactive', ...transitionClasses)

      if (i === this.slide) {
        slides[i].classList.add('active', currClass)
      } else {
        slides[i].classList.add('inactive')

        if (i > this.slide) {
          slides[i].classList.add(nextClass)
        } else {
          slides[i].classList.add(prevClass)
        }
      }
    }
  }

  nextSlide = () => {
    if (this.slide === this.slides.length - 1) {
      return this.slide
    }

    return this.slide + 1
  }

  prevSlide = () => {
    if (this.slide === 0) {
      return this.slide
    }

    return this.slide - 1
  }

  startPresentation = () => {
    this.button.innerHTML = 'Resume presentation'
    document.body.classList.add('presentation-overflow-hidden')

    this.presenting = true
    this.displaySlides()
    this.setProgress()
    this.initListeners()
  }

  endPresentation = () => {
    document.body.classList.remove('presentation-overflow-hidden')

    this.presenting = false
    this.slides.map((s) =>
      s.classList.remove('active', 'inactive', ...transitionClasses),
    )
  }

  setProgress = () => {
    const progress = ((this.slide + 1) / this.slides.length) * 100
    document.body.style.setProperty('--presentation-progress', `${progress}%`)
  }

  transition = (nextSlide) => {
    if (!this.presenting) {
      return
    }

    if (this.slide === this.nextSlide) {
      return
    }

    this.slides.forEach((s) => s.classList.remove(...transitionClasses))

    if (this.presenter) {
      this.syncWriter(nextSlide)
    }

    this.slide = nextSlide

    this.displaySlides()
    this.setProgress()
  }

  setPresenter = () => {
    this.presenter = true
    document.body.classList.add('presentation-presenter')
    this.syncWriter(this.slide)
  }

  initListeners = () => {
    const keyHandlers = {
      ArrowRight: this.nextSlide,
      ArrowLeft: this.prevSlide,
    }

    if (this.listenersInitialized) {
      return
    }

    this.listenersInitialized = true
    window.addEventListener('keyup', (ev) => {
      ev.preventDefault()
      const isEscape = ev.key === 'Escape'
      if (isEscape) {
        this.endPresentation()
        return
      }

      const isSpace = ev.key === ' '
      if (isSpace) {
        this.setPresenter()
        return
      }

      const getSlide = keyHandlers[ev.key]

      if (!getSlide) {
        return
      }

      const nextSlide = getSlide()
      this.transition(nextSlide)
    })

    let touchstartX = 0
    let touchendX = 0
    const handleGesure = () => {
      const magnitude = Math.abs(touchstartX - touchendX)

      if (magnitude < 40) {
        // Ignore since this could be a scroll up/down
        return
      }

      if (touchendX < touchstartX) {
        transition(nextSlide())
      }
      if (touchendX > touchstartX) {
        transition(prevSlide())
      }
    }

    document.addEventListener(
      'touchstart',
      (ev) => {
        touchstartX = ev.changedTouches[0].screenX
      },
      false,
    )

    document.addEventListener(
      'touchend',
      (event) => {
        touchendX = event.changedTouches[0].screenX
        handleGesure()
      },
      false,
    )
  }
}

const getValue = (key, initial) => {
  try {
    const existing = window.localStorage.getItem(key)
    if (!existing) {
      return initial
    }
    return JSON.parse(existing)
  } catch (_a) {
    return initial
  }
}

const setValue = (key, value) =>
  window.localStorage.setItem(key, JSON.stringify(value))

const createSyncReader = (key, initial, onChange) => {
  window.addEventListener('storage', () => {
    const value = getValue(key, initial)
    onChange(value)
  })
  return () => getValue(key, initial)
}

const createSyncWriter = (key) => (value) => setValue(key, value)

customElements.define('site-presentation', Presentation)
