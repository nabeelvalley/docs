[[toc]]

> [Based on this EdX Course](https://www.edx.org/course/data-science-inference)

# Inference

Inference is using information about a sample as being representative of the whole

# Parameters and Estimates

We can plot the results of a random 'election poll' draw with the following

```r
library(ggplot2)
library(tidyverse)
library(dslabs)

ds_theme_set()
take_poll(1000)
```

![Sample Election Poll](/content/docs/assets/voter-poll-sample-1.svg)

The goal of statistical inference is to predict the parameter $p$ using the observed data in the sample $n$

We would like to predict the portion of blue beads which is $p$, based on this we can identify the proportion of red beads and the spread

> Proportion of Red Beads

$$
1 - p
$$

> Spread

$$
p - (1 - p)
$$

$$
2p -1
$$

## The Sample Average

The sample average is the proportion of a certain perameter $p$ which is calculated as follows

$$
\bar{X} = \frac{X_1 + X_2 + X_3 + X_4 + ... + X_N}{n}
$$

In this case, the value of an individual $X$ is 1 if it is our outcome of interest, or 0 if not

## Polling vs Forecasting

A poll is taken at a specific time, but forecasting takes into consideration the fact that the probability will change in the future and therefore aims to predict the probability of some event at that time

## Properties of an Estimate

The Expected value of our estimate is the same as the parameter of interest $p$

> Expected Value

$$
E(\bar{X}) = p
$$

We can decrease our standard error by increasing our sample size as can be seen by

> Standard Error

$$
SE(\bar{X}) = \sqrt{p(1-p)/N}
$$

Due to the **Law of Large Numbers** we can know that our standard error will be smallest as we increase the sample size

# Central Limit Theorem in Practice

Suppose we want to know whether or not our estimate is sufficiently accurate \(i.e. the standard error\) but we do not know the actual probability? Well we can estimate that with the following

> Estimate of the Standard Error

$$
\hat{SE}(\bar{X}) = \sqrt{\bar{X}(1-\bar{X})/N}
$$

Using this we can see what the estimate for our probability being correct within 1% is by

```r
pnorm(0.01/se) - pnorm(-0.01/se)
```

## Margin of Error

The margin of error is two times the standard error, using this we can see that there is a 95% chance that we will be within two standard errors

## The Spread

Because we only have two parties we know The Spread can be estimated by

$$
d = 2\bar{X} -1
$$

Since we are multiplying a random variable by two the standard error of this new variable is also multiplied by two

$$
2\hat{SE}(\bar{X})
$$

## Bias

Polling is more complex than random selections as we do not necessarily know if we are reaching all groups equally. For example an internet poll may only be as accurate as that as we are excluding people without access to the internet

# Intervals and P-Values

Confidence intervals are the region in which we can have a 95% chance that $p$ will be within this range

$$
Pr(-2 \leq \frac{\bar{X}-p}{\hat{SE}(\bar{X})}\leq 2) \approx 0.95
$$

It is the intervals that are random, not $p$. The 95% relates to the probability that the random interval we selected contains $p$

## Power

Power can be thought of as the probability of detecting a spread different from zero

## P-Values

These are related to the confidence interval.

# Poll Aggregation

Poll aggregation is the task of combining the results of multiple polls to get an overall result which would be more accurate than each individual result

## Poll Data and Pollster Bias

We can run into differences between polls that do not seem to have expected values that are aligned. This can be known as Pollster Bias

## Data Driven Models

If we make use of a random selection of the different poll data, our standard error will now include pollster to pollster variability, this standard deviation is now an unknown parameter. Because we are still using independent random variables our CLT still works.

We can still however estimate the sample's standard deviation with the following

> Sample Standard Deviation

$$
s = \frac{1}{N-1} \sum_{i=1}^{N} (X_i - \bar{X})^2
$$

Using the `sd` function in R we can still calculate the sample standard deviation by making use of

```r
> sd(polls$spread)
```

# Bayesian Statistics

We speak about probability on the basis that the probability is not a fixed value.

## Bayes' Theorem

$$
PR(A|B) = \frac{Pr(A\space and \space B)}{Pr(B)}
$$

Or rather

$$
PR(A|B) = \frac{Pr(B|A)Pr(A)}{Pr(B)}
$$

## The Hierarchical Model

Provides a mathematical description for why results may not seem to correlate with what we expect. This takes into consideration subjective data, like an individual's ability to play a game, and then the associated randomness or luck

## Posterior Distribution

The probability distribution of $$p$$ where we have an observed distribution $$y$$

> Posterior Distribution

$$
E(p|y)=B\mu +(1-B)Y
$$

$$
E(p|y)=\mu + (1-B)(Y\mu)
$$

$$
B=\frac{\sigma^2}{\sigma^2+\tau^2}
$$

From this we can see that $$B$$ is close to one when $$\sigma$$ is larger

> Standard Error for Posterior Distribution

$$
SE(p|y)^2=\frac{1}{1/\sigma^2 + 1/\tau^2}
$$

This is known as an empirical Bayesian approach which is based on observed data. This will deliver a better confidence interval known as the _Bayesian Credible Interval_

Note that the posterior distribution is normally distributed

# Mathematical Representation of Models

Given a of polls from which we sample an random value from a random poll, we can describe the variability of that data with

$$
X_{i,j} = d + \epsilon_{i,j}
$$

Where $$\epsilon$$ is the an associated error value

In order to adjust this value for pollster to pollster variability we can make use of an adjustment based on the house bias

> House Bias Adjusted Sampling

$$
X_{i,j}=d + h_{i} + \epsilon_{i,j}
$$

In order to compensate for the general bias that may exist in all polls

> General Bias Adjusted

$$
X_{i,j}=d + b + h_{i} + \epsilon_{i,j}
$$

The reason we add these biases, though unknown, will have a significant effect on the standard deviation of our data

> Adjusted Average Value

$$
\bar{X} = d + b + \frac{1}{N}\sum_{i=1}^{N} X_i
$$

> Adjusted Standard Deviation

$$
\sqrt{\sigma^2/N+\sigma_b^2}
$$

Note that because the $$b$$ value is the same in every poll, this does not affect our variance

# Forecasting

Forecasting is about making predictions based on the variability of poll results over time.

> Time Variation in Model

$$
Y_{ijt} = d + b + h_i + b_t + \epsilon_{ijt}
$$

> Model Trend

$$
Y_{ijt} = d + b + h_i + b_t + f(t) + \epsilon_{ijt}
$$

# The T Distribution

Because we are introducing additional variability when estimating the $$\sigma$$ we result in over-confidence confidence intervals which are not sufficiently large to take into consideration this additional variability

> Confidence Interval

$$
Z = \frac{\bar{X}-d}{\sigma/\sqrt{N}}
$$

> Confidence Interval with $$s$$ instead of $$\sigma$$

$$
Z = \frac{\bar{X}-d}{s/\sqrt{N}}
$$

This theory tells us that $$Z$$ follows a t-distribution with $$N-1$$ degrees of freedom which controls the variability of our system. This holds for data which is still somewhat different from a normal distribution

# Chi Squared Test

Aims to calculate how likely it is that we see a deviation as large or larger than identified by chance, in the case of categorical or binary data
