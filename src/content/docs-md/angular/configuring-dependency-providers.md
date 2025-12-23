---
published: true
title: Configuring Angular Dependency Providers
description: Providing and Customizing Angular Dependencies for Dependency Injection
---

Angular uses dependency injection for managing dependencies between different parts of your application. This works fairly well for your application code as you have full control over your dependencies. A problem comes up however when working with dependencies provided by some 3rd party code that we cannot easily control or manipulate the dependencies of

An example of this is as follows:

I have some service defined in some library code that requires a predefined dependency:

```ts
class LibraryService {
    constructor(dep: PredefinedDependency) { }
}
```

Now, when configuring the library you are told to add `PredefinedDependency` to your Angular providers list, like so:

```ts
providers: [
    // other stuff
    PredefinedDependency
]
```

The `PredefinedDependency` takes some inital configuration but in our application we have a usecase where something about our dependency may need to change at runtime, for example when a user logs in we may want to swap out the credentials used for the dependency. This would be fine if we were using the dependency directly, but since it is used in some library code we can't change it at that level

## Configuring our own Dependency

What we can do instead is provide our own class that extends the one that the library requires:

```ts
@Injectable()
class MyConfigurableDependency(){
    constructor(private dep: PredefinedDependency) {}
}
```

Then, we can provide this to Angular in place of the `PredefinedDependency` type with `useClass`:

```ts
providers: [
    // other stuff
    {
        provide: PredefinedDependency,
        useClass: MyConfigurableDependency
    }
]
```

## Usage

Since we have swapped out our dependency, we can modify the implementation of to do what we want:

```ts
@Injectable()
class MyConfigurableDependency(){
    constructor(private dep: PredefinedDependency) {}

    getDataWithAuth(auth: string){
        // call some internal implementation for our usecase that we may want
        return this.internalStuff({
            auth
        })
    }
}
```

Or we can override the implementation used by the Library completely to work differently depending on some internal state that we can set elsewhere:


```ts
@Injectable({
    // Provide as a singleton since we want to be able to modify the dependency's global state
    providedIn: 'root'
})
class MyConfigurableDependency(){
    useAuth = false

    constructor(private dep: PredefinedDependency) {}

    setAuthState(state: boolean) {
        this.useAuth = state
    }

    getDataWithAuth(auth: string){
        // call some internal implementation for our usecase that we may want
        return this.internalStuff({
            auth
        })
    }

    override getData(){
        if (this.useAuth) {
            return super.getData()
        } else {
            return this.getDataWithAuth()
        }
    }
}
```

... Or something like that depending on what you want to do, but that's just normal OOP and less to do with Angular

## References

- [Depencency Injection Documentation](https://angular.io/guide/dependency-injection-providers)