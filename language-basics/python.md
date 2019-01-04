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
| '               | \\'          |
| "               | \\"          |
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

