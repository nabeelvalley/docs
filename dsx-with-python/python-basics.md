# Python Basics

[Based on this Cognitive Class Course](https://cognitiveclass.ai/learn/data-science-with-python/)

- [Python Basics](#python-basics)
  - [Labs](#labs)
  - [Types](#types)
    - [Hello World](#hello-world)
    - [Python Version](#python-version)
    - [Comments](#comments)
    - [Docstrings](#docstrings)
    - [Types of Objects](#types-of-objects)
    - [Type Conversion](#type-conversion)
    - [Expressions](#expressions)
    - [Variables](#variables)
  - [Strings](#strings)
    - [Defining Strings](#defining-strings)
    - [Indexing](#indexing)
    - [Length](#length)
    - [Slicing](#slicing)
    - [Stride](#stride)
    - [Concatenation](#concatenation)
    - [Escape Characters](#escape-characters)
    - [String Operations](#string-operations)
  - [Tuples](#tuples)
    - [Define](#define)
    - [Indexing](#indexing-1)
    - [Concatenation](#concatenation-1)
    - [Slice and Stride](#slice-and-stride)
    - [Sorting](#sorting)
    - [Nesting](#nesting)
  - [Lists](#lists)
    - [Defining](#defining)
    - [Indexing](#indexing-2)
    - [Operations](#operations)
      - [Slice and Stride](#slice-and-stride-1)
      - [Extend](#extend)
      - [Append](#append)
    - [Modify an element](#modify-an-element)
    - [Delete an Element](#delete-an-element)
    - [String Splitting](#string-splitting)
    - [Cloning](#cloning)
  - [Sets](#sets)
    - [Defining a Set](#defining-a-set)
    - [Set Operations](#set-operations)
      - [Set from a List](#set-from-a-list)
      - [Add Element](#add-element)
      - [Remove Element](#remove-element)
      - [Check if Element is in Set](#check-if-element-is-in-set)
    - [Set Logic](#set-logic)
      - [Intersection](#intersection)
      - [Difference](#difference)
      - [Union](#union)
      - [Superset](#superset)
      - [Subset](#subset)
  - [Dictionaries](#dictionaries)
    - [Defining](#defining-1)
    - [Accessing a Value](#accessing-a-value)
    - [Get All Keys](#get-all-keys)
    - [Append a Key](#append-a-key)
    - [Delete an Entry](#delete-an-entry)
    - [Verify that Key is in Dictionary](#verify-that-key-is-in-dictionary)
  - [Conditions and Branching](#conditions-and-branching)
    - [Comparison Operators](#comparison-operators)
    - [Logical Operators](#logical-operators)
    - [String Comparison](#string-comparison)
  - [Branching](#branching)
    - [If](#if)
    - [If-Else](#if-else)
    - [Elif](#elif)
  - [Loops](#loops)
    - [For Loops](#for-loops)
    - [Range](#range)
    - [While Loops](#while-loops)
  - [Functions](#functions)
    - [Defining](#defining-2)
    - [Help](#help)
    - [Scope](#scope)
  - [Objects and Classes](#objects-and-classes)
    - [Defining a Class](#defining-a-class)
    - [Instantiating an Object](#instantiating-an-object)
    - [Interacting with our Object](#interacting-with-our-object)
  - [Reading Files](#reading-files)
    - [Open](#open)
      - [Properties](#properties)
      - [Read](#read)
      - [Close](#close)
    - [With](#with)
    - [Read File by Characters](#read-file-by-characters)
    - [Read File by Lines](#read-file-by-lines)
  - [Writing Files](#writing-files)
  - [Copy a File](#copy-a-file)
  - [Pandas](#pandas)
    - [Importing Pandas](#importing-pandas)
    - [Creating a DataFrame](#creating-a-dataframe)
    - [Read CSV as DataFrame](#read-csv-as-dataframe)
    - [Read XLSX as DataFrame](#read-xlsx-as-dataframe)
    - [View DataFrame](#view-dataframe)
    - [Working with DataFrame](#working-with-dataframe)
      - [Assigning Columns](#assigning-columns)
      - [Reading Cells](#reading-cells)
      - [Slicing](#slicing-1)
    - [Saving Data to CSV](#saving-data-to-csv)


## Labs

Jupyter Notebooks with Examples on these can be found in the `labs` folder

The Labs are from [this Cognitive Class Course](https://cognitiveclass.ai/learn/data-science-with-python/) and are under the MIT License

## Types

### Hello World

We can simply print out a string in Python as follows

```py
print('Hello, World!')
```

### Python Version

We can check our version as follows

```py
import sys
print(sys.version)
```

The `sys` module is a built-in module that has many system specific parameters and functions

### Comments

Comments can be done by using the `#`

```py
# Python comments
```

### Docstrings

Python also allows for use of docstrings which can appear immediately after a function, class definition, or at the top of a module, these are done as follows

```python
def hello():
    '''
    This function will say hello
    It also takes no input arguments
    '''
    return 'Hello'
hello()
```

Also note that Python uses `'` and `"` to mean the same thing

### Types of Objects

Python is object oriented, and dynamically typed. We can get the type of a value in python with the `type` function

```py
type(12) # int
type(2.14) # float
type("Hello") # str
type(True) # bool
type(False) # bool
```

We can get information about a type using the `sys` object properties, for example

```py
sys.float_info
```

### Type Conversion

We can use the following to convert between types

```py
float(2)
int(1.1)
int('1')
str(1)
str(1.1)
int(True) # 1
int(False) # 0
float(True) # 1.0
bool(1) # True
```

### Expressions

Expressions in python can include integers, floats, and strings, depending on the operation

We can do the following

```py
1 + 2 # addition
1 - 2 # subtraction
1 / 2 # division
1 // 2 # integer division
```

Integer division will round off to the nearest integer

It is also helpful to note that Python will obey BODMAS

### Variables

Variables can simply be assigned without being defined first, and are dynamically types

```py
x = 2
y = x / 2

x = 2 + 4
x = 'Hello'
```

In a notebook we can simply evaluate the value of a variable or expression by placing it as the last line of a cell

## Strings

### Defining Strings

Strings can be defined with either `'` or `"`, and can be a combination of any characters

```py
'Hello World'
'H3110 Wor!$'
"Hello World"
```

### Indexing

Strings are simply an ordered sequence of characters, we can index these as any other array with `[]` as follows

```py
name = 'John'
name[0] # J
name[3] # n
```

We can also index negatively as follows

```py
name = 'John'
name[-1] # n
name[-4] # J
```

### Length

We can get the length of a string with `len()`

```py
len(name) # 4
```

### Slicing

We can slice strings as follows

```py
name = 'John Smith'
name[0:4] # John
name[5:7] # Sm
```

Or generally as

```py
string[start:end]
```

### Stride

We can also input the stride, which will select every nth value within a certain range

```py
string[::stride]
string[start:stop:stride]
```

For example

```py
name[::3] # Jnmh
name[0:4:2] # Jh
```

### Concatenation

We can concatenate strings as follows

```py
text = 'Hello'
text + text # HelloHello
text * 3 # HelloHelloHello
```

### Escape Characters

At times we may need to escape some characters in a Python string, these are as follows

| Character       | Escape      |
| --------------- | ----------- |
| newline         | \<NEW LINE> |
| \               | \\          |
| '               | \\'         |
| "               | \\"         |
| ASCII Bell      | \a          |
| ASCII Backspace | \b          |
| ASCII FF        | \f          |
| ASCII LF        | \n          |
| ASCII CR        | \r          |
| ASCII Tab       | \t          |
| ASCII VT        | \v          |
| Octal Character | \ooo        |
| Hex Character   | \xhh        |

We can also do multi line strings with the `"""` or `'''`

If we have a string that would otherwise need escaping, we can use a string literal as follows

```py
text = r'\%\n\n\t'
text # '\%\n\n\t'
```

### String Operations

We have a variety of string operations such as

```py
text = 'Hello;
text.upper() # HELLO
text.lower() # hello
text.replace('Hel', 'Je') # Jello
text.find('l') # 2
text.find('ell') # 1
text.find('asnfoan') # -1
```

## Tuples

### Define

A tuple is a way for us to store data of different types, this can be done simply as follows

```py
my_tuple = ('Hello', 3, 0.14)
type(my_tuple) # tuple
```

A key thing about tuples is that they are immutable. We can reassign the entire tuple, but not change its values

### Indexing

We can index a tuple the same way as a string or list using positive or negative indexing

```py
my_tuple[1] # 3
my_tuple[-2] # 3
```

### Concatenation

We can also concatenate tuples

```py
my_tuple += ('pies', 'are', 3.14)
my_tuple # ('Hello', 3, 0.14, 'pies', 'are', 3.14)
```

### Slice and Stride

We can slice and stride as usual with

```py
my_tuple[start:end]
my_tuple[::2]
my_tuple[0:4:2]
```

### Sorting

We can sort a tuple with the `sorted` function

```py
sorted(tuple)
```

The `sorted` function will return a **list**

### Nesting

Since tuples can hold anything, they can also hold tuples

```py
my_tuple = ('hello', 4)
my_tuple2 = (my_tuple, 'bye')
```

We can access elements of tuples with double indexing as follows

```py
my_tuple2[0][1] # 4
```

## Lists

### Defining

A list is an easy way for us to store data of any form, such as numbers, strings, tuples, and lists

Lists are mutable and have many operations that enable us to work with them more easily

```py
my_list = [1,2,3,'Hello']
```

### Indexing

Lists can also be indexed using the usual method both negatively and positively

```py
my_list[1] # 2
my_list[-1] # Hello
```

### Operations

#### Slice and Stride

```py
my_list[start:end] # slicing
my_list[::stride]
my_list[start:end:stride]
```

#### Extend

Extend will add each object to the end of the list

```py
my_list = [1,2]
my_list.extend([item1, item2])
my_list # [1, 2, item1, item2]
```

#### Append

Append will add the input as a single object to the last value of the list

```py
my_list = [1,2]
my_list.append([item1, item2])
my_list # [1, 2, [item1, item2]]
```

### Modify an element

List elements can be modified by referencing the index

```py
my_list = [1,2]
my_list[1] = 3
my_list # [1,3]
```

### Delete an Element

```py
my_list = [1,2,3]
del(my_list[1])
my_list # [1,3]
```

We can delete elements by index as well

### String Splitting

We can split a string into a list as follows

```py
my_list = 'hello'.split()
my_list # [h,e,l,l,o]

my_list = 'hello, world, !'.split(',')
my_list # ['hello', 'world', '!']
```

### Cloning

Lists are stored by reference in Python, if we want to clone a list we can do it as follows

```py
new_list = my_list[:]
```

## Sets

A set is a unique collection of objets in Python, sets will automatically remove duplicate items

### Defining a Set

```py
my_set = {1, 2, 3, 1, 2}
my_set # {1, 2, 3}
```

### Set Operations

#### Set from a List

We can create a set from a list with the `set` function

```py
my_set = set(my_list)
```

#### Add Element

We can add elements to a set with

```py
my_set.add("New Element")
```

If the element already exists nothing will happen

#### Remove Element

We can remove an element from a set with

```py
my_set.remove("New Element")
```

#### Check if Element is in Set

We can check if an element is in a set by using `in` which will return a `bool`

```py
"New Element" in my_set # False
```

### Set Logic

When using sets we can compare them with one another

#### Intersection

We can find the intersection between sets with `&` or with the intersection function

```py
set_1 & set_2
set_1.intersection(set_2)
```

#### Difference

We can fin d the difference in a specific set relative to another set with

```py
set_1.difference(set_2)
```

Which will give us the elements that `set_1` has that `set_2` does not

#### Union

We can get the union of two sets with

```py
set_1.union(set_2)
```

#### Superset

We can check if one set is a superset of another with

```py
set_1.issuperset(set_2)
```

#### Subset

We can check if one set is a subset of another with

```py
set_1.isSubset(set_2)
```

## Dictionaries

Dictionaries are like lists, but store data by a key instead of an index

Keys can be strings, numbers, or any immutable object such as a tuple

### Defining

We can define a dictionary as a set of key-value pairs

```py
my_dictionary = {"key1": 1, "key2": "2", "key3": [3, 3, 3], "key4": (4, 4, 4), ('key5'): 5, (0, 1): 6, 92: 'hello'}
```

### Accessing a Value

We can access a value by using its key, such as

```py
my_dictionary['key1'] # 1
my_dictionary[(0,1)] # 6
my_dictionary[5] # 'hello'
```

### Get All Keys

We can get all the keys in a dictionary as follows

```py
my_dictionary.keys()
```

### Append a Key

Key-value pairs can be added to a dictionary as follows

```py
my_dictionary['New Key'] = new_value
```

### Delete an Entry

We can delete an entry by key using

```py
del('New Key)
```

### Verify that Key is in Dictionary

We can use the `in` operator to check if a key exists in a dictionary

```py
'My Key' in my_dictionary
```

## Conditions and Branching

### Comparison Operators

We have a few different comparison operators which will produce a boolean based on their condition

| Operation             | Operator | `i = 1`             |
| --------------------- | -------- | ------------------- |
| equal                 | `==`     | `i == 1`            |
| not equal             | `!=`     | `i != 0`            |
| greater than          | `>`      | `i > 0`             |
| less than             | `<`      | `i < 2`             |
| greater than or equal | `>=`     | `i >= 0 and i >= 1` |
| less than or equal    | `<=`     | `i <= 2 and i <= 1` |


### Logical Operators

Python has the following logical operators

| Operation | Operator | `i = 1`             |
| --------- | -------- | ------------------- |
| and       | `and`    | ` i == 1 and i < 2` |
| or        | `or`     | ` i == 1 or i == 2` |
| not       | `not`    | ` not(i != 0) `     |

### String Comparison

When checking for equality Python will check if the strings are the same

```py
'hello' != 'bye' # True
```

Comparing strings is based on the ASCII Code for the string, for example `'B' > 'A'` because the ASCII Code for B is 102 and A is 101

When comparing strings like this the comparison will be done in order of the characters in the string

## Branching

Branching allows us to run different statements depending on a condition

### If

The if statement will only run the code that forms part of its block if the condition is true

```py
i = 0
if i == 0:
  print('Hello')
```

### If-Else

An if-else can be done as follows

```py
i = 0
if i == 1:
  print('Hello')
else:
  print('Bye')
```

### Elif

If we want to have multiple if conditions, but only have the first one that is true be executed we can do

```py
i = 0
if i == 1:
  print('Hello')
elif i == 0:
  print('Hello World')
elif i > 1:
  print('Hello World!!')
else:
  print('Bye')
```

## Loops

### For Loops

A for loop in Python iterates through a list and executes its internal code block

```py
loop_vals = [1,6,2,9]
for i in loop_vals:
  print(i)
#1 6 2 9
```

### Range

If we want to iterate through the values without using a predefined list, we can use the range function to generate a list of values for us to to iterate through

The `range` function works as follows

```py
ran = range([start,], stop, [,step])
ran # [start, start + step, start + 2*step, ... , stop -1]
```

The range function only requires the stop value, the other two are optional,the stop value is not inclusive

```py
range(5) # [0,1,2,3,4]
range(5, 10) # [5,6,7,8,9]
range(5, 10, 2) # [5,7,9]
```

Using this we can iterate through the values of our array as follows

```py
loop_vals = [1,6,2,9]
for i in range(len(loop_vals)):
  print(loop_vals[i])
```

### While Loops

While loops will continue until the stop condition is no longer true

```py
i = 0
while (i < 10):
  print(i)
  i ++
# 0 1 3 4 5 6 7 8 9
```

## Functions

### Defining

Functions in Python are defined and called as follows

```py
def hello():
  print('Hello')

hello() # Hello
```

We can have arguments in our function

```py
def my_print(arg1, arg2):
  print(arg1, arg2)

my_print('Hello', 'World') # Hello World
```

Functions can also return values

```py
def my_sum(val1, val1):
  answer = val1 + val2
  return answer

my_sum(1,2) # 3
```

A function can also have a variable number of arguments such as

```py
def sum_all(*vals):
  return sum(vals)

sum_all(1,2,3) # 6
```

> The vals object will be taken in as a tuple

Function input arguments can also have default values as follows

```py
def has_default(arg1 = 4):
  print(arg1)

has_default() # 4
has_default(5) # 5
```

Or with multiple arguments

```py
def has_defaults(arg1, arg2 = 4):
  print(arg1, arg2)

has_defaults(5) # 5 4
has_defaults(5,6) # 5 6
```

### Help

We can get help about a function by calling the help function

```py
help(print)
```

Will give us help about the print function

### Scope

Functions have access to variables that are globally defined, as well as their own local scope. Locally defined variables are not accessible from outside the function unless we declare it as global as follows

```py
def make_global():
  global global_var = 5

make_global()
global_var # 5
```

Note that the `global_var` will not be defined until our function is at least called once

## Objects and Classes

### Defining a Class

We can define a class `Circle` which has a constructor, a radius and a colour as well as a function to increase its radius and to plot the Circle

We make use of `matplotlib` to plot our circle here

```py
import matplotlib.pyplot as plt
%matplotlib inline  

class Circle(object):
  
  def __init__(self, radius=3, color='blue'):
    self.radius = radius
    self.color = color
  
  def add_radius(self, r)
    self.radius += r
    return(self.radius)

  def draw_circle(self):      
    plt.gca().add_patch(plt.Circle((0, 0), radius=self.radius, fc=self.color))
    plt.axis('scaled')
    plt.show()  
```

### Instantiating an Object

We can create a new `Circle` object by using the classes constructor

```py
red_circle = Circle(10, 'red')
```

### Interacting with our Object

We can use the `dir` function to get a list of all the methods on an object, many of which are defined by Python already

```py
dir(red_circle)
```

We can get our object's property values by simply referring to them

```py
red_circle.color # red
red_circle.radius # 10
```

We can also manually change the object's properties with

```py
red_circle.color = 'pink'
```

We can call our object's functions the same way

```py
red_circle.add_radius(10) # 20
red_circle.radius # 20
```

The `red_circle` can be plotted by calling the `draw_circle` function

## Reading Files

Note that the preferred method for reading files is [using `with`](#with)

### Open

We can use the built-in `open` function to read a file which will provide us with a `File` object

```py
example1 = '/data/test.txt'
file1 = open(example1,'r')
```
The `'r'` sets open to read mode, for write mode we can use `'w'`

#### Properties

`File` objects have some properties such as

```py
file1.name
file1.mode
```

#### Read

We can read the file contents to a string with the following

```py
file_content = file1.read()
```

#### Close

Lastly we need to close our `File` object with

```py
file1.close
```

We can verify that the file is closed with

```py
file1.closed # True
```

### With

A better way to read files is by using using the `with` statement which will automatically close the file, even if we encounter an exception

```py
with open(example1) as file1:
  file_content = file1.read()
```

We can also read the file in by pieces either based on characters or on lines

### Read File by Characters

We can read the first four characters with

```py
with open(example1,'r') as file1:
  content = file1.read(4)
```

Note that this will still continue to parse the file, and not start over each time we call `read()`, so we can read the first seven characters is like so

```py
with open(example1,'r') as file1:
  content = file1.read(4)
  content += file1.read(3)
```

### Read File by Lines

Our `File` object looks a lot like a list with each line a new element in the list

We can read our file by lines as follows

```py
with open(example1,'r') as file1:
  content = file1.readline()
```

We can read each line of our file into a list with the `readline` function like so

```py
content = []
with open(example1,'r') as file1:
  for line in file1:
    content.append(line)
```

Or with the `readlines` function like so

```py
with open(example1, 'r') as file1:
  content = file1.readlines()
```

## Writing Files

We can also make use of open to write content to a file as follows

```py
out_path = 'data/output.txt'
with open(out_path, 'w') as out_file:
  out_file.write('content')
```

The `write` function works the same as the `read` function in that each time we call it, it will just write a single line to the file, if we want to write multiple lines to our file w need to do this as follows


```py
content = ['Line 1 content', 'Line 2 content', 'Line 3 content']
with open(out_path, 'w') as out_file:
  for line in content:
    out_file.write(line)
```

## Copy a File

We can copy data from one file to another by simultaneously reading and writing between the files

```py
with open('readfile.txt','r') as readfile:
  with open('newfile.txt','w') as writefile:
    for line in readfile:
      writefile.write(line)
```

## Pandas

Pandas is a library that is useful for working with data as a DataFrame in Python


### Importing Pandas

The Pandas library will need to be installed and then imported into our notebook as

```py
import pandas as pd
```

### Creating a DataFrame

We can create a new DataFrame in Pandas as follows

```py
df = pd.DataFrame({'Name':['John','Jack','Smith','Jenny','Maria'],
                'Age':[23,12,34,13,42],
                'Height':[1.2,2.3,1.1,1.6,0.5]})
```

### Read CSV as DataFrame

We can read a csv as a DataFrame with Pandas by doing the following

```py
csv_path ='data.csv'
df = pd.read_csv(csv_path)
```

### Read XLSX as DataFrame

We need to install an additional dependency to do this firstm and then read it with the `pd.read_excel` function

```py
!pip install xlrd
xlsx_path = 'data.xlsx'
df = pd.read_excel(xlsx_path)
```

### View DataFrame

We can view the first few lines of our DataFrame as follows

```py
df.head()
```

Assume our data looks like the following

|     | Name  | Age | Height |
| --- | ----- | --- | ------ |
| 0   | John  | 23  | 1.2    |
| 1   | Jack  | 12  | 2.3    |
| 2   | Smith | 34  | 1.1    |
| 3   | Jenny | 13  | 1.6    |
| 4   | Maria | 42  | 0.5    |

### Working with DataFrame

#### Assigning Columns

We can read the data from a specific column as follows

```py
ages = df[['age']]
```

|     | Age |
| --- | --- |
| 0   | 23  |
| 1   | 12  |
| 2   | 34  |
| 3   | 13  |
| 4   | 42  |

We can also assign multiple columns

```py
age_vs_height = df[['Age', 'Height']]
```

|     | Age | Height |
| --- | --- | ------ |
| 0   | 23  | 1.2    |
| 1   | 12  | 2.3    |
| 2   | 34  | 1.1    |
| 3   | 13  | 1.6    |
| 4   | 42  | 0.5    |

#### Reading Cells

We can read a specific cell in one of two ways. The `iloc` fnction allows us to access a cell with the row and column index, and the `loc` function lets us do this with the row index and column name

```py
df.iloc[1,2] # 2.3
df.loc[1, 'Height'] # 2.3
```

#### Slicing

We can also do slicing using `loc` and `iloc` as follows

```py
df.iloc[1:3, 0:2]
```

|     | Name  | Age |
| --- | ----- | --- |
| 1   | Jack  | 12  |
| 2   | Smith | 34  |

```py
df.loc[0:2, 'Age':'Height']
```
|     | Age | Height |
| --- | --- | ------ |
| 0   | 23  | 1.2    |
| 1   | 12  | 2.3    |
| 2   | 34  | 1.1    |

### Saving Data to CSV

Using Pandas, we can save our DataFrame to a CSV with

```py
df.to_csv('my_dataframe.csv')
```

