---
published: true
title: Scaling
subtitle: Tips for scaling SVGs
---

# Scaling an SVG

Scaling an inline SVG isn't as straightforward as scaling a normal image as they don't behave quite the same when using an `img` tag. There's a lot of information on doing this [on CSS Tricks](https://css-tricks.com/scale-svg/)

In general, the `viewBox` attribute needs to be set. An easy fix for SVG elements that have hardcoded `height` and `width` attributes is to first convert these to the equivalent `viewBox` attribute. For example, something like:

```html
<svg width="456" height="123">...</svg>
```

Would become:

```html
<svg viewBox="0 0 456 393">...</svg>
```

From here you can then treat it as a normal image tag (for the most part) and it should work fine
