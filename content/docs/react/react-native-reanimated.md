References:
- [the Reanimated docs](https://docs.swmansion.com/react-native-reanimated/docs/)
- [the Release Intro Blog Post](https://blog.swmansion.com/introducing-reanimated-2-752b913af8b3)
- [this Intro to React Native Reanimated 2](https://www.youtube.com/watch?v=yz9E10Dq8Bg)
- [this Webinar on React Native Reanimated 2](https://www.youtube.com/watch?v=IdVnnIkNzGA)

# Initialize an App

To create a new app, do the following using the Expo CLI (I've covered the basics for this [here](./react-native-basics))

```sh
expo init native-animation
```

And then select the option for `Blank (Typescript)`

# Install Reanimated

```sh
yarn add react-native-reanimated
```

Optionally, to add support for Web update your `babel.config.js` file add the `reanimated` plugin: `react-native-reanimated/plugin`, so your file should now look like this:

```js
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ["babel-preset-expo"],
    plugins: ["react-native-reanimated/plugin"],
  };
};
```

# Updating Views

Usually when creating components you can mix static and dynamic styles, this allows us to mix styles from our `StyleSheet` with styles from a `useAnimatedStyle` hook, so something like this:

```tsx
const animatedStyles = useAnimatedStyle(() => {
  return {
    transform: [{translateX: 100}]
  }
})

return <Animated.View style={[styles.box, animatedStyles]}/>
```

# Managing Animated State

Shared Values are values that can be read from both the JS and UI Threads and help to:

- Carry data  
- Drive Animations
- Provide Relativeness

Can be created using the `useSharedValue` hook, similar to `Animated.value` but can carry any type of data that we want

These values can also be directly assigned to in order to update them

```tsx
const progress = useSharedValue(0)

const animatedStyles = useAnimatedStyle(() => {
  return {
    transform: [{translateX: progress.value * 100}]
  }
})

// can be modified directly - they are reactive
const onPress = () => progress.value += 1

return <Animated.View style={[styles.box, animatedStyles]}/>
```

Another hook we can use to calculate a value based on the value of `sharedValue` is the `useDerivedValue` hook, which can be used in association with the above example like so:

```tsx
const progress = useSharedValue(0)
const translateX = useDerivedValue(() => progress.value * 100)

const animatedStyles = useAnimatedStyle(() => {
  return {
    transform: [{translateX}]
  }
})

const onPress = () => progress.value += 1

return <Animated.View style={[styles.box, animatedStyles]}/>
```

# Animation

Whe working with animations there's a concept of an animation assigner, this is basically a function that creates an animated value that can then be assigned to a shared value. Some functions available for this are:

- `Easing` functions like `Easing.bezier` or `Easing.bounce`
- `withTiming` to set an animation to happen over a set amount of time
- `withSpring` to make an animation springy

These can be used like so:

```tsx
const style = useAnimatedStyle(() => {
  const duration = 500;
  const w = withSpring(width.value, {duration, easing: Easing.bounce});
  return {
    width: w,
  };
}, []);
```

Additionally there are modifiers that can be used with an animation, something like `delay`:

```tsx
const w = delay(100, withSpring(width.value))
```

# Gestures

When handling gestures we have a `useAnimatedGestureHandler` which can take an object of method handlers, for example setting an `onActive` handler like below

```tsx
import { PanGestureHandler } from "react-native-gesture-handler";

// ...

const translateX = useSharedValue(0.0);
const translateY = useSharedValue(0.0);

const gestureHandler = useAnimatedGestureHandler({
  onActive: (e) => {
    translateX.value = e.translationX;
    translateY.value = e.translationY;
  },
});

const style = useAnimatedStyle(() => {
  return {
    transform: [
      { translateX: translateX.value },
      { translateY: translateY.value },
    ],
  };
}, []);


return (
  <PanGestureHandler onGestureEvent={gestureHandler}>
    <Animated.View style={[styles.box, style]} />
  </PanGestureHandler>
);
```

We can also add an animation to the value we calculate, so something like `withSpring`

```tsx
const gestureHandler = useAnimatedGestureHandler({
  onActive: (e) => {
    translateX.value = withSpring(e.translationX);
    translateY.value = withSpring(e.translationY);
  },
});
```


# Worklets

In React-Native we have a few main threads in which code is executed:

- The Main JS thread where our JavaScript code is executed
- The UI Thread in which rendering Native views are done
- The Native Modules thread where Native Code is run

Reanimated adds to this by running some additional JS code in the UI Thread instead of the main JS thread, these are called worklets, and they're pretty much just functions

A Worklet can be defined using either the `worklet` directive or is implied for a lambda used in the `useAnimatedStyle` hook

A simple worklet can look like so:

```ts
const myWorklet = (a: number, b: number) => {
  'worklet';
  return a + b
}

const onPress = () => {
  runOnUI(myWorklet)(1,2)
}
```

Or, in the `useAnimatedStyle` hook:

```ts
const width = useSharedValue(200);

const style = useAnimatedStyle(() => {
  // this function is also a worklet
  return {
    width: withSpring(width.value),
  };
}, []);

const onPress = () => {
  // unusual in react, but we can modify this value directly here
  width.value = Math.random() * 500;
};
```

- `useSharedValue` creates a value that can be accessed from the UI Thread
- `useAnimatedStyle` uses a worklet which can returns a style
- `withSpring` creates an interpolated value

Using the above, we can render an element with a variable `width` using the `Animated.View`

```tsx
export default function App() {
  const width = useSharedValue(200);

  const style = useAnimatedStyle(() => {
    const duration = 500;
    const w = withSpring(width.value);
    return {
      width: w,
    };
  }, []);

  const onPress = () => {
    // unusual in react, but we can modify this value directly here
    width.value = Math.random() * 500;
  };

  return (
    <View style={styles.container}>
      <StatusBar style="auto" />
      <Animated.View style={[styles.box, style]} />
      <Button color="black" onPress={onPress} title="Change Size" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
  box: {
    height: 200,
    backgroundColor: "blue",
    marginBottom: 20,
  },
});
```

> Note that though worklets can call non-worklet methods, those methods will be executed on the JS Thread and not the UI Thread