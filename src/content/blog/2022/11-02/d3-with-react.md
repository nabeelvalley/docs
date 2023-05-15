---
published: true
title: Visualizations with React
subtitle: 11 February 2022
description: Create SVG Graphs and Visualizations in React using D3
---

[[toc]]

# Data Visualization with D3 and React

React is a library for building reactive user interfaces using JavaScript (or Typescript) and D3 (short for _Data-Driven Documents_) is a set of libraries for working with visualizations based on data

Before getting started, I would recommend familiarity with SVG, React, and D3

Some good references for SVG are on the [MDN SVG Docs](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial)

A good place to start for React would be the [React Docs](https://reactjs.org/) or [my React Notes](/docs/react/complete-react.md)

And lastly, the [D3 Docs](https://github.com/d3/d3/wiki)

## Getting Stared

To follow along, you will need to install [Node.js](https://nodejs.org/en/) and be comfortable using the terminal

I'm going to be using a React App with TypeScript initialized with Vite as follows:

```sh
yarn create vite
```

And then selecting the `react-ts` option when prompted. Next, install `d3` from the project root with:

```sh
yarn add d3
yarn add --dev @types/d3
```

Now that we've got a basic project setup, we can start talking about D3

## Scales (`d3-scale`)

> [`d3-scale` Documentation](https://github.com/d3/d3-scale)

Broadly, scales allow us to map from one set of values to another set of values,

Scales in D3 are a set of tools which map a dimension of data to a visual variable. They help us go from something like `count` in our data to something like `width` in our rendered SVG

We can create scales for a sample dataset like so:

```ts
type Datum = {
  name: string
  count: number
}

export const data: Datum[] = [
  { name: "🍊", count: 21 },
  { name: "🍇", count: 13 },
  { name: "🍏", count: 8 },
  { name: "🍌", count: 5 },
  { name: "🍐", count: 3 },
  { name: "🍋", count: 2 },
  { name: "🍎", count: 1 },
  { name: "🍉", count: 1 },
]
```

> Also, a common thing to do when working with scales is to define margins around out image, this is done simply as an object like so:
> ```ts
> const margin = {
>   top: 20,
>   right: 20,
>   bottom: 20,
>   left: 35,
> };
> ```
> This just helps us simplify some position/layout things down the line

Scales work by taking a value from the `domain` (data space) and returning a value from `range` (visual space):

```ts
const width = 600;
const height = 400;

const x = d3
  .scaleLinear()
  .domain([0, 10])    // values of the data space
  .range([0, width])  // values of the visual space

const position = x(3) // position = scale(value)
```

Additionally, there's also the `invert` method which goes the other way - from `range` to `domain`

```ts
const position = x(3)      // position === 30
const value = x.invert(30) // value === 3
```

> The `invert` method is useful for things like calculating a `value` from a mouse `position`

D3 has different Scale types:

- Continuous (Linear, Power, Log, Identity, Time, Radial)
- Sequential
- Diverging
- Quantize
- Quantile
- Threshold
- Ordinal (Band, Point)

### Continuous Scales

These scales map continuous data to other continuous data

D3 has a few different continuous scale types: 

- Linear
- Power
- Log
- Identity
- Radial
- Time
- Sequential Color

For my purposes at the moment I'm going to be looking at the methods for Linear and Sequential Color scales, but the documentation explains all of the above very thoroughly and is worth a read for additional information on their usage

#### Linear

We can use a `linear` scale in the fruit example for mapping count to an x width:

```ts
const maxX = d3.max(data, (d) => d.count) as number;

const x = d3
  .scaleLinear<number>()
  .domain([0, maxX])
  .range([margin.left, width - margin.right]);
```

If we don't want the custom `domain` to `range` interpolation we can create a custom `interpolator`. An `interpolator` is a function that takes a value from the `domain` and returns the resulting `range` value

D3 has a few different `interpolators` included for tasks such as interpolating colors or rounding values

We can create a custom color domain to interpolate over and use the `interpolateHsl` or `interpolateRgb` functions:

```ts
const color = d3
  .scaleLinear<string>()
  .domain([0, maxX])
  .range(["pink", "lightgreen"])
  .interpolate(d3.interpolateHsl);
```

### Sequential Color

If for some reason we want to use the pre-included color scales

The `scaleSequential` scale is a method that allows us to map to a `color` range using an `interpolator`.

D3 has a few different interpolators we can use with this function like `d3.interpolatePurples`, `d3.interpolateRainbow` or `d3.interpolateCool` among others which look quite nice

We can create a color scale using the `d3.interpolatePurples` which will map the data to a scale of purples:

```ts
const color = d3
  .scaleSequential()
  .domain([0, maxX])
  .interpolator(d3.interpolatePurples);
```

These can be used instead of the `scaleLinear` with `interpolateHsl` for example above but to provide a pre-calibrated color scale

### Ordinal Scales

Ordinal scales have a discrete domain and range and are used for the mapping of discrete data. These are a good fit for mapping a scale with categorical data. D3 offers us the following scales:

- Band Scale
- Point Scale

#### Band Scale

A Band Scale is a type of Ordinal Scale where the output `range` is continuous and numeric

We can create a mapping for where each of our labels should be positioned with `scaleBand`:

```ts
const names = data.map((d) => d.name);

const y = d3
  .scaleBand()
  .domain(names)
  .range([margin.top, height - margin.bottom])
  .padding(0.1);
```

> The domain can be any size array, unlike in the case of continuous scales where the are usually start and end values

## Building a Bar Graph

When creating visuals with D3 there are a few different ways we can output to SVG data. D3 provides us with some methods for creating shapes and elements programmatically via a builder pattern - similar to how we create scales. 

However, there are also cases where we would want to define out SVG elements manually, such as when working with React so that the react renderer can handle the rendering of the SVG elements and we can manage our DOM structure in a way that's a bit more representative of the way we work in React


### The SVG Root

Every SVG image has to have an `svg` root element. To help ensure that this root scales correctly we also use it with a `viewBox` attribute which specifies which portion of the SVG is visible since the contents can go outside of the bounds of the View Box and we may not want to display this overflow content by default

Using the definitions for `margin`, `width` and `height` from before we can get the `viewBox` for the SVG we're trying to render like so:

```ts
const viewBox = `0 ${margin.top} ${width} ${height - margin.top}`;
```

And then, using that value in the `svg` element:

```tsx
return (
  <svg viewBox={viewBox}>
    {/* we will render the graph in here */}
  </svg>
)
```

At this point we don't really have anything in the SVG, next up we'll do the following:

1. Add Bars to the SVG
2. Add Y Labels to the SVG
3. Add X Labels to the SVG

### Bars

We can create Bars using the following:

```tsx
const bars = data.map((d) => (
  <rect
    key={y(d.name)}
    fill={color(d.count)}
    y={y(d.name)}
    x={x(0)}
    width={x(d.count) - x(0)}
    height={y.bandwidth()}
  />
));
```

We make use of the `x` and `y` functions which help us get the positions for the `rect` as well as `y.bandWidth()` and `x(d.count)` to `height` and `width` for the element

We can then add that into the SVG using:

```tsx
return (
  <svg viewBox={viewBox}>
    <g>{bars}</g>
  </svg>
);
```

At this point, the resulting SVG will look like this:

<svg viewBox="0 20 600 380">
  <g>
    <rect fill="rgb(38, 165, 219)" y="26" x="35" width="208" height="40"></rect>
    <rect fill="rgb(68, 121, 223)" y="70" x="35" width="130" height="40"></rect>
    <rect fill="rgb(175, 240, 91)" y="114" x="35" width="545" height="40"></rect>
    <rect fill="rgb(97, 83, 199)" y="158" x="35" width="52" height="40"></rect>
    <rect fill="rgb(32, 226, 157)" y="202" x="35" width="337" height="40"></rect>
    <rect fill="rgb(104, 73, 185)" y="246" x="35" width="26" height="40"></rect>
    <rect fill="rgb(104, 73, 185)" y="290" x="35" width="26" height="40"></rect>
    <rect fill="rgb(88, 95, 210)" y="334" x="35" width="78" height="40"></rect>
  </g>
</svg>

### Y Labels

Next, using similar concepts as above, we can add the Y Labels:

```tsx
const yLabels = data.map((d) => (
  <text key={y(d.name)} y={y(d.name)} x={0} dy="0.35em">
    {d.name}
  </text>
));
```

Next, we can add this into the SVG, and also wrapping the element in a `g` with a some basic text alignment and translation for positioning it correctly:

```tsx
return (
  <svg viewBox={viewBox}>
    <g
      fill="steelblue"
      textAnchor="end"
      transform={`translate(${margin.left - 5}, ${y.bandwidth() / 2})`}
    >
      {yLabels}
    </g>
    <g>{bars}</g>
  </svg>
);
```

The state of the SVG at this point is:

<svg viewBox="0 20 600 380">
  <g fill="steelblue" text-anchor="end" transform="translate(30, 20)">
    <text y="26" x="0" dy="0.35em">🍏</text>
    <text y="70" x="0" dy="0.35em">🍌</text>
    <text y="114" x="0" dy="0.35em">🍊</text>
    <text y="158" x="0" dy="0.35em">🍋</text>
    <text y="202" x="0" dy="0.35em">🍇</text>
    <text y="246" x="0" dy="0.35em">🍎</text>
    <text y="290" x="0" dy="0.35em">🍉</text>
    <text y="334" x="0" dy="0.35em">🍐</text>
  </g>
  <g>
    <rect fill="rgb(38, 165, 219)" y="26" x="35" width="208" height="40"></rect>
    <rect fill="rgb(68, 121, 223)" y="70" x="35" width="130" height="40"></rect>
    <rect
      fill="rgb(175, 240, 91)"
      y="114"
      x="35"
      width="545"
      height="40"
    ></rect>
    <rect fill="rgb(97, 83, 199)" y="158" x="35" width="52" height="40"></rect>
    <rect
      fill="rgb(32, 226, 157)"
      y="202"
      x="35"
      width="337"
      height="40"
    ></rect>
    <rect fill="rgb(104, 73, 185)" y="246" x="35" width="26" height="40"></rect>
    <rect fill="rgb(104, 73, 185)" y="290" x="35" width="26" height="40"></rect>
    <rect fill="rgb(88, 95, 210)" y="334" x="35" width="78" height="40"></rect>
  </g>
</svg>


### X Labels

Next, we can add the X Labels over each `rect` using:

```tsx
const xLabels = data.map((d) => (
  <text key={y(d.name)} y={y(d.name)} x={x(d.count)} dy="0.35em">
    {d.count}
  </text>
));
```

And the resulting code looks like this:

```tsx
return (
  <svg viewBox={viewBox}>
    <g
      fill="steelblue"
      textAnchor="end"
      transform={`translate(${margin.left - 5}, ${y.bandwidth() / 2})`}
    >
      {yLabels}
    </g>
    <g>{bars}</g>
    <g
      fill="white"
      textAnchor="end"
      transform={`translate(-6, ${y.bandwidth() / 2})`}
    >
      {xLabels}
    </g>
  </svg>
);
```

And the final SVG:

<svg viewBox="0 20 600 380">
  <g fill="steelblue" text-anchor="end" transform="translate(30, 20)">
    <text y="26" x="0" dy="0.35em">🍏</text>
    <text y="70" x="0" dy="0.35em">🍌</text>
    <text y="114" x="0" dy="0.35em">🍊</text>
    <text y="158" x="0" dy="0.35em">🍋</text>
    <text y="202" x="0" dy="0.35em">🍇</text>
    <text y="246" x="0" dy="0.35em">🍎</text>
    <text y="290" x="0" dy="0.35em">🍉</text>
    <text y="334" x="0" dy="0.35em">🍐</text>
  </g>
  <g>
    <rect fill="rgb(38, 165, 219)" y="26" x="35" width="208" height="40"></rect>
    <rect fill="rgb(68, 121, 223)" y="70" x="35" width="130" height="40"></rect>
    <rect
      fill="rgb(175, 240, 91)"
      y="114"
      x="35"
      width="545"
      height="40"
    ></rect>
    <rect fill="rgb(97, 83, 199)" y="158" x="35" width="52" height="40"></rect>
    <rect
      fill="rgb(32, 226, 157)"
      y="202"
      x="35"
      width="337"
      height="40"
    ></rect>
    <rect fill="rgb(104, 73, 185)" y="246" x="35" width="26" height="40"></rect>
    <rect fill="rgb(104, 73, 185)" y="290" x="35" width="26" height="40"></rect>
    <rect fill="rgb(88, 95, 210)" y="334" x="35" width="78" height="40"></rect>
  </g>
  <g fill="white" text-anchor="end" transform="translate(-6, 20)">
    <text y="26" x="243" dy="0.35em">8</text>
    <text y="70" x="165" dy="0.35em">5</text>
    <text y="114" x="580" dy="0.35em">21</text>
    <text y="158" x="87" dy="0.35em">2</text>
    <text y="202" x="372" dy="0.35em">13</text>
    <text y="246" x="61" dy="0.35em">1</text>
    <text y="290" x="61" dy="0.35em">1</text>
    <text y="334" x="113" dy="0.35em">3</text>
  </g>
</svg>

### Final Result

The code for the entire file/graph can be seen below:

<details>
<summary>Fruit.tsx</summary>

```tsx
import React from "react";
import * as d3 from "d3";
import { data } from "../data/fruit";

const width = 600;
const height = 400;

const margin = {
  top: 20,
  right: 20,
  bottom: 20,
  left: 35,
};

const maxX = d3.max(data, (d) => d.count) as number;

const x = d3
  .scaleLinear<number>()
  .domain([0, maxX])
  .range([margin.left, width - margin.right])
  .interpolate(d3.interpolateRound);

const names = data.map((d) => d.name);

const y = d3
  .scaleBand()
  .domain(names)
  .range([margin.top, height - margin.bottom])
  .padding(0.1)
  .round(true);

const color = d3
  .scaleSequential()
  .domain([0, maxX])
  .interpolator(d3.interpolateCool);

export const Fruit: React.FC = ({}) => {
  const viewBox = `0 ${margin.top} ${width} ${height - margin.top}`;

  const yLabels = data.map((d) => (
    <text key={y(d.name)} y={y(d.name)} x={0} dy="0.35em">
      {d.name}
    </text>
  ));

  const bars = data.map((d) => (
    <rect
      key={y(d.name)}
      fill={color(d.count)}
      y={y(d.name)}
      x={x(0)}
      width={x(d.count) - x(0)}
      height={y.bandwidth()}
    />
  ));

  const xLabels = data.map((d) => (
    <text key={y(d.name)} y={y(d.name)} x={x(d.count)} dy="0.35em">
      {d.count}
    </text>
  ));

  return (
    <svg viewBox={viewBox}>
      <g
        fill="steelblue"
        textAnchor="end"
        transform={`translate(${margin.left - 5}, ${y.bandwidth() / 2})`}
      >
        {yLabels}
      </g>
      <g>{bars}</g>
      <g
        fill="white"
        textAnchor="end"
        transform={`translate(-6, ${y.bandwidth() / 2})`}
      >
        {xLabels}
      </g>
    </svg>
  );
};
```
</details>

### Ticks and Grid Lines

> Note that D3 includes a `d3-axis` package but that doesn't quite work given that we're manually creating the SVG using React and not D3's string-based rendering

We may want to add Ticks and Grid Lines on the X-Axis, we can do this using the scale's `ticks` method like so:

```tsx
const xGrid = x.ticks().map((t) => (
  <g key={t}>
    <line
      stroke="lightgrey"
      x1={x(t)}
      y1={margin.top}
      x2={x(t)}
      y2={height - margin.bottom}
    />
    <text fill="darkgrey" textAnchor="middle" x={x(t)} y={height}>
      {t}
    </text>
  </g>
));
```

And then render this in the `svg` as:

```tsx
return (
<svg viewBox={viewBox}>
  <g>{xGrid}</g>
  { /* previous graph content */ }
</svg>
);
```

The result will look like this:

<svg viewBox="0 20 600 380">
  <g>
    <g>
      <line stroke="lightgrey" x1="35" y1="20" x2="35" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="35" y="400">0</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="87" y1="20" x2="87" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="87" y="400">2</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="139" y1="20" x2="139" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="139" y="400">4</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="191" y1="20" x2="191" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="191" y="400">6</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="243" y1="20" x2="243" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="243" y="400">8</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="295" y1="20" x2="295" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="295" y="400">10</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="346" y1="20" x2="346" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="346" y="400">12</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="398" y1="20" x2="398" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="398" y="400">14</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="450" y1="20" x2="450" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="450" y="400">16</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="502" y1="20" x2="502" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="502" y="400">18</text>
    </g>
    <g>
      <line stroke="lightgrey" x1="554" y1="20" x2="554" y2="380"></line>
      <text fill="darkgrey" text-anchor="middle" x="554" y="400">20</text>
    </g>
  </g>
  <g fill="steelblue" text-anchor="end" transform="translate(30, 20)">
    <text y="26" x="0" dy="0.35em">🍏</text>
    <text y="70" x="0" dy="0.35em">🍌</text>
    <text y="114" x="0" dy="0.35em">🍊</text>
    <text y="158" x="0" dy="0.35em">🍋</text>
    <text y="202" x="0" dy="0.35em">🍇</text>
    <text y="246" x="0" dy="0.35em">🍎</text>
    <text y="290" x="0" dy="0.35em">🍉</text>
    <text y="334" x="0" dy="0.35em">🍐</text>
  </g>
  <g>
    <rect fill="rgb(38, 165, 219)" y="26" x="35" width="208" height="40"></rect>
    <rect fill="rgb(68, 121, 223)" y="70" x="35" width="130" height="40"></rect>
    <rect
      fill="rgb(175, 240, 91)"
      y="114"
      x="35"
      width="545"
      height="40"
    ></rect>
    <rect fill="rgb(97, 83, 199)" y="158" x="35" width="52" height="40"></rect>
    <rect
      fill="rgb(32, 226, 157)"
      y="202"
      x="35"
      width="337"
      height="40"
    ></rect>
    <rect fill="rgb(104, 73, 185)" y="246" x="35" width="26" height="40"></rect>
    <rect fill="rgb(104, 73, 185)" y="290" x="35" width="26" height="40"></rect>
    <rect fill="rgb(88, 95, 210)" y="334" x="35" width="78" height="40"></rect>
  </g>
  <g fill="white" text-anchor="end" transform="translate(-6, 20)">
    <text y="26" x="243" dy="0.35em">8</text>
    <text y="70" x="165" dy="0.35em">5</text>
    <text y="114" x="580" dy="0.35em">21</text>
    <text y="158" x="87" dy="0.35em">2</text>
    <text y="202" x="372" dy="0.35em">13</text>
    <text y="246" x="61" dy="0.35em">1</text>
    <text y="290" x="61" dy="0.35em">1</text>
    <text y="334" x="113" dy="0.35em">3</text>
  </g>
</svg>

## Building a Line Graph

We can apply all the same as in the Bar Graph before to draw a Line Graph. The example I'll be using consists of a `Datum` as follows:

```ts
export type Datum = {
  date: Date;
  temp: number;
};
```

Given that the X-Axis is a `DateTime` we will need to do some additional conversions as well as formatting

### Working with Domains

In the context of this graph it would also be useful to have an automatically calculated domain instead of a hardcoded one as in the previous example

We can use the `d3.extent` function to calculate a domain:

```ts
const dateDomain = d3.extent(data, (d) => d.date) as [Date, Date];
const tempDomain = d3.extent(data, (d) => d.temp).reverse() as [number, number];
```

We can then use this domain definitions in a `scale`:

```ts
const tempScale = d3
  .scaleLinear<number>()
  .domain(tempDomain)
  .range([margin.top, height - margin.bottom])
  .interpolate(d3.interpolateRound);

const dateScale = d3
  .scaleTime()
  .domain(dateDomain)
  .range([margin.left, width - margin.right]);
```

### Create a Line

The `d3.line` function is useful for creating a `d` attribute for an SVG `path` element which defines the line segments

The `line` function requires `x` and `y` mappings. The line for the graph path can be seen as follows:

```ts
const line = d3
  .line<Datum>()
  .x((d) => dateScale(d.date))
  .y((d) => tempScale(d.temp))(data) as string;
```

We also include the `Datum` type in the above to scope down the type of `data` allowed in the resulting function

### Formatting

D3 includes functions for formatting `DateTime`s. We can create a formatter for a `DateTime` as follows:

```ts
const formatter = d3.timeFormat("%Y-%m")
```

We can then use the formatter like so:

```ts
formatter(dateTime)
```

### Grid Lines

We can define the X Axis and grid lines similar to how we did it previously:

```tsx
const xGrid = dateTicks.map((t) => (
  <g key={t.toString()}>
    <line
      stroke="lightgrey"
      x1={dateScale(t)}
      y1={margin.top}
      x2={dateScale(t)}
      y2={height - margin.bottom}
      strokeDasharray={4}
    />
    <text fill="darkgrey" textAnchor="middle" x={dateScale(t)} y={height}>
      {formatter(t)}
    </text>
  </g>
));
```

And the Y Axis grid lines:

```tsx
const yGrid = tempTicks.map((t) => (
  <g key={t.toString()}>
    <line
      stroke="lightgrey"
      y1={tempScale(t)}
      x1={margin.left}
      y2={tempScale(t)}
      x2={width - margin.right}
      strokeDasharray={4}
    />
    <text
      fill="darkgrey"
      textAnchor="end"
      y={tempScale(t)}
      x={margin.left - 5}
    >
      {t}
    </text>
  </g>
));
```

### Final result

Using all the values that have been defined above, we can create the overall graph and grid lines like so:

```tsx
return (
  <svg viewBox={viewBox}>
    <g>{xGrid}</g>
    <g>{yGrid}</g>
    <path d={line} stroke="steelblue" fill="none" />
  </svg>
);
```

The final code can be seen below:


<details>
<summary>Temperature.tsx</summary>

```tsx
import React from "react";
import * as d3 from "d3";
import { data, Datum } from "../data/temperature";

const width = 600;
const height = 400;

const margin = {
  top: 20,
  right: 50,
  bottom: 20,
  left: 50,
};

const tempDomain = d3.extent(data, (d) => d.temp).reverse() as [number, number];

const tempScale = d3
  .scaleLinear<number>()
  .domain(tempDomain)
  .range([margin.top, height - margin.bottom])
  .interpolate(d3.interpolateRound);

const tempTicks = tempScale.ticks();

const dateDomain = d3.extent(data, (d) => d.date) as [Date, Date];

const dateScale = d3
  .scaleTime()
  .domain(dateDomain)
  .range([margin.left, width - margin.right]);

const dateTicks = dateScale.ticks(5).concat(dateScale.domain());

const line = d3
  .line<Datum>()
  .x((d) => dateScale(d.date))
  .y((d) => tempScale(d.temp))(data) as string;

const formatter = d3.timeFormat("%Y-%m");

export const Temperature: React.FC = ({}) => {
  const viewBox = `0 0 ${width} ${height}`;

  const xGrid = dateTicks.map((t) => (
    <g key={t.toString()}>
      <line
        stroke="lightgrey"
        x1={dateScale(t)}
        y1={margin.top}
        x2={dateScale(t)}
        y2={height - margin.bottom}
        strokeDasharray={4}
      />
      <text fill="darkgrey" textAnchor="middle" x={dateScale(t)} y={height}>
        {formatter(t)}
      </text>
    </g>
  ));

  const yGrid = tempTicks.map((t) => (
    <g key={t.toString()}>
      <line
        stroke="lightgrey"
        y1={tempScale(t)}
        x1={margin.left}
        y2={tempScale(t)}
        x2={width - margin.right}
        strokeDasharray={4}
      />
      <text
        fill="darkgrey"
        textAnchor="end"
        y={tempScale(t)}
        x={margin.left - 5}
      >
        {t}
      </text>
    </g>
  ));

  return (
    <svg viewBox={viewBox}>
      <g>{xGrid}</g>
      <g>{yGrid}</g>
      <g>
        <path d={line} stroke="steelblue" fill="none" />
      </g>
    </svg>
  );
};

```
</details>

And the resulting SVG will then look something like this:

<svg viewBox="0 0 600 400">
  <g>
    <g>
      <line
        stroke="lightgrey"
        x1="156.48148148148147"
        y1="20"
        x2="156.48148148148147"
        y2="380"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="middle" x="156.48148148148147" y="400">
        2011-10
      </text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        x1="267.5925925925926"
        y1="20"
        x2="267.5925925925926"
        y2="380"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="middle" x="267.5925925925926" y="400">
        2011-10
      </text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        x1="378.7037037037037"
        y1="20"
        x2="378.7037037037037"
        y2="380"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="middle" x="378.7037037037037" y="400">
        2011-10
      </text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        x1="489.81481481481484"
        y1="20"
        x2="489.81481481481484"
        y2="380"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="middle" x="489.81481481481484" y="400">
        2011-10
      </text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        x1="50"
        y1="20"
        x2="50"
        y2="380"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="middle" x="50" y="400">2011-10</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        x1="550"
        y1="20"
        x2="550"
        y2="380"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="middle" x="550" y="400">2011-10</text>
    </g>
  </g>
  <g>
    <g>
      <line
        stroke="lightgrey"
        y1="32"
        x1="50"
        y2="32"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="32" x="45">62.5</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        x1="50"
        y1="62"
        x2="550"
        y2="62"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" x="45" y="62">62</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        y1="92"
        x1="50"
        y2="92"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="92" x="45">61.5</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        y1="122"
        x1="50"
        y2="122"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="122" x="45">61</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        y1="152"
        x1="50"
        y2="152"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="152" x="45">60.5</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        x1="50"
        y1="182"
        x2="550"
        y2="182"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" x="45" y="182">60</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        y1="212"
        x1="50"
        y2="212"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="212" x="45">59.5</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        y1="242"
        x1="50"
        y2="242"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="242" x="45">59</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        y1="272"
        x1="50"
        y2="272"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="272" x="45">58.5</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        x1="50"
        y1="302"
        x2="550"
        y2="302"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" x="45" y="302">58</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        y1="332"
        x1="50"
        y2="332"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="332" x="45">57.5</text>
    </g>
    <g>
      <line
        stroke="lightgrey"
        y1="362"
        x1="50"
        y2="362"
        x2="550"
        stroke-dasharray="4"
      ></line>
      <text fill="darkgrey" text-anchor="end" y="362" x="45">57</text>
    </g>
  </g>
  <path
    d="M50,20L105.55555555555554,188L161.11111111111111,236L216.66666666666666,254L272.22222222222223,260L327.77777777777777,362L383.3333333333333,380L438.88888888888886,374L494.4444444444444,380L550,176"
    stroke="steelblue"
    fill="none"
  ></path>
</svg>
