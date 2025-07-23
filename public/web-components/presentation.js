class Presentation extends HTMLElement {
  constructor() {
    super()
  }

  connectedCallback() {
    const button = document.createElement('button')
    button.id = 'presentation-button'
    button.className = 'presentation-hidden'
    button.type = 'button'
    button.innerText = 'Start Presentation'
    this.appendChild(button)

    const progress = document.createElement('div')
    progress.className = 'presentation-progress'
    this.appendChild(progress)

    this.setupPresentation(button)
  }

  setupPresentation(button) {
    let slides = Array.from(
      document.querySelectorAll('site-presentation-slide'),
    )

    let slide = 0
    let presenter = false

    const presentationId = window.location.href
    const syncWriter = createSyncWriter(presentationId)

    const nextSlide = () => {
      if (slide === slides.length - 1) {
        return slide
      }

      return slide + 1
    }

    const prevSlide = () => {
      if (slide === 0) {
        return slide
      }

      return slide - 1
    }

    const nextClass = 'presentation-next'
    const currClass = 'presentation-current'
    const prevClass = 'presentation-prev'

    const transitionClasses = [nextClass, currClass, prevClass]

    const keyHandlers = {
      ArrowRight: nextSlide,
      ArrowLeft: prevSlide,
    }

    const displaySlides = () => {
      for (let i = 0; i < slides.length; i++) {
        slides[i].classList.remove('active', 'inactive', ...transitionClasses)

        if (i === slide) {
          slides[i].classList.add('active', currClass)
        } else {
          slides[i].classList.add('inactive')

          if (i > slide) {
            slides[i].classList.add(nextClass)
          } else {
            slides[i].classList.add(prevClass)
          }
        }
      }
    }

    let presenting = false
    const startPresentation = () => {
      button.innerHTML = 'Resume presentation'
      document.body.classList.add('presentation-overflow-hidden')

      presenting = true
      displaySlides()
      setProgress()
      initListeners()
    }

    const endPresentation = () => {
      document.body.classList.remove('presentation-overflow-hidden')

      presenting = false
      slides.map((s) =>
        s.classList.remove('active', 'inactive', ...transitionClasses),
      )
    }

    const setPresenter = () => {
      presenter = true
      document.body.classList.add('presentation-presenter')
      syncWriter(slide)
    }

    const setProgress = () => {
      const progress = ((slide + 1) / slides.length) * 100
      document.body.style.setProperty('--presentation-progress', `${progress}%`)
    }

    const transition = (nextSlide) => {
      if (!presenting) {
        return
      }

      if (slide === nextSlide) {
        return
      }

      slides.forEach((s) => s.classList.remove(...transitionClasses))

      if (presenter) {
        syncWriter(nextSlide)
      }

      slide = nextSlide

      displaySlides()
      setProgress()
    }

    let listenersInitialized = false
    const initListeners = () => {
      if (listenersInitialized) {
        return
      }

      listenersInitialized = true
      window.addEventListener('keyup', (ev) => {
        ev.preventDefault()
        const isEscape = ev.key === 'Escape'
        if (isEscape) {
          endPresentation()
          return
        }

        const isSpace = ev.key === ' '
        if (isSpace) {
          setPresenter()
          return
        }

        const getSlide = keyHandlers[ev.key]

        if (!getSlide) {
          return
        }

        const nextSlide = getSlide()
        transition(nextSlide)
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

    // If there is no presentation on the page then we don't initialize
    if (slides.length) {
      button.classList.remove('presentation-hidden')
      button.addEventListener('click', startPresentation)
      createSyncReader(presentationId, slide, transition)
    }
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
