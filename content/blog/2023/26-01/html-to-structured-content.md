---
title: Structuring HTML Content
subtitle: 26 January 2023
description: Transforming HTML into structured data to work with EditorJS
---

[[toc]]

# Isn't HTML a structure?

HTML content is structured as a tree - while this is useful for the medium, this structure isn't very convenient for transforming into data that can be used outside of the web or with libraries that use content in a more flat structure

While building [Articly](https://articly.vercel.app) I wanted to use a library called [EditorJS](https://editorjs.io) for displaying and making text content interactive. An immediate problem I ran into was importing content into the editor since it requires the data in a specific format - which is not HTML but rather an array of objects with simplified content

# StackOverflow is helpful sometimes

In order to get the content into the EditorJS format, I needed to find a way to transform the HTML that I had from scraping the web and reading RSS feeds into something I could use as some kind of base

After a little bit of searching, I found this handy function on [StackOverflow](https://stackoverflow.com/questions/12980648/map-html-to-json):

```js
//Recursively loop through DOM elements and assign properties to object
function treeHTML(element, object) {
  object["type"] = element.nodeName;
  var nodeList = element.childNodes;
  if (nodeList != null) {
    if (nodeList.length) {
      object["content"] = [];
      for (var i = 0; i < nodeList.length; i++) {
        if (nodeList[i].nodeType == 3) {
          object["content"].push(nodeList[i].nodeValue);
        } else {
          object["content"].push({});
          treeHTML(
            nodeList[i],
            object["content"][object["content"].length - 1]
          );
        }
      }
    }
  }
  if (element.attributes != null) {
    if (element.attributes.length) {
      object["attributes"] = {};
      for (var i = 0; i < element.attributes.length; i++) {
        object["attributes"][element.attributes[i].nodeName] =
          element.attributes[i].nodeValue;
      }
    }
  }
}
```

Using the above as a guideline, I concluded that the main thing that I need was to iterate over the HTML content in a way that would allow me to build a content array which is recursive - the idea at this point is not to remove the tree structure, but rather to transform it into something that's a bit easier to work with

# A different tree

Now that I had an idea of how to approach the problem, the next step was to define the structure I wanted, below is the final structure I decided on:

1. The source HTML element object needs to be stored as this may useful to downstream processors
2. The `tagName` of the element will be needed to determine how a specific element needs to be handled
3. The `textContent` and `innerHTML` of the element to be stored - this is the core data of the element
4. The `attributes` of the HTML element should be unwrapped to make it easier for downstream code to read
5. The children of the element need to be converted into the the same type by recursively following steps 1-5

Based on the above, the type definition can be seen below along with the implementation:

```ts
type TagName = Uppercase<keyof HTMLElementTagNameMap>;

type HTMLStringContent = string;

type TransformResult = {
  element: Element;
  tagName: TagName;
  textContent?: string;
  htmlContent?: HTMLStringContent;
  attrs: Record<string, string>;
  children: TransformResult[];
};

const transform = (el: Element): TransformResult => ({
  element: el,
  // tag names are strings internally but that's not very informative downstream
  tagName: el.tagName as TagName,
  textContent: el.textContent || undefined,
  htmlContent: el.innerHTML,
  children: Array.from(el.children).map(transform),
  attrs: Array.from(el.attributes).reduce(
    (acc, { name, value }) => ({ ...acc, [name]: value }),
    {}
  ),
});
```

Now that I have the data as a tree structure, we can pass in some simple HTML to see what pops out the other end.

Given the following HTML content:

```html
<div>
  <p>Hello World</p>

  <section>
    <img src="hello.jpg" alt="this is an image" />
  </section>
</div>
```

We can transform it like so:

```ts
// use the DOM to parse it from a string
const el = new DOMParser().parseFromString(html, "text/html").body;

// the convertHtmlToBlocks function takes an HTML ELement
const transformed = transform(el);
```

The `transformed` data looks something like this:

```json
{
  "element": {},
  "tagName": "BODY",
  "textContent": "\n  Hello World\n\n  \n    \n  \n",
  "htmlContent": "<div>\n  <p>Hello World</p>\n\n  <section>\n    <img src=\"hello.jpg\" alt=\"this is an image\">\n  </section>\n</div>",
  "children": [
    {
      "element": {},
      "tagName": "DIV",
      "textContent": "\n  Hello World\n\n  \n    \n  \n",
      "htmlContent": "\n  <p>Hello World</p>\n\n  <section>\n    <img src=\"hello.jpg\" alt=\"this is an image\">\n  </section>\n",
      "children": [
        {
          "element": {},
          "tagName": "P",
          "textContent": "Hello World",
          "htmlContent": "Hello World",
          "children": [],
          "attrs": {}
        },
        {
          "element": {},
          "tagName": "SECTION",
          "textContent": "\n    \n  ",
          "htmlContent": "\n    <img src=\"hello.jpg\" alt=\"this is an image\">\n  ",
          "children": [
            {
              "element": {},
              "tagName": "IMG",
              "htmlContent": "",
              "children": [],
              "attrs": { "src": "hello.jpg", "alt": "this is an image" }
            }
          ],
          "attrs": {}
        }
      ],
      "attrs": {}
    }
  ],
  "attrs": {}
}
```

Not too dissimilar to the structure raw HTML we would have had if we just used `DOMParser` directly, however it now has a lot less noise

# Deforestation

As I mentioned earlier, we need to transform the data into a flat array of items - so the question that comes up now is - how do we do that?

Looking at the input HTML we used, we can break things up into two types of elements - containers and content

Containers are pretty much useless to the content structure we're trying to build - the content is all we really care about

This is an important distinction because it tells us what we can throw away

Secondly, we can think of the content inside of a container as an array of content, once we remove all the containers, this content will become flat

So for example, this HTML:

```html
<div>
  <p>Hello World</p>

  <section>
    <img src="hello.jpg" alt="this is an image" />
  </section>
</div>
```

When we remove the containers can be thought of as:

```html
<p>Hello World</p>

<img src="hello.jpg" alt="this is an image" />
```

Which can be thought of as an array like so:

```ts
[paragraph, image];
```

This is our end goal. In order to get here we still have to figure out two things:

1. How can we separate out the containers from the content
2. How can we transform the content into the structure that's useful to us

# Separating the leaves from the wood

If we think as containers as having no meaningful data, and just being containers for content, then we can conclude that a way to view the data structure is as an array of content - the container is the array, and the content is the items in the array

So, we can write a transformer for a container as something that just returns an array of content

```ts
const removeContainer = (data: TransformResult) => data.children;
```

The above is pretty useful, since this means that the following HTML:

```html
<div>
  <p>Hello World</p>

  <section>
    <img src="hello.jpg" alt="this is an image" />
  </section>
</div>
```

Will be essentially be converted to this:

```html
<p>Hello World</p>

<section>
  <img src="hello.jpg" alt="this is an image" />
</section>
```

Now, we still see that there's a `section` leftover since we only returned one layer of children. Since we already have a way to get rid of the wrapper, we can just apply that to the child that's a section,

So we could have something like this:

```ts
const removeContainer = (data: TransformResult) =>
  data.children.map((child) =>
    isContainer(child) ? removeContainer(child) : child
  );
```

Now the function is a bit weird because the inner map is either returning an array if the `child` is a container, or a single `child` if it's not - for consistency, let's just always return an array:

```ts
const removeContainer = (data: TransformResult) =>
  data.children.map((child) =>
    isContainer(child) ? removeContainer(child) : [child]
  );
```

Much better, but now we've introduced something weird - instead of just returning a `TransformResult[]` we're now returning a `TransformResult[][]` - let's just leave this here for now, we can always unwrap the arrays later - importantly we now know that we've eliminated the wrappers, so the content we're left with now represents:

```html
<p>Hello World</p>

<img src="hello.jpg" alt="this is an image" />
```

So this is pretty great, and is the general idea of how we can unwrap things - next up we can talk about transforming the specific elements into useful data blocks

# Building blocks

EditorJS has different sections - blocks as it calls them - of content. These are simple Javascript objects that represent the data for the block

For the sake of our discussion, we're going to consider two blocks - `ParagraphBlock` and `ImageBlock`

The simplified types that represent their data can be seen below:

```ts
export type ParagraphBlock = {
  type: "paragraph";
  data: {
    text: string;
  };
};

export type SimpleImageBlock = {
  type: "image";
  data: {
    url: string;
    caption: string;
  };
};
```

We can look at the the `TransformResult` for each of the above elements from when we passed the HTML into our `transform` function previously, we can see

For the paragraph:

```json
{
  "element": {},
  "tagName": "P",
  "textContent": "Hello World",
  "htmlContent": "Hello World",
  "children": [],
  "attrs": {}
}
```

Which can be translated to the `ParagraphBlock` data as:

```ts
{
  type: "paragraph",
  data: {
    text: "Hello World"
  }
}
```

A function for doing this could look something like:

```ts
const convertParagraph = (data: TransformResult): ParagraphBlock | undefined =>
  data.textContent
    ? {
        type: "paragraph",
        data: {
          text: data.textContent,
        },
      }
    : undefined;
```

Cool, this lets us transform a paragraph into some structured data.

We can do something similar for images:

```ts
const convertImage = (data: TransformResult): ImageBlock | undefined =>
  data.attrs.src
    ? {
        type: "image",
        data: {
          url: data.attrs.src,
          caption: data.attrs.alt || "",
        },
      }
    : undefined;
```

# Putting it all together

So now that we know how to transform the HTML into something useful, remove the wrappers, and represent individual HTML sections as content blocks, we can put it all together into something that lets us convert a section of HTML fully:

First, we can update the `removeContainer` function to call the converter on the type of tag that it finds:

```ts
// note that we need a handler for BODY since the `DOMParser` will always add a body element when parsing
const isContainer = (data: TransformResult) =>
  data.tagName === "BODY" ||
  data.tagName === "DIV" ||
  data.tagName === "SECTION";

const removeContainer = (data: TransformResult) =>
  data.children.map((child) => {
    if (isContainer(child)) {
      return removeContainer(child);
    } else {
      if (child.tagName === "IMG") {
        const block = convertImage(child);

        return block ? [block] : [];
      } else if (child.tagName === "P") {
        const block = convertParagraph(child);

        return block ? [block] : [];
      }
    }
  });
```

Now, you can probably see a pattern that's going to arise as we add more and more elements that we want to handle - so it may be better to create a list of handlers for different tag types:

```ts
type Block = ParagraphBlock | ImageBlock

const handlers: Partial<Record<TagName, (data: TransformResult) => Block[]>> = {
  // content blocks
  'IMG': convertImage,
  'P': convertParagraph,

  // container blocks - we will always want to remove these
  'DIV': removeContainer,
  'SECTION': removeContainer,
  'BODY': removeContainer,
}
```

Using the above structure, we can tweak the `convertImage` and `convertParagraph` functions a bit so that they return the `Block[]` consistently:

```ts
const convertParagraph = (data: TransformResult): ParagraphBlock[] =>
  data.textContent
    ? [
        {
          type: "paragraph",
          data: {
            text: data.textContent,
          },
        },
      ]
    : [];

const convertImage = (data: TransformResult): ImageBlock[] =>
  data.attrs.src
    ? [
        {
          type: "image",
          data: {
            url: data.attrs.src,
            caption: data.attrs.alt || "",
          },
        },
      ]
    : [];
```

And we can update the `removeContainer` function to handle things a bit more genericallly:

```ts
const removeContainer = (data: TransformResult): Block[] => {
  const contentArr = data.children.map((child) => {
    const handler = handlers[child.tagName];

    if (!handler) {
      return [];
    }

    return handler(child);
  });

  return contentArr.flat(1);
};
```

If you're really attentive, you'll notice the `contentArr.flat(1)` that was added in the above snippet, this flattens the `Block[][]` into a `Block[]`

Once we've got that, we can define a `convert` function that will take the HTML and output the structured blocks like so:

```ts
const convert = (el: Element): Block[] => {
  const transformed = transform(el);

  const initialHandler = handlers[transformed.tagName];

  if (!initialHandler) {
    throw new Error("No handler found for top-level wrapper");
  }

  return initialHandler(transformed);
};
```

# Adding more content types

That's about it, to handle more specific types of content or other HTML elements is just a matter of following the recipe that we did above:

1. Define if an element is a container or content
2. If it's a container, just use the `removeContainer` handler
3. If it's content then define a handler for the specific kind of content

If you roll this out for loads of elements you'll eventually have a pretty robust converter

# Conclusion

That's it! We've covered the basics for building a transformer like this, and once you have a good feel for how this works, the concepts can be applied to loads of different usecases

If you'd like to see the completed version of my converter, you can take a look at the [`html-editorjs` GitHub repo](https://github.com/nabeelvalley/html-editorjs) and if you'd like to look at it in action in an application then take a look at [Articly](https://articly.vercel.app)
