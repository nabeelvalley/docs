---
title: Signals Basics
description: Basic overview of Angular Signals
---

> Notes on AngularArchitects Angular Signals Video

# Why Signals

## Change Detection Historical Context

> This section is very hand wavy

Angular makes use of Zone.js to trigger change detection. Changes can come from Handled DOM events or async tasks

Angular goes through the component tree and what values are rendered in the DOM. It checks which class properties from a component and which DOM elements are related and this can lead to some operations in order to figure out what is impacted by a change

Signals solve this problem by creating an internal reactive graph that lives alongside the coponent tree. Signals then inform the application that something has been updated and it can update the DOM based on this

# Using Signals 

## Defining a Signal

In a simple component, we can define a value as a signal using `signal` with an initial value as can be seen below:

```ts
import { Component, signal } from '@angular/core';

@Component({
  selector: 'app-signals',
  standalone: true,
  imports: [],
  template: ``,
})
export class SignalsComponent {
  name = signal('');
}
```

Signals can also take a generic type for defining them as follows:


```ts
name = signal('');
age = signal('');

users = signal<User[]>([]);
```

## Reading and Updating Signals

We can then read a signal by calling it as function, a simple example of this can be seen below:

```ts
import { Component, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';

interface User {
  name: string;
  age: number;
}

@Component({
  selector: 'app-signals',
  standalone: true,
  imports: [FormsModule],
  template: `
    <input [(ngModel)]="name" />
    <input type="number" [(ngModel)]="age"/>
    <button (click)="submit()">Submit</button>

    <ol>
      @for(user of users(); track name) {
        <li>{{user.name}} - {{user.age}}</li>
      }
    </ol>
  `,
})
export class SignalsComponent {
  name = signal('');
  age = signal('');

  users = signal<User[]>([])
  count = signal(0);

  submit() {
    const name = this.name();
    const age = parseInt(this.age());

    const user: User = {
      name,
      age
    };

    const users = [...this.users(), user];
    this.users.set(users);

    this.name.set("");
    this.age.set("");
    this.count.update(count => count + 1);
  }
}
```

Furthermore, we can see above that signals can be updated using the `set` method on the signal

Signals can also be updated using the `update` function that allows us to derive a new value from the current value of a signal, for example how we're doing the `count` signal above

In the example above, we also see that we are reading signals in our template as:

```html
<input [(ngModel)]="name" />
<input type="number" [(ngModel)]="age"/>
<button (click)="submit()">Submit</button>

<ol>
  @for(user of users(); track name) {
    <li>{{user.name}} - {{user.age}}</li>
  }
</ol>
```

In the above example, we're calling `users()` within a template. Templates are in this considered a Reactive Context - this isn't the same as calling it in the `submit` handler above

We can also see that signals can be bound to `[(ngModel)]` as if it's a normal state value. Note that this method works differently if we use a one-way vs two-way binding. If it's a one-way binding we have to read the value

## Computed Signals

Computed signals are a way to get a new signal that's based on some other signal, for example we can update the `count` above to work based on the length of our `users` value:

```ts
users = signal<User[]>([]);
count = computed(() => this.users().length);
```

In the above, `computed` is aware of the signals that are used internally and so it will be updated when the related values are

The `computed` signal cannot be directly written to

## Effects

Another reactive is within the `effect` function. This gives us a reactive context within our class where we can do some stuff

```ts
export class SignalsComponent {
  name = signal('');
  age = signal('');

  users = signal<User[]>([]);
  count = computed(() => this.users().length);

  constructor() {
    effect(() => console.log("The current count is ", this.count()))
  }

  // ...
}
```

> Note that we can only call `effect` within an injection context, such as a `constructor`


It is also possible to call `effect` elsewhere but you have to provide the injector manually via the `options` object

## Signals Lifecycle

A common pitfall is when manipulating a signal within a synchronous context:

```ts
this.mySignal.set(1);
this.mySignal.set(2);
this.mySignal.set(3);
```

If we have associated `effect` with this signal we will only get the last value from this set of changes. This is because signals work to create an optimized DOM update and under a condition like this. This doesn't really make sense from a change detection perspective

Effectively, signals will only be evaluated during change detection. Hence, `computed` and `effect` will only run once even though we have set the value multiple times

This is not the mechanism to use when an `effect` depends on EVERY change to a signal

