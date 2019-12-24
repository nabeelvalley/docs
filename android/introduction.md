# Introduction to Android Development

> From the [Android Docs](https://developer.android.com/guide)

## Build your First App

> From [here](https://developer.android.com/training/basics/firstapp/index.html)

### Creating a Project

1. Download and install Android Studio
2. Create a new Empty Activity Project with Kotlin selected as the language and make use of `androidx.*` artifacts

Android Studio should now set up the initial project

| Name              | My First App                      |
|-------------------|-----------------------------------|
| Package           | com.nabeelvalley.myfirstapp       |
| Save Location     | C:\Repos\AndroidStudio\MyFirstApp |
| Language          | Kotlin                            |
| Minimum API Level | API Level 15: Android 4.0.3       |
|                   | Use `androidx.*` artifacts        |

After creating the app there should be a gradle download which may take a while

### Generated Files and Structure

There are a couple of different files that are generated in the application directory that we created. The files relevant to the application development are contained in the `app/src`  directory

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

3. Lastly is the `AndroidManifest.xml` file which contains information on the application and define's it's components. It's a manifest - pretty normal

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