
> [Based on this EdX Course](https://www.edx.org/course/data-science-r-basics)

# Configuration

Before starting the course make sure you install the library with the relevant datasets included

```r
install.packages("dslabs")
library(dslabs)
```

From the dslabs library you can use the data sets as needed

# Objects

In order to store a value as a variable we use the assignment variable

```r
a <- 25
```

To display this object we can use

```r
print(a)
```

# Functions

A Data Analysis process is typically a series of functions applied to data

We can define a function in R using:

```r
myfunction <- function(arg1, arg2, ... ){
    statements
    return(object)
}
```

To Evaluate a function we use the parenthesis and arguments:

```r
log(a)
```

We can nest function calls inside of function arguments, for example:

```r
log((exp(a)))
```

To get help for a function we can use the following:

```r
?log
help("log")
```

We can enter function arguments in an order different to the default by using named arguments:

```r
log(x=5, base=3)
```

Otherwise the arguments are evaluated in order

# Comments

Commenting in R is done with the `#` symbol:

```r
# This is a comment
```

# Data Types

R makes use of different data types, in R we typically use _DataFrames_ to store data, these can store a mixture of different data types in a collection

To make use of DataFrames we need to import the `dslabs` library:

```r
library(dslabs)
```

To check the type of an object we an use

```r
class(object)
```

In order to view the structure of an object we can use

```r
str(object)
```

If we want to view the data in a DataFrame, we can use:

```r
head(dataFrame)
```

to Access a variable in an object we use the `$` accessesor, this preserves the rows in the DataFrame

`data$names` will list the names column of the DataFrame

In R we refer to the data points in our DataFrame or Matrix as _Vectors_

We can use the `==` as the logical operator

`Factors` allow us to store catergorical data, we can view the different catergories with the following:

```r
> class(dataFrame$gender) 
[1] Factor
> levels(dataFrame$gender) 
[2] "Male" "Female"
```

# Vectors

The most basic data unit in R is a `Vector`

To create a vector we can use the concatonate function with:

```r
codes <- c(380, 124, 818)
```

If we want to name the values we can do so as follows:

```r
codes <- c(italy=380, canada=124, egypt=818)
codes <- c("italy"=380, "canada"=124, "egypt"=818)
```

Getting a sequence of number we can use:

```r
> seq(1, 5)
[1] 1, 2, 3, 4, 5

> seq(1, 10, 2)
[1] 1, 3, 5, 7, 9
```

We can access an element of a vector with either a single access or multi-access vector as follows:

```r
> codes[3] 
[1] 818

> codes["canada"]
[2] 124

> codes["canada", "egypt"]
[3] 124 818

> codes[1:2]
[4] 380 124
```

# Vector Coercion

Coercion is an attempt by R to guess the type of a variable if it's of a different type of the rest of the values

```r
x <- c(1, "hello", 3)
[1] "1" "hello" "3"
```

If we want to force a coercion we can use the `as.character` function or `as.numeric` function as follows:

```r
> x <- 1:5
> y <- as.character(1:5)
> y
[1] "1" "2" "3" "4" "5"
> as.numeric(y)
[2] 1 2 3 4 5
```

If R is unable to coerse a value it will result in `NA` which is very common with data sets as it refers to missing data

# Sorting

The `sort` function will sort a vector in increasing order, however this gives us no relation to the positions of that data. We can use the `order` function to reuturn the index of the values that are sorted

```r
> x
[1] 31 4 15 92 65

> sort(x)
[2] 4 15 31 65 92

> order(x)
[3] 2 3 1 5 4
```

The entries of vectors that the vectors are ordered by correspond to their rows in the DataFrame, therefore we can order one row by another

```r
index <- order(data.total)
data$name[index]
```

To get the max or min value we can use:

```r
max(data$total) # maximum value
which.max(data$total) # index of maximum value

min(data$total) # minimum value
which.min(data$total) # index of minimum value
```

The `rank` function will return the index of the sizes of the vectors

# Vector Aritmetic

Aritmetic operations occur element-wise

If we operate with a single value the operation will work per element, however if we do this with two vectors, we will add it element-wise, `v3 <- v1 + v2` will mean `v3[1] <- v1[1] + v2[1]` and so on

# Indexing

R provides ways to index vectors based on properties on another vector, this allows us to make use of logical comparators, etc.

```r
> large_tots <- data$total > 200
[1] TRUE TRUE FALSE TRUE FALSE

> small_size <- data$size < 20
[2] FALSE TRUE TRUE TRUE FALSE

index <- large_tots && small_size
[3] FALSE TRUE FALSE TRUE FALSE
```

# Indexing Functinos

* `which` will give us the indexes which are true `which(data$total > 200)` this will only return the values that are true
* `match` returns the values in one vector where another occurs `match(c(20, 14, 5), data$size)` will return only the values in which data$size == 20 \|\| 14 \|\| 5
* `%in%` if we want to check if the contents of a vector are in another vector, for example: 

```r
> x <- c("a", "b", "c", "d", "e")
> y <- c("a", "d", "f")
> y %in% x
[1] TRUE, TRUE, FALSE
```

These functions are very useful for subsetting datasets

# Data Wrangling

The `dplyr` package is useful for manipulating tables of data

* Add or change a column with `mutate`
* Filter data by rows with `filter`
* Filter data by columns with `select`

```r
mutate(data, rate=total/size) # Add rate column based on two other columns

select(data, name, rate) # Will create a new table with only the name and rate columns

filter(data, rate <= 0.7) # Will filter out the rows where the rate expression is true
```

We can combine functions using the pipe operator:

```r
dataTable %>% select(name, rate) %>% filter(rate <= 0.7)
```

# Creating Data Frames

we can create a data frame with the `data.frame` function as follows:

```r
data <- data.frame(names = c("John","James", "Jenny"), 
                   exam_1 = c(90, 29, 45),
                   exam_2 = c(30, 10, 95))
```

Howewever, by default R will pass strings as Factors, to prevent this we use the `stringsAsFactors` argument:

```r
data <- data.frame(names = c("John","James", "Jenny"), 
                   exam_1 = c(90, 29, 45),
                   exam_2 = c(30, 10, 95),
                   stringsAsFactors = FALSE)
```

# Basic Plots

We can make simple plots very easily with the following functions:

* `plot(dataFrame$size, data$rate)`
* `lines(dataFrame$size, data$rate)`
* `hist(dataFrame$size)`
* `boxplot(rate~catergory, data=dataFrame)`

# Programming Basics

# Conditionals

```r
# Can evalutate all elements of a vector
if (test_expression) {
    statement1
} else {
    statement2
}

# Will reuturn a result
ifelse(comparison, trueReturn, falseReturn)

# Will return true if any value in vector meets condition
any(condition)

# Will return true if all values meet condition
all(condition)
```

# Functions

Functions in R are objects, if we need to write a function in R we can do this wth the following:

```r
myfunction <- function(arg1, arg2, optional=TRUE ){
    statements
    return(object)
}
```

This will make use of the usual lexical scoping

# For Loops

```r
for (i in sequence) {
    statements
}
```

At the end of our loop the index value will hold it's last value

# Other Functions

In R we rarely use for-loops We can use other functions like the following:

* apply
* sapply
* tapply
* mapply

Other functions that are widely used are:

* split
* cut
* quantile
* reduce
* identical
* unique

