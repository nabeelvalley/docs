---
published: true
title: Dynamic Angular Components
description: Implementing an Angular Component that is able to render components from a list of selected options
---

As a person who has worked in react something that I've found myself finding very useful is the ability to render components in a generic fashion by using their name to pick a component from a specific list. In React this is relatively straightforward since components are functions and we essentially render them using the function name, behind the scenes JSX will be converted into a function call with the provided props. This enables us to effectively use a strategy pattern for rendering UI

The problem we can run into with trying to do something like this in Angular however is that the module system and the fact that Angular templates are separate from the actual component logic means that we need to be a little creative

For the purpose of this post we'll dive into a short example of a component in Angular that renders a list of components with the assumtion that the components meet a specific class that we define so that other components can inherit from, doing this as a class and not an interface also cleans up the fact that we want the input to be defined as `@Input()` and reduces code written on implementing members

# Base Component

Firstly, we need to define a base component that our other components will extend, this should have any inputs that we would like to share with our implemnted components as well as the dynamic component we will define

```ts
import { Component, Input } from "@angular/core";

@Component({
  selector: "component-base",
  template: "",
})
export class BaseComponent {
  @Input()
  text: string;
}
```

> The template and selector of this component don't really matter as we will never actually render this component

# Implementation Component

Now that we have defined out base, we can define an implementation of this component that renders the `text` in a `div`:

```ts
import { Component } from "@angular/core";
import { BaseComponent } from "./base-component.component";

@Component({
  selector: "component-a",
  template: ` <div>{{ text }}</div> `,
})
export class ComponentA extends BaseComponent {}
```

Furthermore, we can define another component which renders the `text` in an `h1` tag

```ts
import { Component } from "@angular/core";
import { BaseComponent } from "./base-component.component";

@Component({
  selector: "component-b",
  template: ` <h1>{{ text }}</h1> `,
})
export class ComponentB extends BaseComponent {}
```

These are the two components that our `DynamicComponent` will be used to render

# Dynamic Component

Defining the dynamic component requires a few different pieces to come together

1. We need to have some way to resolve a component from some kind of generic input, I am using a simple object for this but any method of doing this will work

```ts
import { ComponentA } from "./a.component";
import { ComponentB } from "./b.component";
import { BaseComponent } from "./base-component.component";

const components = {
  a: ComponentA,
  b: ComponentB,
} as const;

export type ComponentName = keyof typeof components;
```

> I also define a type for `ComponentName` based on the component object I defined, but this is depends on how you plan to resolve the components for your specific implementation

2. Define the target `ViewContainerRef` to use to render the component - the component we render willl be a sibling to this - there isn't a good way to change this behaviour without a bunch of hackery and it's usually not an issue as long as we're aware of how this works

For my example I am just getting the parent Angular node for my component injected using the Angular Constructor Injection

```ts
constructor(private readonly ref: ViewContainerRef) {
  super();
}
```

3. Next, we need to define some way to resolve the component we want to render, I am using an `@Input() component: ComponentName` that will be provided by a consumer of my component and I will resolve the resultant component by accessing it with the object, the relevant lines for reference below:

Component name as input:

```ts
@Input()
component: ComponentName;
```

Resolving the component using the name and list of components:

```ts
const componentType = components[this.icon];
```

4. Lastly we define a method that will actually render the component that is called during the `OnInit` lifecycle method

When rendering the component we use the `this.ref.createComponent` which is a method provided by Angular on a View reference that will allow us to render a component using it's class

```ts
ngOnInit() {
  this.renderComponent();
}

/**
 * Render a component using the component class and name of the configured component
 */
renderComponent() {
  const componentType = components[this.icon];

  const component = this.ref.createComponent<BaseComponent>(componentType);
  component.instance.text = this.text;
}
```

Assembling the above into an Angular component we will have the below:

```ts
import { Component, Input, OnInit, ViewContainerRef } from "@angular/core";
import { ComponentA } from "./a.component";
import { ComponentB } from "./b.component";
import { BaseComponent } from "./base-component.component";

const components = {
  a: ComponentA,
  b: ComponentB,
} as const;

export type ComponentName = keyof typeof components;

/**
 * Renders a dynamic component component based on a list of supported components
 */
@Component({
  selector: "component",
  template: ``,
})
export class DynamicComponent extends BaseComponent implements OnInit {
  /**
   * Name of component to be displayed, `a` or `b` as we currently have it
   */
  @Input()
  component: ComponentName;

  constructor(private readonly ref: ViewContainerRef) {
    super();
  }

  ngOnInit() {
    this.renderComponent();
  }

  /**
   * Render a component using the component class and name of the configured component
   */
  renderComponent() {
    const componentType = components[this.icon];

    const component = this.ref.createComponent<BaseComponent>(componentType);
    component.instance.text = this.text;
  }
}
```
