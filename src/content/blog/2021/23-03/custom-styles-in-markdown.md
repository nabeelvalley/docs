---
published: true
title: Custom Styles in Markdown
subtitle: 23 March 2021
description: Add styles for specific HTML elements in a markdown document
---

---
published: true
title: Custom Styles in Markdown
subtitle: 23 March 2021
description: Add styles for specific HTML elements in a markdown document
---

When working with markdown it can often be useful to be able to style elements using custom CSS

We can accomplish this by including a `style` tag. An example to illustrate this is changing the way a table renders in a specific document by changing the style of table rows to be striped, you would include the following CSS:

```css
<style>
tr:nth-child(even) {
  background-color: #b2b2b2;
  color: #f4f4f4;
}
</style>
```

If the platform you're displaying the HTML in already has the styles included then you may need to add `!important` to override in the CSS:

```css
<style>
tr:nth-child(even) {
  background-color: #b2b2b2!important;
  color: #f4f4f4!important;
}
</style>
```

`my-sample-doc.md`

```md
# Custom CSS in Markdown Example

This is a document where tables are rendered with every second table row with a specific background and foreground colour

<style>
tr:nth-child(even) {
  background-color: #b2b2b2!important;
  color: #f4f4f4!important;
}
</style>

The above CSS will lead to the following table being rendered with alternating row colours:

| Col 1 | Col 2 | Col 3 |
| ----- | ----- | ----- |
| A     | B     | C     |
| 1     | 2     | 3     |
| A1    | B2    | C3    |
```

> Note that depending on your markdown renderer the embeded style tags may be removed, you'll have to look at your specific renderer/converter/platform to see whether this works for you

With the converter I'm using, `showdown.js`, this is how the table above looks (with `!important` included to override my current table styles):

<style>
tr:nth-child(even) {
  background-color: #b2b2b2!important;
  color: #f4f4f4!important;
}
</style>

| Col 1 | Col 2 | Col 3 |
| ----- | ----- | ----- |
| A     | B     | C     |
| 1     | 2     | 3     |
| A1    | B2    | C3    |
