---
published: true
title: Flutter Reference
subtitle: Notes on the Flutter framework
---

[[toc]]

> Notes from the [The Net Ninja Youtube Series](https://www.youtube.com/watch?v=1ukSR1GRtMU&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ)

# What is it

Flutter is a way to build native, cross-platoform applications using the `dart` language

- Easy to build respoonsive applications
- Smooth and responsive applications
- Material design and iOS Cupertino pre-implemented

# Install Flutter

[Documentation](https://flutter.dev/docs/get-started/install/windows?gclid=Cj0KCQjwzN71BRCOARIsAF8pjfhZOA-znjAzldU6xu_LNnlgYa6Cio_Jb17P8Uuq4UcKCQlk0ycePb0aAqLoEALw_wcB&gclsrc=aw.ds)

To install Flutter you need to:

- Download the [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Extract into your 'C:\flutter' directory. Any directory that does not require elevated permissions should work
- Add the `flutter\bin` directory to your System `PATH` (possibly also User Path, I had some issues with the VSCode Extension so maybe both?)
- Close and reopen any Powershell Windows

You should then be able to run the `flutter doctor` command to verify the installation, you may see something like this:

```
[√] Flutter (Channel stable, v1.17.0, on Microsoft Windows [Version 10.0.18363.778], locale en-US)
[X] Android toolchain - develop for Android devices
    X Unable to locate Android SDK.
      Install Android Studio from: https://developer.android.com/studio/index.html
      On first launch it will assist you in installing the Android SDK components.
      (or visit https://flutter.dev/docs/get-started/install/windows#android-setup for detailed instructions).
      If the Android SDK has been installed to a custom location, set ANDROID_SDK_ROOT to that location.
      You may also want to add it to your PATH environment variable.

[!] Android Studio (not installed)
[!] VS Code (version 1.45.0)
    X Flutter extension not installed; install from
      https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
[!] Connected device
    ! No devices available
```

You can address any of the issus that flutter identified during the previous

# Setting Things Up

## General Setup

> Install the Flutter SDK as described above

1. You will need to install Android Studio (so that you have an android debugger)
2. Once installed, on the Android Studio start screen (bottom right) click on `configure > AVD Manager > Create Virtual Device` and then download the `Pie` system image and once that's done select it
3. Set a name for your virtual device (you can leave this as is)
4. Click Finish and the virtual device will be created

## Android Studio

Next, install the following plugins:

1. `configure > Plugins > Marketplace` and search for `Flutter`
2. Install the `Flutter` plugin and ask if it should install the `Dart` plugin as well
3. Restart Android Studio, you should now have a `Start a new Flutter project` option on the start menu

## VSCode

- Install the Flutter and Dart Extensions
-

# Create an Application

The most straightforward way to create a new flutter application is to use the `flutter cli`. To create an app like this simply run:

```
flutter create YourAppName
```

Which will create a directory with the name of your app containing the necessary application files

You can then open the project with VSCode or Android studio

We will need to launch an emulator before we can start the application, to view all available emulators run:

```
flutter emulator
```

To create an emulator you can use:

```
flutter emulator --create --name MyEmulatorName
```

If we've created an emulator called `FlutterCLIEmulator` we should see something like this when we run `flutter emulator`

```
> flutter emulator
2 available emulators:

FlutterCLIEmulator • FlutterCLIEmulator • Google • android
Pixel_2_API_28     • Pixel 2 API 28     • Google • android
```

To launch the emulator we previously installed from your terminal you can run:

```
flutter emulator --launch MyEmulatorName
```

The emulator will remain active so long as the terminal is open. Closing the window will close the emulator

> Note that to delete emulators you will need to use the `AVD Manager` from Android studio

Now that your emulator is running you can use the following to start the application

```
flutter run
```

> Flutter is also able to connect to a device for remote debugging if one is connected to your computer (instead of an emulator)

Once flutter is running the applciation we can see menu which allows us to use keys to control some stuff:

```
Flutter run key commands.
r Hot reload.
R Hot restart.
h Repeat this help message.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).
s Save a screenshot to flutter.png.
...
```

# The App

## Basic App

The entrypoint for our application is the `lib/main.dart` in which we can see the `main` function for our app. We also have an `ios` and `android` directory for any platform specific code and a `test` folder for writing unit tests

> For now delete the `test` directory otherwise you're going to get errors when your tests start failing

Overall our application is made of `Widgets`, a Widget in flutter is simply a Class that renders something

The start portion of our application looks like this:

`main.dart`

```dart
void main() {
  runApp(MyApp());
}
```

`MyApp` is a class which extends `StatelessWidget` which is our root for the application

For the sake of simplicity we'll replace all of the code in the `main.dart` file with the following which will simply display the text `Hello World` on the sreen. We are also using the `MaterialApp` which will use the material design for the app:

`main.dart`

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Text("Hello World"),
  ));
}
```

> To ensure that the reload happens fully use `R` and not `r`

## Laying Things Out

We'll use a `Scaffold` to allow us to lay out a whole bunch of things, and inside of this we can use the different parts of the layout with some stuff in it:

`main.dart`

```dart
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("My App"),
        centerTitle: true,
      ),
      body: Center(child: Text('Hello World')),
      floatingActionButton: FloatingActionButton(
        child: Text("CLICK"),
      ),
    ),
  ));
}
```

## Styling

Using the method above we can add a lot more layout elements to our application layout. We can also make use of fonts. To do so just add the `.tff` files into a folder in our project. For our purpose we'll just add the font files to the `assets/fonts` directory

Next, we add the fonts to our `pubspec.yml` file in the `fonts` property (this is already in the file but is just commmented out)

`pubspec.yml`

```yml
...
flutter:
  uses-material-design: true
  fonts:
    - family: DMMono
    fonts:
      - asset: assets/fonts/DMMono-Regular.ttf
      - asset: assets/fonts/DMMono-Italic.ttf
        style: italic
      - asset: assets/fonts/DMMono-Light.ttf
        weight: 300
      - asset: assets/fonts/DMMono-LightItalic.ttf
        weight: 300
        style: italic
      - asset: assets/fonts/DMMono-Medium.ttf
        weight: 500
      - asset: assets/fonts/DMMono-MediumItalic.ttf
        style: italic
        weight: 500
```

Ensure that the spacing in your `yml` file is correct otherwise this will not work as you expect

Our app with the styles and fonts now applied looks like this:

```dart
import 'package:flutter/material.dart';

void main() {
  const String fontFamily = 'DMMono';
  Color themeColor = Colors.blue[600];

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: fontFamily),
    home: Scaffold(
      appBar: AppBar(
        title: Text(
          "My App",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 2,
            color: Colors.grey[200],
          ),
        ),
        centerTitle: true,
        backgroundColor: themeColor,
      ),
      body: Center(child: Text('Hello World')),
      floatingActionButton: FloatingActionButton(
        child: Text("CLICK"),
        onPressed: () => print("I was pressed"),
        backgroundColor: themeColor,
      ),
    ),
  ));
}
```

## Stateless Widget

A stateless widget is a widget that's data does not change over the course of the widget's lifetime. These can contain data but the data cannot change over time

The following snippet creates a basic Stateless Widget:

```dart
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

One of the benefits of creating custom widgets is that we are able to re use certain components. In this widget we need to return a `Widget` from the `build` function. We can simply move our application's `Scaffold` as the return of this widget

We can also have data for a stateless widget but this will be data that does not change. We can define a widget like this:

```dart
class QuoteCard extends StatelessWidget {
  final Quote quote;
  final String label;

  QuoteCard({this.quote, this.label});

  ...//widget implementation
}
```

The use of `final` says that this property will not be reassigned after the first assignment

> To setup automatic hot reloading we need to make use of a `StatelessWidget` which is a widget that can be hot reloaded, this only works when running the application in `Debug` mode via an IDE and not from the terminal. For VSCode this can be done with the Flutter Extensions and same for Android Studio

Our component now looks something like this:

```dart
import 'package:flutter/material.dart';

void main() {
  const String fontFamily = 'DMMono';

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: fontFamily),
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color themeColor = Colors.blue[600];

    return Scaffold(
      appBar: AppBar(
       ...
      ),
      body: Center(child: Text('Hello World')),
      floatingActionButton: FloatingActionButton(
        ...
      ),
    );
  }
}
```

## Images

We can use either Network Images or Local Images. To use an image we use the `Image` widget with a `NetworkImage` widget as the `image` property, an example of the NetworkImage would look like so:

```dart
...
body: Center(
    child: Image(
      image: NetworkImage(
      "https://media.giphy.com/media/nDSlfqf0gn5g4/giphy.gif"
    ),
  )
),
...
```

If we want to use a locally stored image we need to do a few more things

1. Download the image and save in the `assets/images` folder
2. Update the `pubspec.yml` file to contain the asset listing:

```yml
flutter:
  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/images/NerdBob.gif
```

We can alternatively just declare the folder so that we can include all images in a folder:

```yml
flutter:
  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/images/
```

1. And we'll still be able to use the image the same way. To use the images use an `AssetImage` like this:

```dart
...
body: Center(
  child: Image(
    image: AssetImage("assets/images/NerdBob.gif"),
  ),
),
...
```

Because using images like this is a common task, flutter also provides us with the following two methods:

1. Using `Image.network`

```dart
body: Center(
  child: Image.network(
      "https://media.giphy.com/media/nDSlfqf0gn5g4/giphy.gif"
    ),
),
```

2. Using `Image.asset`

```dart
body: Center(
  child: Image.asset("assets/images/NerdBob.gif"),
),
```

> The above methods are pretty much just shorthands for the initial methods

## Icons

An Icon Widget looks like this:

```dart
 Icon(
  Icons.airplanemode_active,
  color: Colors.lightBlue[500],
)
```

And a Button looks like this

```dart
RaisedButton(
  onPressed: () => {},
  child: Text("IT'S GO TIME")
)
```

> There are of course more options for both of these but those are the basics

We can also make use of an RaisedButton with an Icon which works like so

```dart
RaisedButton.icon(
  color: Colors.red,
  textColor: Colors.white,
  onPressed: () => {print("We Gone")},
  icon: Icon(Icons.airplanemode_active),
  label: Text("IT'S GO TIME")
)
```

Or an IconButton:

```dart
IconButton(
  color: Colors.red,
  onPressed: () => {print("We Gone")},
  icon: Icon(Icons.airplanemode_active),
)
```

## Containers

Container Widgets are general containers. When we don't have anything in them they will fill the available space, when they do have children they will take up the space that the children take up.

Containers also allow us to add padding and margin to it's children

- Padding is controlled using `EdgeInsets`
- Margin is controlled using `EdgeInsets`

```dart
body: Container(
  color: Colors.grey[800],
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.all(20),
  child: Text(
    "Hello World",
    style: TextStyle(color: Colors.white),
  ),
),
```

If we don't need the colour and margin properties and only want padding, we can use a `Paddint` widget

```dart
body: Padding(
  padding: EdgeInsets.all(20),
  child: Text(
    "Hello World",
    style: TextStyle(color: Colors.white),
  ),
),
```

## Layouts

We have a few Widgets we can use to make layouts, some of these are:

The `Row` Widget which can have children as an array of Widgets:

```dart
body: Row(
  children: <Widget>[
    Text("Hello World"),
    RaisedButton(
      onPressed: () {},
      child: Text("I AM BUTTON"),
    ),
    RaisedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.alarm),
        label: Text("Wake Up")
    ),
  ]
),
```

Out layout widgets also have the concept of a `main` and `cross` axis and we can control the layout along these axes. This works almost like FlexBox:

```dart
body: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.center,
  ....
)
```

We can do the same with a `Column` layout:

```dart
body: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text("Hello World"),
      RaisedButton(
        onPressed: () {},
        child: Text("I AM BUTTON"),
      ),
      RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.alarm),
          label: Text("Wake Up")
      ),
    ]
),
```

## Refactor Menus

You can click on a widget and then click on the light bulb/refactor button, or the Flutter Overview Panel (VSCode or Android Studio) and that will allow you to do some things like:

1. Move widgets around
2. Add or remove wrapper Widgets
3. Extract widget to function/new widget

## Expanded Widgets

Expanded widgets allow us to make a Widget use up all the extra available space, this is a bit like setting a Flex grow value for a widget

This is a Wrapper widget that we can use to make a child expand into the available space in its main-axis like so:

```dart
Expanded(
  child: Container(
    padding: EdgeInsets.all(30),
    color: Colors.cyan,
    child: Text("1"),
  ),
),
```

We can also set a `flex` value which defines the portion of space we want a Widget to use

```dart
body: Row(
  children: <Widget>[
    Expanded(
      flex: 2,
      child: MyWidget(),
    ),
    Expanded(
      flex: 1,
      child: MyWidget(),
    ),
    Expanded(
      flex: 0,
      child: MyWidget(),
    ),
  ],
),
```

These are also useful for containing an image, for example:

```dart
body: Row(
  children: <Widget>[
    Expanded(
      flex: 2,
      child: Image.asset("assets/images/NerdBob.gif")
    ),
    Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(30),
        color: Colors.cyan,
        child: Text("Hello"),
      ),
    ),
  ],
),
```

## Sized Box Widget

The Sized Box widget allows us to simply add a spacer, we can set the height and width

```dart
SizedBox(
  height: 10,
  width: 20,
),
```

The `height` and `width` properties are both optional

## CircleAvatar Widget

Flutter also provides a widget for rendering circle shaped avatars:

```dart
CircleAvatar(
  backgroundImage: AssetImage("assets/Avatar.gif"),
  radius: 80,
),
```

## Center Widget

A `Center` Widget can be used to just center things:

```dart
Center(
  child: WidgetToCenter(),
),
```

## Divider Widget

Flutter provides us with a `Divider` widget which will draw a simple horizontal line. We provide a `height` for the bounding box and a `color` for the line.

```dart
Divider(height: 60, color: Colors.amberAccent),
```

## Stateful Widgets

A Widget that contains state usually consists of two classes, one for the widget itself that extends `StatefilWidget` and another for the type of the state itself which extends `State<T>`. This looks something like:

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

We can also convert a current `StatelessWidget` to a `StatefulWidget` by using the recfctorings available for the class

### Updating State

To update state in our component we use the inherited `setState` function and use it to perform state updates. This function takes a function as a parameter and we handle state updates in this

A function with a state property `_level` and a function for incrementing it's state can be defined in our class like so:

```dart
class _CardState extends State<NinjaCard> {
  int _level = 1;

  void _incrementLevel() {
    setState(() => _level++);
  }
```

We can then use call the `_incrementLevel` from the `onPressed` handler from a button, and simply render the `_level` variable anywhere we want to use it

> The state of the component can be updated independendently of the `setState` call, but this will not trigger a re-render of the component

## Card Widget

We can use the `Card` widget to render a card:

```dart
Card(
  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
  color: Colors.grey[900],
  elevation: 4,
  child: Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      ...// widget content
    ),
  ),
);
```

## SafeArea

If we are not using a layout that is designed to keep the content in the screen we can use a `SafeArea` widget which will ensure that whatever content we have on the screen does not end up under the time area, etc. See the usage below:

```dart
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text("HOME")),
    );
  }
}
```

## Routing

Routes in flutter make use of a `Map` and a function that makes use of the current app `context` which is used so that Widgets can get information about the app state and returns a Widget for the given route

To configure our application to use some routes we can do the following:

```dart
void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/select-location': (context) => SelectLocation(),
    },
  ));
}
```

By default when our application loads it will start at the `/` route but we can specify a different route using the `initialRoute` property

```dart
void main() {
  runApp(MaterialApp(
    initialRoute: "/home",
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/select-location': (context) => SelectLocation(),
    },
  ));
}
```

To navigate to a new route we can use the `Navigator` class and the methods available on that.

To push a new page on top of our existing page we can do:

```dart
Navigator.pushNamed(context, "/select-location")
```

To replace the current route instead of add a new page above it we can do:

```dart
Navigator.pushReplacementNamed(context, "/home");
```

And to go back to the previouse route we can do:

```dart
Navigator.pop(context),
```

We can use the above to make out `/home` route navigate to the `/select-location` route like so:

```dart
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: <Widget>[
        FlatButton.icon(
            onPressed: () => Navigator.pushNamed(context, "/select-location"),
            icon: Icon(Icons.edit_location),
            label: Text("Select Location"))
      ])),
    );
  }
}
```

Where clicking the button will cause a navigation.

Additionally, in our `/select-location` route we use a layout with an `AppBar`, what we get with this is a button that will automatically do the `Navigator.pop` functioning for navigating backwards

The routing process works by adding screens on top of one another, routing allows us to navigate up and down this route. The problem with is that we may end up with a large stack of routes and we need to be careful about how we manage the stack

We can also pass data through to routes as well as use Static routenames that are associated with the widgets for the screen they use, for example if we have a `Home` widget defined like so:

```dart
class Home extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  Timezone data = Timezone();
  ...
}
```

And the class for the data we would like to pass to the screen like this:

```dart
class HomeArgs {
  final Timezone data;
  HomeArgs({this.data});
}
```

We can call load this screen with the relevant arguments like this:

```dart
Navigator.pushReplacementNamed(
  context,
  Home.routeName,
  arguments: HomeArgs(data: data),
);
```

Or just using a map. Note that if we use a map then the class itself needs to be adapted to accept the `Map` type input:

```dart
Navigator.pushReplacementNamed(
  context,
  "/home",
  arguments: {data: Timezone()},
);
```

We can then access the data that was passed using the `context` object in our build function

```dart
class _HomeState extends State<Home> {
  Timezone data = Timezone();

  @override
  Widget build(BuildContext context) {
    HomeArgs args = ModalRoute.of(context).settings.arguments;
    data = args.data;
    ... // do the stuff like build the widget, etc
  }
}
```

### Using Route Changes to Get User Data

We can make use of a Navigator push action to open a screen to allow for user input/load some data, and then we can pop back to the initial screen witht the data that was recieved. By doing this we can view the process of this input (from the intial route's perspective) as an `async` action that spans multipls routes

For example, consider something like the following flow:

1. User clicks on a button like "update data" from the Home page which routes to a Data updating component

```dart
onPressed: () async {
  dynamic result = await Navigator.pushNamed(context, "/get-data");
  // will do stuff with the data
}
```

2. Data component loads data/does whatever it does
3. When the Data component is completed it pops back to the Home page passing the data

```dart
Navigator.pop(context, { ... data });
```

4. The Home page uses that data to update it's state, using `setState`

```dart
onPressed: () async {
  dynamic result = await Navigator.pushNamed(context, "/get-data");

  setState((){
    this.data = result;
  });
}
```

## Widget Lifecycles

In Flutter we have two kinds of widgets:

- Stateless
  - Does not have state that changes over time
  - `Build` function only runs once
- Stateful
  - Can have state which changes over time
  - `setState` is used to change the state
  - `Build` function is called after the state has been changes
  - `initState` lifecycle method is called when the widget is created
    - Useful for subscribing to streams that can change our data
  - `Dispose` is triggered when the widget is removed

In a `StatefulWidger` we can override the `initState` function like this:

```dart
@override
void initState() {
  super.initState();// call the parent init state
  // do whatever setup is needed
  // only runs once at the start of a lifecycle method
}
```

## Packages

Flutter packages can be found at [pub,dev](https://pub.dev/). The [`http` package](https://pub.dev/packages/http) can be used to make HTTP requests

To use the package we need to do the following:

1. Add it to our `pubspec.yml` file

`pubspec.yml`

```yml
dependencies:
  http: ^0.12.1
```

2. Install it with:

```
flutter pub get
```

## Fetching Data (http package)

We can make use of the `http` package to fetch some data from an API. for now we'll use the `JSONPlaceholder` API. To get data we can use the `get` function of the `http` package

```dart
ToDo data;
bool hasError = false;
bool isLoading = true;

void getData() async {
  Response res = await get("https://jsonplaceholder.typicode.com/todos/1");

  print(res.body);

  if (res.statusCode == 200) {
    // no error
    setState(() {
      Map<String, dynamic> json = jsonDecode(res.body);
      data = ToDo.fromJson(json);
      isLoading = false;
    });
  } else {
    // there was an error
    print("Error");
    setState(() {
      hasError = true;
      isLoading = true;
    });
  }
}
```

The data that comes from the API is a JSON Map, we need to parse this into a Dart object manually, we can do this from the class that we want to parse the object into:

```dart
class ToDo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  ToDo({this.userId, this.id, this.title, this.completed});

  // this is the function we call to parse the object from the JSON result
  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      completed: json["completed"],
    );
  }
}
```

Note that it is also possible for us to make use of more automatic means of doing this (such as with Code Generation), more information on this can be found [in the Flutter documentation](https://flutter.dev/docs/development/data-and-backend/json)

## ListViews

We can build list views using a `ListView.builder` which allows us to output a template for each item in a list automatically instead of us doing the data-template conversion on our own

The `ListView.builder` widget takes an `itemCount` which is the number of items in the list, and a `itemBuilder` which takes the `context` and `index` and uses it to then render a given element

```
ListView.builder(
  itemCount: data.length,
  itemBuilder: (context, index) => Card(
    child: Text(data[index]),
  ),
);
```
