<details>
  <summary>Contents</summary>

- [Creating a Project](#creating-a-project)
- [Generated Files and Structure](#generated-files-and-structure)
- [Running the App](#running-the-app)
- [Editing the UI](#editing-the-ui)
- [String Localization](#string-localization)
- [Handling Events](#handling-events)
- [Create a New Activity](#create-a-new-activity)

</details>

> From the [Android Docs](https://developer.android.com/guide) and [this section](https://developer.android.com/training/basics/firstapp/index.html)

# Creating a Project

1. Download and install Android Studio
2. Create a new Empty Activity Project with Kotlin selected as the language and make use of `androidx.*` artifacts

Android Studio should now set up the initial project

| Name              | My First App                      |
| ----------------- | --------------------------------- |
| Package           | com.nabeelvalley.myfirstapp       |
| Save Location     | C:\Repos\AndroidStudio\MyFirstApp |
| Language          | Kotlin                            |
| Minimum API Level | API Level 15: Android 4.0.3       |
|                   | Use `androidx.*` artifacts        |

After creating the app there should be a gradle download which may take a while

# Generated Files and Structure

There are a couple of different files that are generated in the application directory that we created. The files relevant to the application development are contained in the `app/src` directory

1. The first relevant file is the `MainActivity.kt` file which is the application's entrypoint and is in the `app/java/com.nabeelvalley.myfirstapp` directory, the code in this file can be seen below:

```kt
package com.nabeelvalley.myfirstapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
```

2. Next is the `app/res/activity_main.xml` file which is the layout file for the Main Activity, this contains a simple `TextView` wrapped in a `ConstraintLayout` which can be seen below:

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".MainActivity">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Hello World!"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

3. Then we have the `AndroidManifest.xml` file which contains information about the application and define's its components. It's a manifest - pretty normal

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.nabeelvalley.myfirstapp" >

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme" >
        <activity android:name=".MainActivity" >
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
```

4. Additionally there are `build.gradle` files for different parts of the application that are used by Gradle to build the application

# Running the App

To run the application on a device you will need to do the following:

1. Enable USB Debugging on your device
2. Install your device drivers, [information here](https://developer.android.com/studio/run/oem-usb.html)

> Note if using a Huawei you need to use HiSuite which should show up as a drive when your device is plugged in, you may then neeed to run

3. On Android Studio click on `File > Sync Project with Gradle Files`, this will ensure that the correct debugging options show up in the debug toolbar
4. In the Debuging toolbar click on the Run button, this should show a list of devices and you can select your device from here

# Editing the UI

The UI is built using XML, however it can also be edited through the Android Studio Layout Editor which is probably easier for now. Different components are called `View`s and these are contained in `ViewGroup`s

To view the Layout Editor do the following:

1. Open the `app/res/layout/activity_main.xml` file
2. Click the `Design` tab at the bottom of the window if you see the XML
3. Click `Select Design Surface` and select `Blueprint`

In the Component Tree you will see that the main wrapper is a `ConstraintLayout` which contains a `TextView` object

A `ConstraintLayout` is a layout that defines the positioning of each child based on constraints to its siblings, this avoids some needs for a nested layout which can take longer to draw to the screen

We can add a Text Box with the following steps

1. Remove the current `TextView` element by clicking on the Component Tree and then clicking Delete
2. From the `Text` section of the component list drag an `EditText` component onto the screen, this is a text box that accepts plain text input
3. Click and drag the anchors (or dots) in the middle of the top edge to the top of the screen and the left to the left edge of the screen to create a constraint
4. In the `Layout` section of the attributes (should be on the right) set the margins to `16dp`

Next add a `Button` onto the screen and then do the following

1. Add a `16dp` constraint from the left side to the `EditText`
2. Right click on the `Button` and click `Show Baseline`
3. Drag a constraint from `Button`'s Baseline to the `EditText`'s Baseline

> You should notice the different attributes of the elements on the right side of the screen, these can be edited

Now let's make the text box responsive:

1. `Shift + Cick` to select the two elements
2. `Right Click` to open the menu and select `Chains > Create Horizontal Chain`

> A chain is a bidirectional constraint that allows you to lay out children in a group

3. Select the button and set the right margin to `16dp`
4. From the Layout menu on the `EditText` and click twice on the horizontal constraints and set them to be `Match Constraints`

# String Localization

We can add localizations for strings by adding them to the `app/res/values/strings.xml` file directly or using the Translations Editor

1. Open the `strings.xml` file and on the top right click `Open Editor` and then the `+` at the left to create a new value
2. Use the Translation Editor to create the following values

| Key             | Default Value   |
| --------------- | --------------- |
| `message_edit`  | Enter a Message |
| `button_submit` | Submit          |

The Resulting XML file should contain the following:

```xml
<resources>
    <string name="app_name">My First App</string>
    <string name="message_edit">Enter a Message</string>
    <string name="button_submit">Submit</string>
</resources>
```

Next we can apply the strings to our field and button from the Design View/Editor

1. Select the layout element
2. In the `text` property delete the value and click on icon to the right and select the correct string resource for the field

The resulting layout should be as follows:

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
        xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:tools="http://schemas.android.com/tools"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        tools:context=".MainActivity">
    <EditText
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:inputType="textShortMessage"
            android:ems="10"
            android:id="@+id/editText" android:layout_marginTop="16dp"
            app:layout_constraintTop_toTopOf="parent" android:layout_marginStart="16dp"
            app:layout_constraintStart_toStartOf="parent" android:layout_marginLeft="16dp"
            android:text="@string/message_edit" app:layout_constraintHorizontal_bias="0.5"
            app:layout_constraintEnd_toStartOf="@+id/button"/>
    <Button
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:id="@+id/button" app:layout_constraintStart_toEndOf="@+id/editText" android:layout_marginLeft="16dp"
            android:layout_marginStart="16dp"
            app:layout_constraintBaseline_toBaselineOf="@+id/editText" android:text="@string/button_submit"
            app:layout_constraintHorizontal_bias="0.5" app:layout_constraintEnd_toEndOf="parent"
            android:layout_marginRight="16dp" android:layout_marginEnd="16dp"/>
</androidx.constraintlayout.widget.ConstraintLayout>
```

# Handling Events

We can handle the click event on the `Submit` button by using an event handler in our `MainActivity.kt` file, we just need to add a handler function to the class

We can add something like:

```kotlin
/** Called when the user taps the submit button */
fun handleSubmit(view: View) {
    // Do stuff
}
```

We can then bind this to the `onClick` event on the Attributes list for the button. For a method to be compatible with the `android:onClick` attribute it must:

1. Be publicly accessible
2. Return `unit` or `void`
3. Have a `View` as its only parameter

Next, from the function we defined we can use the following to get the `text` value from the `EditText`

```kotlin
val editText = findViewById<EditText>(R.id.editText)
val message = editText.text.toString()
```

> Note that you can click `Alt + Enter` to resolve missing references

Next we can create an `Intent` for a second activity for which we will send the `message` to using the following code

```kotlin
val intent = Intent(this, DisplayMessageActivity::class.java).apply {
    putExtra(EXTRA_MESSAGE_KEY, message)
}
```

From the above we have the `DisplayMessageActivity` class that is not yet defined, this is the class for the activity we will create next. The `putExtra` function is used to store intent data as a key-value pair

The `EXTRA_MESSAGE_KEY` is defined above out class as a `const`

```kotlin
const val EXTRA_MESSAGE_KEY = "com.example.myfirstapp.MESSAGE"
```

And then we can start an activity with the intent using:

```kotlin
startActivity(intent)
```

The overall `MainActivity.kt` file should now be as follows

```kotlin
package com.nabeelvalley.myfirstapp

import androidx.appcompat.app.AppCompatActivity
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText

const val EXTRA_MESSAGE = "com.example.myfirstapp.MESSAGE"

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    /** Called when the user taps the submit button */
    fun handleSubmit(view: View) {
        val editText = findViewById<EditText>(R.id.editText)
        val message = editText.text.toString()
        val intent = Intent(this, DisplayMessageActivity::class.java).apply {
            putExtra(EXTRA_MESSAGE, message)
        }
        startActivity(intent)
    }
}
```

Lastly from the design view from the `activity_main.xml` you should be able to select the `handleSubmit` option in the `onClick` dropdown which will set the handler to the function we created

# Create a New Activity

From the Project Window right click on the `app` folder and select `New > Activity > Empty Activity` and call it `DisplayMessageActivity`

On the new activity add a `TextField` and change the `id` to `messageDisplay`

Now using the `onCreate` function we can add the following code to set the `TextView` to display the data we have from the `EditText` on the main screen

```kotlin
// Get the Intent that started this activity and extract the string
val message = intent.getStringExtra(EXTRA_MESSAGE)

// Capture the layout's TextView and set the string as its text
val textView = findViewById<TextView>(R.id.messageDisplay).apply {
    text = message
}
```

This leaves the resulting `DisplayMessageActivity.kt` file as follows:

```kotlin
package com.nabeelvalley.myfirstapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView

class DisplayMessageActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display_message)

        // Get the Intent that started this activity and extract the string
        val message = intent.getStringExtra(EXTRA_MESSAGE)

        // Capture the layout's TextView and set the string as its text
        val textView = findViewById<TextView>(R.id.messageDisplay).apply {
            text = message
        }
    }
}
```

Lastly we need to add a button from the `DisplayMessageActivity` back to the `MainActivity`, we can do this from the `AndroidManifest.xml` by replacing the `<activity>` tag for the `DisplayMessageActivity` with the following to indicate the parent activity:

```xml
<activity android:name=".DisplayMessageActivity"
          android:parentActivityName=".MainActivity">
    <!-- The meta-data tag is required if you support API level 15 and lower -->
    <meta-data
        android:name="android.support.PARENT_ACTIVITY"
        android:value=".MainActivity" />
</activity>
```

Lastly we can run the application and we should be able to pass data between as well as navigate the two activities
