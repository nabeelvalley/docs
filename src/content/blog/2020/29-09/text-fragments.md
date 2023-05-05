[[toc]]

When linking to a webpage it can be useful to link to a specific part of a page. Using a hash in the URl you can link to the `id` attribute in the HTML of a page

For example, `https://my.website.com#overview` would link to the element with `id="overview"` in the HTML

However, it may be useful for us to link to a general piece of text on a page, we can use _text fragments_ to do so. These work similar to the way a hash does, but we can link to any text on a page even if it does not have an `id`. Additionally, the user's browser will highlight the text set to draw the user's attention to it

> Note that at the moment only Chromium based browsers support this

To do this, we need to identifiy the text on the page we want to link to. Say we'd like to link to the first paragraph of this page, we can use the **text directive** (`#:~:text=`) param in the URL to link to specific text instead of just the `#` like we use for an ID

We would need to take the part of the text we want to focus, URL encode it, then add it to the **text directive** the final URL may look something like this:

```
https://my.website.com/#:~:text=When%20linking%20to%20a%20webpage
```

If you need to highlight a larger piece of text, you can use the start and end of your text segment, separated by a comma, for example selecting the entire first paragraph of this post:

```
https://my.website.com/#:~:text=when%20linking,HTML%20of%20a%20page
```

The link below should link to the first paragraph of this page if opened in a new tab (provided your browser supports text fragments):

> [ctrl + click me](#:~:text=when%20linking,HTML%20of%20a%20page)

You can read more about text fragments in URLs on [web.dev](https://web.dev/text-fragments/)
