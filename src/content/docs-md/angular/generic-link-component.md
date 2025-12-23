---
published: true
title: Angular Generic Link Component
description: A link component that simply wraps the HTML anchor component to allow internal and external lnks
---

Often we want to be able to render a link element in Angular which is able to appropriately direct a user to an internal or external website link while taking advantage of the Angular router for internal linking. Below you can see an example of a component that will enable this behaviour

## Component

```ts
import { CommonModule } from '@angular/common';
import { Component, Input } from '@angular/core';
import { RouterModule } from '@angular/router';

export interface LinkProps {
  /**
   * The link to the page to use.
   * If this starts with "." or "/" will be converted to an internal link
   * Otherwise will use an href.
   *
   * > In the case of an external link the fragment will be ignored
   */
  href?: string | null;

  /**
   * Section of page to link to in the case of an internal link
   */
  fragment?: string | null;

  /**
   * Class to be applied to the inner lanchor component.
   *
   * To style the Angular host component use the `class` attribute
   */
  anchorClass?: string | null;

  /**
   * Conditional classes to be applied to the inner anchor component
   *
   * To style the Angular host component use the `ngClass` attribute
   */
  ngAnchorClass?: Record<string, boolean>;
}

@Component({
  selector: 'ui-link',
  standalone: true,
  imports: [RouterModule, CommonModule],
  template: `
    @if (isInternalLink()) {
      <a
        [class]="anchorClass || ''"
        [ngClass]="ngAnchorClass"
        [routerLink]="href"
      >
        <ng-container *ngTemplateOutlet="content"></ng-container>
      </a>
    } @else {
      <a [class]="anchorClass || ''" [ngClass]="ngAnchorClass" [href]="href">
        <ng-container *ngTemplateOutlet="content"></ng-container>
      </a>
    }

    <ng-template #content><ng-content></ng-content></ng-template>
  `,
})


export class LinkComponent implements LinkProps {
  @Input()
  href?: string | null;

  @Input()
  ngAnchorClass?: Record<string, boolean>;

  @Input()
  anchorClass?: string | null;

  @Input()
  fragment?: string | null;

  isInternalLink() {
    return this.href?.startsWith('/') || this.href?.startsWith('.');
  }
}
```

## VSCode/Tailwind Setup

If you're using VSCode with the TailwindCSS extension, you may also be concerned that your new class properties won't be detected, so here's the settings you need for that:

`.vscode/settings.json`

```json
{
  "tailwindCSS.classAttributes": [
    "class",
    "className",
    "ngClass",
    "anchorClass",
    "ngAnchorClass"
  ]
}
```

## References

The basic idea and structure is from [this StackOverflow answer](https://stackoverflow.com/questions/60510530/cannot-use-href-with-routerlink-at-the-same-time-as-conditional-attributes-in-an) which helped to solve the issues with the other ways of attempting this that helps ensure that the component is rendered under all conditions as well as that the href attribute is not removed