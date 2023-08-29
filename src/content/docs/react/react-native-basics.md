---
published: true
title: React Native Basics
subtitle: Based on the NetNinja Course
---

> From the Net Ninja's React-Native Course [on YouTube](https://www.youtube.com/watch?v=ur6I5m2nTvk&list=PL4cUxeGkcC9ixPU-QkScoRBVxtPPzVjrQ)

# Introduction

React native allows us to use React to develop native mobile applications. We're going through this course using the Expo CLI along with Typescript instead of just plain RN with JS

# Init App

To create a new RN app we use the `expo-cli` using the following:

```sh
npm install -g expo-cli
expo init rn-net-ninja
```

And select the `blank (TypeScript)` as the application type. Then, `cd` into the created directory and run `yarn start`

```sh
cd rn-net-ninja
yarn start
```

You can then scan the barcode from the terminal via the `Expo Go` app which you can download from the app store on your test device

In the scaffolded code you will see the following structure:

```§
rn-net-ninja
  |- .expo
  |- .expo-shared
  |- assets
  |- app.json
  |- App.tsx
  |- babel.config.js
  |- package.json
  |- tsconfig.json
  |- yarn.lock
```

# Views and Styles

The `App.tsx` file contains a `View` with some `Text` and a `StyleSheet`

`App.tsx`

```tsx
import { StatusBar } from 'expo-status-bar'
import React from 'react'
import { StyleSheet, Text, View } from 'react-native'

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Hello, World!</Text>
      <StatusBar style="auto" />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
})
```

In RN we use the `Text` component to represent any plain text view as we would in typical `JSX`, additionally, the `View` can be likened to a `div` and the `StyleSheet` to a CSS File

In terms of the way RN uses styles it uses a CSS-like API but doesn't actually render to CSS but does magic in the background to get these to be like native styles

An important distinction when compared CSS is that RN styles aren't inherited by children elements, this means that if we want to apply a specific font to each component for example, we would actually have to apply this to every element individually

# Text Inputs

RN Provides some other basic components, one of these are the `TextInput` component which we can use like so:

```tsx
export default function App() {
  const [name, setName] = useState<string>("Bob");

  const handleTextChange = useCallback(setName, [name]);

  return (
    <View style={styles.inputWrapper}>
      <Text style={styles.inputLabel}>Enter Name</Text>
      <TextInput
        style={styles.input}
        value={name}
        onChangeText={handleTextChange}
      />
  );
}
```

# Lists and ScrollView

`ScrollView` allows us to render a list of items in a scrollable area, this can be rendered as follows:

```tsx
// people: { id: number; name: string; age: number;}[]
<ScrollView>
  {people.map((p, i) => (
    <View style={styles.person} key={i}>
      <Text>{p.name}</Text>
      <Text>{p.age}</Text>
    </View>
  ))}
</ScrollView>
```

# FlatList

Additionally, there's another way to render a scrollable list of elements: using a `FlatList` which looks like so:

```tsx
// people: { id: number; name: string; age: number;}[]
<FlatList
  data={people}
  renderItem={({ item }) => (
    <View style={styles.person}>
      <Text>{item.name}</Text>
      <Text>{item.age}</Text>
    </View>
  )}
  keyExtractor={({ id }) => id.toString()}
/>
```

Additionally, `FlatList` also supports a `numColumns` prop which lets us set the number of columns to use for the layout

The `FlatList` will only render the components as they move into view, and this is useful when we have a really long list of items that we want to render

# Pressable

We can use the `Pressable` component to make any element able to handle touch events, for example:

In general, we can surround an element by `Pressable` and then handle the `onPress` event:

```tsx
<Pressable onPress={() => onPersonSelected(item)}>
  <View style={styles.person}>
    <Text>{item.name}</Text>
    <Text>{item.age}</Text>
  </View>
</Pressable>
```

And then, somewhere higher up we can have `onPersonSelected` defined:

```tsx
const onPersonSelected = useCallback<PersonSelectedCallback>(
  (p) => setName(p.name),
  []
)
```

We can set some app props by applying this to the `FlatList` components above.

Without too much detail, some of the types being referenced by our setup are:

```ts
interface Person {
  id: number
  name: string
  age: number
}

type PersonSelectedCallback = (p: Person) => void
```

And our person display component will then look like this:

```tsx
const PeopleView: React.FC<{ onPersonSelected: PersonSelectedCallback }> =
  function ({ onPersonSelected }) {
    const people = [
      { name: 'Jeff', age: 1 },
      { name: 'Bob', age: 2 },
      // ...
    ].map((p, i) => ({ ...p, id: i }))

    return (
      <FlatList
        data={people}
        renderItem={({ item }) => (
          <Pressable onPress={() => onPersonSelected(item)}>
            <View style={styles.person}>
              <Text>{item.name}</Text>
              <Text>{item.age}</Text>
            </View>
          </Pressable>
        )}
        keyExtractor={({ id }) => id.toString()}
      />
    )
  }
```

# Keyboard Dismissing

We'll notice that the way the app works at the moment, some basic interactions, such as the keyboard automatically being dismissed don't work. In order to do this we need to add a handler onto the component which causes the keyboard t be dismissed.

This can be done using a combination of a `Pressable` or `TouchableWithoutFeedback` and then `Keyboard.dismiss()` in the `onPress` handler

# Flexbox

Just a short note here - `Views` in RN behave like flexboxes, so we can do normal flexboxy things for layout in our components.

Something that's commonly done is to use `flex: 1` on components so that they fill the available space on a page. This is especially useful for limiting the size of a `ScrollView` or `FlatList`

Additionally, applying `flex: 1` to the root component will cause the app to fill our entire screen

# Fonts

To use custom fonts you can make use of the Expo CDK, [here's the doc](https://docs.expo.io/versions/latest/sdk/font/)

```sh
expo install expo-font
```

And we can use a font from our app with the `useFonts` hook:

```tsx
import * as React from 'react'
import { View, Text, StyleSheet } from 'react-native'
import { useFonts } from 'expo-font'

export default function App() {
  const [loaded] = useFonts({
    koho: require('./assets/fonts/KoHo-Regular.ttf'),
  })

  if (!loaded) {
    return null
  }

  return (
    <View style={styles.container}>
      <Text style={{ fontFamily: 'koho', fontSize: 30 }}>KoHo</Text>
    </View>
  )
}
```

# React Navigation

We're going to use the `react-navigation` library for building out the navigation and routing.

We can to install the required packages with:

```sh
yarn add @react-navigation/native
```

> `expo install` does some additional version checks, etc.

```sh
expo install react-native-gesture-handler react-native-reanimated react-native-screens react-native-safe-area-context @react-native-community/masked-view
```

Additionally, `react-navigation` supports a few different types of navigation. For our first case we're going to use a Stack navigation. So we need to install that with:

```sh
yarn add @react-navigation/stack
```

## Stack Navigator

We can create a Stack Navigator using some of the constructs provided by `react-navigation`. These work by using `createStackNavigator` and composing the navigation within a `NavigationContainer`. Note that we also use the `AppStackParamList` to list the params required for each screen

`routes/HomeNavigationContainer.tsx`

```tsx
import React from 'react'
import { createStackNavigator } from '@react-navigation/stack'
import { NavigationContainer } from '@react-navigation/native'
import Home from '../screens/Home'
import ReviewDetails from '../screens/ReviewDetails'

export type AppStackParamList = {
  Home: undefined
  ReviewDetails: undefined
}

const Stack = createStackNavigator<AppStackParamList>()

export default function HomeNavigationContainer() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Home">
        <Stack.Screen name="Home" component={Home} />
        <Stack.Screen name="ReviewDetails" component={ReviewDetails} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}
```

We can then use this from the `App` component with:

`App.tsx`

```tsx
// other imports
import HomeNavigationContainer from './routes/HomeNavigationContainer'

export default function App() {
  // other stuff

  return <HomeNavigationContainer />
}
```

## Navigating

In order to navigate we need to use the `navigation` prop that's passed to our component by `react-navigation`. In order to do this we need to configure our screen to use the `AppStackParamList` type with `StackScreenProps`

`screens/Home.tsx`

```tsx
import { StackScreenProps } from '@react-navigation/stack'
import React from 'react'
import { View, Text, Button } from 'react-native'
import { AppStackParamList } from '../routes/HomeNavigationContainer'
import { globalStyles } from '../styles'

type HomeProps = StackScreenProps<AppStackParamList, 'Home'>

const Home: React.FC<HomeProps> = function ({ navigation }) {
  const navigateToReviews = () => {
    navigation.navigate('ReviewDetails')
  }

  return (
    <View style={globalStyles.container}>
      <Text style={globalStyles.titleText}>Home Page</Text>
      <Button title="To Reviews" onPress={navigateToReviews} />
    </View>
  )
}

export default Home
```

## Send data to screen

We can send some data to each screen by defining the data in our routing params:

```ts
export type AppStackParamList = {
  Home: undefined
  ReviewDetails: { title: string; rating: number; body: string }
}
```

And then our Reviews screen will look like this:

```tsx
type ReviewDetailsProps = StackScreenProps<AppStackParamList, "ReviewDetails">;

const ReviewDetails: React.FC<ReviewDetailsProps> = function ({ navigation, route }) {
  const params = route.params

  // ... render stuff, etc.
```

And lastly, we can update the `Home` component to send the data that this screen requires using the `navigator.navigate` function:

```tsx
const Home: React.FC<HomeProps> = function ({ navigation }) {
  const navigateToReviews = () => {
    navigation.navigate("ReviewDetails", { // screen props/data
      title: 'that racing movie',
      rating: 1,
      body: 'it was terrible'
    });
  };

  // ... render stuff, etc.
```

## Drawer Navigation

Now, since we've got all our navigation working, we're going to add some complexity by including a drawer based navigation that wraps our overall application. To do this we will need to change when we're using our stack and creating the NavigationContainer

To do this, we'll first return just the stack from the `HomeNavigationContainer` and then create the container at the `App` component level. It also may be useful to rename the `HomeNavigationContainer` file to `HomeStack.tsx`

`routes/HomeStack.tsx`

```tsx
import { StackScreenProps } from '@react-navigation/stack'
import React from 'react'
import { View, Text, Button } from 'react-native'
import { AppStackParamList } from '../routes/HomeStack'
import { globalStyles } from '../styles'

type HomeProps = StackScreenProps<AppStackParamList, 'Home'>

const Home: React.FC<HomeProps> = function ({ navigation }) {
  const navigateToReviews = () => {
    navigation.navigate('ReviewDetails', {
      title: 'that racing movie',
      rating: 1,
      body: 'it was terrible',
    })
  }

  return (
    <View style={globalStyles.container}>
      <Text style={globalStyles.titleText}>Home Page</Text>
      <Button title="To Reviews" onPress={navigateToReviews} />
    </View>
  )
}

export default Home
```

Next, we need to add the `About` page content into a stack, like so:

`routes/AboutStack.tsx`

```tsx
import React from 'react'
import { createStackNavigator } from '@react-navigation/stack'
import { NavigationContainer } from '@react-navigation/native'
import About from '../screens/About'

export type AppStackParamList = {
  About: undefined
}

const Stack = createStackNavigator<AppStackParamList>()

export default function AboutStack() {
  return (
    <Stack.Navigator initialRouteName="About">
      <Stack.Screen name="About" component={About} />
    </Stack.Navigator>
  )
}
```

Then, we will include these components/stacks as the component that needs to be rendered. Since we're using a `DrawerNavigator`, we do this by first creating the navigator, then providind our screens as the routes:

`routes/DrawerNavigator.tsx`

```tsx
import React from 'react'
import {
  createDrawerNavigator,
  DrawerScreenProps,
} from '@react-navigation/drawer'
import HomeStack from './HomeStack'
import AboutStack from './AboutStack'
import { NavigationContainer } from '@react-navigation/native'

type DrawerParamList = {
  Home: undefined
  About: undefined
}

const Navigator = createDrawerNavigator<DrawerParamList>()

export default function DrawerNavigator() {
  return (
    <NavigationContainer>
      <Navigator.Navigator drawerType="front">
        <Navigator.Screen component={HomeStack} name="Home" />
        <Navigator.Screen component={AboutStack} name="About" />
      </Navigator.Navigator>
    </NavigationContainer>
  )
}
```

And lastly, we can use this from the `App.tsx` file like so:

`App.tsx`

```tsx
import React from 'react'
import { useFonts } from 'expo-font'
import AppLoading from 'expo-app-loading'
import { Stack } from './routes/HomeStack'
import { NavigationContainer } from '@react-navigation/native'
import Home from './screens/Home'
import ReviewDetails from './screens/ReviewDetails'
import DrawerNavigator from './routes/DrawerNavigator'

export default function App() {
  const [loaded] = useFonts({
    'koho-regular': require('./assets/fonts/KoHo-Regular.ttf'),
  })

  if (!loaded) {
    return <AppLoading />
  }

  return <DrawerNavigator />
}
```

Now that we've got the drawer working, it's a matter of finding a way to trigger it from our code, we can use a custom header component to do this. A special consideration here is that this component should have a definition for a composite navigation type in order to access and work with the drawer:

```tsx
import { useNavigation } from '@react-navigation/core'
import {
  DrawerNavigationProp,
  DrawerScreenProps,
  useIsDrawerOpen,
} from '@react-navigation/drawer'
import { CompositeNavigationProp } from '@react-navigation/native'
import { StackNavigationProp, StackScreenProps } from '@react-navigation/stack'
import React from 'react'
import { View, StyleSheet, Text, Button } from 'react-native'
import { DrawerParamList } from '../routes/DrawerNavigator'

// composite navigation type to state that the screen
// is within two types of navigators
type HeaderScreenNavigationProp = CompositeNavigationProp<
  StackNavigationProp<DrawerParamList, 'Home'>,
  DrawerNavigationProp<DrawerParamList>
>

const Header = function () {
  const navigation = useNavigation<HeaderScreenNavigationProp>()

  function openDrawer() {
    navigation.openDrawer()
  }

  return (
    <View style={styles.header}>
      <Button title="Menu" onPress={openDrawer} />
      <Text>Header Text</Text>
    </View>
  )
}

export default Header
```

We can then implement the `Header` in the `HomeStack` component in the `options` param for the stack:

`routes/HomeStack.tsx`

```tsx
export default function HomeStack() {
  return (
    <Stack.Navigator initialRouteName="Home">
      <Stack.Screen
        name="Home"
        component={Home}
        options={{
          header: Header,
        }}
      />
      <Stack.Screen name="ReviewDetails" component={ReviewDetails} />
    </Stack.Navigator>
  )
}
```

And the exact same for `About`

`routes/AboutStack.tsx`

```tsx
export default function AboutStack() {
  return (
    <Stack.Navigator initialRouteName="About">
      <Stack.Screen
        name="About"
        component={About}
        options={{
          header: () => <Header />,
        }}
      />
    </Stack.Navigator>
  )
}
```

## Custom Title for Stack-Generate Header

Using the Stack Navigation, we are also provided with a title, this is still used by the `ReviewDetails` screen as it doesnt have any additional options. In addition to the `options` param as an object, we can also set it to a function which calculates the values from the data shared to the component. So we can use the `title` prop from our component to set this:

`routes/HomeStack.tsx`

```tsx
<Stack.Screen
  name="ReviewDetails"
  component={ReviewDetails}
  options={({ route }) => ({
    title: route.params.title,
  })}
/>
```

# Images

To use images in React-Native, we make use of the `Image` component with the `source` prop with a `require` call

```tsx
import { Image } from 'react-native'

//... do stuff

return <Image source={require('../assets/my-image.png')}>
```

Note that the `require` data must be a constant string, so we can't calculate this on the fly

If we have a set of images that we would like to dynamically select from, we can however still do something like this:

```ts
const images = {
  car: require('../assets/car.png'),
  bike: require('../assets/bike.png'),
  truck: require('../assets/truck.png'),
  boat: require('../assets/boat.png'),
}
```

```tsx
const selectedImage = 'truck'

return <Image source={images[selectedImage]}>
```

Additionally, if we want to call an image from a URL, we can do this as we normally would, for example:

```tsx
const imageUrl = getUserProfileUrl('my-user')

return <Image source={imageUrl}>
```

## BackgroundImage

In RN we can't set image backgrounds using a normal `background` style prop, instead we need to use a `BackgroundImage` component from `react-native`, this works similar to the `Image` component but with the element we're adding the background to contained in it

```tsx
<BackgroundImage source={require('../assets/truck.png')}>
  <View>{/* view content here */}</View>
</BackgroundImage>
```

# Modals

RN comes with a handy modal component which allows us to render modals, `Modal`s are controlled using a `visible` prop. A modal in use could look something like this:

`screens/About.tsx`

```tsx
import React, { useCallback, useState } from 'react'
import { StyleSheet, View, Text, Button, Modal } from 'react-native'
import { globalStyles } from '../styles'

export default function About() {
  const [isOpen, setIsOpen] = useState<boolean>(false)

  const toggleModal = useCallback(() => {
    setIsOpen(!isOpen)
  }, [isOpen])

  return (
    <View style={globalStyles.container}>
      <Text>About Page</Text>
      <Button title="Show Modal" onPress={toggleModal} />
      <Modal visible={isOpen} animationType="slide">
        <Text>Hello from the modal</Text>
        <Button title="Close Modal" onPress={toggleModal} />
      </Modal>
    </View>
  )
}
```
