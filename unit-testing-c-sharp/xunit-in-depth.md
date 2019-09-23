# xUnit in Depth

## Installing xUnit

- From NuGet you can search for `xunit` and `xunit.runner.visualstudio`
- Can add a new `xUnit Test Project` from Visual Studio

## Attributes

- `[Fact]` - A Test with no inputs, can have additional information such as a name and whether or not it should be skipped with: `[Fact(DisplayName = "I am a Test", Skip = "I should be skipped")]`. Skip will cause a specific test to be ignored
- `[Theory` - A Test with some params, defined by `[InlineData(1,2,3)]`
- `[MemberData(nameof(TestData))]` - Allows you to define a method which will map the relevant values to the test params, kind of like InlineData but will get the data in a more dynamic way
- `[ClassData]` - Works like above but will deliver an `IEnumerable` of input items such as above

By default xUnit runs tests in Parallel. All tests in a single class run in Series but accross classes run in Parallel

Additionally you can create a custom collection of tests to run in series with the `[Collection("MySeriesStuff")]`, all classes with the `MySeriesStuff` collection will be run in series

## Testing for Exceptions

When testing for exceptions we can do this using the Arange, Act, Assert method with a class property such as `_customMessage` and then testing if the exception matches that

```cs
Exception ex = Record.Exception(() => ThrowAnError())
Assert.Equal(_customMessage, ex.Message)
```

## Setup and Teardown

We can make use of a `Constructor` and `Dispose` pattern which will be used before and after each test

```cs
public class MyTests : IDisposable
{
    public MyTests()
    {
        // General Setup Stuff
    }

    public void Dispose()
    {
        // General Teardown stuff
    }
}
```

We can also create a class fixture which will run before and after the entire series is done

## Collections

In a test you can use the `ITestOutputHelper` which will write to any standard outputs

```cs
private readonly ITestOutputHelper _output;

public MyTests(ITestOutputHelper output)
{
    _output = output;
}

[Fact]
public void MyTest()
{
    _output.WriteLine("Hello");
}
```
