> "Decorator is a structural design pattern that lets you attach new behaviors to objects by placing these objects inside special wrapper objects that contain the behaviors"

The decorator pattern is about changing the behaviour of a method at runtime instead of compile time. This allows us to modify functionality of a class without modifying the class contents

To do this we wrap the _component_ object in a _decorator_ object

A decorator has the exact same interface/abstract class as the _component_ object (the component) therefore making it exchangable with the _component_ object

> "The decorator pattern attaches additional responsibilities to an object dynamically (at runtime). Decorators provide a flexible alternative to subclassing, allows the use of composition to share behaviour"

The _decorator_ inherits from the _component_ and also has a property of type _component_

The functioning of the decorator pattern makes use of recursion

# Example

We could implement a multi-factor authentication type model by using the decorator pattern using something like the following:

## Base Classes

Before we can create our concrete implementations we need to establish the base classes for our Logins and Decorators to work from, we can simply create two classes in which our `AbstractLogin` is the main root, and our `LoginDecorator` inherits from `AbstractLogin`


```cs
// base class for concrete component classes and base decorator
public abstract class AbstractLogin
{
    public abstract bool Login();
}

// base class for concrete decorator classes
public abstract class LoginDecorator : AbstractLogin
{
    public abstract AbstractLogin InnerLogin { get; }
}
```

## Login Implementation

We can implement our login as any class that inherits from the `Login` and carries out a login functionality, like so:

```cs
// implementation of a user type that can login
public class LocalUser : AbstractLogin
{
    // handles the login of the local user using a normal process
    public override bool Login()
    {
        System.Console.WriteLine("User Login");
        return true;
    }
}
```

## Decorator Implementation

Lastly, we need to implement decorators such that each decorator will make some reference/call to the inner `AbstractLogin` in order to carry out the login behaviour and extend on it's behaviour

```cs
// decorates an AbstractLogin
// enables a second layer of authentication around the InnerLogin
public class EmailPinLoginDecorator : LoginDecorator
{
    // store instance of inner AbstractLogin
    // to verify before outer login can be done
    public override AbstractLogin InnerLogin { get; }

    public EmailPinLoginDecorator(AbstractLogin innerLogin)
    {
        InnerLogin = innerLogin;
    }


    // handle login by first making call to InnerLogin's process
    public override bool Login()
    {
        System.Console.WriteLine("Email Pin Verification process");

        var innerLoginResult = InnerLogin.Login();

        if (innerLoginResult)
        {
            System.Console.WriteLine("Inner login successful");
            return true;
        }
        else
        {
            return false;
        }
    }
}
```

Since decorators can be wrapped arbitrarily we can add another decorator which is pretty much exactly the same as above:

```cs
// basically implemented in the same way as the EmailPinLoginDecorator
public class SMSPinLoginDecorator : LoginDecorator
{
    public override AbstractLogin InnerLogin { get; }

    public SMSPinLoginDecorator(AbstractLogin innerLogin)
    {
        InnerLogin = innerLogin;
    }

    public override bool Login()
    {
        System.Console.WriteLine("SMS Pin Verification process");

        var innerLoginResult = InnerLogin.Login();

        if (innerLoginResult)
        {
            System.Console.WriteLine("Inner login successful");
            return true;
        }
        else
        {
            return false;
        }
    }
}
```

## Using the Decorator Pattern

Given the way we've configured our decorator each one takes an instance of `AbstractLogin` in the constructor, this could be initialized in any method but this one is straightforward to use

We want to create an instance of the `LocalUser` which has the ability to implement some kind of multi factor auth that needs both a successful email and SMS pin to be verified.

Implementing the decorator pattern with just the `EmailPinLoginDecorator` would look like so:

```cs
// create initial user
var user = new LocalUser();

// decorate user with necessary login wrappers
var withEmailAuth = new EmailPinLoginDecorator(user);

// execute the login correctly reaching each level
var loginResult = withEmailAuth.Login();
```

Implementing this using the above classes looks like this:

```cs
// create initial user
var user = new LocalUser();

// decorate user with necessary login wrappers
var withEmailAuth = new EmailPinLoginDecorator(user);
var withSMSAndEmailAuth = new SMSPinLoginDecorator(withEmailAuth);

// execute the login correctly reaching each level
var loginResult = withSMSAndEmailAuth.Login();
```

Based on the way the decorator pattern works we could even make things more complicated by requiring more layers of decorators or can simplify the implementation by removing decorators as you can see above

The way the pattern works means there's no limit to how many layers you are able to decorate with and allows for very complex implementation and abstraction when using this kind of pattern

# References

- [Decorator Pattern - Christopher Okhravi](https://www.youtube.com/watch?v=GCraGHx6gso&t=830s)
- [Decorator Pattern - Refactoring Guru](https://refactoring.guru/design-patterns/decorator)