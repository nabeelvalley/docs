---
published: true
title: Gradients
subtitle: Basic application of SVG Linear and Radial Gradients to SVG Elements
---

> For reference take a look at the [MDN SVG Gradient Docs](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Gradients)

SVG has provides us with two different gradient elements, namely `linearGradient` and `radialGradient` which can be applied as fills or strokes to SVG elements

Gradients work by defining them inside of a `defs` element so that they can be reused in multiple parts of an SVG and they must have an `id` attribute so they can be referenced by other elements

## Defining Gradients

### The `stop` Element

When defining any type of gradient it's necessary to define a `stop`s. A `stop` defines a color and it's position and is always a child of a `linearGradient` or `radialGradient` element

A stop has the following properties:

1. `offset` - where the stop should be placed along the gradient. Can either be a number of a percentage, `offset="0.5"` or `offset="50%"` for example. Default is `0`
2. `stop-color` - The color associated with the stop. Default is `black`
3. `stop-opacity` - The opacity associated with the stop Default is `1`

A gradient does not need to define all of the above properties but you likely will want to in order to effectively define a gradient

Some examples of a `stop` using the above definitions can be seen below:

```svg
<stop stop-color="blue"/>
<stop stop-color="#E2E2E2" offset="0.5" />
<stop stop-color="#D5E73F" stop-opacity="0.7" offset="80%" />
```

### The `linearGradient` Element

Linear gradients are gradients that change along a straight line (the gradient vector).

Creating a `linearGradient` in the `defs` section of an SVG file looks like so:

```svg
<defs>
  <linearGradient id="linear">
    <stop stop-color="blue"/>
    <stop stop-color="#E2E2E2" offset="0.5" />
    <stop stop-color="#D5E73F" stop-opacity="0.7" offset="80%" />
  </linearGradient>
</defs>
```

Additionally we can control the position/direction of the gradient vector by changing it's start and end points using the `x1`, `x2`, `y1`, and `y2` values.

So a horizontal gradient (the default) would look something like this:

```svg
<linearGradient id="linear" x1="0" y1="0" x2="1" y2="0">
```

And a vertical one like so:

```svg
<linearGradient id="linear" x1="0" y1="0" x2="0" y2="1">
```

### The `radialGradient` Element

Radial Gradients are gradients that change along a a radius from a defined focal point

Creating a `radialGradient` in the `defs` section of an SVG file looks like so:

```svg
<defs>
  <radialGradient id="radial">
    <stop stop-color="blue"/>
    <stop stop-color="#E2E2E2" offset="0.5" />
    <stop stop-color="#D5E73F" stop-opacity="0.7" offset="80%" />
  </linearGradient>
</defs>
```

For a `radialGradient` we can also control the radius, center point positions, and focal point radius, and focal point positions using `r`, `cx`, `cy`, `fr`, `fx`, and `fy` respectively

To define a gradient with a small center radius, we can do something like this:

```svg
<radialGradient id="radial" r="0.5" />
```

Or for a gradient which is off-center we can do this:

```svg
<radialGradient id="radial" cx="0.2" cy="0.2" />
```

And likewise for changing the focal point:

```svg
<radialGradient id="radial" fx="0.2" fy="0.2" />
```

Or using `fr` instead:

```svg
<radialGradient id="radial" fr="0.2" />
```

## Using Gradients

Using SVG Gradients can be done by referencing the gradient from the `fill` or `stroke` property of an SVG element

For example, I can use the `linearGradient` defined above for a circle's fill with:

```svg
<circle
  cx="50"
  cy="50"
  r="40"
  fill="url(#linear)"
/>
```

Or for the stroke on a path with:

```svg
<path
  d="M 0 100 L 10 40 L 100 50"
  stroke-width="1"
  fill="transparent"
  stroke="url(#linear)"
/>
```

A more complete example using the `linearGradient` and `radialGradient` can be seen below:

```svg
<svg viewBox="0 0 100 100"  xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <linearGradient id="linear" x1="0" y1="0" x2="0" y2="1">
      <stop stop-color="blue"/>
      <stop stop-color="#E2E2E2" offset="0.5" />
      <stop stop-color="#D5E73F" stop-opacity="0.7" offset="80%" />
    </linearGradient>
   <radialGradient id="radial" fr="0" r="0.7" cx="0.3" cy="0.3">
      <stop stop-color="blue"/>
      <stop stop-color="#E2E2E2" offset="0.5" />
      <stop stop-color="#D5E73F" stop-opacity="0.7" offset="80%" />
    </linearGradient>
  </defs>

  <circle cx="50" cy="50" r="40" fill="url(#radial)" />
  <path d="M 0 100 L 10 40 L 100 50" stroke-width="1" stroke="url(#linear)" fill="transparent" />
</svg>
```

And the result:

<svg viewBox="0 0 100 100"  xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink">
<defs>
<linearGradient id="linear" x1="0" y1="0" x2="0" y2="1">
<stop stop-color="blue"/>
<stop stop-color="#E2E2E2" offset="0.5" />
<stop stop-color="#D5E73F" stop-opacity="0.7" offset="80%" />
</linearGradient>
<radialGradient id="radial" fr="0" r="0.7" cx="0.3" cy="0.3">
<stop stop-color="blue"/>
<stop stop-color="#E2E2E2" offset="0.5" />
<stop stop-color="#D5E73F" stop-opacity="0.7" offset="80%" />
</linearGradient>
</defs>

  <circle cx="50" cy="50" r="40" fill="url(#radial)" />
  <path d="M 0 100 L 10 40 L 100 50" stroke-width="1" stroke="url(#linear)" fill="transparent" />
</svg>
