---
published: true
title: Observer
---

The Observer pattern defines a one to many dependency between objects so that when one object changes state, all it's dependencies are notfied of this change

The Observer pattern is used to enable one object to subscribe to some changes of another object. It allows us to move from a `poll` type architecture to a `push` type architecture

This pattern allows a client (observer) to subscribe to messages/changes from a subject (an observarble), provided the observable is made aware of all observers

# Example

A broad idea of the what an observable and observer would contain may look something like this:

```cs
using System.Collections.Generic;

namespace DesignPatterns.Observer
{
    // typical structure of an observable
    public interface IObservable
    {
        public List<IObserver> Observers { get; set; }
        public void Register(IObserver observer);
        public void Unregister(IObserver observer);
        public void Notify();
    }

    // typical structure of an observer
    public interface IObserver
    {
        public void OnNotify();
    }
}
```

## Definition of Classes

An example implementation is seen below:

```cs
using System;
using System.Collections.Generic;

namespace DesignPatterns.Observer
{
    // typical structure of an observable
    public interface IObservable<T>
    {
        // register an object as an observer
        public void Register(T observer);
        //unregister an object as an observer
        public void Unregister(T observer);
        // notify observers
        public void Notify();
    }

    // typical structure of an observer, implement IDisposable for cleanup
    public interface IObserver<T>: IDisposable
    {
        // handle notification event from observable
        public void OnNotify(T observable);
    }

    public class BookingStatus : IObservable<User>
    {
        // keep track of the observer list
        private List<User> _observers = new List<User>();

        // status, we will notify on changes from this
        private string _status;

        public string Status
        {
            get =>_status;
        }

        public void UpdateStatus (string status)
        {
             _status = status;
             // run notification function when change happens
            Notify();
        }

        public void Notify()
        {
            // notify all observers
            _observers.ForEach(o => o.OnNotify(this));
        }

        public void Register(User user)
        {
            if (!_observers.Contains(user))
            {
                _observers.Add(user);
            }
        }

        public void Unregister(User user)
        {
            if (_observers.Contains(user))
            {
                _observers.Remove(user);
            }
        }
    }

    public class User : IObserver<BookingStatus>
    {
        public string Name { get; }
        // store a reference to observable for deregistration
        private BookingStatus _observable { get; set; }

        public User(string name, BookingStatus observable)
        {
            Name = name;
            _observable = observable;
            _observable.Register(this);
        }

        // handle notification
        public void OnNotify(BookingStatus observable)
        {
            Console.WriteLine($"User {Name} Status Update: {observable.Status}");
        }

        public void Dispose()
        {
            // unregister when disposed
            _observable.Unregister(this);
        }
    }
}
```

## Usage

```cs
// instantiate observable
var bookingStatus = new BookingStatus();

// instantiate observers
var user1 = new User("user1", bookingStatus);
var user2 = new User("user2", bookingStatus);

// update status, notify all observers
bookingStatus.UpdateStatus("notification to user1 and user2");

// dispose user1
user1.Dispose();

// this will only notify user1
bookingStatus.UpdateStatus("notification to user1 only");
```

Using this kind of framework, we can have other classes that extend the `IObserver` and by creating and registering these we can have different classes that all react to the `Notify` function calls

> In a real implementation you may want to consider using the C# built-in implementation, this makes use of a lot of additional functionality like correct instance disposing, etc. Information on that can be found [in the docs](https://docs.microsoft.com/en-us/dotnet/standard/events/observer-design-pattern)

Implementations can differ between different languages/frameworks, you can view implementations in different languages [on Refactoring Guru](https://refactoring.guru/design-patterns/observer)

# References

- [Observer Pattern - Christopher Okhravi](https://www.youtube.com/watch?v=_BpmfnqjgzQ&list=PLrhzvIcii6GNjpARdnO4ueTUAVR9eMBpc&index=2) > - [Observer in C# - Refactoring Guru](https://refactoring.guru/design-patterns/observer)
- [Observer Design Pattern - Microsoft Docs](https://docs.microsoft.com/en-us/dotnet/standard/events/observer-design-pattern)
