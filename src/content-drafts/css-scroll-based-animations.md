---
title: CSS Scroll Based Animations
published: false
---

Based on the examples and documentation on:

- https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_scroll-driven_animations
- https://scroll-driven-animations.style/demos/stacking-cards/css/
- https://scroll-driven-animations.style/

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <style>
      body {
        animation: saturate;
        /* animation based on scroll position on the page */
        animation-timeline: scroll();
        animation-range: entry 0% exit 100%;
      }

      @keyframes saturate {
        from {
          background-color: hsl(180deg 0% 100%);
        }

        to {
          background-color: hsl(180deg 70% 60%);
        }
      }

      h1 {
        font-size: 48px;
        height: 80vh;

        animation: appear;

        /* animation based on how much of the element is in view */
        animation-timeline: view();
        animation-range: cover 0% cover 50%;
      }

      @keyframes appear {
        from {
          opacity: 0.2;
        }

        to {
          opacity: 1;
        }
      }

      .cards {
        --cards-top: 20px;
        --card-offset: 20px;
        --card-count: 4;
        --card-height: 100px;

        /* needed to ensure that at the end all items scroll off in a block and do not sweep over */
        display: grid;
        grid-template-columns: 1fr;
        grid-template-rows: repeat(4, var(--card-height));

        /* compensates for the padding created by the children */
        padding-bottom: calc(var(--card-count) * var(--card-offset));
        padding-top: var(--cards-top);

        /* the name of the block that the scroll animation timeline is based on */
        view-timeline-name: --cards-view-timeline;

        & .card {
          --index-rev: calc(var(--card-count) - var(--index));

          /* sticky position so that cards stack together */
          position: sticky;
          top: 0;

          /* calculated based on the index of a card so that they stack at an offset for 3d-ness
           padding is a sum of the base-padding and the padding calculated for the current card */
          padding-top: calc(
            var(--cards-top) + calc(var(--index) * var(--card-offset))
          );

          /* content is separated from the card since we want to shrink the content without
            affecting the layout of the actual block in the grid */
          & .content {
            /* which part of the animation timeline do we want to animate over */
            --start-range: calc(var(--index) / var(--card-count) * 100%);
            --end-range: calc((var(--index) + 1) / var(--card-count) * 100%);

            /* card height to correctly resize for grid as used above */
            height: var(--card-height);

            /* specify the animation we want to use - forwards */
            animation: shrink forwards;
            animation-timeline: --cards-view-timeline;
            animation-range: exit-crossing var(--start-range) exit-crossing
              var(--end-range);
          }
        }
      }

      @keyframes shrink {
        100% {
          /* some variables for calculating the scale reduction based on index */
          --scale-per-card: 0.03;
          --scale-diff: calc(var(--scale-per-card) * var(--index-rev));

          /* shrink the card content */
          transform: scale(calc(1 - var(--scale-diff)));
          left: 0px;
        }
      }

      .content {
        border: 1px solid black;
        border-radius: 12px;
        background-color: lightgrey;
      }
    </style>

    <h1>Hello World</h1>
    <div class="cards">
      <div class="card" style="--index: 0">
        <div class="content">First Item</div>
      </div>
      <div class="card" style="--index: 1">
        <div class="content">Second Item</div>
      </div>
      <div class="card" style="--index: 2">
        <div class="content">Third Item</div>
      </div>
      <div class="card" style="--index: 3">
        <div class="content">Fourth Item</div>
      </div>
    </div>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
  </body>
</html>
```
