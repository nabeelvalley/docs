---
published: true
title: User interfaces with Compose
subtitle: Building Declarative Android UIs using Jetpack Compose and Kotlin
---

[[toc]]

# Jetpack Compose

> Based on the [Jetpack Compose Learning Path](https://developer.android.com/courses/pathways/compose#article-https://developer.android.com/jetpack/compose/tutorial)

## Composable Functions

### Using a Composable

Compose makes use of composable functions that let us define our UI programmatically

Composable functions make use of the`@Composable` annotation

We can render a composable `Text` element like so:

```kt
setContent {
    Text("Hello World")
}
```

Compose uses the Kotlin compiler to turn these functions into UI elements

The `Text` element above will therefore render some text to the screen


### Defining a Composable

We can define a composable function like so:

```kt
@Composable
fun Greeting(userName: String) {
    Text(text = "Hello userName")
}
```

### Composable Previews

Additionally, we can create a preview of a component using the `@Preview` annotation before the `@Composable`

So to preview our component above we can use the following:

```kt
@Preview
@Composable
fun GreetingPreview() {
    Greeting("bob")
}
```

Additionally, we can include a background to our preview using the `showBackground = true` on the `Preview` annotation as can be seen below

```kt
@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    Greeting("bob")
}
```

We can make use of Android Studio's Design Preview to view Preview components

### Composable Data

We can also make our component take more complex data, e.g. using a Data class like so:

```kt
data class User(val userName: String, val title: String)

@Composable
fun FancyGreeting(user: User) {
    Text(user.displayName)
    Text(user.title)
}

@Preview(showBackground = true)
@Composable
fun FancyGreetingPreview() {
    FancyGreeting(user = User("bob", "The Business Man"))
}
```

### Builtin Composables

As we've seen, there's the `Text` composable component that's defined by compose, in addition, we have a few other useful components that come pre-defined for us

First, there's the `Column` component

```kt
import androidx.compose.foundation.layout.Column

// ...

Column {
    Text("message")
    Text("another message")
}
```

And the `Row`

```kt
import androidx.compose.foundation.layout.Row

// ...

Row {
    Text("message")
    Text("another message")
}
```

There's also the `Image`

```kt
import androidx.compose.foundation.Image
import androidx.compose.ui.res.painterResource

// ...

Image(
    painter = painterResource(R.drawable.profile_picture
    contentDescription = "User profile picture"
)
```

And the `Spacer`

```kt
Spacer(modifier = Modifier.width(8.dp))
```

### Modifiers

Modifiers allow us to change the styles of a specific component.

For example, we can add a modifier to a `Column` like so:

```kt
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

// ...
@Composable
fun FancyGreeting(user: User) {
    Column(modifier = Modifier.padding(all = 12.dp)) {
        Text(user.userName)
        Text(user.title)
    }
}
```

We can further update the above example by adding some modifiers to the text:


```kt
@Composable
fun FancyGreeting(user: User) {
    Column(modifier = Modifier.padding(all = 12.dp)) {
        Text(
            modifier = Modifier.padding(bottom = 8.dp),
            text = user.userName
        )
        Text(user.title)
    }
}
```

And, modifiers can also be chained to create more complex styles:

```kt
@Composable
fun FancyGreeting(user: User) {
    Column(modifier = Modifier.padding(all = 12.dp)) {
        Text(
            modifier = Modifier
                .padding(bottom = 8.dp)
                .align(alignment = Alignment.CenterHorizontally),
            text = user.userName
        )
        Text(user.title)
    }
}
```

### Text Styles

In addition to the above modifiers, the `Text` composable also takes a few additional properties that we can use to modify the style of the text. Here's a simple way that we can add some styles to the `Text` element

```kt
Text(
    text = user.userName,
    modifier = Modifier
        .padding(bottom = 8.dp)
        .align(alignment = Alignment.CenterHorizontally),
    style = TextStyle(
        color = Color.Blue,
        fontStyle = FontStyle.Italic
    )
)
```

We can also define our app's text styles in a central location and reuse it from there, or we can use the `MaterialTheme` ones as such:

```kt
Text(
    text = user.title,
    style = MaterialTheme.typography.body1
)
```

Applying this to our composable above:

```kt
@Composable
fun FancyGreeting(user: User) {
    Column(modifier = Modifier.padding(all = 12.dp)) {
        Text(
            text = user.userName,
            modifier = Modifier
                .padding(bottom = 8.dp)
                .align(alignment = Alignment.CenterHorizontally),
            style = MaterialTheme.typography.h2
        )
        Text(
            text = user.title,
            style = MaterialTheme.typography.body1
        )
    }
}
```

### Lists

List views can be done using the `LazyRow` and `LazyRow` composable. These composables have an `items` lambda which can be used to render a given item

> Note that we can use the sample data from `androidx.compose.foundation.lazy.items`

```kt
@Composable
fun MessageList(messages: List<Message>) {
    LazyColumn {
        items(messages) { message ->
            FancyGreeting(
                User(message.name, message.message)
            )
        }
    }
}
```

### State Management

Composable functions can store local state by using `remember`, and can track changes to the value passed to `mutableStateOf`. State will then be redrawn automatically when the value is updated

Using this method of state management we use the `by` keyword. This keyword delegates the getter and setter value for a specific variable to a function (in this case, `remember`)

Using the above, we can create an `ExpandableGreeting` which manages the state required by our `FancyGreeting`

```kt
@Composable
fun ExpandableGreeting (user: User) {
    var expanded by remember {
        mutableStateOf(false)
    }

    val onExpand = {
        expanded = !expanded
    }

    FancyGreeting(user, expanded, onExpand)
}
```

And we can also update our `FancyGreeting` to take some expand-related options

```kt
@Composable
fun FancyGreeting(user: User, expanded: Boolean, onExpand: () -> Unit) {
    Column(
    // ...
            modifiers = Modifier.clickable {
                onExpand()
            }
    ) {
        Text(
        // ...
            maxLines = if (expanded) Int.MAX_VALUE else 1,
        )
    }
}
```

### Animations

Compose provides us with a modifier for handling animation that we can apply to the `Text` above, you can see this below:

```kt
Text(
    maxLines = if (expanded) Int.MAX_VALUE else 1,
    modifier = Modifier.animateContentSize()
)
```

This will make it automatically animate when expanded
