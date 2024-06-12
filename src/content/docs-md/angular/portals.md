---
title: Rendering Angular Components with Portals
description: Using portals to render content in a different part of the DOM
subtitle: 12 June 2024
published: true
---

When working with web frameworks we are often constrained to rendering content in a specific part of the DOM in which the component we are working on is rendered, and changing this ordering can often be a lot of work. In order to simplify this, most frameworks provide a concept of a Portal that allows us to define some content in one part of our app and render it elsewhere.

For the sake of our example, I would like to be able to write some markup that looks like this:

```html
<portal-content>
  <p>This is some content that is rendered inside a portal</p>

  <button (click)="increment()">Count: {{ count }}</button>

  <blockquote>Angular functionality will work as normal within the portal</blockquote>
</portal-content>
```

And have it render at some other place in the DOM. Since we're using Angular we'll use a `ng-template` to denote where we ouput our content, and we can programatically render stuff into this template with Angular

To create this kind of API we need to define the following:

## Portal Content

A component that defines the content for the portal, we need this so we can directly access its contents and render it elsewhere. This content will need to render content somewhere else in the component tree later on

This component is fairly simple and makes use of a small composition of an `ng-template` and `ng-content` as follows:

```ts
@Component({
  selector: "portal-content",
  standalone: true,
  template: `
    <ng-template #content>
      <ng-content></ng-content>
    </ng-template>
  `,
})
export class PortalContentComponent {
  @ViewChild("content")
  content?: TemplateRef<unknown>;
}
```

This also exposes the contents of the portal via the `content` Template Reference so that it can be accessed by components that will render this

## Portal Renderer

The portal rendering component takes the content defined with the `portal-content` and renders it programatically somewhere - for our example we're using the same component but this can render content elsewhere by passing around the `TemplateRef` we defined above

This component uses the `<ng-template [cdkPortalOutlet]="contentOutput"></ng-template>` to specify the template target. We will then use the `@angular/cdk/portal` module to construct the portal content:

```ts
@Component({
  selector: "portal-root",
  standalone: true,
  imports: [PortalContentComponent, PortalModule],
  template: `
    <portal-content>
      <!-- some content to render goes in here  -->
    </portal-content>

    <hr />

    <!-- the content will instead be rendered here -->
    <ng-template [cdkPortalOutlet]="contentOutput"></ng-template>
  `,
})
export class PortalRootComponent {
  @ViewChild(PortalContentComponent)
  content?: PortalContentComponent;
  contentOutput?: Portal<any>;

  constructor(readonly elem: ElementRef, readonly ref: ViewContainerRef) {}

  showPortalContent() {
    const content = this.content?.content;

    if (content) {
      this.contentOutput = new TemplatePortal(content, this.ref);
    }
  }
}
```

## Complete Code

A complete example using the two concepts demonstrated above can be seen below:

```ts
import { Component, ElementRef, TemplateRef, ViewChild, ViewContainerRef } from "@angular/core";

import { Portal, TemplatePortal, PortalModule } from "@angular/cdk/portal";

@Component({
  selector: "portal-content",
  standalone: true,
  template: `
    <ng-template #content>
      <ng-content></ng-content>
    </ng-template>
  `,
})
export class PortalContentComponent {
  @ViewChild("content")
  content?: TemplateRef<unknown>;
}

@Component({
  selector: "portal-root",
  standalone: true,
  imports: [PortalContentComponent, PortalModule],
  template: `
    <h1>Hello World</h1>

    <p>This is where the portal content is localted in the template:</p>

    <portal-content>
      <p>This is some content that is rendered inside a portal</p>

      <button (click)="increment()">Count: {{ count }}</button>

      <blockquote>Angular functionality will work as normal within the portal</blockquote>
    </portal-content>

    <p>The Portal content will be rendered here in the DOM:</p>

    <ng-template [cdkPortalOutlet]="contentOutput"></ng-template>

    <hr />
    <button (click)="showPortalContent()">Show Portal Content</button>
  `,
})
export class PortalRootComponent {
  count = 0;

  @ViewChild(PortalContentComponent)
  content?: PortalContentComponent;
  contentOutput?: Portal<any>;

  constructor(readonly elem: ElementRef, readonly ref: ViewContainerRef) {}

  showPortalContent() {
    const content = this.content?.content;

    if (content) {
      this.contentOutput = new TemplatePortal(content, this.ref);
    }
  }

  increment() {
    this.count++;
  }
}
```

