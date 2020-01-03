# Building Android Apps with Kotlin

> From [this Udacity Corse](https://classroom.udacity.com/courses/ud9012)

## Building your First App

### Create a Project

To get started you will need to first install Android Studio and an Emulator if needed

To get started create a new Android Studio Project with the following settings, select the `Empty Activity` and name the application DiceRoller with the Root Package `com.example.DiceRoller`. Select the `API Level 19` and 

| Name              | My First App                      |
| ----------------- | --------------------------------- |
| Package           | com.nabeelvalley.diceroller       |
| Save Location     | C:\Repos\AndroidStudio\DiceRoller |
| Language          | Kotlin                            |
| Minimum API Level | API Level 19: Android 4.4         |
|                   | Use `androidx.*` artifacts        |

### Set up an Emulator

1. In the debug toolbar click `Run (Green Play Button) > Add new Virtual Device` And select the  `Pixel 2 with Play Store` and then select the newest API Emulator after downloading the image
2. Once the Emulator is downloaded you can select it
3. Click Okay and the app should build and open on your Emulator

> To use an app on your device configure the debugging [See Intro To Android Notes](./introduction-to-android.md#Running-the-App)

### What's in an App

The application when using the `Android` project view, if you look at the application there are the following folders

1. `java` is your application code
2. `res` are the static resources for your app
3. `generatedJava` contains build outputs
4. `manifests` contains manifest files with application details
5. `Gradle Scripts` are generated files that configure the application build and installation

The `MainActivity.kt` file and the `activity_main.xml` files are the stuff we see when the application runs the Main Activity, this is declared in the `AndroidManifest.xml` file:

```xml
<activity android:name=".MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>

        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity>
```

The Objects in our Layout File (`activity_main.xml`) are transformed into Kotlin Objects during the inflation process that we can work with and manipulate in the `MainActivity.xml

An Activity has a set of `Lifecycle` Methods that are called during the application setup, for our activity we have the following code:

```kotlin
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
```

The `R.layout.activity_main` is the layout that is being used, in the Layout file we can have:

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
            app:layout_constraintTop_toTopOf="parent"/>

</androidx.constraintlayout.widget.ConstraintLayout>
```

The above layout can be previewed on Android Studio, but is essentially a `ConstraintLayout` with just a `TextView` in the center. The different nodes in the Layout file are called `Views`, there are many types of views

### Update the Layout

For our first layout we'll use a `LinearLayout` with an Image and Button in it. For now just replace the current View COntents with:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              xmlns:tools="http://schemas.android.com/tools"
              android:layout_width="match_parent"
              android:layout_height="wrap_content"
              tools:context=".MainActivity">

    <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Hello World!" />

</LinearLayout>
```

Looking at the XML we can see the different properties of the `LinearLayout` and `TextView` that are on the screen

Now let's update the text and positioning of the layout to add a button and center everything on the screen, we can use the following code to do so:

```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              xmlns:tools="http://schemas.android.com/tools"
              android:layout_width="match_parent"
              android:layout_height="wrap_content"
              android:layout_gravity="center_vertical"
              android:orientation="vertical"
              tools:context=".MainActivity">

    <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_gravity="center_horizontal"
            android:text="1"
            android:textSize="30sp"/>

    <Button
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_gravity="center_horizontal"
            android:text="Roll"/>

</LinearLayout>
```

Lastly double click on the word Roll, and a lightbulb should appear in the menu, select the `Extract string resource` and it will be added to the `values/strings.xml` file:

```xml
<resources>
    <string name="app_name">DiceRoller</string>
    <string name="roll">Roll</string>
</resources>
```

We can then reference it in the layout by replacing `Roll` with `@string/roll`

### Handle the Button

In order for us to access objects in the layout file we need to have a way to refer to the different elements, we can do this by searching for the relevant layout item. To make this easy we can define an ID for a view and this is generated as a constant in the `R` class and we can use `findViewById` in the Kotlin code and we can access this object

Set the Id for the button to modify the text when the activity starts up

1. Set the ID on the button with `android:id="@+id/roll_button"`
2. Get the button from the `onCreate` method with 

```kotlin
var rollButton = findViewById<Button>(R.id.roll_button)
```

3. Update the button text with

```kotlin
rollButton.text = "Let's Roll"
``` 

We can then add a `listener` to handle the button click using and simply show a toast message. We make use of the `setOnClickListener` to do this

```kotlin
rollButton.setOnClickListener {
    Toast.makeText(this, "button clicked", Toast.LENGTH_SHORT)
        .show()
}
```

We can make use of this handler to change the TextView, set the ID to `@+id/result_text`

Next we'll move the handler to it's own logic. Create a function in the class called `handleRollClick` which will just replace the text for now, first be sure to add `import kotlin.random.Random` and use that `Random`

```kotlin
import kotlin.random.Random

...

private fun handleDiceRoll() {
    val randomInt = Random.nextInt(6) + 1

    val resultText = findViewById<TextView>(R.id.result_text)
    resultText.text = randomInt.toString()
}
```

Then reference this from the `onClickHandler` with:

```kotlin
rollButton.setOnClickListener { handleDiceRoll() }
```

Clicking the button now should display a random number

### Use an Image

First, download all the images from [here](https://github.com/udacity/andfun-kotlin-dice-roller/raw/master/DiceImages.zip) and unzip the folder

The images we're using are all vectors. Switch to `Project` view and go to `app > src > main > res > Drawable` and drag the images into the `Drawable` folder

You can then preview these images in Android Studio

Now replace the `result_text` with the below Image View that shows the `empty_dice` image until the dice has been rolled

```xml
<ImageView
        android:id="@+id/dice_image"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        android:src="@drawable/empty_dice" />
```

Then in the handler get the `dice_image` view and set the `imageResource` to the image based on the number we have

```kotlin
private fun handleDiceRoll() {
    val randomInt = Random.nextInt(6) + 1

    val drawableResource = when (randomInt) {
        1 -> R.drawable.dice_1
        2 -> R.drawable.dice_2
        3 -> R.drawable.dice_3
        4 -> R.drawable.dice_4
        5 -> R.drawable.dice_5
        else -> R.drawable.dice_6
    }

    val diceImage = findViewById<ImageView>(R.id.dice_image)
    diceImage.setImageResource(drawableResource)
}
```

We should minimize the calls to `findViewById` as this can be expensive. We should keep this reference in a field, we should create a `lateinit` variable which allows us to say that a variable will not be used before we assign it initially

The `MainActivity` can be updated to use the `lateinit` variable by inializing in with the `onCreate` function and then using that reference in the `handleDiceRoll` function

```kotlin
class MainActivity : AppCompatActivity() {
    lateinit var diceImage: ImageView

    override fun onCreate(savedInstanceState: Bundle?) {
        ...
        rollButton.setOnClickListener { handleDiceRoll() }
        diceImage = findViewById(R.id.dice_image)
    }

    private fun handleDiceRoll() {
        ...
        diceImage.setImageResource(drawableResource)
    }
}
```

We can also set the `ImageView` to set some data for the preview data, this is helpful for when we are designing and our data is based on some image or data that will maybe be fetched during some loading process, we can show the data for this with the `tools` namespace in the XML. For the `ImageView` we can change the image `src` for the preview by adding this:

```xml
android:src="@drawable/dice_1"
```

So our resulting `ImageView` will be:

```xml
<Button
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        android:text="@string/roll"
        android:id="@+id/roll_button"/>
```

### Gradle

Gradle is the build system that is used for android, it does a few different things:

1. Specify what devices can run an app
2. Compile that application
3. Dependency management
4. App Signing
5. Automated Testing

When running an application the Gradle file compiles the application into an `APK`, there are two Gradle file types in the project, one for the entire project and one for each module

The Gradle website has some detail into what each of the different parts of this file are

Looking at the Project Gradle file in `repositories` we can see which remote servers libraries will be downloaded from:

```gradle
repositories {
    google()
    jcenter()
}
```

Next we specify the dependencies for the Project, these are reference the plugins needed:

```gradle
dependencies {
    classpath 'com.android.tools.build:gradle:3.4.0'
    classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"  "
    // NOTE: Do not place your application dependencies here; they belong
    // in the individual module build.gradle files
}
```

If we look at the app module `build.gradle` we can see the different plugins needed for a project

```gradle
apply plugin: 'com.android.application'

apply plugin: 'kotlin-android'

apply plugin: 'kotlin-android-extensions'
```

Next we can see the configuration for our module:

```gradle
compileSdkVersion 28
defaultConfig {
    applicationId "com.nabeelvalley.diceroller"
    minSdkVersion 19
    targetSdkVersion 28
    versionCode 1
    versionName "1.0"
    testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
}
```

If we look further down we can see the dependencies needed for a specific module:

```gradle
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation"org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"  "
    implementation 'androidx.appcompat:appcompat:1.1.0'
    implementation 'androidx.core:core-ktx:1.1.0'
    implementation 'androidx.constraintlayout:constraintlayout:1.1.3'
    testImplementation 'junit:junit:4.12'
    androidTestImplementation 'androidx.test:runner:1.2.0'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.2.0'
}
```

### Updating App Compatability

Note that `androidx` is included as a dependency for the application, this is a collection of libraries that are used to provide compatability across different android API levels

For us to make use of this for better image support, we can do the following:

1. Enable the support library in the app `build.gradle` file in the `defaultConfig`:

```
vectorDrawables.useSupportLibrary = true
```

2. Replace `app:src` with `app:srcCompat`
3. Add the XML namespace to the app:

```xml
xmlns:app="http://schemas.android.com/apk/res-auto"
```

4. Not sure how necessary this is but I also needed to change the `ImageView` to `androidx.appcompat.widget.AppCompatImageView` because the preview no longer worked after changing to use `srcCompat`

The resulting `ImageView` is:

```xml
<androidx.appcompat.widget.AppCompatImageView
        android:id="@+id/dice_image"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        app:srcCompat="@drawable/empty_dice"
        tools:src="@drawable/dice_1"/>
```

If we want to be more correct about how we're handling the Image view we can also change the type of our `diceImage` property to be `AppCompatImageView` which we import from `androidx`, so our declaration looks like so:

```kotlin
lateinit var diceImage: AppCompatImageView
```

