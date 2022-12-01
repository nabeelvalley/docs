[[toc]]

# Data Analysis With Python

[Based on this Cognitive Class Course](https://cognitiveclass.ai/courses/data-analysis-python/)

## Labs

The Labs for the course are located in the `Labs` folder are from CognitiveClass and are licensed under MIT

## Introduction

The data being analysed will be based on a used-car analysis and how to estimate the price of a used car based on its characteristics

- Dataset to be analyzed in Python
- Overview of Python Packages
- Importing and Exporting Data
- Basic Insights from the Data

### Understanding the Data

Thhe Data being used is the Autos dataset from the Machine Learning Database at [archive.ics.uci](https://archive.ics.uci.edu/ml/machine-learning-databases/autos/)

The first few lines of the file are as follows

[`imports-85.data`](https://archive.ics.uci.edu/ml/machine-learning-databases/autos/imports-85.data)

```
3,?,alfa-romero,gas,std,two,convertible,rwd,front,88.60,168.80,64.10,48.80,2548,dohc,four,130,mpfi,3.47,2.68,9.00,111,5000,21,27,13495
3,?,alfa-romero,gas,std,two,convertible,rwd,front,88.60,168.80,64.10,48.80,2548,dohc,four,130,mpfi,3.47,2.68,9.00,111,5000,21,27,16500
1,?,alfa-romero,gas,std,two,hatchback,rwd,front,94.50,171.20,65.50,52.40,2823,ohcv,six,152,mpfi,2.68,3.47,9.00,154,5000,19,26,16500
2,164,audi,gas,std,four,sedan,fwd,front,99.80,176.60,66.20,54.30,2337,ohc,four,109,mpfi,3.19,3.40,10.00,102,5500,24,30,13950
2,164,audi,gas,std,four,sedan,4wd,front,99.40,176.60,66.40,54.30,2824,ohc,five,136,mpfi,3.19,3.40,8.00,115,5500,18,22,17450
2,?,audi,gas,std,two,sedan,fwd,front,99.80,177.30,66.30,53.10,2507,ohc,five,136,mpfi,3.19,3.40,8.50,110,5500,19,25,15250
1,158,audi,gas,std,four,sedan,fwd,front,105.80,192.70,71.40,55.70,2844,ohc,five,136,mpfi,3.19,3.40,8.50,110,5500,19,25,17710
1,?,audi,gas,std,four,wagon,fwd,front,105.80,192.70,71.40,55.70,2954,ohc,five,136,mpfi,3.19,3.40,8.50,110,5500,19,25,18920
```

And the [description of the data can be found here](https://archive.ics.uci.edu/ml/machine-learning-databases/autos/imports-85.names), the attributes are as follows

| Column | Attribute          | Attribute Range                                                                                                                                                                                |
| ------ | ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.     | symboling:         | -3, -2, -1, 0, 1, 2, 3.                                                                                                                                                                        |
| 2.     | normalized-losses: | continuous from 65 to 256.                                                                                                                                                                     |
| 3.     | make:              | alfa-romero, audi, bmw, chevrolet, dodge, honda, isuzu, jaguar, mazda, mercedes-benz, mercury, mitsubishi, nissan, peugot, plymouth, porsche, renault, saab, subaru, toyota, volkswagen, volvo |
| 4.     | fuel-type:         | diesel, gas.                                                                                                                                                                                   |
| 5.     | aspiration:        | std, turbo.                                                                                                                                                                                    |
| 6.     | num-of-doors:      | four, two.                                                                                                                                                                                     |
| 7.     | body-style:        | hardtop, wagon, sedan, hatchback, convertible.                                                                                                                                                 |
| 8.     | drive-wheels:      | 4wd, fwd, rwd.                                                                                                                                                                                 |
| 9.     | engine-location:   | front, rear.                                                                                                                                                                                   |
| 10.    | wheel-base:        | continuous from 86.6 120.9.                                                                                                                                                                    |
| 11.    | length:            | continuous from 141.1 to 208.1.                                                                                                                                                                |
| 12.    | width:             | continuous from 60.3 to 72.3.                                                                                                                                                                  |
| 13.    | height:            | continuous from 47.8 to 59.8.                                                                                                                                                                  |
| 14.    | curb-weight:       | continuous from 1488 to 4066.                                                                                                                                                                  |
| 15.    | engine-type:       | dohc, dohcv, l, ohc, ohcf, ohcv, rotor.                                                                                                                                                        |
| 16.    | num-of-cylinders:  | eight, five, four, six, three, twelve, two.                                                                                                                                                    |
| 17.    | engine-size:       | continuous from 61 to 326.                                                                                                                                                                     |
| 18.    | fuel-system:       | 1bbl, 2bbl, 4bbl, idi, mfi, mpfi, spdi, spfi.                                                                                                                                                  |
| 19.    | bore:              | continuous from 2.54 to 3.94.                                                                                                                                                                  |
| 20.    | stroke:            | continuous from 2.07 to 4.17.                                                                                                                                                                  |
| 21.    | compression-ratio: | continuous from 7 to 23.                                                                                                                                                                       |
| 22.    | horsepower:        | continuous from 48 to 288.                                                                                                                                                                     |
| 23.    | peak-rpm:          | continuous from 4150 to 6600.                                                                                                                                                                  |
| 24.    | city-mpg:          | continuous from 13 to 49.                                                                                                                                                                      |
| 25.    | highway-mpg:       | continuous from 16 to 54.                                                                                                                                                                      |
| 26.    | price:             | continuous from 5118 to 45400.                                                                                                                                                                 |

Missing Attribute Values: (denoted by "?")

The _Symboling_ is an indicator of the vehicle risk level, the lower the level the lower the risk (from an insurance level)

The _normalized-losses_ is an indicator of the rate at which the vehicle loses value over time

The _price_ is the value that we would like to predict given the other features

> Note that this dataset is from 1995 and therefore the prices may seem a little low

### Python Libraries

#### Scientific Computing Libraries

##### Pandas

Pandas is a library for working with Data Structures, primarily DataFrames

##### NumPy

NumPy is a library for working with Arrays and Matrices

##### SciPy

SciPy includes functions for assisting in mathematical analysis as well as some basic visualizations

#### Visualization

##### Matplotlib

Matplotlib is the most commonly used Python library for data visualization

##### Seaborn

Seaborn is based on Matplotlib and provides functionality such as heat maps, time series, and viollin plots

#### Algorithmic Libraries

##### Scikit-learn

Machine learning, regression, classification,etc.

##### Statsmodels

Explore data, estimate statistical models, and perform statistical tests

### Import and Export Data

#### Importing

When importing data we need ot take a few things into consideration such as

- Format
- File source/path

In our case the data is CSV (.data), and is located as a remote source

We can import our data as follows

```python
import pandas as pd
import numpy as np
```

```python
# read the online file by the URL provides above, and assign it to variable "df"
path="https://archive.ics.uci.edu/ml/machine-learning-databases/autos/imports-85.data"

df = pd.read_csv(path,header=None)

print("import done")
```

    import done

```python
df.head(2)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
      <th>7</th>
      <th>8</th>
      <th>9</th>
      <th>...</th>
      <th>16</th>
      <th>17</th>
      <th>18</th>
      <th>19</th>
      <th>20</th>
      <th>21</th>
      <th>22</th>
      <th>23</th>
      <th>24</th>
      <th>25</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>?</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>130</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000</td>
      <td>21</td>
      <td>27</td>
      <td>13495</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>?</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>130</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000</td>
      <td>21</td>
      <td>27</td>
      <td>16500</td>
    </tr>
  </tbody>
</table>
<p>2 rows × 26 columns</p>
</div>

We can see that our data comes in without headers, we can assign the headers to our data based on the information in the `imports-85.names` file

```python
headers = ['symboling','normalized-losses','make','fuel-type','aspiration', 'num-of-doors','body-style',
         'drive-wheels','engine-location','wheel-base', 'length','width','height','curb-weight','engine-type',
         'num-of-cylinders', 'engine-size','fuel-system','bore','stroke','compression-ratio','horsepower',
         'peak-rpm','city-mpg','highway-mpg','price']
df.columns = headers
```

```python
df.head(10)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>fuel-type</th>
      <th>aspiration</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>...</th>
      <th>engine-size</th>
      <th>fuel-system</th>
      <th>bore</th>
      <th>stroke</th>
      <th>compression-ratio</th>
      <th>horsepower</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>?</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>130</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000</td>
      <td>21</td>
      <td>27</td>
      <td>13495</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>?</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>130</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000</td>
      <td>21</td>
      <td>27</td>
      <td>16500</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>?</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>hatchback</td>
      <td>rwd</td>
      <td>front</td>
      <td>94.5</td>
      <td>...</td>
      <td>152</td>
      <td>mpfi</td>
      <td>2.68</td>
      <td>3.47</td>
      <td>9.0</td>
      <td>154</td>
      <td>5000</td>
      <td>19</td>
      <td>26</td>
      <td>16500</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>...</td>
      <td>109</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>10.0</td>
      <td>102</td>
      <td>5500</td>
      <td>24</td>
      <td>30</td>
      <td>13950</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.4</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.0</td>
      <td>115</td>
      <td>5500</td>
      <td>18</td>
      <td>22</td>
      <td>17450</td>
    </tr>
    <tr>
      <th>5</th>
      <td>2</td>
      <td>?</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.5</td>
      <td>110</td>
      <td>5500</td>
      <td>19</td>
      <td>25</td>
      <td>15250</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1</td>
      <td>158</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>105.8</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.5</td>
      <td>110</td>
      <td>5500</td>
      <td>19</td>
      <td>25</td>
      <td>17710</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1</td>
      <td>?</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>wagon</td>
      <td>fwd</td>
      <td>front</td>
      <td>105.8</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.5</td>
      <td>110</td>
      <td>5500</td>
      <td>19</td>
      <td>25</td>
      <td>18920</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1</td>
      <td>158</td>
      <td>audi</td>
      <td>gas</td>
      <td>turbo</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>105.8</td>
      <td>...</td>
      <td>131</td>
      <td>mpfi</td>
      <td>3.13</td>
      <td>3.40</td>
      <td>8.3</td>
      <td>140</td>
      <td>5500</td>
      <td>17</td>
      <td>20</td>
      <td>23875</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0</td>
      <td>?</td>
      <td>audi</td>
      <td>gas</td>
      <td>turbo</td>
      <td>two</td>
      <td>hatchback</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.5</td>
      <td>...</td>
      <td>131</td>
      <td>mpfi</td>
      <td>3.13</td>
      <td>3.40</td>
      <td>7.0</td>
      <td>160</td>
      <td>5500</td>
      <td>16</td>
      <td>22</td>
      <td>?</td>
    </tr>
  </tbody>
</table>
<p>10 rows × 26 columns</p>
</div>

Next we can remove the missing values from the price column as follows

#### Analyzing Data

Pandas has a few different methods to undertand the data

We need to do some basic checks such as

- Data Types
  - Pandas automatically assigns data types which may not necessarily be correct
  - This will further allow us to understand what functions we can apply to what columns

```python
df.dtypes
```

    symboling              int64
    normalized-losses     object
    make                  object
    fuel-type             object
    aspiration            object
    num-of-doors          object
    body-style            object
    drive-wheels          object
    engine-location       object
    wheel-base           float64
    length               float64
    width                float64
    height               float64
    curb-weight            int64
    engine-type           object
    num-of-cylinders      object
    engine-size            int64
    fuel-system           object
    bore                  object
    stroke                object
    compression-ratio    float64
    horsepower            object
    peak-rpm              object
    city-mpg               int64
    highway-mpg            int64
    price                 object
    dtype: object

We can also view the statisitcal summary as follows

```python
df.describe()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>wheel-base</th>
      <th>length</th>
      <th>width</th>
      <th>height</th>
      <th>curb-weight</th>
      <th>engine-size</th>
      <th>compression-ratio</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.834146</td>
      <td>98.756585</td>
      <td>174.049268</td>
      <td>65.907805</td>
      <td>53.724878</td>
      <td>2555.565854</td>
      <td>126.907317</td>
      <td>10.142537</td>
      <td>25.219512</td>
      <td>30.751220</td>
    </tr>
    <tr>
      <th>std</th>
      <td>1.245307</td>
      <td>6.021776</td>
      <td>12.337289</td>
      <td>2.145204</td>
      <td>2.443522</td>
      <td>520.680204</td>
      <td>41.642693</td>
      <td>3.972040</td>
      <td>6.542142</td>
      <td>6.886443</td>
    </tr>
    <tr>
      <th>min</th>
      <td>-2.000000</td>
      <td>86.600000</td>
      <td>141.100000</td>
      <td>60.300000</td>
      <td>47.800000</td>
      <td>1488.000000</td>
      <td>61.000000</td>
      <td>7.000000</td>
      <td>13.000000</td>
      <td>16.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.000000</td>
      <td>94.500000</td>
      <td>166.300000</td>
      <td>64.100000</td>
      <td>52.000000</td>
      <td>2145.000000</td>
      <td>97.000000</td>
      <td>8.600000</td>
      <td>19.000000</td>
      <td>25.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1.000000</td>
      <td>97.000000</td>
      <td>173.200000</td>
      <td>65.500000</td>
      <td>54.100000</td>
      <td>2414.000000</td>
      <td>120.000000</td>
      <td>9.000000</td>
      <td>24.000000</td>
      <td>30.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2.000000</td>
      <td>102.400000</td>
      <td>183.100000</td>
      <td>66.900000</td>
      <td>55.500000</td>
      <td>2935.000000</td>
      <td>141.000000</td>
      <td>9.400000</td>
      <td>30.000000</td>
      <td>34.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>3.000000</td>
      <td>120.900000</td>
      <td>208.100000</td>
      <td>72.300000</td>
      <td>59.800000</td>
      <td>4066.000000</td>
      <td>326.000000</td>
      <td>23.000000</td>
      <td>49.000000</td>
      <td>54.000000</td>
    </tr>
  </tbody>
</table>
</div>

However, if we want to view a summary including fields that are of type objectm we can do the following

```python
df.describe(include = "all")
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>fuel-type</th>
      <th>aspiration</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>...</th>
      <th>engine-size</th>
      <th>fuel-system</th>
      <th>bore</th>
      <th>stroke</th>
      <th>compression-ratio</th>
      <th>horsepower</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>205.000000</td>
      <td>205</td>
      <td>205</td>
      <td>205</td>
      <td>205</td>
      <td>205</td>
      <td>205</td>
      <td>205</td>
      <td>205</td>
      <td>205.000000</td>
      <td>...</td>
      <td>205.000000</td>
      <td>205</td>
      <td>205</td>
      <td>205</td>
      <td>205.000000</td>
      <td>205</td>
      <td>205</td>
      <td>205.000000</td>
      <td>205.000000</td>
      <td>205</td>
    </tr>
    <tr>
      <th>unique</th>
      <td>NaN</td>
      <td>52</td>
      <td>22</td>
      <td>2</td>
      <td>2</td>
      <td>3</td>
      <td>5</td>
      <td>3</td>
      <td>2</td>
      <td>NaN</td>
      <td>...</td>
      <td>NaN</td>
      <td>8</td>
      <td>39</td>
      <td>37</td>
      <td>NaN</td>
      <td>60</td>
      <td>24</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>187</td>
    </tr>
    <tr>
      <th>top</th>
      <td>NaN</td>
      <td>?</td>
      <td>toyota</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>NaN</td>
      <td>...</td>
      <td>NaN</td>
      <td>mpfi</td>
      <td>3.62</td>
      <td>3.40</td>
      <td>NaN</td>
      <td>68</td>
      <td>5500</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>?</td>
    </tr>
    <tr>
      <th>freq</th>
      <td>NaN</td>
      <td>41</td>
      <td>32</td>
      <td>185</td>
      <td>168</td>
      <td>114</td>
      <td>96</td>
      <td>120</td>
      <td>202</td>
      <td>NaN</td>
      <td>...</td>
      <td>NaN</td>
      <td>94</td>
      <td>23</td>
      <td>20</td>
      <td>NaN</td>
      <td>19</td>
      <td>37</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>4</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.834146</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>98.756585</td>
      <td>...</td>
      <td>126.907317</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>10.142537</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>25.219512</td>
      <td>30.751220</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>std</th>
      <td>1.245307</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>6.021776</td>
      <td>...</td>
      <td>41.642693</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>3.972040</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>6.542142</td>
      <td>6.886443</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>min</th>
      <td>-2.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>86.600000</td>
      <td>...</td>
      <td>61.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>7.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>13.000000</td>
      <td>16.000000</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>94.500000</td>
      <td>...</td>
      <td>97.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>8.600000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>19.000000</td>
      <td>25.000000</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>97.000000</td>
      <td>...</td>
      <td>120.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>9.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>24.000000</td>
      <td>30.000000</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>102.400000</td>
      <td>...</td>
      <td>141.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>9.400000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>30.000000</td>
      <td>34.000000</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>max</th>
      <td>3.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>120.900000</td>
      <td>...</td>
      <td>326.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>23.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>49.000000</td>
      <td>54.000000</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>11 rows × 26 columns</p>
</div>

We can also use `df.info` to see the top and bottom thirty rows of the dataframe

If we would like to get a more complete report of the dataset however, we can make use of the `pandas_profiling` library which will output a full overall data visualisation

```python
import pandas as pd
import pandas_profiling
pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/planets.csv').profile_report()
```

## Preprocessing Data

Data preprocessing is the process of cleaning the data in order to get data from its raw form to a more usable format

This can include different stages such as

- Missing value handling
- Data formatting
- Data normalization
- Data binning
- Turning categorical values into numerical values

### Missing Values

When no data value is stored for a specific feature in an obsevation

Missing data can be represented in many different ways such as ?, N/A, 0 or blank among other ways

In our dataset normalized losses are represented as NaA

We can deal with missing values in a variety of ways

- Check if the correct data can be found
- Drop the feature
- Drop the data entry
- Replace with average or similar datapoints
- Replace with most common value
- Replace based on knowledge about data
- Leave the data as missing data

Dropping missing data can be done with the `df.dropna()` function, since we have missing values in the price column, which means those rows will need to be dropped

We also need to make use of the `inplace=True` parameter to modify the actual dataframe

The `df.replace()` function allows us to replace missing values in the data

```python
df.replace("?", np.nan, inplace = True)
df.head(10)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>fuel-type</th>
      <th>aspiration</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>...</th>
      <th>engine-size</th>
      <th>fuel-system</th>
      <th>bore</th>
      <th>stroke</th>
      <th>compression-ratio</th>
      <th>horsepower</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>NaN</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>130</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000</td>
      <td>21</td>
      <td>27</td>
      <td>13495</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>NaN</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>130</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000</td>
      <td>21</td>
      <td>27</td>
      <td>16500</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>NaN</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>hatchback</td>
      <td>rwd</td>
      <td>front</td>
      <td>94.5</td>
      <td>...</td>
      <td>152</td>
      <td>mpfi</td>
      <td>2.68</td>
      <td>3.47</td>
      <td>9.0</td>
      <td>154</td>
      <td>5000</td>
      <td>19</td>
      <td>26</td>
      <td>16500</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>...</td>
      <td>109</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>10.0</td>
      <td>102</td>
      <td>5500</td>
      <td>24</td>
      <td>30</td>
      <td>13950</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.4</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.0</td>
      <td>115</td>
      <td>5500</td>
      <td>18</td>
      <td>22</td>
      <td>17450</td>
    </tr>
    <tr>
      <th>5</th>
      <td>2</td>
      <td>NaN</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.5</td>
      <td>110</td>
      <td>5500</td>
      <td>19</td>
      <td>25</td>
      <td>15250</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1</td>
      <td>158</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>105.8</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.5</td>
      <td>110</td>
      <td>5500</td>
      <td>19</td>
      <td>25</td>
      <td>17710</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1</td>
      <td>NaN</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>wagon</td>
      <td>fwd</td>
      <td>front</td>
      <td>105.8</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.5</td>
      <td>110</td>
      <td>5500</td>
      <td>19</td>
      <td>25</td>
      <td>18920</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1</td>
      <td>158</td>
      <td>audi</td>
      <td>gas</td>
      <td>turbo</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>105.8</td>
      <td>...</td>
      <td>131</td>
      <td>mpfi</td>
      <td>3.13</td>
      <td>3.40</td>
      <td>8.3</td>
      <td>140</td>
      <td>5500</td>
      <td>17</td>
      <td>20</td>
      <td>23875</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0</td>
      <td>NaN</td>
      <td>audi</td>
      <td>gas</td>
      <td>turbo</td>
      <td>two</td>
      <td>hatchback</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.5</td>
      <td>...</td>
      <td>131</td>
      <td>mpfi</td>
      <td>3.13</td>
      <td>3.40</td>
      <td>7.0</td>
      <td>160</td>
      <td>5500</td>
      <td>16</td>
      <td>22</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>10 rows × 26 columns</p>
</div>

Next, we can count the missing value in each column

```python
missing_data = df.isnull()
missing_data.head(5)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>fuel-type</th>
      <th>aspiration</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>...</th>
      <th>engine-size</th>
      <th>fuel-system</th>
      <th>bore</th>
      <th>stroke</th>
      <th>compression-ratio</th>
      <th>horsepower</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>False</td>
      <td>True</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>1</th>
      <td>False</td>
      <td>True</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2</th>
      <td>False</td>
      <td>True</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>3</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>4</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 26 columns</p>
</div>

```python
for column in missing_data.columns.values.tolist():
    print(column)
    print (missing_data[column].value_counts())
    print('')
```

    symboling
    False    205
    Name: symboling, dtype: int64

    normalized-losses
    False    164
    True      41
    Name: normalized-losses, dtype: int64

    make
    False    205
    Name: make, dtype: int64

    fuel-type
    False    205
    Name: fuel-type, dtype: int64

    aspiration
    False    205
    Name: aspiration, dtype: int64

    num-of-doors
    False    203
    True       2
    Name: num-of-doors, dtype: int64

    body-style
    False    205
    Name: body-style, dtype: int64

    drive-wheels
    False    205
    Name: drive-wheels, dtype: int64

    engine-location
    False    205
    Name: engine-location, dtype: int64

    wheel-base
    False    205
    Name: wheel-base, dtype: int64

    length
    False    205
    Name: length, dtype: int64

    width
    False    205
    Name: width, dtype: int64

    height
    False    205
    Name: height, dtype: int64

    curb-weight
    False    205
    Name: curb-weight, dtype: int64

    engine-type
    False    205
    Name: engine-type, dtype: int64

    num-of-cylinders
    False    205
    Name: num-of-cylinders, dtype: int64

    engine-size
    False    205
    Name: engine-size, dtype: int64

    fuel-system
    False    205
    Name: fuel-system, dtype: int64

    bore
    False    201
    True       4
    Name: bore, dtype: int64

    stroke
    False    201
    True       4
    Name: stroke, dtype: int64

    compression-ratio
    False    205
    Name: compression-ratio, dtype: int64

    horsepower
    False    203
    True       2
    Name: horsepower, dtype: int64

    peak-rpm
    False    203
    True       2
    Name: peak-rpm, dtype: int64

    city-mpg
    False    205
    Name: city-mpg, dtype: int64

    highway-mpg
    False    205
    Name: highway-mpg, dtype: int64

    price
    False    201
    True       4
    Name: price, dtype: int64

We'll replace the missing data as follows

- Replace by Mean
  - "normalized-losses": 41 missing data
  - "stroke": 4 missing data
  - "bore": 4 missing data
  - "horsepower": 2 missing data
  - "peak-rpm": 2 missing data
- Replace by Frequency
  - "num-of-doors": 2 missing data
    - Becase most cars have 4 doors
- Drop the Roe
  - "price": 4 missing data
    - Because price is what we want to predict, it does not help if it is not there

#### Normalized Losses

```python
avg_1 = df['normalized-losses'].astype('float').mean(axis = 0)
df['normalized-losses'].replace(np.nan, avg_1, inplace = True)
```

#### Bore

```python
avg_2=df['bore'].astype('float').mean(axis=0)
df['bore'].replace(np.nan, avg_2, inplace= True)
```

#### Stroke

```python
avg_3 = df["stroke"].astype("float").mean(axis = 0)
df["stroke"].replace(np.nan, avg_3, inplace = True)
```

#### Horsepower

```python
avg_4=df['horsepower'].astype('float').mean(axis=0)
df['horsepower'].replace(np.nan, avg_4, inplace= True)
```

#### Peak RPM

```python
avg_5=df['peak-rpm'].astype('float').mean(axis=0)
df['peak-rpm'].replace(np.nan, avg_5, inplace= True)
```

#### Number of Doors

First we need to check which door count is the most common

```python
df['num-of-doors'].value_counts()
```

    four    114
    two      89
    Name: num-of-doors, dtype: int64

And then replace invalid values with that

```python
df["num-of-doors"].replace(np.nan, "four", inplace = True)
```

#### Price

And then lastly drop the columns with a missing price

```python
df.dropna(subset=["price"], axis=0, inplace = True)

# reset index, because we droped two rows
df.reset_index(drop = True, inplace = True)
```

#### Clean Data

The we can view our dataset which has no missing values

```python
df.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>fuel-type</th>
      <th>aspiration</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>...</th>
      <th>engine-size</th>
      <th>fuel-system</th>
      <th>bore</th>
      <th>stroke</th>
      <th>compression-ratio</th>
      <th>horsepower</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>130</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000</td>
      <td>21</td>
      <td>27</td>
      <td>13495</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>130</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000</td>
      <td>21</td>
      <td>27</td>
      <td>16500</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>hatchback</td>
      <td>rwd</td>
      <td>front</td>
      <td>94.5</td>
      <td>...</td>
      <td>152</td>
      <td>mpfi</td>
      <td>2.68</td>
      <td>3.47</td>
      <td>9.0</td>
      <td>154</td>
      <td>5000</td>
      <td>19</td>
      <td>26</td>
      <td>16500</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>...</td>
      <td>109</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>10.0</td>
      <td>102</td>
      <td>5500</td>
      <td>24</td>
      <td>30</td>
      <td>13950</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.4</td>
      <td>...</td>
      <td>136</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.0</td>
      <td>115</td>
      <td>5500</td>
      <td>18</td>
      <td>22</td>
      <td>17450</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 26 columns</p>
</div>

### Formatting Data

Now we nee to ensure that our data is correctly formatted

- Data is usually collected in different places and stored in different formats
- Bringing data into a common standard allows for more meaningful comparison

In order to format data, Pandas comes with some tool for us to use

We can also apply mathematical to our data as well as type conversions and column renames

Sometimes the incorrect data type may be set by default to the correct type, it may be necessary for us to convert our data to the correct type for analysis. We can convert datatypes using the `df.astype()` function, and check types with `df.dtypes`

#### Data Types

```python
df.dtypes
```

    symboling              int64
    normalized-losses     object
    make                  object
    fuel-type             object
    aspiration            object
    num-of-doors          object
    body-style            object
    drive-wheels          object
    engine-location       object
    wheel-base           float64
    length               float64
    width                float64
    height               float64
    curb-weight            int64
    engine-type           object
    num-of-cylinders      object
    engine-size            int64
    fuel-system           object
    bore                  object
    stroke                object
    compression-ratio    float64
    horsepower            object
    peak-rpm              object
    city-mpg               int64
    highway-mpg            int64
    price                 object
    dtype: object

#### Convert types

We can easily convert our data to the correct types with

```python
df[['bore', 'stroke']] = df[['bore', 'stroke']].astype('float')
df[['normalized-losses']] = df[['normalized-losses']].astype('int')
df[['price']] = df[['price']].astype('float')
df[['peak-rpm']] = df[['peak-rpm']].astype('float')
```

And view the corrected types

```python
df.dtypes
```

    symboling              int64
    normalized-losses      int64
    make                  object
    fuel-type             object
    aspiration            object
    num-of-doors          object
    body-style            object
    drive-wheels          object
    engine-location       object
    wheel-base           float64
    length               float64
    width                float64
    height               float64
    curb-weight            int64
    engine-type           object
    num-of-cylinders      object
    engine-size            int64
    fuel-system           object
    bore                 float64
    stroke               float64
    compression-ratio    float64
    horsepower            object
    peak-rpm             float64
    city-mpg               int64
    highway-mpg            int64
    price                float64
    dtype: object

#### Standardization

Standardization is the process of taking data from one format to another that may be more meaningful for us to use, such as converting our fuel consumption

```python
# transform mpg to L/100km by mathematical operation (235 divided by mpg)
df['city-L/100km'] = 235/df['city-mpg']
df[['city-mpg','city-L/100km']].head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>city-mpg</th>
      <th>city-L/100km</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>21</td>
      <td>11.190476</td>
    </tr>
    <tr>
      <th>1</th>
      <td>21</td>
      <td>11.190476</td>
    </tr>
    <tr>
      <th>2</th>
      <td>19</td>
      <td>12.368421</td>
    </tr>
    <tr>
      <th>3</th>
      <td>24</td>
      <td>9.791667</td>
    </tr>
    <tr>
      <th>4</th>
      <td>18</td>
      <td>13.055556</td>
    </tr>
  </tbody>
</table>
</div>

```python
df.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>fuel-type</th>
      <th>aspiration</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>...</th>
      <th>fuel-system</th>
      <th>bore</th>
      <th>stroke</th>
      <th>compression-ratio</th>
      <th>horsepower</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
      <th>city-L/100km</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000.0</td>
      <td>21</td>
      <td>27</td>
      <td>13495.0</td>
      <td>11.190476</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>mpfi</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000.0</td>
      <td>21</td>
      <td>27</td>
      <td>16500.0</td>
      <td>11.190476</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>hatchback</td>
      <td>rwd</td>
      <td>front</td>
      <td>94.5</td>
      <td>...</td>
      <td>mpfi</td>
      <td>2.68</td>
      <td>3.47</td>
      <td>9.0</td>
      <td>154</td>
      <td>5000.0</td>
      <td>19</td>
      <td>26</td>
      <td>16500.0</td>
      <td>12.368421</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>...</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>10.0</td>
      <td>102</td>
      <td>5500.0</td>
      <td>24</td>
      <td>30</td>
      <td>13950.0</td>
      <td>9.791667</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.4</td>
      <td>...</td>
      <td>mpfi</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.0</td>
      <td>115</td>
      <td>5500.0</td>
      <td>18</td>
      <td>22</td>
      <td>17450.0</td>
      <td>13.055556</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 27 columns</p>
</div>

```python
df['highway-L/100km'] = 235/df['highway-mpg']
df[['highway-mpg','highway-L/100km']].head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>highway-mpg</th>
      <th>highway-L/100km</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>27</td>
      <td>8.703704</td>
    </tr>
    <tr>
      <th>1</th>
      <td>27</td>
      <td>8.703704</td>
    </tr>
    <tr>
      <th>2</th>
      <td>26</td>
      <td>9.038462</td>
    </tr>
    <tr>
      <th>3</th>
      <td>30</td>
      <td>7.833333</td>
    </tr>
    <tr>
      <th>4</th>
      <td>22</td>
      <td>10.681818</td>
    </tr>
  </tbody>
</table>
</div>

```python
df.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>fuel-type</th>
      <th>aspiration</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>...</th>
      <th>bore</th>
      <th>stroke</th>
      <th>compression-ratio</th>
      <th>horsepower</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
      <th>city-L/100km</th>
      <th>highway-L/100km</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000.0</td>
      <td>21</td>
      <td>27</td>
      <td>13495.0</td>
      <td>11.190476</td>
      <td>8.703704</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>...</td>
      <td>3.47</td>
      <td>2.68</td>
      <td>9.0</td>
      <td>111</td>
      <td>5000.0</td>
      <td>21</td>
      <td>27</td>
      <td>16500.0</td>
      <td>11.190476</td>
      <td>8.703704</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>gas</td>
      <td>std</td>
      <td>two</td>
      <td>hatchback</td>
      <td>rwd</td>
      <td>front</td>
      <td>94.5</td>
      <td>...</td>
      <td>2.68</td>
      <td>3.47</td>
      <td>9.0</td>
      <td>154</td>
      <td>5000.0</td>
      <td>19</td>
      <td>26</td>
      <td>16500.0</td>
      <td>12.368421</td>
      <td>9.038462</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>...</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>10.0</td>
      <td>102</td>
      <td>5500.0</td>
      <td>24</td>
      <td>30</td>
      <td>13950.0</td>
      <td>9.791667</td>
      <td>7.833333</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>gas</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.4</td>
      <td>...</td>
      <td>3.19</td>
      <td>3.40</td>
      <td>8.0</td>
      <td>115</td>
      <td>5500.0</td>
      <td>18</td>
      <td>22</td>
      <td>17450.0</td>
      <td>13.055556</td>
      <td>10.681818</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 28 columns</p>
</div>

#### Renaming Columns

If there is a need for us to rename columns we can do so with `df.rename()`, for example

```py
df.rename(columns={'"highway-mpg"':'highway-consumption'}, inplace=True)
```

### Data Normalization

This is an important part of data preprocessing

We may need to normalize our variables such that the range of our data is more consistent, allowing us to manage the way that different values will impact our analysis

There are several differnet ways to normalize data

#### Simple Feature Scaling

$$
x_{new}=\frac{x_{old}}{x_{max}}
$$

```py
df['length'] = df['length']/df['length'].max()
```

#### Min-Max

$$
x_{new}=\frac{x_{old}-x_{min}}{x_{max}-x_{min}}
$$

```py
df['length'] = (df['length']-df['length'].min())/
               (df['length'].max()-df['length'].min())
```

#### Z-Score

The resulting values hover around zero, and are in terms of their standard deviation from the mean

$$
x_{new}=\frac{x_{old}-\mu}{\sigma}
$$

```py
df['length'] = (df['length']-df['length'].mean())/
               df['length'].std()
```

#### Normalization

Next we will normalize our values using the _Simple Feature Scaling Method_

We will apply this to the following features

- 'length'
- 'width'
- 'height'

```python
df['length'] = df['length']/df['length'].max()
df['width'] = df['width']/df['width'].max()
df['height'] = df['height']/df['height'].max()
df[["length","width","height"]].head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>length</th>
      <th>width</th>
      <th>height</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.811148</td>
      <td>0.890278</td>
      <td>0.816054</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.811148</td>
      <td>0.890278</td>
      <td>0.816054</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.822681</td>
      <td>0.909722</td>
      <td>0.876254</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.848630</td>
      <td>0.919444</td>
      <td>0.908027</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.848630</td>
      <td>0.922222</td>
      <td>0.908027</td>
    </tr>
  </tbody>
</table>
</div>

### Binning

Binning is grouping values together into bins, this can sometimes improve accuracy of predictive models and help us to better understand the data distribution

We'll arrange our 'horsepower' column into bins such that we can label cars as having a 'Low', 'Medium', or 'High' horsepower as follows

```python
df["horsepower"]=df["horsepower"].astype(float, copy=True)
binwidth = (max(df["horsepower"])-min(df["horsepower"]))/4
bins = np.arange(min(df["horsepower"]), max(df["horsepower"]), binwidth)
bins
```

    array([  48. ,  101.5,  155. ,  208.5])

We can then use `pd.cut()` to determine what bin each value belongs in

```python
group_names = ['Low', 'Medium', 'High']
df['horsepower-binned'] = pd.cut(df['horsepower'], bins, labels=group_names,include_lowest=True )
df[['horsepower','horsepower-binned']].head(20)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>horsepower</th>
      <th>horsepower-binned</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>111.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>1</th>
      <td>111.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>2</th>
      <td>154.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>3</th>
      <td>102.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>4</th>
      <td>115.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>5</th>
      <td>110.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>6</th>
      <td>110.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>7</th>
      <td>110.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>8</th>
      <td>140.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>9</th>
      <td>101.0</td>
      <td>Low</td>
    </tr>
    <tr>
      <th>10</th>
      <td>101.0</td>
      <td>Low</td>
    </tr>
    <tr>
      <th>11</th>
      <td>121.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>12</th>
      <td>121.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>13</th>
      <td>121.0</td>
      <td>Medium</td>
    </tr>
    <tr>
      <th>14</th>
      <td>182.0</td>
      <td>High</td>
    </tr>
    <tr>
      <th>15</th>
      <td>182.0</td>
      <td>High</td>
    </tr>
    <tr>
      <th>16</th>
      <td>182.0</td>
      <td>High</td>
    </tr>
    <tr>
      <th>17</th>
      <td>48.0</td>
      <td>Low</td>
    </tr>
    <tr>
      <th>18</th>
      <td>70.0</td>
      <td>Low</td>
    </tr>
    <tr>
      <th>19</th>
      <td>70.0</td>
      <td>Low</td>
    </tr>
  </tbody>
</table>
</div>

#### Visualization

We can use `matplotlib` to visualize the number of vehicles in each of our bins with the following

```python
%matplotlib inline
from matplotlib import pyplot as plt

a = (0,1,2)

# draw historgram of attribute "horsepower" with bins = 3
plt.hist(df["horsepower"], bins = 3)

# set x/y labels and plot title
plt.xlabel("Horsepower")
plt.ylabel("Count")
plt.title("Horsepower Bins")
plt.show()
```

![png](/publicimages-an/output_57_0.png)

### Categorical to Quantatative

Most statistical models cannot take in objects as strings, in order to do this we provide a dummy variable that contains whether or not an entry is a certain string variable, we can do this in pandas with `pd.get_dummies()`

This method will automatically generate a dummy vector for the provided dataframe, and is used as follows

```py
dummy_value = pd.get_dummies(df['value'])
```

#### Fuel

We will do this for the 'fuel-type' column in our data

```python
dummy_fuel = pd.get_dummies(df["fuel-type"])
dummy_fuel.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>diesel</th>
      <th>gas</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>

Then we will rename our columns for clarity

```python
dummy_fuel.rename(columns={'gas':'fuel-type-gas', 'diesel':'fuel-type-diesel'}, inplace=True)
dummy_fuel.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>fuel-type-diesel</th>
      <th>fuel-type-gas</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>

Then we will add this column to our dataset

```python
# merge data frame "df" and "dummy_fuel"
df = pd.concat([df, dummy_fuel], axis=1)

# drop original column "fuel-type" from "df"
df.drop("fuel-type", axis = 1, inplace=True)
```

```python
df.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>aspiration</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>length</th>
      <th>...</th>
      <th>horsepower</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
      <th>city-L/100km</th>
      <th>highway-L/100km</th>
      <th>horsepower-binned</th>
      <th>fuel-type-diesel</th>
      <th>fuel-type-gas</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>0.811148</td>
      <td>...</td>
      <td>111.0</td>
      <td>5000.0</td>
      <td>21</td>
      <td>27</td>
      <td>13495.0</td>
      <td>11.190476</td>
      <td>8.703704</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>std</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>0.811148</td>
      <td>...</td>
      <td>111.0</td>
      <td>5000.0</td>
      <td>21</td>
      <td>27</td>
      <td>16500.0</td>
      <td>11.190476</td>
      <td>8.703704</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>std</td>
      <td>two</td>
      <td>hatchback</td>
      <td>rwd</td>
      <td>front</td>
      <td>94.5</td>
      <td>0.822681</td>
      <td>...</td>
      <td>154.0</td>
      <td>5000.0</td>
      <td>19</td>
      <td>26</td>
      <td>16500.0</td>
      <td>12.368421</td>
      <td>9.038462</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>0.848630</td>
      <td>...</td>
      <td>102.0</td>
      <td>5500.0</td>
      <td>24</td>
      <td>30</td>
      <td>13950.0</td>
      <td>9.791667</td>
      <td>7.833333</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>std</td>
      <td>four</td>
      <td>sedan</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.4</td>
      <td>0.848630</td>
      <td>...</td>
      <td>115.0</td>
      <td>5500.0</td>
      <td>18</td>
      <td>22</td>
      <td>17450.0</td>
      <td>13.055556</td>
      <td>10.681818</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 30 columns</p>
</div>

#### Aspiration

We will do the same as above with our aspiration variable

```python
# get indicator variables of aspiration and assign it to data frame "dummy_variable_2"
dummy_aspiration = pd.get_dummies(df['aspiration'])

# change column names for clarity
dummy_aspiration.rename(columns={'std':'aspiration-std', 'turbo': 'aspiration-turbo'}, inplace=True)

# show first 5 instances of data frame "dummy_variable_1"
dummy_aspiration.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>aspiration-std</th>
      <th>aspiration-turbo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>

```python
# merge data frame "df" and "dummy_variable_1"
df = pd.concat([df, dummy_aspiration], axis=1)

# drop original column "fuel-type" from "df"
df.drop('aspiration', axis = 1, inplace=True)
```

```python
df.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>length</th>
      <th>width</th>
      <th>...</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
      <th>city-L/100km</th>
      <th>highway-L/100km</th>
      <th>horsepower-binned</th>
      <th>fuel-type-diesel</th>
      <th>fuel-type-gas</th>
      <th>aspiration-std</th>
      <th>aspiration-turbo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>0.811148</td>
      <td>0.890278</td>
      <td>...</td>
      <td>21</td>
      <td>27</td>
      <td>13495.0</td>
      <td>11.190476</td>
      <td>8.703704</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>0.811148</td>
      <td>0.890278</td>
      <td>...</td>
      <td>21</td>
      <td>27</td>
      <td>16500.0</td>
      <td>11.190476</td>
      <td>8.703704</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>two</td>
      <td>hatchback</td>
      <td>rwd</td>
      <td>front</td>
      <td>94.5</td>
      <td>0.822681</td>
      <td>0.909722</td>
      <td>...</td>
      <td>19</td>
      <td>26</td>
      <td>16500.0</td>
      <td>12.368421</td>
      <td>9.038462</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>0.848630</td>
      <td>0.919444</td>
      <td>...</td>
      <td>24</td>
      <td>30</td>
      <td>13950.0</td>
      <td>9.791667</td>
      <td>7.833333</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>four</td>
      <td>sedan</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.4</td>
      <td>0.848630</td>
      <td>0.922222</td>
      <td>...</td>
      <td>18</td>
      <td>22</td>
      <td>17450.0</td>
      <td>13.055556</td>
      <td>10.681818</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 31 columns</p>
</div>

### Exporting

Then we can export our clean data to a CSV as follows

```python
df.to_csv('clean_df.csv')
```

## Exploratory Data Analysis

Exploratory Data Analysis (EDA) is an approach to analyze data in order to

- Summarize main characteristics of data
- Gain better understanding of a dataset
- Uncover relationships between varables
- Identify important variables that impact our problem

### Descriptive Statistics

When analyzing data it is important to describe the data giving a few short summaries. We have a few different ways to do this, such as

- `df.describe()` to get general statistical information about numeric data
- `df.values_counts` to get a count of the different values of categorical data
- `sns.boxplot()` to generate box plots
- `plt.scatter()` Scatter plots show the relationship between the predictor and target variables

### Correlation

Correlation is a measure to what exctent different vriables are interdependent

> Correlation does not imply causation

#### Pearson Correlation

We can make use of Pearson correlation to measure the strength of correlation between two features, this has two values

- Correlation Coeffient
  - Close to 1: Positive relationship
  - Close to -1: Negative relationship
  - Close to 0: No relationship
- P-Value
  - P < 0.001: Strong certainty in the result
  - P < 0.05 : Moderate certainty in result
  - P < 0.1 : Weak certainty in result
  - P > 0.1 : No certainty in result

We would define a strong correlation when the Correlation Coefficient is around 1 or -1, and the P-Value is less than 0.001

We can find our correlation values for two variables with

```python
from scipy import stats
```

##### Wheel Base and Price

```python
pearson_coef, p_value = stats.pearsonr(df['wheel-base'], df['price'])
print("The Pearson Correlation Coefficient is", pearson_coef, " with a P-value of P =", p_value)
```

    The Pearson Correlation Coefficient is 0.584641822266  with a P-value of P = 8.07648827073e-20

##### Horsepower and Price

```python
pearson_coef, p_value = stats.pearsonr(df['horsepower'], df['price'])
print("The Pearson Correlation Coefficient is", pearson_coef, " with a P-value of P =", p_value)
```

    The Pearson Correlation Coefficient is 0.809574567004  with a P-value of P = 6.36905742826e-48

#### Positive Correlation

We can visualize our data using some of the visualizations we described above such as by comparing engine size to price

```python
import seaborn as sns

sns.regplot(x="engine-size", y="price", data=df)
plt.ylim(0,)
plt.show()
```

![png](/publicimages-an/output_78_0.png)

We can also view the correlation matrix for these two variables as follows

```python
df[["engine-size", "price"]].corr()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>engine-size</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>engine-size</th>
      <td>1.000000</td>
      <td>0.872335</td>
    </tr>
    <tr>
      <th>price</th>
      <td>0.872335</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>

From this we can see that engine size is a fairly good predictor of price

#### Negative Correlation

We can also look at the correation between highway mileage and price

```python
sns.regplot(x="highway-mpg", y="price", data=df)
plt.show()
df[['highway-mpg', 'price']].corr()
```

![png](/publicimages-an/output_82_0.png)

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>highway-mpg</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>highway-mpg</th>
      <td>1.000000</td>
      <td>-0.704692</td>
    </tr>
    <tr>
      <th>price</th>
      <td>-0.704692</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>

Where we can note a Negative Linear Relationship

#### Weak Correlation

We can the compare Peak RPM and price

```python
sns.regplot(x="peak-rpm", y="price", data=df)
plt.show()
df[['peak-rpm','price']].corr()
```

![png](/publicimages-an/output_84_0.png)

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>peak-rpm</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>peak-rpm</th>
      <td>1.000000</td>
      <td>-0.101616</td>
    </tr>
    <tr>
      <th>price</th>
      <td>-0.101616</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>

Where we can see a weak linear relationship

We can also observe the relationships between stroke and price

```python
sns.regplot(x="stroke", y="price", data=df)
plt.show()
df[["stroke","price"]].corr()
```

![png](/publicimages-an/output_86_0.png)

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>stroke</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>stroke</th>
      <td>1.000000</td>
      <td>0.082269</td>
    </tr>
    <tr>
      <th>price</th>
      <td>0.082269</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>

Next we can look at boxplots of our different categorical values in order to look at their distribution

```python
sns.boxplot(x="body-style", y="price", data=df)
plt.show()
```

    /opt/conda/envs/DSX-Python35/lib/python3.5/site-packages/seaborn/categorical.py:462: FutureWarning: remove_na is deprecated and is a private function. Do not use.
      box_data = remove_na(group_data)

![png](/publicimages-an/output_88_1.png)

```python
sns.boxplot(x="engine-location", y="price", data=df)
plt.show()
```

    /opt/conda/envs/DSX-Python35/lib/python3.5/site-packages/seaborn/categorical.py:462: FutureWarning: remove_na is deprecated and is a private function. Do not use.
      box_data = remove_na(group_data)

![png](/publicimages-an/output_89_1.png)

```python
sns.boxplot(x="drive-wheels", y="price", data=df)
plt.show()
```

    /opt/conda/envs/DSX-Python35/lib/python3.5/site-packages/seaborn/categorical.py:462: FutureWarning: remove_na is deprecated and is a private function. Do not use.
      box_data = remove_na(group_data)

![png](/publicimages-an/output_90_1.png)

#### Descriptive Statistics

Next we can find some descriptive statistics about our data by the following

```python
df.describe()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>wheel-base</th>
      <th>length</th>
      <th>width</th>
      <th>height</th>
      <th>curb-weight</th>
      <th>engine-size</th>
      <th>bore</th>
      <th>stroke</th>
      <th>...</th>
      <th>peak-rpm</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
      <th>city-L/100km</th>
      <th>highway-L/100km</th>
      <th>fuel-type-diesel</th>
      <th>fuel-type-gas</th>
      <th>aspiration-std</th>
      <th>aspiration-turbo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>201.000000</td>
      <td>201.00000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>...</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
      <td>201.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.840796</td>
      <td>122.00000</td>
      <td>98.797015</td>
      <td>0.837102</td>
      <td>0.915126</td>
      <td>0.899108</td>
      <td>2555.666667</td>
      <td>126.875622</td>
      <td>3.330692</td>
      <td>3.256874</td>
      <td>...</td>
      <td>5117.665368</td>
      <td>25.179104</td>
      <td>30.686567</td>
      <td>13207.129353</td>
      <td>9.944145</td>
      <td>8.044957</td>
      <td>0.099502</td>
      <td>0.900498</td>
      <td>0.820896</td>
      <td>0.179104</td>
    </tr>
    <tr>
      <th>std</th>
      <td>1.254802</td>
      <td>31.99625</td>
      <td>6.066366</td>
      <td>0.059213</td>
      <td>0.029187</td>
      <td>0.040933</td>
      <td>517.296727</td>
      <td>41.546834</td>
      <td>0.268072</td>
      <td>0.316048</td>
      <td>...</td>
      <td>478.113805</td>
      <td>6.423220</td>
      <td>6.815150</td>
      <td>7947.066342</td>
      <td>2.534599</td>
      <td>1.840739</td>
      <td>0.300083</td>
      <td>0.300083</td>
      <td>0.384397</td>
      <td>0.384397</td>
    </tr>
    <tr>
      <th>min</th>
      <td>-2.000000</td>
      <td>65.00000</td>
      <td>86.600000</td>
      <td>0.678039</td>
      <td>0.837500</td>
      <td>0.799331</td>
      <td>1488.000000</td>
      <td>61.000000</td>
      <td>2.540000</td>
      <td>2.070000</td>
      <td>...</td>
      <td>4150.000000</td>
      <td>13.000000</td>
      <td>16.000000</td>
      <td>5118.000000</td>
      <td>4.795918</td>
      <td>4.351852</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.000000</td>
      <td>101.00000</td>
      <td>94.500000</td>
      <td>0.801538</td>
      <td>0.890278</td>
      <td>0.869565</td>
      <td>2169.000000</td>
      <td>98.000000</td>
      <td>3.150000</td>
      <td>3.110000</td>
      <td>...</td>
      <td>4800.000000</td>
      <td>19.000000</td>
      <td>25.000000</td>
      <td>7775.000000</td>
      <td>7.833333</td>
      <td>6.911765</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1.000000</td>
      <td>122.00000</td>
      <td>97.000000</td>
      <td>0.832292</td>
      <td>0.909722</td>
      <td>0.904682</td>
      <td>2414.000000</td>
      <td>120.000000</td>
      <td>3.310000</td>
      <td>3.290000</td>
      <td>...</td>
      <td>5125.369458</td>
      <td>24.000000</td>
      <td>30.000000</td>
      <td>10295.000000</td>
      <td>9.791667</td>
      <td>7.833333</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2.000000</td>
      <td>137.00000</td>
      <td>102.400000</td>
      <td>0.881788</td>
      <td>0.925000</td>
      <td>0.928094</td>
      <td>2926.000000</td>
      <td>141.000000</td>
      <td>3.580000</td>
      <td>3.410000</td>
      <td>...</td>
      <td>5500.000000</td>
      <td>30.000000</td>
      <td>34.000000</td>
      <td>16500.000000</td>
      <td>12.368421</td>
      <td>9.400000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>3.000000</td>
      <td>256.00000</td>
      <td>120.900000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>4066.000000</td>
      <td>326.000000</td>
      <td>3.940000</td>
      <td>4.170000</td>
      <td>...</td>
      <td>6600.000000</td>
      <td>49.000000</td>
      <td>54.000000</td>
      <td>45400.000000</td>
      <td>18.076923</td>
      <td>14.687500</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
<p>8 rows × 22 columns</p>
</div>

```python
df.describe(include=['object'])
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>make</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>engine-type</th>
      <th>num-of-cylinders</th>
      <th>fuel-system</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>201</td>
      <td>201</td>
      <td>201</td>
      <td>201</td>
      <td>201</td>
      <td>201</td>
      <td>201</td>
      <td>201</td>
    </tr>
    <tr>
      <th>unique</th>
      <td>22</td>
      <td>2</td>
      <td>5</td>
      <td>3</td>
      <td>2</td>
      <td>6</td>
      <td>7</td>
      <td>8</td>
    </tr>
    <tr>
      <th>top</th>
      <td>toyota</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>ohc</td>
      <td>four</td>
      <td>mpfi</td>
    </tr>
    <tr>
      <th>freq</th>
      <td>32</td>
      <td>115</td>
      <td>94</td>
      <td>118</td>
      <td>198</td>
      <td>145</td>
      <td>157</td>
      <td>92</td>
    </tr>
  </tbody>
</table>
</div>

##### Value Counts

We can get an indication as to the frequencies of our categorical values with the following

```python
# drive-wheel counts as a variable
drive_wheels_counts = df['drive-wheels'].value_counts().to_frame()
drive_wheels_counts.rename(columns={'drive-wheels': 'value_counts'}, inplace=True)
drive_wheels_counts
drive_wheels_counts.index.name = 'drive-wheels'
drive_wheels_counts
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>value_counts</th>
    </tr>
    <tr>
      <th>drive-wheels</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>fwd</th>
      <td>118</td>
    </tr>
    <tr>
      <th>rwd</th>
      <td>75</td>
    </tr>
    <tr>
      <th>4wd</th>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>

```python
# engine-location as variable
engine_loc_counts = df['engine-location'].value_counts().to_frame()
engine_loc_counts.rename(columns={'engine-location': 'value_counts'}, inplace=True)
engine_loc_counts.index.name = 'engine-location'
engine_loc_counts.head(10)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>value_counts</th>
    </tr>
    <tr>
      <th>engine-location</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>front</th>
      <td>198</td>
    </tr>
    <tr>
      <th>rear</th>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>

#### Grouping Data

It can be helpful to group data in order to see if there is a correlation between a certain categorical data and some other variable

We can get an array of all uniques 'drive-wheel' categories with

```python
df['drive-wheels'].unique()
```

    array(['rwd', 'fwd', '4wd'], dtype=object)

In Pandas we can use `df.groupby()`to do this as such

```python
df_wheels = df[['drive-wheels','body-style','price']]
df_wheels = df_wheels.groupby(['drive-wheels'],as_index= False).mean()
df_wheels
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>drive-wheels</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>4wd</td>
      <td>10241.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>fwd</td>
      <td>9244.779661</td>
    </tr>
    <tr>
      <th>2</th>
      <td>rwd</td>
      <td>19757.613333</td>
    </tr>
  </tbody>
</table>
</div>

Next we can look at the wheels compared to the body style

```python
df_external = df[['drive-wheels', 'body-style', 'price']]
df_group = df_external = df_external.groupby(['drive-wheels','body-style'],
                                            as_index=False).mean().round()
df_group
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>drive-wheels</th>
      <th>body-style</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>4wd</td>
      <td>hatchback</td>
      <td>7603.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4wd</td>
      <td>sedan</td>
      <td>12647.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4wd</td>
      <td>wagon</td>
      <td>9096.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>fwd</td>
      <td>convertible</td>
      <td>11595.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>fwd</td>
      <td>hardtop</td>
      <td>8249.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>fwd</td>
      <td>hatchback</td>
      <td>8396.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>fwd</td>
      <td>sedan</td>
      <td>9812.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>fwd</td>
      <td>wagon</td>
      <td>9997.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>rwd</td>
      <td>convertible</td>
      <td>23950.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>rwd</td>
      <td>hardtop</td>
      <td>24203.0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>rwd</td>
      <td>hatchback</td>
      <td>14338.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>rwd</td>
      <td>sedan</td>
      <td>21712.0</td>
    </tr>
    <tr>
      <th>12</th>
      <td>rwd</td>
      <td>wagon</td>
      <td>16994.0</td>
    </tr>
  </tbody>
</table>
</div>

We can view this data a bit more conviniently as a pivot table, we can do this with `df.pivot()` so as to display the data as below

```python
grouped_pivot = df_group.pivot(index='drive-wheels',columns='body-style')
grouped_pivot
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="5" halign="left">price</th>
    </tr>
    <tr>
      <th>body-style</th>
      <th>convertible</th>
      <th>hardtop</th>
      <th>hatchback</th>
      <th>sedan</th>
      <th>wagon</th>
    </tr>
    <tr>
      <th>drive-wheels</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>4wd</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>7603.0</td>
      <td>12647.0</td>
      <td>9096.0</td>
    </tr>
    <tr>
      <th>fwd</th>
      <td>11595.0</td>
      <td>8249.0</td>
      <td>8396.0</td>
      <td>9812.0</td>
      <td>9997.0</td>
    </tr>
    <tr>
      <th>rwd</th>
      <td>23950.0</td>
      <td>24203.0</td>
      <td>14338.0</td>
      <td>21712.0</td>
      <td>16994.0</td>
    </tr>
  </tbody>
</table>
</div>

Next we can use a heatmap to visualize the above relationship, the heatmap plots the target variable as the colour with respect to the drive-wheels and body-style variables

```python
#use the grouped results
fig, ax = plt.subplots()
im=ax.pcolor(grouped_pivot, cmap='RdBu')

#label names
row_labels=grouped_pivot.columns.levels[1]
col_labels=grouped_pivot.index

#move ticks and labels to the center
ax.set_xticks(np.arange(grouped_pivot.shape[1])+0.5, minor=False)
ax.set_yticks(np.arange(grouped_pivot.shape[0])+0.5, minor=False)

#insert labels
ax.set_xticklabels(row_labels, minor=False)
ax.set_yticklabels(col_labels, minor=False)

#rotate label if too long
plt.xticks(rotation=90)

fig.colorbar(im)
plt.show()
```

![png](/publicimages-an/output_106_0.png)

### Analysis of Variance (ANOVA)

If we want to analyze a categorical variable and see the correlation between different categories

- Statistical comparison of groups

ANOVA is a statistical test that hels find the correlation between different groups of a categorical variable, the ANOVA returns two values

- F-Test score is the variation between sample group means divided by variation within the sample group
- P-Value is a measure of confidence and show if the obtained result is statistically significant

##### Drive Wheels

```python
grouped_test2=df[['drive-wheels','price']].groupby(['drive-wheels'])
grouped_test2.head(2)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>drive-wheels</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>rwd</td>
      <td>13495.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>rwd</td>
      <td>16500.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>fwd</td>
      <td>13950.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4wd</td>
      <td>17450.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>fwd</td>
      <td>15250.0</td>
    </tr>
    <tr>
      <th>136</th>
      <td>4wd</td>
      <td>7603.0</td>
    </tr>
  </tbody>
</table>
</div>

```python
grouped_test2.get_group('4wd')['price']
```

    4      17450.0
    136     7603.0
    140     9233.0
    141    11259.0
    144     8013.0
    145    11694.0
    150     7898.0
    151     8778.0
    Name: price, dtype: float64

To obtain the ANOVA values, we use the `stats.f_oneway` function from scipy for the correlation between drive wheels and price

##### Drive Wheels and Price

```python
# ANOVA
f_val, p_val = stats.f_oneway(grouped_test2.get_group('fwd')['price'], grouped_test2.get_group('rwd')['price'], grouped_test2.get_group('4wd')['price'])

print( "ANOVA results: F=", f_val, ", P =", p_val)
```

    ANOVA results: F= 67.9540650078 , P = 3.39454435772e-23

This shows a large F and small P, meaning that there is a strong corelation between the three drive types and the price, however does this apply for each individual comparison of drive type?

##### FWD and RWD

```python
f_val, p_val = stats.f_oneway(grouped_test2.get_group('fwd')['price'], grouped_test2.get_group('rwd')['price'])

print( "ANOVA results: F=", f_val, ", P =", p_val )
```

    ANOVA results: F= 130.553316096 , P = 2.23553063557e-23

##### 4WD and RWD

```python
f_val, p_val = stats.f_oneway(grouped_test2.get_group('4wd')['price'], grouped_test2.get_group('rwd')['price'])

print( "ANOVA results: F=", f_val, ", P =", p_val)
```

    ANOVA results: F= 8.58068136892 , P = 0.00441149221123

4WD and FWD

```python
f_val, p_val = stats.f_oneway(grouped_test2.get_group('4wd')['price'], grouped_test2.get_group('fwd')['price'])

print("ANOVA results: F=", f_val, ", P =", p_val)
```

    ANOVA results: F= 0.665465750252 , P = 0.416201166978

## Model Development

A model can be thought of as a mathematical equation used to predict a value given a specfic input

More relevant data will allow us to more accurately predict an outcome

### Linear Regression

#### Simple Linear Regression

SLR helps us to identify a relationship between two independant variables in the form of

$$
y=b_0 + b_1x
$$

We make use of training datapoints to help us find the $b_0$ and $b_1$ values

Our measured datapoints will have some noise, causing our data to be differerntiated from the model

We make use of our training data to fit a model to our data, we then use the model to make predictions. We denote our predicted values as an estimate with

$$
\hat y=b_0+b_1x
$$

If the linear model is correct, we can assume that the offsets are noise, otherwise it may be other factors that we have not taken into consideration

We can create a linear regression model by importing it from `sklearn` and creating a new `LinearRegression` object as follows

```py
from sklearn.linear_model import LinearRegression

lm = LinearRegression()
```

Then we define the predictor and target variables and use `lm.fit()` to find the parameters $b_0$ and $b_1$

```py
X = df[['predictor']]
Y = df[['target']]

lm.fit(X,Y)
```

We can then obtain a prediction using `lm.predict()'

```py
yhat = lm.predict(X)
```

The intercept and slope are attributes of the `LinearRegression` object and can be found with `lm.intercept_` and `lm.coef_` respectively

We can train an SLR model for our data as follows

```python
df.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }

</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>symboling</th>
      <th>normalized-losses</th>
      <th>make</th>
      <th>num-of-doors</th>
      <th>body-style</th>
      <th>drive-wheels</th>
      <th>engine-location</th>
      <th>wheel-base</th>
      <th>length</th>
      <th>width</th>
      <th>...</th>
      <th>city-mpg</th>
      <th>highway-mpg</th>
      <th>price</th>
      <th>city-L/100km</th>
      <th>highway-L/100km</th>
      <th>horsepower-binned</th>
      <th>fuel-type-diesel</th>
      <th>fuel-type-gas</th>
      <th>aspiration-std</th>
      <th>aspiration-turbo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>0.811148</td>
      <td>0.890278</td>
      <td>...</td>
      <td>21</td>
      <td>27</td>
      <td>13495.0</td>
      <td>11.190476</td>
      <td>8.703704</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>two</td>
      <td>convertible</td>
      <td>rwd</td>
      <td>front</td>
      <td>88.6</td>
      <td>0.811148</td>
      <td>0.890278</td>
      <td>...</td>
      <td>21</td>
      <td>27</td>
      <td>16500.0</td>
      <td>11.190476</td>
      <td>8.703704</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>122</td>
      <td>alfa-romero</td>
      <td>two</td>
      <td>hatchback</td>
      <td>rwd</td>
      <td>front</td>
      <td>94.5</td>
      <td>0.822681</td>
      <td>0.909722</td>
      <td>...</td>
      <td>19</td>
      <td>26</td>
      <td>16500.0</td>
      <td>12.368421</td>
      <td>9.038462</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>four</td>
      <td>sedan</td>
      <td>fwd</td>
      <td>front</td>
      <td>99.8</td>
      <td>0.848630</td>
      <td>0.919444</td>
      <td>...</td>
      <td>24</td>
      <td>30</td>
      <td>13950.0</td>
      <td>9.791667</td>
      <td>7.833333</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>164</td>
      <td>audi</td>
      <td>four</td>
      <td>sedan</td>
      <td>4wd</td>
      <td>front</td>
      <td>99.4</td>
      <td>0.848630</td>
      <td>0.922222</td>
      <td>...</td>
      <td>18</td>
      <td>22</td>
      <td>17450.0</td>
      <td>13.055556</td>
      <td>10.681818</td>
      <td>Medium</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 31 columns</p>
</div>

```python
from sklearn.linear_model import LinearRegression
```

```python
X = df[['highway-mpg']]
Y = df['price']
```

```python
lm = LinearRegression()
lm.fit(X,Y)
```

    LinearRegression(copy_X=True, fit_intercept=True, n_jobs=1, normalize=False)

```python
Yhat=lm.predict(X)
Yhat[0:5]
```

    array([ 16236.50464347,  16236.50464347,  17058.23802179,  13771.3045085 ,
            20345.17153508])

```python
lm_eq = 'yhat = ' + str(lm.intercept_) + ' + ' + str(lm.coef_[0]) + 'x'
print(lm_eq)
```

    yhat = 38423.3058582 + -821.733378322x

#### Multiple Linear Regression

MLR is used to explain the relationship between 1 continuous target and 2 or more predictors

The model will then be defined by the function

$$
\hat y=b_0 + b_1x_1 + b_2x_2 + b_3x_3 + ... + b_nx_n
$$

The resulting equation represents a surface in $n$ dimensional space that will define $y$ given each component of $x$

We can train this model just as before as follows

```py
X = df[['predictor1','predictor2','predictor3',...,'predictorN']]
Y = df[['target']]

lm.fit(X,Y)
```

And then predict as before with

```py
yhat = lm.predict(X)
```

Where `X` is in the form of the training data

The intercept and coefficiencts of the model can once again be found with `lm.intercept_` and `lm.coef_` respectively

We can develop a MLR model as follows

```python
Z = df[['horsepower', 'curb-weight', 'engine-size', 'highway-mpg']]
lm.fit(Z, df['price'])
print('intercept: ' + str(lm.intercept_), '\ncoefficients: ' + str(lm.coef_))
```

    intercept: -15806.6246263
    coefficients: [ 53.49574423   4.70770099  81.53026382  36.05748882]

### Model Evaluation using Visualization

#### Regression Plot

Regression plots gives us a good estimate of:

- The relationship between two variables
- The strength of correlation
- The direction of the relationship

A regression plot is a combination of a scatter plot, and a linear regression line

We create a regression plot using the `sns.regplot()` function in `seaborn`

```py
import seaborn as sns

sns.regplot(x='predictor', y='target', data=df)
plt.ylim(0,)
plt.show()
```

##### Single Linear Regression

We can visualize SLR as follows

```python
width = 12
height = 10
plt.figure(figsize=(width, height))
sns.regplot(x="highway-mpg", y="price", data=df)
plt.ylim(0,)
plt.show()
```

![png](/publicimages-an/output_129_0.png)

```python
plt.figure(figsize=(width, height))
sns.regplot(x="peak-rpm", y="price", data=df)
plt.ylim(0,)
```

    (0, 47422.919330307624)

![png](/publicimages-an/output_130_1.png)

#### Residual Plot

A Residual plot represents the error between the actual and predicted value, the results should have 0 mean if the linear assumption is applicable

If the residual plot is not equally distributed around the mean of 0 throughout, we know that the linear model is not correct for the data we have

We can create a residual plot as with `sns.residplot()`

```py
sns.residplot(df['predictor'], df['target'])
```

```python
width = 12
height = 10
plt.figure(figsize=(width, height))
sns.residplot(df['highway-mpg'], df['price'])
plt.show()
```

![png](/publicimages-an/output_132_0.png)

#### Distribution Plot

We use this to look at the distribution of the actual vs predicted values for our model

A distribution plot can be made with `sns.distplot()`

```py
ax1 = sns.distplot(df['target'], hist=False, label='Actual Value')
sns.distplot(yhat, hist=False, label='Fitted Values', ax=ax1)
plt.show()
```

##### Multiple Linear Regression

Using A Distribution Plot is more valuable when looking at MLR model performance

```python
Y_hat = lm.predict(Z)
```

```python
plt.figure(figsize=(width, height))


ax1 = sns.distplot(df['price'], hist=False, color="r", label="Actual Value")
sns.distplot(Yhat, hist=False, color="b", label="Fitted Values" , ax=ax1)


plt.title('Actual vs Fitted Values for Price')
plt.xlabel('Price (in dollars)')
plt.ylabel('Proportion of Cars')

plt.show()
plt.close()
```

![png](/publicimages-an/output_135_0.png)

### Polynomial Regression and Pipelines

Polynomial Regression is a form of regression used to describe curvilinear relationships in which our predictor variable is not linear

- Quadratic $\hat y=b_0 + b_1x_1 + b_2x_1^2$
- Cubic $\hat y=b_0 + b_1x_1 + b_2x_1^2 + b_2x_1^3$
- Higher Order $\hat y=b_0 + b_1x_1 + b_2x_1^2 + ...  + b_2x_1^n$

Picking the correct order can make our model more accurate

We can fit a polynomial to our data using `np.polyfit()`, and can print out the resulting model with `np.polydl()`

For an $n^{th}$ order polynomial we can create and view a model as follows

```py
model = np.polyfit(X,Y,n)
print(np.polydl(f))
```

#### Visualization

Visualizing Polynomial regression plots is a bit more work but can be done with the function below

```python
def PlotPolly(model,independent_variable,dependent_variabble, Name):
    x_new = np.linspace(15, 55, 100)
    y_new = model(x_new)

    plt.plot(independent_variable,dependent_variabble,'.', x_new, y_new, '-')
    plt.title('Polynomial Fit with Matplotlib for Price ~ Length')
    ax = plt.gca()
    fig = plt.gcf()
    plt.xlabel(Name)
    plt.ylabel('Price of Cars')

    plt.show()
    plt.close()
```

Next we can do the polynomial fit for our data

```python
x = df['highway-mpg']
y = df['price']

f = np.polyfit(x, y, 3)
p = np.poly1d(f)
print(p)
```

            3         2
    -1.557 x + 204.8 x - 8965 x + 1.379e+05

```python
PlotPolly(p,x,y, 'highway-mpg')
```

![png](/publicimages-an/output_140_0.png)

### Multi Dimension Polynomial Regression

Polynomial regression can also be done in multiple dimensions, for example a second order approximation would look like the following

$$
\hat y=b_0 + b_1x_1 + b_2x_2 + b_3x_1x_2 + b_4x_1^2 + b_5x_2^2
$$

If we want to do multi dimentional polynomial fits, we will need to use `PolynomialFeatures` from `sklearn.preprocessing` to preprocess our features as follows

```py
X = df[['predictor1','predictor2','predictor3',...,'predictorN']]
Y = df[['target']]

pr = PolynomialFeatures(degree=2)
x_poly = pr.fit_transform(X, include_bias=False)
```

```python
from sklearn.preprocessing import PolynomialFeatures
```

```python
pr = PolynomialFeatures(degree=2)
pr
```

    PolynomialFeatures(degree=2, include_bias=True, interaction_only=False)

```python
Z_pr = pr.fit_transform(Z)
```

Before the transformation we have 4 features

```python
Z.shape
```

    (201, 4)

After the transformation we have 15 features

```python
Z_pr.shape
```

    (201, 15)

### Pre-Processing

`sklearn` has some preprocessing functionality such as

#### Normalization

We can train a scaler and normalize our data based on that as follows

```py
from sklearn.preprocessing import StandardScaler

scale = StandardScaler()
scale.fit(X[['feature1','feature2',..., 'featureN']])

X_scaled = scale.transform(X[['feature1','feature2',..., 'featureN']])
```

There are other normalization functions available with which we can preprocess our data

#### Pipelines

There are many steps to getting a prediction, such as Normalization, Polynomial Transformation, and training a Linear Regression Model

We can use a Pipeline library to help simplify the process

First we import all the libraries we will need as well as the pipeline library

```py
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler

from sklearn.pipeline import Pipeline
```

Then we construct our pipeline using a list of tuples defined as `('name of estimator model', ModelConstructor())` and create our pipeline object

```py
input = [('scale', StandardScaler()),
         ('polynomial', PolynomialFeatures(degree=n),
         ...,
         ('mode', LinearRegression()]
pipe = Pipeline(Input)
```

We can then create our pipeline object on the data by using the `pipe.train` function

```py
pipe.train(X[['feature1','feature2',..., 'featureN']], Y)
yhat = pipe.predict(X[['feature1','feature2',..., 'featureN']])
```

The above method will normalize the data, then perform a polynomial transform and output a prediction

```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
```

```python
Input=[('scale',StandardScaler()),
       ('polynomial', PolynomialFeatures(include_bias=False)),
       ('model',LinearRegression())]
```

```python
pipe=Pipeline(Input)
pipe
```

    Pipeline(memory=None,
         steps=[('scale', StandardScaler(copy=True, with_mean=True, with_std=True)), ('polynomial', PolynomialFeatures(degree=2, include_bias=False, interaction_only=False)), ('model', LinearRegression(copy_X=True, fit_intercept=True, n_jobs=1, normalize=False))])

```python
pipe.fit(Z,y)
```

    Pipeline(memory=None,
         steps=[('scale', StandardScaler(copy=True, with_mean=True, with_std=True)), ('polynomial', PolynomialFeatures(degree=2, include_bias=False, interaction_only=False)), ('model', LinearRegression(copy_X=True, fit_intercept=True, n_jobs=1, normalize=False))])

```python
ypipe=pipe.predict(Z)
ypipe[0:4]
```

    array([ 13102.74784201,  13102.74784201,  18225.54572197,  10390.29636555])

### In-Sample Evaluation

Two important measures that determine how well a model fits a speficic dataset are

- Mean Squared Error (MSE)
- R-Squared ($R^2$)

#### Mean Squared Error

We simply find the difference between the average square error of our prediction when compared to our data

To get the MSE in Python we can do the following

```py
from sklearn.metrics import mean_squared_error

mean_squared_error(X['target'],Y_predicted_sample)
```

#### R-Squared

$R^2$ is the coefficient of determination

- Measure of how close the data is to the fitted regression line
- The percentage of variation in Y that is explained by the model
- Like comparing our model to the mean of the data in approximating the data

$R^2$ is usually between 0 and 1

$$
R^2=1-\frac{MSE of Regression Line}{MSE of \bar y}
$$

We can get the $R^24$ value with `lm.score()`

A negative $R^2$ can be a sign of overfitting

#### In-Sample Evaluation of Models

We can evaluate our models with the following

```python
#highway_mpg_fit
lm.fit(X, Y)
# Find the R^2
lm.score(X, Y)
```

    0.49659118843391747

```python
Yhat = lm.predict(X)
Yhat[0:4]
```

    array([ 16236.50464347,  16236.50464347,  17058.23802179,  13771.3045085 ])

```python
from sklearn.metrics import mean_squared_error
```

```python
#mean_squared_error(Y_true, Y_predict)
mean_squared_error(df['price'], Yhat)
```

    31635042.944639895

```python
# fit the model
lm.fit(Z, df['price'])
# Find the R^2
lm.score(Z, df['price'])
```

    0.80935628065774567

```python
Y_predict_multifit = lm.predict(Z)
```

```python
mean_squared_error(df['price'], Y_predict_multifit)
```

    11980366.87072649

Now we can check what the $R^2$ value for our model is

```python
from sklearn.metrics import r2_score
```

```python
r_squared = r2_score(y, p(x))
r_squared
```

    0.67419466639065173

```python
mean_squared_error(df['price'], p(x))
```

    20474146.426361222

### Prediction and Decision Making

We should use visualization, numerical evaluation, and model comparison in order to see if the model values makes sense

To compare our model to the data we can simply plot the output of our model over the range of our data

```python
new_input=np.arange(1,100,1).reshape(-1,1)
```

```python
lm.fit(X, Y)
```

    LinearRegression(copy_X=True, fit_intercept=True, n_jobs=1, normalize=False)

```python
yhat=lm.predict(new_input)
yhat[0:5]
```

    array([ 37601.57247984,  36779.83910151,  35958.10572319,  35136.37234487,
            34314.63896655])

```python
plt.plot(new_input,yhat)
plt.show()
```

![png](/publicimages-an/output_171_0.png)

#### Conclusion

From the results above (yes, they're a mess but it's all pretty much just from the CC Lab file) we can note the $R^2$ and MSE values are as follows

Simple Linear Regression: Using Highway-mpg as a Predictor Variable of Price.

- R-squared: 0.49659118843391759
- MSE: 3.16 x10^7

Multiple Linear Regression: Using Horsepower, Curb-weight, Engine-size, and Highway-mpg as Predictor Variables of Price.

- R-squared: 0.80896354913783497
- MSE: 1.2 x10^7

Polynomial Fit: Using Highway-mpg as a Predictor Variable of Price.

- R-squared: 0.6741946663906514
- MSE: 2.05 x 10^7

#### SLR vs MLR

Usually having more variables helps the prediction, however if you do not have enough data you can run into trouble or many of the variables may just be noise and not be very useful

The MSE for MLR is Smaller than for SLR, and the $R^2$ for MLR is higher as well, MSE and $R^2$ both seem to indicate that MLR is a better fit than SLR

#### SLR vs Polynomial

The MSE for the Polynomial Fit is less than for the SLR and the $R^2$ is higher meaning that the Polynomial Fit is a better predictor based on 'highway-mpg' than the SLR

#### MLR vs Polynomial

The MSE for the MLR is smaller than for the Polynomial Fit, and the MLR also has a higher $R^2$ therefore the MLR is as better fit than the Polynomial in this case

#### Overall

The MLR has the lowest $R^2$ and the highest MSE, meaning that it is the best fit of the three models that have been evaluate

## Model Evaluation

Model Evaluation tells us how our model works in the real wold. In-Sample evaluation does not give us an indication as to how our model performs under real lifr circumstances

### Training and Test Sets

We typically split our data into a training and testing set and use to build and evaluate our model respectively

- Split into
  - 70% Training
  - 30% Testing
- Build and Train with Training Set
- Use Testing Set to evaluate model performance

`sklearn` gives us a function to split out data into a train and test set

```py
from sklearn.model_selection import train_test_split

X_train, X_test, Y_train, Y_test = train_test_split(x_data,y_data,test_size=0.3,random_state=0)
```

### Generalization Performance

Generalization Error is a measure of how well our data does at predicting previously unseen data

The error we obtain using our testing data is an approximation of this error

### Cross Validation

Cross validation involves us splitting the data into folds and using a fold for testing and the remainder for training, and we make use of each combination of training, and evalution

We can use `cross_val_score()` to evaluate our out-of-sample evaluation

```py
from sklearn.model_selection import cross_val_score
scores = cross_val_score(lr,X,Y,cv=n)
```

Where `X` is our predictor matrix, `Y` is our target, and `n` is our number of folds

If we want to use get the actual predicted values from our model we can do the following

```py
from sklearn.model_selection import cross_val_predict
yhat = cross_val_predict(lr,X,Y,cv=n)
```

### Overfitting, Underfitting, and Model Selection

The goal of model selection is to try to select the best function to fit our model, if our model is too simple we will have model that does not appropriately fit our data, whereas if we have a model that is too complex, it wil perfectly fit our testing data but will not be good at approximating new data

We need to be sure to fit the data, not the noise

It is also possible that the data we are trying to approximate cannot be fitted by polynomial at all, for example in the case of cyclic data

We can make use of the following code to look at the effect of order on our $R^2$ error for a model

```py
rsq_test = []
order = [1,2,3,4]

for n in order:
    pr = PolynomialFeatures(degree=n)
    x_train_pr = pr.fit_transform(x_train[['feature']]
    x_test_pr = pr.fit_transform(x_test[['feature']]
    lm.fit(x_train_pr, y_train)
    rsq_test.append(lr.score(x_test_pr, y_test))
```

### Ridge Regression

Ridge Regression prevents overfitting

Ridge regression controls the higher order parameters in our model by using a factor $\alpha$, increasing our $\alpha$ value will help us avoid overfitting until, however increasing it too far can lead to us underfitting the data

To use ridge regression we can do the following

```py
from sklearn.linear_model import Ridge

ridge_model = Ridge(alpha=0.1)
ridge_model.fit(X,Y)
yhat=RidgeModel.predict(X)
```

We will usually start off with a small value of $\alpha$ such as 0.0001 and increase our value in orders of magnitude

Furthermore we can use Cross Validation to identify an optimal $\alpha$

### Grid Search

Grid Search allows us to scan through multiple free parameters

Parameters such as $\alpha$ are not part of the training or fitting process. These parameters are called Hyperparameters

`sklearn` has a means of automatically iterating over these parameters called Grid Search

This allows us to use different hyperparameters to train our model, and select the model that provides the lowest MSE

The values of a grid search are simply a list whcih contains a dictionary for the parameters we want to modify

```py
params = [{'param name':[value1, value2, value3, ...]}]
```

We can use Grid Search as follows

```py
from sklearn.linear_model import Ridge
from sklearn.model_selection import GridSearchCV

params = [{'alpha':[0.0001, 0.01, 1, 10, 100]}, {'normalize':[True,False]}]

rr = Ridge()

grid = GridSearchCV(rr, params, cv=4)
grid.fit(X_train[['feature1','feature2',...], Y_train)

grid.best_estimator_

scores = grid.cv_results_
```

The `scores` dictionary will store the results for each hyperparameter combination given our inputs

## Conclusion

For more specific examples of the different setions look at the appropriate Lab
