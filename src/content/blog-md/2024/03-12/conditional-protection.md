---
title: Conditionally Protect Properties in Typescript
description: Using type-guards to protect access to values
subtitle: 03 December 2024
---

# Type Guards

So, type guards are really handy in Typescript as they let us check if something meets a certain requirement before moving along, for example, given the following user type:

```ts
type User = {
  active: boolean;
  name: string;
  age: number;
};
```

We can define a type guard that checks if the user is fully is `active` before allowing certain things. To do this we usually use a type guard, that looks like this:

```ts
type ActiveUser = User & { active: true };

const isActive = (base: Partial<User>): base is ActiveUser =>
  !!(base.active && base.age && base.name);
```

The important thing in a type guard is that it takes something of one type and asserts something about that type, e.g. that it is an `ActiveUser` in the above. This is done by returning a boolean, if it is `true` then the assertion applies, otherwise it does not

And normally, we would use it like so:

```ts
if (isActive(user)) {
    // do stuff that can only be done with an active user
}

// outside of this scope users are not active
```

# Gaurded Class

The above solution is usually good enough. But it's also possible to couple the types of these checks while not providing direct access to the underlying object. This is useful in cases where we may want to restrict access to some functionality unless a certain set of checks pass

To do this, we can encapsulate the value and check into a class, e.g. the `Guarded` class below:

```ts
class Guarded<Unsafe, Safe extends Unsafe> {
  constructor(
    protected readonly value: Unsafe,
    private readonly safe: (value: Unsafe) => value is Safe,
  ) {}

  /**
   * Type guard that grants access to the wrapped `value`
   */
  isSafe(): this is { value: Safe } {
    return this.safe(this.value);
  }
}
```

In the above, we define a `Guarded` class htat has a type of a `Safe` and `Unsafe` value. These generics can be inferred by the arguments provided to `constructor`

Next, we define the `isSafe` method on the class that is a gaurd that says something about `this` which is the instance itself.

So, we can use `Guarded` to wrap something that we want to only make available under certain scenarios:

```ts
const guarded = new Guarded(value, isActive);

if (guarded.isSafe()) {
  console.log('Can access value here', guarded.value);
}

// guarded.value; // error: Property 'value' is protected and only accessible within class 'Guarded<Unsafe, Safe>' and its subclasses.ts(2445)
console.log("Can't access value here");
```

What's great is that this `safe` check is re-run whenever we want to access the `value`, this means that we can make certain properties available based on some other state that can be checked in the `safe` method

Furthermore, the Typescript compiler itself will prevent you from accessing `value` if we determine it is unsafe. This protects us both at a runtime as well as compile time

# Note

The first idea of Type Guards is quite often used and should be good enough for normal use

Withr egards to the `Guarded` idea, use with caution. The idea here it to create a certain safety for consumers of some code, but this is at the expense of complexity and should be used with care. Outside of the "can it be done" discussion I haven't really had much use for something like this since usually a normal type guard is good enough