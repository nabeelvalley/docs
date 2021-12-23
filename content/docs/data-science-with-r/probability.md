> [Based on this EdX Course](https://www.edx.org/course/data-science-probability)

# Configuration

Before starting the course make sure you install the library with the relevant datasets included

```r
install.packages("dslabs") 
library(dslabs)
```

From the dslabs library you can use the data sets as needed

# Discrete Probability

A subset of probability in which there are distinct possible outcomes, or categorical data. We can express this as

$$
Pr(A)
$$

## Monte Carlo Simulations

Computers allow us to mimic randomness, in R we can use the `sample` function to do this. We can first create a sample set, and from that select a random element. We use the repeat function to generate our elements

```r
> beads <- rep(c("red","blue"), times = c(2,3))
[1] "red"  "red"  "blue" "blue" "blue"
> sample(beads, 1)
[1] "red"
```

Next we can run this simulation repetively by usimg the replicate function

```r
> B <- 1000
> events <- replicate(B, sample(beads, 1))
> table(events)
    events
    blue  red 
    628  372
```

This method is useful for estimating the probability when we are unable to calculate it directly

The sample function works without replacement, if we want to use it with replacement we can set the replace argument to true, this will allow us to make the selection without the use of replicate

```r
> events <- sample(beads, 1000, replace = TRUE)
> table(events)
events
    blue  red 
    588  412
```

## Probability Distributions

For Catergorical data probability distribution is the same as the propportion of each value in the data set

## Independence

Events are Independent if the outcome of one event does not affect the outcom of the other

Hence the probability of A given B is the same as the probability of A for independant events

> if A and B are independent:

$$
Pr(A|B) = Pr(A)
$$

$$
Pr(A \& B) = Pr(A) Pr(B)
$$

## Combinations and Permutations

In order to review more complex calculations we can use R to calculate them, this can make use of the `expand.grid` function which will output all the combinations of two lists, and the paste function will combine two vectors

We can make use of this to define a deck of cards as follows

```r
> suits <- c("Diamonds", "Clubs", "Hearts", "Spades")
> numbers <- c("Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King")
> grid <- expand.grid(number = numbers, suit = suits)
> grid
      number  suit
    1     Ace Diamonds
    2     Two Diamonds
    3   Three Diamonds
    ...
    51  Queen   Spades
    52   King   Spades
> deck <- paste(grid$number, grid$suit)
> deck
    [1] "Ace Diamonds"   "Two Diamonds"   "Three Diamonds"
    [4] "Four Diamonds"  "Five Diamonds"  "Six Diamonds"  
    ...
    [49] "Ten Spades"     "Jack Spades"    "Queen Spades"  
    [52] "King Spades"
```

Now that we have a deck we can check the probaility that the first card drawn will be a certain value, we can do this by first defining a vector of kings and then checking what portion of the deck that is

```r
> kings <- paste("King", suits)
> mean(deck %in% kings)
[1] 0.07692308 # = 4 / 52
```

What if we want to find the likelihood of a specific permutation, e.g two consecutive kings, we can do this with the `permutaion` and `combination` functions

### permutations\(\)

This function computes for any list of size `n` all the different ways we can select `r` items

```r
> install.packages("gtools")
> library(gtools)
> permutations(5,2)
      [,1] [,2]
 [1,]    1    2
 [2,]    1    3
 [3,]    1    4
... 
[19,]    5    3
[20,]    5    4
```

If we want to use this using a specific vector from which we select our permutations we can do this with the `v` argument

```r
> hands <- permutations(52, 2, v = deck)
> hands
        [,1]             [,2]            
   [1,] "Ace Clubs"      "Ace Diamonds"  
   [2,] "Ace Clubs"      "Ace Hearts"    
   [3,] "Ace Clubs"      "Ace Spades"  
   ...
```

Thereafter we can look at which cases have a first card that is a king and the second card that is a king

```r
> first_card <- hands[,1]
> second_card <- hands[,2]
> mean(first_card %in%  kings & second_card %in% kings) / mean(first_card %in% kings)
[1] 0.05882353 # = 3/51
```

### combinations\(\)

This will not take into consideration the order of two events, but rather the overall result

```r
combinations(52, 2, v = deck)
```

## The Birthday Problem

We have 50 people and we want to find out the probability of at least two people sharing a birthday. We can do this by using the duplicated function which will return true for an element if that element has occurred previously

```r
> birthdays <- sample(1:365, 50, replace = TRUE)
> any(duplicated(birthdays))
[1] TRUE
```

We can simulate this many times with a Monte Carlo Simulation to find the probability numerically

```r
> results <- replicate(10000, 
        any(duplicated(sample(1:365, 50, replace = TRUE))))
> mean(results)
[1] 0.9703 # The probabilty of there being two people who share a birthday
```

Note that the replicate function can take multiple statements/lines in the function area with `{...}`

## sapply

What if we want to apply the above statements to a variety of different n values? We can defie the above as a function and then apply this to a different set of data

```r
compute <- function(n,  B = 1000){
      same_day <- replicate(B, {
          bdays <- sample(1:365, n, replace = TRUE)
        any(duplicated(bdays))
    })
    mean(same_day)
}
```

We can then use the `sapply` function to apply this function in an element-wise method \(basically turn our function into something more like an array map function\)

```r
> count <- 1:50
> probablilites <- sapply(count, compute)
 [1] 0.000 0.001 0.009 0.013 0.026 ...
> plot(probabilities)
```

![Plot of Estimated Probabilities](/docs/assets/birthdays.svg)

We can do this mathematically though with the following:

```text
Pr(1 is unique) = 1
Pr(2 is unique | 1 is unique) = 364/365
Pr(3 is unique | 1 and 2 is unique) = 363/365
...
```

We can then use the multiplicative rule to compute the final probability which is

```text
1 - (1 x 364/365 x 363/365 x ... x (365 - n  + 1)/365)
```

We can define a function that will compute this exactly for a given problem

```r
exact <- function(n){
    unique_prob <- seq(365, 365 - n + 1)/ 365
    1 - prod(unique_prob)
}
```

Thereafter we can use this and plot it comparatively

```text
> exactprobability - sapply(n, exact)
> plot(probabilities) lines(exact_probability, col = "red")
```

![Monte Carlo Approximation vs Actual Value](/docs/assets/birthdays-comparative.svg)

## Sample size

How many samples are enough? Basically when our estimate result starts to stabalize we can assume that we have a large enough number of experiments

## Addition Rule

The addition rule states that

$$
Pr(A or B) = Pr(A) + Pr(B) - Pr(A and B)
$$

# Continuous Probability

We make use of a Cumulative Probability Function to allow us to use continuous probabilities, this is because we need to verify whether a value falls within a certain range and not is a specific value

## Theoretical Distribution

The cumulative distribution for the Normal Distribution in R is defined by the `pnorm` function. We say that a random quantity is normally distributed as follows

```text
F(a) = pnorm(a, avg, s)
```

Based on the idea of continuous probability we make use of intervals instead of exact values, we can however run into the issue of discretization where although our measurement of interest is continious, our dataset is still discrete

## Probability Density

We can get the probability density function for a normal distribution with the `dnorm` function

## Normal Distributions

We can run Monte Carlo simulations on normally distributed data, we can use the `rnorm` function to get a normally distributed set of random values

```r
rnorm(n, avg, sd)
```

This is useful as it will allow us to generate normally distributed data to mimic naturally occuring data

## Other Continuous Distributions

R has other functions available for different distribution types, these are prefixed with the letters

* `d` for Density
* `q` for Quartile
* `p` for Probability Desnsity Function
* `r` for Random

# Random Variables

Random Variables are numeric outcomes resulting from a random process

## Sampling Models

We model the behavior of one system by using a simplified version of that system

## Notation

For random values we use Capital letters for random values

## Standard Error

This tells us the expected difference between an actual value and the expected value

$$
SE = \frac{SD}{\sqrt{n}}
$$

The variance is the square of the standard error

## Central Limit Theorem

When the sample size is large the probability distribution is approximately normal

Based on this we need only the average and standard deviation to find the expected probability distribution

## Law of Large Numbers

The standard error of a set of numbers decreases as the sample size increases, this is also known as _The Law of Averages_

## How Large is Large

The CLT can be useful even with relatively small data sets, but this is not the norm

In general, the larger the probability of success the smaller our sample size needs to be

