# Python

Some basic language syntax and operation for python

- [Python](#python)
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