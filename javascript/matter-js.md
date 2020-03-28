> Some notes on using Matter.js based on [The Coding Train YouTube Videos](https://www.youtube.com/channel/UCvjgXvBlbQiydffZU7m1_aw)

# Physics Engine Overview

> [Playlist](https://www.youtube.com/watch?v=wB1pcXtEwIs&list=PLRqwX-V7Uu6akvoNKE4GAxf6ZeBYoJ4uh&index=2&t=0s)

At a high level to move things around we make use of basic physics concepts using vector math, collisions, etc. In order to do this we can make use of pre-implemented things like a physics engine in order to make things move around and interact

In general when using a physics engine we have some of the following steps:

1. Setup allows us to define the inital state of the world
2. We then tell the physics engine to start
3. The state we defined will iterate over a render loop updating the different properties of the objects in our world

Physics Engines usually have some common concepts:

- **The World** which is a defined space with specific rules
- **A Body** which is an entity in that world
- **A Connection** which states how different bodies are related to one another

# Matter.js

[Matter.js](https://github.com/liabru/matter-js) is a 2D rigd body physics engine that runs in the browser. The general Getting Started Buide can be found [on GitHub](https://github.com/liabru/matter-js/wiki/Getting-started)

Matter.js has a built-in render and runner for simulations that does very basic rendering for the purpose of debugging. For our purpose we'll use [p5.js]() for rendering

## Setup the Application

To get started with the Library we should initilize a new package and add the `matter.js` library to it

```
mkdir matter-js
cd matter-ms
yarn init -y
yarn add matter-js p5
```

Thereafter we need to create a few files for our code:

1. `index.html` which will just reference the relevant files
2. `index.js` which is where we will implement our javascript

In our `index.html` file we'll include the following to reference `matter-js` and our own `index.js` file:

`index.html`

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Matter.js</title>
  </head>

  <body>
    <script src="./node_modules/matter-js/build/matter.js"></script>
    <script src="./node_modules/p5/lib/p5.js"></script>
    <script src="./index.js"></script>
  </body>
</html>
```

Within our page context the `Matter` variable should allow us to access the functionality of the library

## Basic Setup

As a basic setup to our page we can then create an Engine and Renderer instance using `Matter` in a setup function as well as define the different bodies and add them to the `World`

`index.js`

```js
// Render = Matter.Render,
;(World = Matter.World), (Bodies = Matter.Bodies)

let engine
let render
let body
let ground

function setup() {
  createCanvas(400, 400)

  engine = Engine.create()

  // shape is defined its centroid and dimensions
  body = Bodies.rectangle(200, 200, 80, 80)
  ground = Bodies.rectangle(200, 375, 400, 50, {
    isStatic: true
  })

  World.add(engine.world, [body, ground])
  Engine.run(engine)
}
```

> You can also see the call to `createCanvas` which is what processing will use to create the canvas for the site

## Rendering

Now that the engine is running, we can start looking at how to render the specific objects as they move through our canvas

Each of the respective bodies we create have some basic properties that we can use to render the body. In the case of `Matter.Bodies` we have a `vertices` property. We can use `p5` to render the vertices as follows:

```js
const renderFromVertices = vertices => {
  beginShape()

  vertices.forEach(point => {
    vertex(point.x, point.y)
  })

  endShape(CLOSE)
}
```

We can then implement this in a `draw` function which `p5` will call and pass it the relevant shapes we want to be drawn like so:

`index.js`

```js
function draw() {
  background(51)

  const renderBody = body => {
    if (body.render.visible) {
      beginShape()

      body.vertices.forEach(point => {
        vertex(point.x, point.y)
      })

      endShape(CLOSE)
    }
  }

  renderBody(body)
  renderBody(ground)
}
```

Taking into consideration the `render` properties of the body which we can assign from the `Matter.Bodies` instances, we can see that each body has `render.fillStyle`, `render.strokeStyle`, `render.opacity`, and a `render.visible` property

We can update our render function to make use of these properties like so:

```js
const renderBody = ({ render, vertices }) => {
  if (render.visible) {
    beginShape()

    opacity = render.opacity * 255

    fillColour = color(render.fillStyle)
    fillColour.setAlpha(opacity)

    fill(fillColour)

    strokeColour = color(render.strokeStyle)
    strokeColour.setAlpha(opacity)

    stroke(render.strokeStyle)
    strokeWeight(render.lineWidth)

    vertices.forEach(point => {
      vertex(point.x, point.y)
    })

    endShape(CLOSE)
  }
}
```

Next, we can simply always render all the bodies in our world like so:

```js
engine.world.bodies.forEach(renderBody)
```

So using all of the above, our `draw` function becomes:

```js
function draw() {
  background(51)

  const renderBody = ({ render, vertices }) => {
    if (render.visible) {
      beginShape()

      opacity = render.opacity * 255

      fillColour = color(render.fillStyle)
      fillColour.setAlpha(opacity)

      fill(fillColour)

      strokeColour = color(render.strokeStyle)
      strokeColour.setAlpha(opacity)

      stroke(render.strokeStyle)
      strokeWeight(render.lineWidth)

      vertices.forEach(point => {
        vertex(point.x, point.y)
      })

      endShape(CLOSE)
    }
  }

  engine.world.bodies.forEach(renderBody)
}
```
 
> While all the above technically works, I think it may just make sense to write a canvas renderer which should work more or less the same. So hopefully I'll do that doo