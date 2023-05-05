---
title: Un-editable sections inside of a content editable
subtitle: 16 November 2022
description: Block user interactions and editing within a contenteditable or specific parts of it
published: true
---

I was working on an [EditorJS](https://editorjs.io/) plugin and needed to have a way of creating a block that would restrict certain user interactions

Initially, I tried to make use of event listeners to block the undesirable events, but the behavior on mobile was inconsistent and I wanted to avoid the mobile keyboard popping up as well when needed

In addition to the above, I also noticed that even when blocking the events using JavaScript, though the debugger didn't register the event, the user was still able to make changes to the sections being blocked

The solution proved to be fairly simple, though only tested on chrome so it may not be robust.

In my case, what worked was the following:

<style>
.demo-editable {
	padding: 10px;
	background-color: skyblue;
}

.demo-uneditable {
	padding: 10px;
	background-color: salmon;
}
</style>

```html
<div contenteditable="true">
  <div contenteditable="false">
    I should be uneditable, and on mobile won't even trigger a keyboard popup
  </div>
</div>
```

<div class="demo-editable" contenteditable="true">
  <div contenteditable="false">
    I should be uneditable, and on mobile won't even trigger a keyboard popup
  </div>
</div>

Now, more generally, we can have other editable content while still having uneditable sections

```html
<div contenteditable="true">
  I continue to be editable

  <div contenteditable="false">
    But I should be uneditable, and on mobile won't even trigger a keyboard
    popup
  </div>
</div>
```

<div class="demo-editable" contenteditable="true">
  I continue to be editable
  
  <div  class="demo-uneditable" contenteditable="false">
    But I should be uneditable, and on mobile won't even trigger a keyboard popup
  </div>
</div>
