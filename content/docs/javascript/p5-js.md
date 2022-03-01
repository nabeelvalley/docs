> Notes from [`p5.js`](https://p5js.org/) and [The Nature of Code](https://natureofcode.com/book/introduction/)

# Random Walk

Using `p5` we can create a random walker. With `p5` we usually structure stuff using OOP, for example we will define a random walker with the ability to take a new step as well as render itself:

`Walker.js`

```js
class Walker {
  constructor(xi, yi) {
    this.x = xi
    this.y = yi
  }

  step() {
    this.x += random(-2, 2)
    this.y += random(-2, 2)

    this.draw()
  }

  draw() {
    stroke("red")
    strokeWeight(2)
    point(this.x, this.y)
  }
}
```

We also need to create a walker instance and define the needed `setup` and `draw` functions for `p5`:

`sketch.js`

```js
const h = 500
const w = 700

let walker

function setup() {
  createCanvas(w, h)
  background(220)

  walker = new Walker(w / 2, h / 2)
}

function draw() {
  walker.step()
}
```

<details>
<summary>Random Coloured Walkers</summary>

We can also create a whole bunch of random walkers with random colours like so:

```js
const h = 1200
const w = 1200

let walkers = []

function setup() {
  createCanvas(w, h)
  background("red")

  for (let step = 0; step < 500; step++) {
    walkers.push(new Walker(width, height, 100))
  }
}

function draw() {
  walkers.forEach(w => w.step())
}

class Walker {
  constructor(w, h, b) {
    this.x = random(b, w - b)
    this.y = random(b, h - b)

    this.c1 = random(0, 255)
    this.c2 = random(0, 255)
    this.c3 = random(0, 255)
  }

  step() {
    function getC(c) {
      const newC = c + random(-2, 2)

      if (newC <= 1) return 255
      if (newC >= 254) return 0
      else return newC
    }

    this.c1 = getC(this.c1)
    this.c2 = getC(this.c2)
    this.c3 = getC(this.c3)

    this.x += random(-2, 2)
    this.y += random(-2, 2)

    this.draw()
  }

  draw() {
    stroke(this.c1, this.c2, this.c3)
    strokeWeight(2)
    point(this.x, this.y)
  }
}
```

</details>


# Vectors

`p5` also contains a Vector Class, this is a class of functions that allows us to work with vectors as mathematical structures

We can create a bouncing ball animation by using two vectors, one for `position` and one for `velocity` we can apply some vector math to get the ball to bounce around the screen

```js
const w = 600, h = 500, r = 50

let position
let velocity

this.setup = () => {
  createCanvas(w, h);
  
  position = createVector(random(r, w - r), random(r, h - r))
  velocity = createVector(10, 10)  
}

this.draw = () =>  {
  background(0);
  
  position.add(velocity)
  
  if (position.x <= r || position.x >= w - r) velocity.x *= -1
  if (position.y <= r || position.y >= h - r) velocity.y *= -1
  
  fill('red')
  noStroke()
  ellipse(position.x, position.y, r * 2)  
}
```

We cal also do something like the above using a 3D canvas

