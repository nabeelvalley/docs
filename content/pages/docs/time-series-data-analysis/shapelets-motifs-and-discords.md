---
published: true
title: Shapelets, Motifs, and Discords
description: Using Shapelets, Motifs, and Discords in Time Series Data Analysis
---

> Notes on [Shaplets, Motifs and Discords: A set of Primitives for Mining Massive Time Series and Image Archives by Eamonn Keogh](https://www.youtube.com/watch?v=ODspi8-uWgo)

A time series will consist of a time series (T) and many subsequences (C)

Motifs, discords, and shapelets are subsequences with special properties

## Motifs

A pattern that repeats itself throughout a series, we can use these to do tasks like detect specific events

The most repeated pattern in a dataset is a motif. Once we've found a motif there are two questions we can ask:

1. Is it coincedental - would we find two equally similar patterns in random data?
2. Does the pattern have any domain meaning - is this a known patern that has any meaning in the context of the data?

### What are Motifs useful for

We can use this to find underrepresented or overrepresented sequences within a time series. A Motif may appear consistently over time or may have missing points which may infer some event of interest

Motifs also enable us to make sense of messy data. We can find sets of motifs and give them discrete labels - we can then convert huge time series data into discrete strings and we can then search for data based on this

Motifs can also be used for Motif Joins which allow us to find commonality between different time series

## Shapelets

Shapelets are basically supervised Motifs

Shapelets are used to find local patterns that may tell different time series apart. We may be able to use subsegments that are able to distinguish between specific classes

We can then use shapelets and build a shapelet dictionary that can the be used to build a decision tree from them in order to build a decision tree out of this

### Testing the Utility of a Canditate Shapelet

We can test a shapelet by arranging the time series objects as a distance to the shapelet to find the optimal split point that distinguishes between shapelets

Doing this naively can take a very long time, but there are ways in which this can be sped up expecially at prediction time, once we have a decision tree for identifying shapelets the models can be pretty fast

## Discords

Discords are sequences with the property that the nearest neighbor of a subsequence is as far away as possible and canbe used to help us find anomalies

Discords take only one parameter which is the dicord length, this makes these algorithms really easy to work with and also helps prevent overfitting by keeping models simple

Discords work very well for detecting outliers and anomalies in time sereis data
