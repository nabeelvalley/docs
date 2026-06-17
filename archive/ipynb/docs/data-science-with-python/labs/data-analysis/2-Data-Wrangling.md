 <a href="https://www.bigdatauniversity.com"><img src = "https://ibm.box.com/shared/static/ugcqz6ohbvff804xp84y4kqnvvk3bq1g.png" width = 300, align = "center"></a>

<h1 align=center><font size = 5>Data Analysis with Python</font></h1>

  #### Prerequisites, Python for Data Science click to start course:
  
  <a href="http://cocl.us/DA0101ENtoPY0101EN"><img src = "https://ibm.box.com/shared/static/jmtb4pgle2dsdlzfmyrgv755cnqw95wk.png" width = 300, align = "center"></a>

# Module 2 : Data Wrangling

### Welcome!

By the end of this notebook, you will have learned the basics of Data Wrangling! 

## Table of content

<div class="alert alert-block alert-info" style="margin-top: 20px">
<li><a href="#ref1">Identify and handle missing values</a>
<ul><div><a href="#ref2">- Identify missing values</a></div>
<div><a href="#ref3">- Deal with missing values</a></div>
<div><a href="#ref4">- Correct data format</a></div></ul></li>
<p></p>
<li><a href="#ref5">Data standardization</a></li>
<li><a href="#ref6">Data Normalization (centring/scaling)</a></li>
<li><a href="#ref7">Binning</a></li>
<li><a href="#ref8">Indicator variable</a></li>
<p></p>
Estimated Time Needed: <strong>30 min</strong>
</div>
 
<hr>

## What is the purpose of Data Wrangling?

Data Wrangling is the process of converting data from the initial format to a format that may be better for analysis.

### What is the fuel consumption (L/100k) rate for the disel car?

### Import data

You can find the "Automobile Data Set" from the following link: https://archive.ics.uci.edu/ml/machine-learning-databases/autos/imports-85.data. We will be using this data set throughout this course.


#### Import pandas 

```py
import pandas as pd
```


## Reading the data set from the URL and adding the related headers.

#### URL of dataset

```py
filename = 'https://archive.ics.uci.edu/ml/machine-learning-databases/autos/imports-85.data'
```


 Python list "headers" containing name of headers 

```py
headers = ["symboling","normalized-losses","make","fuel-type","aspiration", "num-of-doors","body-style",
         "drive-wheels","engine-location","wheel-base", "length","width","height","curb-weight","engine-type",
         "num-of-cylinders", "engine-size","fuel-system","bore","stroke","compression-ratio","horsepower",
         "peak-rpm","city-mpg","highway-mpg","price"]
```


Use the Pandas method **read_csv()** to load the data from the web address. Set the parameter  "names" equal to the Python list "headers".

```py
df = pd.read_csv(filename, names = headers)
print("Done")
```


 Use the method **head()** to display the first five rows of the dataframe. 

```py
# To see what the data set looks like, we'll use the head() method.
df.head()
```


As we can see, several question marks appeared in the dataframe; those are missing values which may hinder our further analysis. 
<div>So, how do we identify all those missing values and deal with them?</div> 


**How to work with missing data?**

Steps for working with missing data:
1. identify missing data
2. deal with missing data
3. correct data format

<a id="ref1"></a>
# 1. Identify and handle missing values


<a id="ref2"></a>
### Convert "?" to NaN
In the car dataset, missing data comes with the question mark "?".
We replace "?" with NaN (Not a Number), which is Python's default missing value marker, for reasons of computational speed and convenience. Here we use the function: 
 <pre>.replace(A, B, inplace = True) </pre>
to replace A by B

```py
import numpy as np

# replace "?" to NaN
df.replace("?", np.nan, inplace = True)
df.head(5)
```


### Evaluating for Missing Data

The missing values are converted to Python's default. We use Python's built-in functions to identify these missing values. There are two methods to detect missing data:
1.  **.isnull()**
2.  **.notnull()**

The output is a boolean value indicating whether the passed in argument value are in fact missing data.

```py
missing_data = df.isnull()
missing_data.head(5)
```


"True" stands for missing value, while "False" stands for not missing value.

### Count missing values in each column
Using a for loop in Python, we can quickly figure out the number of missing values in each column. As mentioned above, "True" represents a missing value, "False"  means the value is present in the dataset.  In the body of the for loop the method  ".value_couts()"  counts the number of "True" values. 

```py
for column in missing_data.columns.values.tolist():
    print(column)
    print (missing_data[column].value_counts())
    print("")    
```


Based on the summary above, each column has 205 rows of data, seven columns containing missing data:

1. "normalized-losses": 41 missing data
2. "num-of-doors": 2 missing data
3. "bore": 4 missing data
4. "stroke" : 4 missing data
5. "horsepower": 2 missing data
6. "peak-rpm": 2 missing data
7. "price": 4 missing data

<a id="ref3"></a>
## Deal with missing data
**How to deal with missing data?**

    
    1. drop data 
        a. drop the whole row
        b. drop the whole column
    2. replace data
        a. replace it by mean
        b. replace it by frequency
        c. replace it based on other functions

Whole columns should be dropped only if most entries in the column are empty. In our dataset, none of the columns are empty enough to drop entirely.
We have some freedom in choosing which method to replace data; however, some methods may seem more reasonable than others. We will apply each method to many different columns:

**Replace by mean:**

    "normalized-losses": 41 missing data, replace them with mean
    "stroke": 4 missing data, replace them with mean
    "bore": 4 missing data, replace them with mean
    "horsepower": 2 missing data, replace them with mean
    "peak-rpm": 2 missing data, replace them with mean
    
**Replace by frequency:**

    "num-of-doors": 2 missing data, replace them with "four". 
        * Reason: 84% sedans is four doors. Since four doors is most frequent, it is most likely to 
    

**Drop the whole row:**

    "price": 4 missing data, simply delete the whole row
        * Reason: price is what we want to predict. Any data entry without price data cannot be used for prediction; therefore they are not useful to us

#### Calculate the average of the column 

```py
avg_1 = df["normalized-losses"].astype("float").mean(axis = 0)
```


#### Replace "NaN" by mean value in "normalized-losses" column

```py
df["normalized-losses"].replace(np.nan, avg_1, inplace = True)
```


#### Calculate the mean value for 'bore' column

```py
avg_2=df['bore'].astype('float').mean(axis=0)
```


#### Replace NaN by mean value

```py
df['bore'].replace(np.nan, avg_2, inplace= True)
```


<div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question  #1: </h1>

<b>According to the example above, replace NaN in "stroke" column by mean.</b>
</div>

```py

```


<div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question #1 Answer: </h1>
<b>Run the code below! Did you get the right code?</b>
</div>

Double-click __here__ for the solution.

<!-- Your answer is below:

# calculate the mean vaule for "stroke" column
avg_3 = df["stroke"].astype("float").mean(axis = 0)

# replace NaN by mean value in "stroke" column
df["stroke"].replace(np.nan, avg_3, inplace = True)

-->

#### Calculate the mean value for the  'horsepower' column:

```py
avg_4=df['horsepower'].astype('float').mean(axis=0)
```


#### Replace "NaN" by mean value :

```py
df['horsepower'].replace(np.nan, avg_4, inplace= True)
```


#### Calculate the mean value for 'peak-rpm' column:

```py
avg_5=df['peak-rpm'].astype('float').mean(axis=0)
```


#### Replace NaN by mean value:

```py
df['peak-rpm'].replace(np.nan, avg_5, inplace= True)
```


To see which values are present in a particular column, we can use the ".value_counts()" method:

```py
df['num-of-doors'].value_counts()
```


We can see that four doors are the most common type. We can also use the ".idxmax()" method to calculate for us the most common type automatically:

```py
df['num-of-doors'].value_counts().idxmax()
```


The replacement procedure is very similar to what we have seen previously

```py
#replace the missing 'num-of-doors' values by the most frequent 
df["num-of-doors"].replace(np.nan, "four", inplace = True)
```


Finally, let's drop all rows that do not have price data:

```py
# simply drop whole row with NaN in "price" column
df.dropna(subset=["price"], axis=0, inplace = True)

# reset index, because we droped two rows
df.reset_index(drop = True, inplace = True)
```


```py
df.head()
```


**Good!** Now, we obtain the dataset with no missing values.

<a id="ref4"></a>
## Correct  data format
**We are almost there!**
<div>The last step in data cleaning is checking and making sure that all data is in the correct format (int, float, text or other).</div>

In Pandas, we use 
<div>**.dtype()** to check the data type</div>
<div>**.astype()** to change the data type</div>

#### Lets list the data types for each column

```py
df.dtypes
```


As we can see above, some columns are not of the correct data type. Numerical variables should have type 'float' or 'int', and variables with strings such as categories should have type 'object'. For example, 'bore' and 'stroke' variables are numerical values that describe the engines, so we should expect them to be of the type 'float' or 'int'; however, they are shown as type 'object'. We have to convert data types into a proper format for each column using the "astype()" method.  

#### Convert data types to proper format

```py

df[["bore", "stroke"]] = df[["bore", "stroke"]].astype("float")
df[["normalized-losses"]] = df[["normalized-losses"]].astype("int")
df[["price"]] = df[["price"]].astype("float")
df[["peak-rpm"]] = df[["peak-rpm"]].astype("float")
print("Done")
```


#### Let us list the columns after the conversion  

```py
df.dtypes
```


**Wonderful!**

Now, we finally obtain the cleaned dataset with no missing values and all data in its proper format.

<a id="ref5"></a>
# Data Standardization
Data is usually collected from different agencies with different formats.
(Data Standardization is also a term for a particular type of data normalization, where we subtract the mean and divide by the standard deviation)

**What is Standardization?**
<div>Standardization is the process of transforming data into a common format which allows the researcher to make the meaningful comparison.
</div>

**Example**
<div>Transform mpg to L/100km:</div>
<div>In our dataset, the fuel consumption columns "city-mpg" and "highway-mpg" are represented by mpg (miles per gallon) unit. Assume we are developing an application in a country that accept the fuel consumption with L/100km standard</div>
<div>We will need to apply **data transformation** to transform mpg into L/100km?</div>


The formula for unit conversion is
L/100km = 235 / mpg
<div>We can do many mathematical operations directly in Pandas.</div>

```py
df.head()
```


```py
# transform mpg to L/100km by mathematical operation (235 divided by mpg)
df['city-L/100km'] = 235/df["city-mpg"]

# check your transformed data 
df.head()
```


<div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question  #2: </h1>

<b>According to the example above, transform mpg to L/100km in the column of "highway-mpg", and change the name of column to "highway-L/100km".</b>
</div>

```py

```


<div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question #2 Answer: </h1>
<b>Run the code below! Did you get the right code?</b>
</div>

Double-click __here__ for the solution.

<!-- Your answer is below:
# transform mpg to L/100km by mathematical operation (235 divided by mpg)
df["highway-mpg"] = 235/df["highway-mpg"]

# rename column name from "highway-mpg" to "highway-L/100km"
df.rename(columns={'"highway-mpg"':'highway-L/100km'}, inplace=True)

# check your transformed data 
df.head()
-->

<a id="ref6"></a>
# Data Normalization 

**Why normalization?**
<div>Normalization is the process of transforming values of several variables into a similar range. Typical normalizations include scaling the variable so the variable average is 0, scaling the variable so the variable variance is 1, or scaling variable so the variable values range from 0 to 1
 </div>

**Example**
<div>To demonstrate normalization, let's say we want to scale the columns "length", "width" and "height" </div>
<div>**Target:** we would like to Normalize those variables so their value ranges from 0 to 1.</div>
<div>**Approach:** replace origianl value by (original value)/(maximum value)</div>

```py
# replace (origianl value) by (original value)/(maximum value)
df['length'] = df['length']/df['length'].max()
df['width'] = df['width']/df['width'].max()
```


<div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Questiont #3: </h1>

<b>According to the example above, normalize the column "height".</b>
</div>

```py


```


<div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question #3 Answer: </h1>
<b>Run the code below! Did you get the right code?</b>
</div>

Double-click __here__ for the solution.

<!-- Your answer is below:

df['height'] = df['height']/df['height'].max() 
# show the scaled columns
df[["length","width","height"]].head()

-->

Here we can see, we've normalized "length", "width" and "height" in the range of [0,1].

<a id="ref7"></a>
#  Binning
**Why binning?** 
<div>Binning is a process of transforming continuous numerical variables into discrete categorical 'bins', for grouped analysis.
 </div>

**Example: ** 
<div>In our dataset, "horsepower" is a real valued variable ranging from 48 to 288, it has 57 unique values. What if we only care about the price difference between cars with high horsepower, medium horsepower, and little horsepower (3 types)? Can we rearrange them into three ‘bins' to simplify analysis? </div>

<div>We will use the Pandas method 'cut' to segment the 'horsepower' column into 3 bins <div>



## Example of Binning Data In Pandas

 Convert data to correct format 

```py
df["horsepower"]=df["horsepower"].astype(float, copy=True)
```


We would like four bins of equal size bandwidth,the forth is because the function "cut"  include the rightmost edge:

```py
binwidth = (max(df["horsepower"])-min(df["horsepower"]))/4
```


We build a bin array, with a minimum value to a maximum value, with bandwidth calculated above. The bins will be values used to determine when one bin ends and another begins.

```py
bins = np.arange(min(df["horsepower"]), max(df["horsepower"]), binwidth)
bins
```


 We set group  names:

```py
group_names = ['Low', 'Medium', 'High']
```


 We apply the function "cut" the determine what each value of "df['horsepower']" belongs to. 

```py
df['horsepower-binned'] = pd.cut(df['horsepower'], bins, labels=group_names,include_lowest=True )
df[['horsepower','horsepower-binned']].head(20)
```


Check the dataframe above carefully, you will find the last column provides the bins for "horsepower" with 3 categories ("Low","Medium" and "High"). 
<div>We successfully narrow the intervals from 57 to 3!</div>

## Bins visualization 
Normally, a histogram is used to visualize the distribution of bins we created above. 

```py
%matplotlib inline
import matplotlib as plt
from matplotlib import pyplot

a = (0,1,2)

# draw historgram of attribute "horsepower" with bins = 3
plt.pyplot.hist(df["horsepower"], bins = 3)

# set x/y labels and plot title
plt.pyplot.xlabel("horsepower")
plt.pyplot.ylabel("count")
plt.pyplot.title("horsepower bins")
```


The plot above shows the binning result for attribute "horsepower". 

<a id="ref8"></a>
# Indicator variable (or dummy variable)
**What is an indicator variable?**
<div>An indicator variable (or dummy variable) is a numerical variable used to label categories. They are called 'dummies' because the numbers themselves don't have inherent meaning. </div>

**Why we use indicator variables?**
<div>So we can use categorical variables for regression analysis in the later modules.</div>

**Example**
<div>We see the column "fuel-type" has two unique values, "gas" or "diesel". Regression doesn't understand words, only numbers. To use this attribute in regression analysis, we convert "fuel-type" into indicator variables.</div>

<div>We will use the panda's method 'get_dummies' to assign numerical values to different categories of fuel type. <div>

```py
df.columns
```


 get indicator variables and assign it to data frame "dummy_variable_1" 

```py
dummy_variable_1 = pd.get_dummies(df["fuel-type"])
dummy_variable_1.head()
```


change column names for clarity 

```py
dummy_variable_1.rename(columns={'fuel-type-diesel':'gas', 'fuel-type-diesel':'diesel'}, inplace=True)
dummy_variable_1.head()
```


We now have the value 0 to represent "gas" and 1 to represent "diesel" in the column "fuel-type". We will now insert this column back into our original dataset. 

```py
# merge data frame "df" and "dummy_variable_1" 
df = pd.concat([df, dummy_variable_1], axis=1)

# drop original column "fuel-type" from "df"
df.drop("fuel-type", axis = 1, inplace=True)
```


```py
df.head()
```


The last two columns are now the indicator variable representation of the fuel-type variable. It's all 0s and 1s now.

<div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question  #4: </h1>

<b>As above, create indicator variable to the column of "aspiration": "std" to 0, while "turbo" to 1.</b>
</div>

```py


```


<div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question #4 Answer: </h1>
<b>Run the code below! Did you get the right code?</b>
</div>

Double-click __here__ for the solution.

<!-- Your answer is below:

# get indicator variables of aspiration and assign it to data frame "dummy_variable_2"
dummy_variable_2 = pd.get_dummies(df['aspiration'])

# change column names for clarity
dummy_variable_2.rename(columns={'std':'aspiration-std', 'turbo': 'aspiration-turbo'}, inplace=True)

# show first 5 instances of data frame "dummy_variable_1"
dummy_variable_2.head()

-->

 <div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question  #5: </h1>

<b>Merge the new dataframe to the original dataframe then drop the column 'aspiration'</b>
</div>

```py

```


 <div class="alert alert-danger alertdanger" style="margin-top: 20px">
<h1> Question #5 Answer: </h1>
<b>Run the code below! Did you get the right code?</b>
</div>

Double-click __here__ for the solution.

<!-- Your answer is below:

#merge the new dataframe to the original datafram
df = pd.concat([df, dummy_variable_2], axis=1)

# drop original column "aspiration" from "df"
df.drop('aspiration', axis = 1, inplace=True)

-->

 save the new csv 

```py
df.to_csv('clean_df.csv')
```


# About the Authors:  

This notebook written by [Mahdi Noorian PhD](https://www.linkedin.com/in/mahdi-noorian-58219234/) ,[Joseph Santarcangelo PhD]( https://www.linkedin.com/in/joseph-s-50398b136/), Bahare Talayian, Eric Xiao, Steven Dong, Parizad , Hima Vsudevan and [Fiorella Wenver](https://www.linkedin.com/in/fiorellawever/).
Copyright &copy; 2017 [cognitiveclass.ai](cognitiveclass.ai?utm_source=bducopyrightlink&utm_medium=dswb&utm_campaign=bdu). This notebook and its source code are released under the terms of the [MIT License](https://bigdatauniversity.com/mit-license/).


 <a href="http://cocl.us/DA0101EN_NotbookLink_bottom"><img src = "https://ibm.box.com/shared/static/cy2mwm7519t4z6dxefjpzgtbpi9p8l7h.png" width = 750, align = "center"></a>