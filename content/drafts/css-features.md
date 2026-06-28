---
title: Stuff I Want to Try
description: Some new CSS Features I want to try
published: false
---

Content from [Syntax.fm](https://syntax.fm/show/616/supper-club-adam-argyle-on-what-s-new-in-css)

- [ ] Style Queries
  - https://developer.chrome.com/blog/style-queries/
  - https://una.im/style-queries/
- [ ] Container queries
  - https://www.smashingmagazine.com/2021/05/complete-guide-css-container-queries/
- [ ] New Relative Units - https://nerdy.dev/new-relative-units-ric-rex-rlh-and-rch
- [ ] Gradients and Colour Spaces - https://gradient.style/
- [ ] Open Props - https://open-props.style
- [ ] Container Queries
- [ ] Trig Functions - https://web.dev/css-trig-functions
- [ ] Animation principles - https://www.creativebloq.com/advice/understand-the-12-principles-of-animation
- [ ] View Transitions/FLIP
  - https://live-transitions.pages.dev/
  - https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API
- [ ] Text Wrap Balance/Pretty
  - https://developer.chrome.com/blog/css-text-wrap-balance/
- [ ] Scroll driven animations
  - https://scroll-driven-animations.style/
  - https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_scroll-driven_animations
- Cascade layers
- CSS Nesting
- CSS Houdini (`@property`)
- https://www.projectwallace.com/
- https://www.smashingmagazine.com/native-css-masonry-layout-css-grid/

---

Some random snippets:

https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_containment/Container_size_and_style_queries

```css
@container style(color: green) and style(background-color: transparent),
    not style(background-color: red),
    style(--themeBackground),
    style(--themeColor: blue) or style(--themeColor: purple),
    (max-width: 100vw) and style(max-width: 600px) {
  /* <stylesheet> */
}
```

```css
@property --theme-color {
  initial-value: rebeccapurple;
  inherited: true;
}

:root {
  --theme-color: rebeccapurple;
}

main {
  --theme-color: blue;
}

@container style(--theme-color) {
  /* <stylesheet> */
}
```

https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_nesting/Nesting_at-rules

```css
.foo {
  @layer base {
    block-size: 100%;
    @layer support {
      & .bar {
        min-block-size: 100%;
      }
    }
  }
}
```

```css
.foo {
  display: grid;
  @media (orientation: landscape) {
    grid-auto-flow: column;
    @media (min-width: 1024px) {
      max-inline-size: 1024px;
    }
  }
}
```

https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_scroll-driven_animations

```css
#square {
  background-color: deeppink;
  width: 100px;
  height: 100px;
  margin-top: 100px;
  animation-name: rotateAnimation;
  animation-duration: 1ms; /* Firefox requires this to apply the animation */
  animation-direction: alternate;
  animation-timeline: --squareTimeline;

  position: absolute;
  bottom: 0;
}

@keyframes rotateAnimation {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
```

https://developer.mozilla.org/en-US/docs/Web/CSS/@property

```css
@property --property-name {
  syntax: '<color>';
  inherits: false;
  initial-value: #c0ffee;
}
```
