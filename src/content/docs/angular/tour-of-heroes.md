---
published: true
title: Tutorial - Tour of Heroes
subtitle: Introduction to Angular Basics
description: Angular Tour of Heroes tutorial notes
---

## Setup

## Angular CLI

Before you can start developing angular applications you need to install the Angular CLI:

```sh
yarn global add @angular/cli
```

To view the CLI functionality you can use:

```sh
ng help
```

## App Initialization

Create a new app with:

```sh
ng new my-app-name
```

And then start the app with:

```sh
cd my-app-name
yarn start
```

You can then open the application on [localhost:4200](http://localhost:4200)

## The App

## Starter Files

The Angular applcation that's generated will be found in the `src` directory with end-to-end tests in the `e2e` directory

Angular applications are made of different components, the `app` directory contains the `app` component which is the main shell of the angular application and consists of the following:

1. `app.component.ts` - class
2. `app.component.html` - template
3. `app.component.css` - styles

The _class_ file contains a property in the class for the `title` property:

`app.component.ts`

```ts
title = 'Tour of Heroes'
```

Which we can then rendered in the _template_ by replacing its contents with:

```html
<h1>{{title}}</h1>
```

> The above makes use of the `{{title}}` notation to render the value of the class' `title` property

Additionally, the `styles.css` file contains global styles which will apply to every component

### Components

To generate a new component you can use the `ng generate component` command:

```sh
ng generate component
```

Which will then ask you for a component name. Once the generation is complete it will generate the class, template, and style files for the component as well as add it to the `app.module.ts` file

The command will also generate a `selector` property to refer to the component in CSS for the `@Component` decorator function, this also matches the name to be used for the component's html template from other components

The `ngOnInit` lifecycle hook is also added, this is what's used to run any initialization logic and is run after the component is created by Angular

The generated `class` looks like this:

`heroes.component.ts`

```ts
import { Component, OnInit } from '@angular/core'

@Component({
  selector: 'app-heroes',
  templateUrl: './heroes.component.html',
  styleUrls: ['./heroes.component.css'],
})
export class HeroesComponent implements OnInit {
  constructor() {}

  ngOnInit(): void {}
}
```

We can then use this from the `app` component like so:

`app.component.html`

```html
<h1>{{title}}</h1>
<app-heroes></app-heroes>
```

### Interfaces

You can generate an interface with:

```sh
ng generate interface
```

And then inputting the interface name will generate the interface. Thereafter you can just add properties to the interface as you normally would:

`app/hero.ts`

```ts
export interface Hero {
  id: number
  name: string
}
```

You can then refer to it in the `class` like so:

```ts
hero: Hero = {
  id: 1,
  name: 'Jeff',
}
```

And in a `template` like so:

```ts
<div><span>id: </span>{{hero.id}}</div>
<div><span>name: </span>{{hero.name}}</div>
```

### Modules

The `Modules` are how Angular understands how an application fits together and this allows us to provide some metadata about how an Angular app fits together and what dependencies it has. The top-level `AppModule` is decorated with `NgModule`

Furthermode, we can opt-in to other modules from the module file. For example, we can use the `FormsModule` as follows:

`app.module.ts`

```ts
import { FormsModule } from '@angular/forms';

// ...

imports: [
  BrowserModule,
  FormsModule,
],
```

We can the use the FormModule for two-way data binding using an input in the `heroes.component.html` file:

`heroes.component.html`

```html
<div>
  <label
    >name:
    <input [(ngModel)]="hero.name" placeholder="name" />
  </label>
</div>
```

Which binds the `hero.name` property between the `template` and `class` so that changes on one will reflect on the other. So updating the data in the `input` will update our class state as well as any other template references

### Bindings

#### Loops

To render a list of elements you can use `*ngFor`. So to render a list of heroes you can do the following:

`heroes.component.html`

```html
<li *ngFor="let hero of heroes">
  <span class="badge">{{hero.id}}</span> {{hero.name}}
</li>
```

#### Events

You can bind to click events using the `click` binding with an expression to evaluate on click

`heroes.component.html`

```html
<li *ngFor="let hero of heroes" (click)="onSelect(hero)">
  <span class="badge">{{hero.id}}</span> {{hero.name}}
</li>
```

And then implementing a handler in the template:

`heroes.component.ts`

```ts
  onSelect(hero: Hero) {
    this.selectedHerp = hero
  }
```

#### Conditionals

You can make use of conditionals with the `*ngIf` to selectively render a part of the template
