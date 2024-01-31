---
published: true
title: Synchronize external state with Angular
description: Using NgZone to synchronize state from external libraries with Angular
---

> Note, the information covered here should rarely be needed (if ever) in a project, you likely want to try one of the more general Angular state mechanisms before using this

Sometimes when working with Angular and integrating with an external library you may notice that certain events from the external library are not synchronized appropriately with Angular - take the following example:

I have a library that handles data caching called `MyCache`. On initalization, `MyCache` needs to execute some asynchronous setup after which we need to refresh some data on a component.

My code currently isn't correctly displaying the new data when my synchronization is complete

A simple example of this is as follows:

```ts
// imports

@Component(/* setup */)
class MyComponent {
    constructor(){
        MyCache.init().onComplete(() => this.onComplete())
    }

    onComplete(){
        // the changes from this function are not correctly detected by Angular
    }
}
```

A reason for an issue as described above may be due to the fact that the initialization of our library happens outside of Angular's state management. 

The simplest approach we can use to solving this issue us by mangully calling Angular's change detection:

```ts
import { ChangeDetectorRef } from '@angular/core'

// imports

@Component(/* setup */)
class MyComponent {
    constructor(changeDetector: ChangeDetectorRef){
        MyCache.init().onComplete(() => {
            this.onComplete()

            // call `changeDetector.detectChanges` to manually run Angular Change Dectectino
            changeDetector.detectChanges()
        })
    }

    onComplete(){
        // the changes from this function will be detected when this function completes
    }
}

```

While the above method should work generally, I've also had some issues when working with complex asynchronous state where we do not know when a given task will complete. In order to solve this, we can use `NgZone` which provides a `run` method that can be used to tell Angular that some callback will change some internal state that Angular will need to react to

We can update our code to use `NgZone` by having Angular inject the `zone` into our component, we can then use this to inform Angular of the change when we handle it:

```ts
import { NgZone } from '@angular/core'
// other imports

@Component(/* setup */)
class MyComponent {
    constructor(zone: NgZone){
        MyCache.init().onComplete(() => 
            // Using `zone.run` to handle while informing Angular 
            zone.run(() => this.onComplete())
        )
    }

    onComplete(){
        // the changes done here should now be correctly detected and reflected in the rest of our application
    }
}
```

> NgZone also provides another method for opting out of the Angular change detection called `runOutsideAngular` which can be useful for doing work where we don't need to inform Angular of changes and can be of a performance benefit in some cases

# References

- [ChangeDetectorRef Documentation](https://angular.io/api/core/ChangeDetectorRef) 
- [NgZone Documentation](https://angular.io/api/core/NgZone)