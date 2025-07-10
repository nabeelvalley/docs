---
title: Exploring the CSS Paint API
description: Walking through a simple example of using the CSS Houdini Paint API
subtitle: 10 July 2025
published: true
feature: true
---

[The CSS Painting API](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Painting_API) is part of [the CSS Houdini group of APIs](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Painting_API) which provide low level access to the CSS engine

The CSS Houdini APIs use the idea of "worklets" which are basically JS files that the CSS engine will use as part of it's rendering pipeline

For the sake of this example, I'll be looking specifically at the CSS Painting API to build a custom CSS `paint` worklet

# The CSS `paint` function

Before getting into specifics around how to implement a worklet, it's nice to see what we're trying to get to. Worklets are effectively JS functions that we can "call" from our CSS code to modify how an element is rendered. The CSS Painting API exposes a `paint` function in CSS. Let's assume we have a worklet called `myCustomPainter`

We would be able to apply this to some `html` code like so:

```html
<h1 class="fancy">Hello world</h1>
```

And we can style this using the CSS `paint` function with the name of our worklet:

```css
.fancy {
  background-image: paint(myCustomPainter);  
}
```

This will invoke our worklet to `paint` a custom background for our element

# The Methods Available

The CSS Paint API exposes a few different methods and bits of functionality to us

Firstly, we have the methods needed for defining a worklet, this is the global `CSS.paintWorklet.addModule` method:

```ts
namespace CSS {
  declare const paintWorklet: {
    addModule(url: string): Promise<void>
  }
}
```

Next, we also have the `registerPaint` function which is a global function in the Worklet scope that is used to register a class that handles painting:

```ts
declare function registerPaint(name: string, paintCtor: PainterOptions): Promise<void>
```

The actual `PainterOptions` consists of two parts, a `Paint` class that handles the actual painting, and a static `PainterClassRef` that specificies some metadata about the `Paint` class:

```ts
declare interface Paint {
  paint(ctx: PaintRenderingContext, size: PaintSize, styleMap: StylePropertyMapReadOnly): void
}

type PaintCtor = new () => Paint

declare interface PainterClassRef {
  /**
   * CSS Properties accessed by the `paint` function. These can be normal or custom properties.
   */
  inputProperties?: string[]

  /**
   * Specififes if the rendering context supports transparency
   */
  contextOptions?: { alpha: boolean }

  /**
   * Inputs to the `paint` function from CSS.
   * Not supported in any browsers I've tested.
   * Chrome on MacOS will completely break rendering the `paint` function is passed
   * any values in the CSS
   */
  inputArguments?: string[]
}

type PainterOptions = PainterClassRef & PaintCtor
```

Lastly, for the sake of completeness, the remaining types used by the above definitions are:

```ts
/** Not exactly a Canvas but it's pretty similar */
declare type PaintRenderingContext = CanvasRenderingContext2D

declare type PaintSize = { height: number, width: number }
```

# Defining a Worklet

A simple Paint class without any input properties looks something like this:

```ts title="my-painter.ts"
export class MyCustomPainter implements Paint {
  static get contextOptions() {
    return { alpha: true };
  }
  
  static registerPaint() {
    registerPaint("myCustomPainter", MyCustomPainter);
  }

  paint(ctx: PaintRenderingContext, _size: PaintSize, styleMap: StylePropertyMapReadOnly) { }
}
```

> The `registerPaint` method isn't strictly necessary but it lets us keep the registration inside of the class which is nice

Registering this as a worklet is done in two steps:

1. From our main script, we need to run `CSS.paintWorklet.addModule`. I'm using the Vite `url` param to get this directly from the path to my worklet file:

```ts title="main.ts"
import workletUrl from './worklet?url'

CSS.paintWorklet.addModule(workletUrl)
```

2. From the worklet, you need to register the `MyCustomPainter` as a `painter`:

```ts title="worklet.ts"
import { MyCustomPainter } from "./my-painter";

MyCustomPainter.registerPaint()
```

# Taking Inputs

In order for our worklet to do something fun we will probably want to take some inputs. We can specifiy which CSS properties (or custom properties) we want to use as an input - we do this via `inputProperties`. We can also register a custom property by using `CSS.registerProperty`

For our example, we'll also define a method in the `MyCustomPainter` class that does this:

```ts title="my-painter.ts"
// ... rest of class
static readonly colorProp = '--custom-painter-color'

static registerProperties() {
  CSS.registerProperty({
    name: MyCustomPainter.colorProp,
    syntax: '<color>',
    inherits: false,
    initialValue: 'transparent',
  })
}

static get inputProperties() {
  return [MyCustomPainter.colorProp]
}

// ... rest of class
```

Then, we need to call the `registerProperties` method above to register the custom property in the `main.ts` file (or somewhere in the normal page/JS context)

We can do this along with where we defined the worklet:

```ts title="main.ts"
import { MyCustomPainter } from './my-painter'
import workletUrl from './worklet?url'

CSS.paintWorklet.addModule(workletUrl)
MyCustomPainter.registerProperties()
```

> While it should be possible to get inputs as `arguments` to a painter, it seems that is not supported on any browsers as yet

This will make it so that we can provide inputs when painting. Inputs can come from our CSS, so using our worklet now looks like this:

```css
.fancy {
  --custom-painter-color: yellow;
  background-image: paint(myCustomPainter);  
}
```

Then, we can access this in the `paint` method to do something like draw a rectangle over the entire canvas

```ts title="my-painter.ts"
// ... rest of class
paint(ctx: PaintRenderingContext, size: PaintSize, styleMap: StylePropertyMapReadOnly) {
  const color = styleMap.get(MyCustomPainter.colorProp)!.toString()

  ctx.fillStyle = color
  ctx.fillRect(0, 0, size.width, size.height)
}
```

The `paint` method receives a rendering `context`, the `size` of the element, and the `styles` that we defined in `registerProperties` (if they are set on the element)

It's also nice to note that since we've specified that `--custom-painter-color` has an `initialValue` it will not be `undefined` and the browser will provide us with the `initialValue` if it's not provided


And that's really about it. The API is pretty simple but powerful and makes it possible to do so much

# The Complete Worklet

```html title="index.html"
<h1 class="fancy">Hello world</h1>
```

```css title="style.css"
.fancy {
  --custom-painter-color: yellow;
  background-image: paint(myCustomPainter);  
}
```

```ts title="my-painter.ts"
export class MyCustomPainter implements Paint {
  static readonly colorProp = '--custom-painter-color'

  static registerProperties() {
    CSS.registerProperty({
      name: MyCustomPainter.colorProp,
      syntax: '<color>',
      inherits: false,
      initialValue: 'transparent',
    })
  }

  static registerPaint() {
    registerPaint("myCustomPainter", MyCustomPainter);
  }

  static get inputProperties() {
    return [MyCustomPainter.colorProp]
  }

  static get contextOptions() {
    return { alpha: true };
  }

  paint(ctx: PaintRenderingContext, size: PaintSize, styleMap: StylePropertyMapReadOnly) {
    const color = styleMap.get(MyCustomPainter.colorProp)!.toString()

    ctx.fillStyle = color
    ctx.fillRect(0, 0, size.width, size.height)
  }
}
```

```ts title="worklet.ts"
import { MyCustomPainter } from "./my-painter";

MyCustomPainter.registerPaint()
```

```ts title="main.ts"
import { MyCustomPainter } from './my-painter'
import workletUrl from './worklet?url'

MyCustomPainter.registerProperties()
CSS.paintWorklet.addModule(workletUrl)
```

```ts title="paint.d.ts"
// Types for working with the CSS Paint API

namespace CSS {
  declare const paintWorklet: {
    addModule(url: string): Promise<void>
  }
}

declare function registerPaint(name: string, paintCtor: PainterOptions): Promise<void>

declare interface Paint {
  paint(ctx: PaintRenderingContext, size: PaintSize, styleMap: StylePropertyMapReadOnly): void
}

type PaintCtor = new () => Paint

declare interface PainterClassRef {
  inputProperties?: string[]
  contextOptions?: { alpha: boolean }

  /**
   * Not supported in any browsers I've tested.
   * Chrome on MacOS will completely break rendering the `paint` function is passed
   * any values in the CSS
   */
  inputArguments?: string[]
}

type PainterOptions = PainterClassRef & PaintCtor

declare type PaintRenderingContext = CanvasRenderingContext2D

declare type PaintSize = { height: number, width: number }
```

# References

There are loads of things you can do with the Houdini APIs, some things I recommend reading and taking a look at on this topic are:

- [The CSS Paint API Spec](https://www.w3.org/TR/css-paint-api-1/)
- [Is Houdini Ready Yet?](https://ishoudinireadyyet.com/)
- [CSS Houdini Experiments](https://css-houdini.iamvdo.me/)
- [MDN CSS Houdini Docs](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_properties_and_values_API/Houdini)

# Notes

It's kinda annoying how many moving parts this has and that makes it a little challenging to include a live example on this blog. Hopefully the other examples I've linked above will serve this purpose

Some nice next things to look at from here are the other Houdini APIs since they offer very different sets of functionality and can be combined to do some interesting stuff