[[toc]]

> The strategy pattern is about using composition instead of inheritence

The strategy pattern defines a family of algorithms, encapsulates each one, and makes them interchangeable. The algorithm can vary independent of clients using it

> Algorithm/implementation is decoupled from its clients

This works by creating an object which wraps the behaviour we want to implement in a family of classes, allowing clients to choose which behaviour they would like to implement by referencing the interface that these behaviours implement.

# Example

## Definition of Classes

```cs
namespace DesignPatterns.Strategy
{
    public class User {
        // strategy to be used for logging in a user
        // this is what we want to change depending on an implementation
        private ILoginStrategy _loginStrategy { get; set; }

        public string Username { get; set; }
        public string Password { get; set; }

        // we set the behaviour when instantiating
        public User(ILoginStrategy loginStrategy)
        {
            this._loginStrategy = loginStrategy;
        }

        // we can possibly change the strategy later
        public void SetLoginStrategy(ILoginStrategy loginStrategy)
        {
            this._loginStrategy = loginStrategy;
        }

        // login function that can be called by a consumer of this class
        public bool Login() => _loginStrategy.Execute(Username, Password);
    }

    // interface to define login strategies
    public interface ILoginStrategy
    {
        public bool Execute(string username, string password);
    }

    // login strategy for logging in from a local service
    public class LocalLoginStrategy: ILoginStrategy
    {
        public bool Execute(string username, string password) => true;
    }

    // login strategy for logging in from a remote service
    public class RemoteLoginStrategy : ILoginStrategy
    {
        public bool Execute(string username, string password) => false;
    }
}
```

## Usage

```cs
var user = new User(new LocalLoginStrategy()) {
    Username = "user",
    Password = "Password"
};

// calling this uses the LocalLoginStrategy
user.Login();

user.SetLoginStrategy(new RemoteLoginStrategy());

// calling this uses the RemoteLoginStrategy
user.Login();
```

# References

- [Strategy Pattern - Christopher Okhravi](https://www.youtube.com/watch?v=v9ejT8FO-7I&list=PLrhzvIcii6GNjpARdnO4ueTUAVR9eMBpc)
- [Strategy in C# - Refactoring Guru](https://refactoring.guru/design-patterns/strategy/csharp/example#:~:text=Strategy%20is%20a%20behavioral%20design,delegates%20it%20executing%20the%20behavior.)
