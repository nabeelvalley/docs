---
title: CSS Anchor Positioning
description: Positining CSS elements and some other interesting CSS
subtitle: 11 February 2026
published: true
---

I was reading a pull request the other day and someone suggested the use of `position-anchor` which was something I hadn't seen before and so I thought I'd write something small about it

In putting together this example, I came across a few interesting points that I wanted to talk about - but before getting into those, here's a small example first

## Example

For the example we'll use some HTML and CSS in order to place some content relative to some specific anchor. The result we see is that the "Content for Anchor N" is placed at the top right of the "Anchor N" element, but this could be many other placements or layouts as desired

<section>
  <h3 class="anchor" anchor-name="--anchor-1">Anchor 1</h3>
  <p class="anchored" anchor-name="--anchor-1">Content for Anchor 1</p>

  <h3 class="anchor" anchor-name="--anchor-2">Anchor 2</h3>
  <p class="anchored" anchor-name="--anchor-2">Content for Anchor 2</p>
</section>

<style>
  .anchor {
    anchor-name: attr(anchor-name type(<custom-ident>));
    margin: 50px;
  }

  .anchored {
    position-anchor: attr(anchor-name type(<custom-ident>));
    position: fixed;
    bottom: anchor(bottom);
    right: anchor(right);
  }
</style>


The above example uses a few interesting bits that I'd like to discuss before throwing a wall of code at you

## CSS Identifiers

Though it does a pretty good job of making everything look like a string - CSS does indeed have data types (<cite>[CSS Data Types - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/Data_types)</cite>). Usually we don't need to think too hard about these but they end up being necessary in the above example when using the `position-anchor` attribute and `attr` function

An `<ident>` is the type used to represent an identifier in CSS (<cite>[CSS <ident> - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/ident)</cite>)

A `<custom-ident>` is a case-sensitive string that can be user-defined and used as CSS identifier (<cite>[CSS <custom-ident> - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/custom-ident)</cite>)

The `position-anchor` attribute requires a `<dashed-ident>` which is a `<custom-ident>` that starts with `--` (<cite>[CSS <dashed-ident> - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/dashed-ident)</cite>). These will never be defined by CSS and are only ever defined by the user

In our example, we're receiving our `<dashed-ident>` via `attr()`. Since a `<dashed-ident>` cannot be defined by CSS, the type we will receive from `attr()` is a `<custom-ident>`. Note that this **must** start with `--` in order to work in the place of a `<dashed-ident>`

## Reading Attributes in CSS

The CSS `attr()` function lets us read the value of an element attribute and use it in CSS (<cite>[CSS attr() - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/attr)</cite>). This means that we can effectively provide variables for use within CSS by way of HTML attributes. This is really handy and has tons of use cases

In the example above, we're using the `attr()` to read the value of the `anchor` attribute. Some ways of using `attr()` can be seen below:

```css
/* basic */
attr(attribute-name)

/* with a unit or type*/
attr(attribute-name unit)
attr(attribute-name type(<css-type>))
```

To actually use this, we can specify an attribute on an HTML element like so:

```html
<h3 class="anchor" anchor-name="--anchor-1">Anchor 1</h3>
```

And we can then read an attribute, for example - the `anchor-name` attribute as a `<custom-ident>`, using `attr()` as seen below:

```css
.anchor {
  anchor-name: attr(anchor-name type(<custom-ident>));
}
```

`attr()` can be used to read data from an attribute and use it in CSS pretty much anywhere that we'd normally use hard-coded data

## Anchor Positioning

Now that we've covered what the `attr` and `<custom-ident>` syntax is all about, we can dive into anchor positioning

Anchor positioning is a set of CSS attributes and behaviors that make it possible to connect the positions and sizes of different elements (<cite>[CSS anchor positioning - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Anchor_positioning)</cite>). For the sake of this example, we'll use the different parts of the anchor positioning module to place an element at the top-right of another element. Making this work requires us to define the anchor element. This is done using the `anchor-name` property on said element (<cite>[CSS anchor-name - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/anchor-name)</cite>):

```html
<h3 class="anchor-1">Anchor 1</h3>

<style>
.anchor-1 {
  anchor-name: --anchor-1
}
</style>
```

And then, we can reference this `anchor-name` from any elements that want to position themselves relative to this with the `position-anchor` property which specifies the name of the anchor element (<cite>[CSS position-anchor - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/position-anchor)</cite>)

```html
<p class="anchored-1">Content for Anchor 1</p>

<style>
.anchored-1 {
  position-anchor: --anchor-1;
  position: fixed;

  bottom: anchor(bottom);
  right: anchor(right);
}
</style>
```

In the above, we specify `position: fixed` to place this element relative to the `position-anchor` and out of the normal document flow (<cite>[CSS position - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/position)</cite>)

The CSS `anchor()` function is used to return the length relative to the anchor element and allows us to position the anchored element relative to the anchor (<cite>[CSS anchor() - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/anchor)</cite>)

## Putting It Together

The example above is fairly repetitive. For each element having to redefine a CSS rule sets the `anchor-name` and `position-anchor` can become tedious. There are two solutions that will give us some kind of reusability here, namely:

1. Using a CSS custom property that is set on the element
2. Using a custom HTML attribute and reading that in the CSS

Lately I've been liking the use of custom HTML attributes as a hook for styling - this is inspired by the [TAC CSS Methodology](https://jordanbrennan.hashnode.dev/tac-a-new-css-methodology) which uses Tags, Attributes, and Classes - in that order - as styling hooks

As such, the below example uses the `anchor-name` attribute on the HTML element to define the values to use for `anchor-name` and `position-anchor`, which we then read in the CSS using `attr()`:

```html
<h3 class="anchor" anchor-name="--anchor-1">Anchor 1</h3>
<p class="anchored" anchor-name="--anchor-1">Content for Anchor 1</p>
```

And then, define generic CSS rules that can work with any provided `anchor-name` attribute and read them accordingly:

```css
.anchor {
  anchor-name: attr(anchor-name type(<custom-ident>));
  margin: 50px;
}

.anchored {
  position-anchor: attr(anchor-name type(<custom-ident>));
  position: fixed;
  bottom: anchor(bottom);
  right: anchor(right);
}
```

Putting that together gets the behavior we're after in a pretty neat and reusable way

## The Big Example

Putting all the above together, we can get back to the code for the original example, which can be seen once more below:

<section>
  <h3 class="anchor" anchor-name="--anchor-3">Anchor 3</h3>
  <p class="anchored" anchor-name="--anchor-3">Content for Anchor 3</p>

  <h3 class="anchor" anchor-name="--anchor-4">Anchor 4</h3>
  <p class="anchored" anchor-name="--anchor-4">Content for Anchor 4</p>
</section>

<style>
  .anchor {
    anchor-name: attr(anchor-name type(<custom-ident>));
    margin: 50px;
  }

  .anchored {
    position-anchor: attr(anchor-name type(<custom-ident>));
    position: fixed;
    bottom: anchor(bottom);
    right: anchor(right);
  }
</style>

The respective HTML and CSS is as follows:

```html
<section>
  <h3 class="anchor" anchor-name="--anchor-3">Anchor 3</h3>
  <p class="anchored" anchor-name="--anchor-3">Content for Anchor 3</p>

  <h3 class="anchor" anchor-name="--anchor-4">Anchor 4</h3>
  <p class="anchored" anchor-name="--anchor-4">Content for Anchor 4</p>
</section>

<style>
  .anchor {
    anchor-name: attr(anchor-name type(<custom-ident>));
    margin: 50px;
  }

  .anchored {
    position-anchor: attr(anchor-name type(<custom-ident>));
    position: fixed;
    bottom: anchor(bottom);
    right: anchor(right);
  }
</style>
```

## Accessibility Notes

Be careful with this idea, though it's useful to move elements around the screen arbitrarily but it's probably undesirable from an accessibility standpoint. Try to ensure that the elements are still related logically and ordered so that screen readers and other accessibility tools work as you'd intend

## Further Reading

The above APIs can also be a handy addition to the [HTML popover attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/popover) and can lead to some nice JavaScript-free behaviors
