---
published: true
title: Complex UI
subtitle: Building and Animating Aomplex UI with Flutter
---

[[toc]]

> Notes from [this talk](https://www.youtube.com/watch?v=FCyoHclCqc8) by [Marcin Szalek](http://twitter.com/marcin_szalek)

# Building Blocks of Complex UI

> Look at some examples on [Marcin's Website](https://fidev.io/complex-ui)

To build complex UI there are 3 core classes in Flutter

1. `Stack`/`Overlay` allows us to position widgtes in an absolute manner relative to one another, enabling things like overlaying
2. `Transform` is how we can apply transformations to widgets and control how it is painted. Rotations, positioning, etc. `Transform.translate`, `transform.Rotate`, `Transform.scale` as well as the default form which accepts a matrix for the transformation. Transforms happen before paint but after layout calculations are done
3. `AnimationBuilder` allows you to create interpolations between different widget states with which we use a `Duration` and `AnimationController`. The `AnimationBuilder` is called every time the controller's value changes

# How to Approach a Complex Design

1. Look it it's already been implemented by an existing [standard Flutter Widget](https://flutter.dev/docs/development/ui/widgets) or on the Flutter Widget of the Week
2. Identify static elements, something that we can replace with a single widget/block so we can think about what's happening with the overall layout
3. Think about how the different elements are transforming
4. Wrap the overall `AnimatedBuilder` in a `GestureDetector` so we can use gestures to also control the process on our animation and then different handlers for setting the positions based on the motion
