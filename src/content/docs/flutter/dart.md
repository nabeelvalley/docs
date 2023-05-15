---
published: true
title: Dart Reference
subtitle: Notes on the Dart language
---

[[toc]]

> Notes from the [The Net Ninja Youtube Series](https://www.youtube.com/watch?v=1ukSR1GRtMU&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ)

To get started with Dart you can use [DartPad](https://dartpad.dev/)

# Hello World

A simple Hello World in dart looks like so:

```dart
void main() {
  print("Hello World");
}
```

In Dart we require semicolons and the entrypoint is the `main` function

# Variables

We declare variables like this:

```dart
int age = 5;
print(age);
```

Some data types are:

- `int`
- `String` which can use a `'` or a `"`
- `bool`
- `dynamic`

We can also define variables as `dynamic` which means that their type can be changed

String interpolation can also be done like so:

```dart
int age = 5;
String name = "John";
String person = "My name is $name and I am $age years old";
```

# Functions

Functions make use of the following structure:

```dart
MyType fName() {
  ...//do stuff

  return thing; //type of MyType
}
```

If a function has a single line we can also make use of an arrow function which looks like this:

```dart
MyType getThing() => thing;
```

A function with inputs is defined and used like so:

```dart
int add(int x, int y) => x + y;
```

And used as you'd expect:

```dart
int result = add(1,3);
```

Functions can also take in optional params, there are two methods for this, named and unnamed params:

```dart
// unnamed
int sumUN(int a, int b, [int c, int d]) => ....

//named
int sumN(int a, int b, {int c, int d}) => ...
```

The way we call these functions differ

````dart
// unnamed
sumUN(1,2)
sumUN(1,2,3)
sumUN(1,2,3,4)

//named
sumN(1,2)
sumN(1,2, {c: 3})
sumN(1,2, {c: 3, d: 4})
```

# Lists

Lists in Dart are defined using the `[]` notation

```dart
List names = ['john', 'jeff', 'johnny'];
````

We can also use list methods to work with the list

```dart
names.add('sally');
names.add(12); // not a string

names.remove('john');
```

The list as defined above does not have a defined type, usually we want to specify the allowable types (coz obviously). We can set the type using the `<T>` notation like so:

```dart
List<String> names = ['john', 'jeff', 'johnny'];
```

We also have methods available for lists such as the `map` function which will return an `IEnumerable`:

```dart
myList.map((el){
  // do stuff
  return el;
})
```

And additionally the `toList` method which will allow us to convert the above back into a list

```dart
myList.map((el){
  // do stuff
  return el;
}).toList()
```

# Classes

Classes are defined using the `class` keyword, with the properties defined within the class. The `new` keyword is not needed

```dart
void main() {
  Person john = Person("John", 3);
  john.greet();

  john.setAge(5);

  print(john.getAge());
}

class Person {
  String name; // public by default
  int _age; // private if starts with _

  Person(String name, int age){
    this.name = name;
    this._age = age;
  }

  void greet() =>
    print("Hello, I am " + name);

  void setAge(int newAge) {
    this._age = newAge;
  }


  int getAge() => this._age;
}
```

> Private properties start with `_` and cannot be accessed from outside the class

We can also initialize class variables like this:

```dart
class Person {
  String name = "Person";
  int _age = 1;
  ...
}
```

We can use inheritance using the `extends` keyword:

```dart
class NotCat {
  bool isCat = false;
  String description = "Not a Kitty";

  NotCat(bool isCat){
    // we don't care
  }
}

class Person extends NotCat {
  String name; // public by default
  int _age; // private if starts with _

  Person(String name, int age): super(false){
    this.name = name;
    this._age = age;
  }
}
```

When using the above we need to be sure to also call the constructor of the base class from the inheriting class using `super`

# Const and Final

A `const` variable is one that's value is constant at compile time, a `final` variable is one that is only assigned to once

In dart we can also define constants using the `const` and `final` keywords like so:

```dart
const int age = 12;
final String name= "John";
final Person myPerson = Person(name, age);
```

You can also create constant instances of objects but that requres a `const` constructor

If we have a class with a constructor but we want to use it as a const constructor, we can do so by using the `final` keyword for our property, and the below notation for the constructor:

```dart
class QuoteCard extends StatelessWidget {

  final Quote quote;
  QuoteCard({this.quote});
  ...
}
```

We can then create an instance of this like so:

```dart
var myCard =  QuoteCard(quote: myQuote)
```

# Maps

Maps are like dictionaries/key-value pairs

To create a map we use the `Map` data type and the `[]` accessor:

```dart
Map person = {
  "name": "Jeff Smith",
  "age": 64
};


print(person["name"])
```

This is used in flutter when doing routing for pages

# Async

Async code is code that finishes some time after being called but is not blocking. We use a combination of `async`, `await`, and `Futures`

## Futures

A function that makes use of a Future that simply does a delay looks like this:

```dart
void getData(){
  Future.delayed(Duration(seconds: 3), (){
    // callback function
    print("Callback activated")
  });
}
```

The callback is run when the future completes. This is similar to `Promise` in JavaScript

We can then call the above function from our `initState` function. A complete example would be something like this:

```dart
class _SelectLocationState extends State<SelectLocation> {
  String name = "FETCHING NAME";

  void getData() {
    Future.delayed(Duration(seconds: 2), () {
      // callback function, will run after 2 seconds
      setState(() {
        name = "Johnny";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: Text("Select Location"),
        elevation: 0,
        backgroundColor: Colors.purple,
      ),
      body: Text(name),
    );
  }
}
```

## Async/Await

Sometimes however we have some asynchronous code that needs to run sequentially we can make use of `async` and `await`

Similar to other languages, `Futures` (promises) can be awaited within an `async` function. If we wanted to make our `getData` function run more sequentially we can do something like this (note we also added `async` to the function definition):

```dart
String name = "FETCHING NAME";
String bio = "FETCHING BIO";

void getData() async {
  String userName = await Future.delayed(Duration(seconds: 2), () {
    // callback function
    return "Johnny";
  });

  String userBio = await Future.delayed(Duration(seconds: 2), () {
    return "$userName's Bio. Here are more things about $userName";
  });

  setState(() {
    name = userName;
    bio = userBio;
  });
}
```

# Exceptions

To handle exceptions in dart we can use a `try-catch`:

```dart
try {
  // do some stuff
} catch(e) {
  // handle the exception
}
```

We can also use an optional `finally`

```dart
try {
  doStuff();
  setState(() {
    hasError = false;
  });
} catch (e) {
  setState(() {
    hasError = true;
  });
} finally {
  setState(() {
    isLoading = false;
  });
}
```

## Cascade operator

Dart has a cascade operator `..` which allows a function to return the instance of the initial object and not the result of a function call:

```dart
void main() {
  var person = Person();

  // normal function call returns result
  print(person.haveBirthday());  // out: 1

  // cascaded function call returns person
  print(person..haveBirthday()); // out: Instance of 'Person'

}

class Person {
  int age = 0;
  int haveBirthday() {
    age ++;
    return age;
  }
}
```

Or from [the documentation](https://dart.dev/guides/language/language-tour):

> "Cascades (..) allow you to make a sequence of operations on the same object. In addition to function calls, you can also access fields on that same object. This often saves you the step of creating a temporary variable and allows you to write more fluid code."

```dart
querySelector('#confirm') // Get an object.
  ..text = 'Confirm' // Use its members.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'));
```

# Conditionals

## If-Else

```dart
if (isCar) {
  print("Car");
} else {
  print("Not Car");
}
```

With multiple conditions:

```dart
int age = 12;

if (age > 35) {
  // do stuff
} else if (age > 20) {
  // do stuff
} else if (age > 10) {
  // do stuff
} else {
  // do stuff
}
```

## Ternary

We can use a ternary operator like so:

```dart
bool isCar = thing == "Car" ? true : false
```

The ternary operator doesn't have to return a boolean, it can pretty much be anything

```dart
String carGoes = thing == "Car" ? "Vroom Vroom" : "Pew Pew Pew"
```
