---
published: true
title: Visualization
---

---
published: true
title: Visualization
---

> [Based on This EdX Course](https://www.edx.org/course/data-science-visualization)

# Configuration

Before starting the course make sure you install the library with the relevant datasets included

```r
install.packages("dslabs")
library(dslabs)
```

From the dslabs library you can use the data sets as needed

# Distributions

Numerical Data is often summarised in a single value, the average, with a standard deviation. these two numbers can provide us with a lot of data

# Data Types

- Catergorical
  - Ordinal
  - Non-Ordinal
- Numeric
  - Discrete
  - Continious

If a numeric set is discrete and only consists of a few possible values \(e.g 1, 2, 3\) we can consider it to be ordinal

# Describing Data

## Frequency Distribution

The simplest way to describe a data set is a distribution. The simplest example of this could be a two catergory distribution. This works well for Ordinal data.

## CDF

For discrete data we make use of a cumlative distribution function. The problem with a CDF is that it does not easiy convey a lot of data about the data

## Histograms

Histograms allow us to sacrifice some information but allow us to display more usable data, which easily displays things like our range, distribution, and symmetry, however due to dividing our data into bins we lose some information regarding the specific values

## Smooth Density Plots

A smoothened version of a histogram which goes on the fact that the list of observed data is a subset that is representative of the all the values, this allows us to approximate the whole based on the measured

We create a Histogram with Bin sizes appropriate for our data, change counts on the Y-Axis to densities, and then create a line that best approximates the points on the top of the histogram. The smooth density plot will have a bottom area of 1, the area under this graph gives us the fraction of our data that will fall within a specific range

# Normal Distribution

AKA the Bell Curve, or Gaussian Distribution. This is a common distribution for datasets, the normal distribution for data can be calculated with only the mean, and standard deviation. We have functions in R for these

```r
mean <- mean(x)
standard_deviation <- sd(x)
```

# Standard Units

For data that is approximately normal we can express a datapoint in standard units which describes how many standard deviations away something is from the mean

# Quantile--Quantile Plots

To check if an approximation is good we use QQ Plots.

If the quantiles for the data match the quantiles for the normal distribution then the data is normally distributed

```r
observed_quantiles <- quantile(x, p)
theoretical_quantiles <- qnorm(p, mean = mean(x), sd = sd(x))
```

To see if they match, we plot them against each other and then use an identity line, if the points fall close to the `x = y` line on our graph then we have a normal distribution

```r
plot(theoretical_quantiles, observed_quantiles)
abline(0,1)
```

If we use standard units we can instead do:

```r
observed_quantiles <- quantile(z, p)
theoretical_quantiles <- qnorm(p)
```

# Percentiles

Special Cases of Quantiles that are commonly used in which p is defined at values of increments of 0.01, our special cases are the mean at 0.5, and quartiles at 0.25, 0.50, 0.75

# Boxplots

Summarize data distribution in 5 numbers, the range with the percentiles: 0.25, 0.5, 0,75. These are useful for viewing the data distribution and for easily comparing data

# GGPlot

We will be using the `ggplot2` library for plotting because it is easy for beginners to use as well as makes use of good default behaviour which suits most general usecases

# Graph Components

- Data
- Geometry - Plot Type `geom_...()`
- Aesthetic Mapping - Points, colouring, etc. `aes()`
- Scale - Log, linear, etc.

The first step to define a ggplot graph is by assigning the data to it, we can view the plot by simply printing it

```r
plot <- ggplot(data = dataFrame)
print(plot)
```

# Layers

Graphs are made of layers based on components, to add layers, we use the `+` operator

```r
plot <- ggplot(data = dataFrame) +
        geom_points(aes(x = ..., y = ...)) +
        geom_text(aes(x = ..., y = ..., label = ...), nudge_x = 1.5)
print(plot)
```

The `aes` function can recognise our values that are defined in the `datFrame`, this is not the case with the other functions.

The problem we have is that we keep having to redifine the mappings for x and y, we can instead define a global aesthetic mapping

```r
plot <- ggplot(data = dataFrame, aes(x = ..., y = ..., label = ...)) +
        geom_points() +
        geom_text(nudge_x = 1.5)
print(plot)
```

We can write local mappings which wil overwrite the global mappings

# Scales, Colours, and Labels

We want the scales to be in log10 base, this can be done by adding

```r
plot <- ... + scale_x_continious(trans = "log10")
            + scale_y_continious(trans = "log10")
```

Since the log function is so close we can add it simply by

```r
plot <- ... + scale_x_log10()
            + scale_y_log10()
```

We can add colour mappings based on a catergorical variable by simply using an aesthetic mapping

```r
plot <- ... + geom_points(aes(col = region))
```

Add a simple line with the gradient and intersept with

```r
plot <- ... + geom_abline(intersept = ..., lty = 2, color = ...)
```

# Add-On Packages

- `ggthemes` - Themes
- `ggrepel` - Ensures labels do not bump nto things

To use a theme we can do the following

```r
library(ggthemes)
library(ggrepel)

plot <- ... + theme_themeName()
            + geom_text_repel()
```

# Other Graph Types

- `geom_histogram`
- `geom_density`
- `geom_qq`

To use multiple plot objects on a single plot we use the `gridExtra` package

```r
library(gridExtra)
grid.arrange(plot1, plot2, plot3, ncol = 3)
```

# DPLYR Functions

## Summarize

```r
library(tidyverse)
ageSummary <- dataFrame %>%
            summarize(median = median(age),
            minimum = min(age),
            maximum = max(height))
```

## Dot Placeholder

The dot placeholder allows us to access the data being piped into a series of functions

```r
names <- dataFrame %>% .$names
```

## Group By

This allows us to break data into two different sets which return a group data frame. This is like a table with the same columns but two separate sets of rows

```r
groupedData = dataFrame %>%
            + groupBy(catergoryName)
```

## Sorting Tables

In dplyr we have the arrange function that will allow us to order data by a single column or even multiple columns

```r
sortedData <- dataFrame %>% arrange(age, desc(weight))
```

We can view a part of the table with the `top_n` function as follows:

```r
sortedData %>% top_n(10, age)
```

# Data Faceting

To separate the data in our data sets based on some sort of catergorization without the need to make separate plots we can use the `facet_grid` function which requires our row vector and column vector separated by a `~`

```r
dataFrame %>% ggplot() + facet_grid(age~gender)
```

If we would like to use just one variable to differentiate we can use the dot placeholder

```r
dataFrame %>% ggplot() + facet_grid(.~gender)
```

If we want to be able to wrap our plots if we have many plots we use

```r
dataFrame %>% ggplot() + facet_wrap(~gender)
```

# Time Series Plots

If we want to plot multiple lines on a plot we need to tell ggplot to do this

```r
people %>% ggplot(aes(age, avgHeight, col = gender))
            + geom_line
```

# Transformations

We can tranform our data if we have some sort of logorithmc relationship making it easy to explore different datasets. However we have the ability to use a log scale or to log dataset

# Reorder

We can reorder Factors in a method other than the default which is alphabetical for a plot with the `reorder` function

# Encoding Data Using Visual Cues

Humans are not good at using angles or areas independently. Pie or Donut charts are ineffective ways to display information. By using length and position we can more effectively communicate information.

Brightness and colour are difficult to distinguish but can sometimes be useful for displaying more complex data

# When to Include Zero

With bar charts Zero sould be inluded as it makes it can be deceptive to exclude the origin. If it is the magnitude of the data that is impportant we should include the origin

However if what we are trying to show is variability within a group, then a more localised scale is more effective

# Do Not Distort Quantities

We should not make use of deceptive presentation when displaying data, ie we should prefer something like length over a visual using areas as these are esasier for us to understand

# Order Meaningfully

We should order by a meaningful value. We rarely will use alphabetical. Ordering by magnitude or median, min or max can be contribute towards more meaningful graphs

# Show the Data

It's useful to make use of tools like jitter and alpha blending to allow us to give an idea of our data distribution while showing the actual data points in a meaningful way

# Common Axes

When comparing data across plots we must be sure to keep the axes the same

Plots should be laid out in the perpendicular direction to the data when using it to compare multiple sets of data

# Slope Charts

Slope charts allow us to display change between a small number of points, this can be done with ggplot in an indirect fashion by using lines

# Bland-Altman Plot

Depicts the difference versus the average

# Encoding Additional Variables

We can use shape, colour, intensity, and size to additionally encode additional variable information into our graph

# Avoid 3D plots

Plots should always be made in 2D as far as possible

# Avoid too Many Significant Digits

The default behaviour in R is for a table is to show data up to 7 digits, this is not necessarily useful

We can specify our sifnificant figures with the `signif` and `round` functions

Alternatively the global digit count can be set by `options(digits = n)`
