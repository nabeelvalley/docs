---
title: Defining a Custom SVG Renderer for Matter.js
---

## Defining a Renderer

```ts
import { Engine, Composite, Runner } from "matter-js";
import { createRect, Renderer } from "./renderer";

const engine = Engine.create();

const screen = document.createElementNS("http://www.w3.org/2000/svg", "svg");
screen.style.backgroundColor = "lightgrey";
screen.setAttribute("height", "500");
screen.setAttribute("width", "500");

document.body.appendChild(screen);

const renderer = new Renderer(engine);

const bodies = [
  createRect(100, 200, 100, 100, {
    angle: 0.5,
  }),
  createRect(150, 50, 100, 100),
  createRect(0, 450, 500, 50, { isStatic: true }),
];

Composite.add(
  engine.world,
  bodies.map((b) => b.body),
);

bodies.forEach((b) => screen.appendChild(b.svg));

renderer.run();

const runner = Runner.create();
Runner.run(runner, engine);

setTimeout(() => {
  Runner.stop(runner);
  renderer.stop();
}, 3000);
```

## Using the Renderer

```ts
import { Engine, Composite, Runner } from "matter-js";
import { createRect, Renderer } from "./renderer";

const engine = Engine.create();

const screen = document.createElementNS("http://www.w3.org/2000/svg", "svg");
screen.style.backgroundColor = "lightgrey";
screen.setAttribute("height", "500");
screen.setAttribute("width", "500");

document.body.appendChild(screen);

const renderer = new Renderer(engine);

const bodies = [
  createRect(100, 200, 100, 100, {
    angle: 0.5,
  }),
  createRect(150, 50, 100, 100),
  createRect(0, 450, 500, 50, { isStatic: true }),
];

Composite.add(
  engine.world,
  bodies.map((b) => b.body),
);

bodies.forEach((b) => screen.appendChild(b.svg));

renderer.run();

const runner = Runner.create();
Runner.run(runner, engine);
```
