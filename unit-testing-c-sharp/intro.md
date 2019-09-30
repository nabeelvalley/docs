# Introduction to Testing

[Past 1](https://www.youtube.com/watch?v=HhRvW1b4IwM)

Unit testing is about testing code to do what it is expected to do

We try to test a specific piece of code without testing everything connected to it, we may have to mock specific elements such as when a test would require database or API call

In test-driven development we start off by defining the test and thereafter work out our actual code

## Installing Prereqs

Create a new Console App and add the following packages from Nuget:

- `xunit`
- `xunit.runner.visualstudio`

> You will also need to enter the following into your `.csproj` file so that the tests, or if you get the `CS0017 Program has more than one entry point defined. Compile with /main to specify the type that contains the entry point.` error:

```xml
<PropertyGroup>
    ...
    <GenerateProgramFile>false</GenerateProgramFile>
</PropertyGroup>
```

## Writing a Test

When we are talking about unit tests we make use of the following three stages:

1. Arrange - Set up the necessary parts for out test
2. Act - Executing the code under tests, we try to only have one of these
3. Assert - Make sure that what happened did happen

We can define a testing class named `UnitTest1` that will test a `Calculator` class before defining the calculator's implementation by defining a test to add two numbers, and having define a `Calculator.Add` method which will take in two numbers and add them

```cs
using Xunit;

namespace UnitTestingXUnit
{
    public class Tests
    {
        [Fact]
        public void Should_Add_Two_Numbers()
        {
            // Arrange
            int num1 = 5;
            int num2 = 10;
            // system-under-test
            var sut = new Calculator();

            // Act
            var result = sut.Add(num1, num2);

            //Assert
            Assert.Equal(15, result);
        }
    }
}
```

In the above code, a `[Fact]` is used for a normal test that does not take in any inputs

We can use Visual Studio to generate the `Calculator` class and placeholder `Add` methods, or create a `Calculator.cs` file with the following:

```cs
using System;

namespace UnitTestingXUnit
{
    internal class Calculator
    {
        public Calculator()
        {
        }

        public int Add(int num1, int num2)
        {
            throw new NotImplementedException();
        }
    }
}
```

At this point the test will trow a `NotImplementedException` if it is run, our next step is to write the minimum necessary code to make the test pass, that would be the following:

```cs
public int Add(int num1, int num2)
{
    return 15;
}
```

That method would result in a test that passes, at this point we have not really done anything practical but we have flushed out the basics of this API, this is just to ensure that we have the API defined correctly, this is essentially a spec for our code

In this specific case the implementation would be obvious, however it may not always be an obvious operation

Realistically the implementation of this function would be:

```cs
public int Add(int num1, int num2)
{
    return num1 + num2;
}
```

We can do the same thing for a division test

```cs
[Fact]
public void Should_Divide_Two_Numbers()
{
    // Arrange
    int num = 5;
    int divisor = 10;
    // system-under-test
    var sut = new Calculator();

    // Act
    var result = sut.Divide(num, divisor);

    //Assert
    Assert.Equal(0.5, result);
}
```

And then the division code with:

```cs
public int Divide(int num, int divisor)
{
    return num / divisor;
}
```

You can then view the `Test Explorer` from the Top Menu `Tests > Test Explorer`

In the Test Explorer you can run the tests by right clicking on the `Tests` group

> If when trying to run the Tests for a Console App you get a `` error, you will need to add the following to your `<PropertyGroup>` section on your `.csproj` file

```xml
<GenerateProgramFile>false</GenerateProgramFile>
```

Thereafter, you should be able to run the tests, you will notice that the `Should_Divide_Two_Numbers` test will fail, clicking on that test will show you the following output:

```
 Source: Tests.cs line: 24
   Duration: 11 ms

  Message:
    Assert.Equal() Failure
    Expected: 0.5
    Actual:   0
  Stack Trace:
    at Tests.Should_Divide_Two_Numbers() in Tests.cs line: 36
```

You can also run the test with the `dotnet test` command from the application directory, which will yield something like the following output

```
[xUnit.net 00:00:02.56]     UnitTestingXUnit.Tests.Should_Divide_Two_Numbers [FAIL]
Failed   UnitTestingXUnit.Tests.Should_Divide_Two_Numbers
Error Message:
 Assert.Equal() Failure
Expected: 0.5
Actual:   0
Stack Trace:
   at UnitTestingXUnit.Tests.Should_Divide_Two_Numbers() in C:\Repos\UnitTestingXUnit\Tests.cs:line 36

Total tests: 2. Passed: 1. Failed: 1. Skipped: 0.
Test Run Failed.
Test execution time: 3.9877 Seconds
```

From this we can see that the test yielded an actual output of `0` but expected `0.5`, this is because the function returns an `int` and makes use of integer division

If we instead coerce the `divisor` to a `double` and change our function to return that, like below, the tests will pass

```cs
public double Divide(int num, int divisor)
{
    return num / (double) divisor;
}
```

A `[Theory]` is a test which takes in different params and will allow us to parametrize a test, such as the following `Add` test with the `[InlineData]` set:

```cs
[Theory]
[InlineData(5, 10, 15)]
public void Should_Add_Two_Numbers(int num1, int num2, int expected)
{
    // system-under-test
    var sut = new Calculator();

    // Act
    var result = sut.Add(num1, num2);

    //Assert
    Assert.Equal(expected, result);
}
```

We can make use of different possible input combinations and this can drive the way we develop the API, such as using an input set of `(null, 10, 15)` which means we need to update the API to do something like make use of nullable ints

We can also handle the case where we want our code to throw an exception such as when an argument is null and we can test for this by combining the `act` and `assert` portions

```cs
[Theory]
[InlineData(null, 10)]
[InlineData(10, null)]
[InlineData(null, null)]
public void Should_Not_Add_Nulls(int? num1, int? num2)
{
    // system-under-test
    var sut = new Calculator();

    //Assert
    Assert.Throws<ArgumentNullException>(() => sut.Add(num1, num2));
}
```

Which is a new case that we will need to handle, which we can do as follows:

```cs
public int Add(int? num1, int? num2)
{
    if (!num1.HasValue || !num2.HasValue)
    {
        throw new ArgumentNullException();
    }

    return num1.Value + num2.Value;
}
```

## Summary

When doing TDD with `Xunit` we usually define our test cases and scenarios and then go about writing the code that will satisfy those tests. We can use tests which have no params labelled with the `[Facts]` annotation, and `[Theory]` which allows us to provide parameters such as `[InlineData(1,5,6)]`

Additionally tests can be run using the Visual Studio Test Runner or the `dotnet test` command

The code that defines our tests, and satisfies them is in the `Tests.cs` and `Calculator.cs` files respectively:

`Tests.cs`

```cs
using System;
using Xunit;

namespace UnitTestingXUnit
{
    public class Tests
    {
        [Theory]
        [InlineData(5, 10, 15)]
        public void Should_Add_Two_Numbers(int num1, int num2, int expected)
        {
            // system-under-test
            var sut = new Calculator();

            // Act
            var result = sut.Add(num1, num2);

            //Assert
            Assert.Equal(expected, result);
        }

        [Theory]
        [InlineData(null, 10)]
        public void Should_Not_Add_Nulls(int? num1, int? num2)
        {
            // system-under-test
            var sut = new Calculator();

            //Assert
            Assert.Throws<ArgumentNullException>(() => sut.Add(num1, num2));
        }

        [Fact]
        public void Should_Divide_Two_Numbers()
        {
            // Arrange
            int num = 5;
            int divisor = 10;
            // system-under-test
            var sut = new Calculator();

            // Act
            var result = sut.Divide(num, divisor);

            //Assert
            Assert.Equal(0.5, result);
        }
    }
}
```

`Calculator.cs`

```cs
using System;

namespace UnitTestingXUnit
{
    public class Calculator
    {
        public Calculator(){ }

        public int Add(int? num1, int? num2)
        {
            if (!num1.HasValue || !num2.HasValue)
            {
                throw new ArgumentNullException();
            }

            return num1.Value + num2.Value;
        }

        public double Divide(int num, int divisor)
        {
            return num / (double) divisor;
        }
    }
}
```
