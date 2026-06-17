 <div class="alert alert-block alert-info" style="margin-top: 20px">
 <a href="http://cocl.us/NotebooksPython101"><img src = "https://ibm.box.com/shared/static/yfe6h4az47ktg2mm9h05wby2n7e8kei3.png" width = 750, align = "center"></a>




<a href="https://www.bigdatauniversity.com"><img src = "https://ibm.box.com/shared/static/ugcqz6ohbvff804xp84y4kqnvvk3bq1g.png" width = 300, align = "center"></a>

<h1 align=center><font size = 5>WRITING YOUR OWN FUNCTIONS IN PYTHON</font></h1>

## Table of Contents


<div class="alert alert-block alert-info" style="margin-top: 20px">
<ol>

<li><a href="#ref1">What is a Function?</a></li>
<li><a href="#ref3">Using if/else statements in functions</a></li>
<li><a href="#ref4">Setting default argument values in your custom functions</a></li>
<li><a href="#ref6">Global and local variables</a></li>
<li><a href="#ref7">Scope of a Variable </a></li>

</ol>
<br>
<p></p>
Estimated Time Needed: <strong>40 min</strong>
</div>

<hr>

<hr>

<a id='ref1'></a>
<center><h2>Defining a Function</h2></center>

A function is a reusable block of code which performs operations specified in the function.  They let you break down tasks and allow you to reuse your code in different programs.

There are two types of functions :


- **Pre-defined functions**
- **User defined functions**

<h3>What is a Function?</h3>

 You can define functions to provide the required functionality. Here are simple rules to define a function in Python:
-   Functions blocks begin **def** followed by the function **name** and parentheses **()**.
-   There are input parameters or arguments that should be placed within these parentheses. 
-   You can also define parameters inside these parentheses.
-  There is a body within every function that starts with a colon (**:**) and is indented.
-  You can also place documentation before the body 
-  The statement **return**  exits a function, optionally passing back a value 

An example of a function that adds on to the parameter **a** prints and returns the output as **b**:
 

```py
def add(a):
    """
    add 1 to a
    """
    b=a+1; 
    print(a, "if you add one" ,b)
    
    return(b)
```


The figure below illustrates the terminology: 

<a ><img src = "https://ibm.box.com/shared/static/wsl6jcfld2c3171ob19vjr5chw9gyxrc.png" width = 500, align = "center"></a>
  <h4 align=center>  
   A labeled function
  </h4> 

 We can obtain help about a function :

```py
help(add)
```


We can call the function:

```py
add(1)
```


If we call the function with a new input we get a new result:

```py
add(2)
```


 We can create different functions. For example, we can create a function that multiplies two numbers. The numbers will be represented by the variables **a** and **b**:

```py
def Mult(a,b):
    c=a*b
    return(c)
```


The same function can be used for different data types. For example, we can multiply two integers:


```py
Mult(2,3)
```


 Two Floats: 

```py
Mult(10,3.14)
```


We can even replicate a string by multiplying with an integer: 

```py
Mult(2,"Michael Jackson ")
```


#### Come up with a function that divides the first input by the second input:

```py

```


Double-click __here__ for the solution.
<!-- 
def div(a,b):
    return(a/b)
 -->

 <h3>Variables </h3>


The input to a function is called a formal parameter.

A variable that is declared inside a function is called a  local variable. The parameter only exists within the function (i.e. the point where the function starts and stops).  

A variable that is declared outside a function definition is a global variable, and its value is accessible and modifiable throughout the program. We will discuss more about global variables at the end of the lab.


```py
#Function Definition   
def square(a):
    """Square the input and add one  
    """
    #Local variable 
    b=1
    c=a*a+b;
    print(a, "if you square +1 ",c) 
    return(c)

```


The labels are displayed in the figure:  

<a ><img src = "https://ibm.box.com/shared/static/gpfa525nnfwxt5rhrvd3o6i8rp2iwsai.png" width = 500, align = "center"></a>
  <h4 align=center>  
    Figure 2: A function with labeled variables  
  </h4> 




We can call the function  with an input of 3:

```py
#Initializes Global variable  

x=3
#Makes function call and return function a y
z=square(x)
z
```


 We can call the function  with an input of 2 in a different manner:

```py
square(2)
```


 If there is no **return** statement, the function returns **None**. The following two functions are equivalent:  
  

```py
def MJ():
    print('Michael Jackson')
    
def MJ1():
    print('Michael Jackson')
    return(None)
```


```py
MJ()
```


```py
MJ1()
```


 Printing the function after a call reveals a **None** is the default return statement:

```py
print(MJ())
print(MJ1())
```


#### Create a function **con** that  concatenates two strings using the addition operation:
: 

```py
def con(a,b):
    return(a+b)
```


Double-click __here__ for the solution.
<!-- 
def div(a,b):
    return(a+b)
 -->

#### Can the same function be used to add to integers or strings?

```py

```


 Double-click __here__ for the solution.
<!-- 
yes,for example: 
con(2,2)
 -->

#### Can the same function be used to concentrate a list or tuple?

```py

```


Double-click __here__ for the solution.
<!-- 
yes,for example: 
con(['a',1],['b',1])
 -->

<h3><b>Pre-defined functions</b></h3>

There are many pre-defined functions in Python, so let's start with the simple ones.

The **print()** function:

```py
album_ratings = [10.0,8.5,9.5,7.0,7.0,9.5,9.0,9.5] 
print(album_ratings)
```


The **sum()** function adds all the  elements in a list or tuple:

```py
sum(album_ratings)
```


 The length function returns the length of a list or tuple: 

```py
len(album_ratings)
```


<div class="alert alert-success alertsuccess" style="margin-top: 20px">
<h4> [Tip] How do I learn more about the pre-defined functions in Python? </h4>
<p></p>
We will be introducing a variety of **pre-defined functions** to you as you learn more about Python. There are just too many functions, so there's no way we can teach them all in one sitting. But if you'd like to take a quick peek, here's a short reference card for some of the commonly-used pre-defined functions:   
http://www.astro.up.pt/~sousasag/Python_For_Astronomers/Python_qr.pdf
</div>

<h3>Functions Makes Things Simple </h3>

Consider the two lines of code in **Block 1** and **Block 2**: the procedure for each block is identical. The only thing that is different is the variable names and values.


### Block 1:

```py
a1=4;
b1=5;
c1=a1+b1+2*a1*b1-1
if(c1<0):
    c1=0; 
else:
    c1=5;
c1   
```


### Block 2:

```py
a2=0;
b2=0;
c2=a2+b2+2*a2*b2-1
if(c2<0):
    c2=0; 
else:
    c2=5;
c2   
```


We can replace the lines of code with a function. A function combines many instructions into a single line of code. Once a function is defined, it can be used repeatedly. You can invoke the same function many times in your program. You can save your function and use it in another program or use someone else’s function. The lines of code in code **block 1** and code **block 2** can be replaced by the following function:  
 


```py
def Equation(a,b):
    c=a+b+2*a*b-1
    if(c<0):
        c=0
        
    else:
        c=5
    return(c) 

```


 This function takes two inputs, a and b, then applies several operations to return c. 
We simply define the function, replace the instructions with the function, and input the new values of **a1**,**b1** and **a2**,**b2** as inputs. The entire process is demonstrated in the figure: 

<a ><img src = "https://ibm.box.com/shared/static/efn4rii75bgytjdb5c8ek6uezch7yaxq.gif" width = 1100, align = "center"></a>
  <h4 align=center>  
    Example of a function used to replace redundant lines of code 
  </h4> 

Code **Blocks 1** and **Block 2** can now be replaced with code **Block 3** and code **Block 4**.

### Block 3:

```py
a1=4;
b1=5;
c1=Equation(a1,b1)
c1
```


### Block 4:

```py
a2=0;
b2=0;
c2=Equation(a2,b2)
c2
```


<hr>

<a id='ref3'></a>
<center><h2>Using if/else statements and loops in functions</h2></center>

The **return()** function is particularly useful if you have any IF statements in the function, when you want your output to be dependent on some condition: 

```py
def type_of_album(artist,album,year_released):
    if year_released > 1980:
        print(artist,album,year_released)
        return "Modern"
    else:
        print(artist,album,year_released)
        return "Oldie"
    
x = type_of_album("Michael Jackson","Thriller",1980)
print(x)

```


 We can use a loop in a function. For example, we can **print** out each element in  a list:

```py
def PrintList(the_list):
    for element in the_list:
        print(element)
```


```py
PrintList(['1',1,'the man',"abc"])
```


<hr>

<a id='ref4'></a>
<center><h2>Setting default argument values in your custom functions</h2></center>

You can set a default value for arguments in your function. For example, in the **`isGoodRating()`** function, what if we wanted to create a threshold for what we consider to be a good rating? Perhaps by default, we should have a default rating of 4:


```py
def isGoodRating(rating=4): 
    if(rating < 7):
        print("this album sucks it's rating is",rating)
        
    else:
        print("this album is good its rating is",rating)

```


<hr>

```py
isGoodRating()
isGoodRating(10)
   
```


<a id='ref6'></a>
<center><h2>Global variables</h2></center>
<br>
So far, we've been creating variables within functions, but we have not discussed variables outside the function.  These are called global variables. 
<br>
Let's try to see what **printer1** returns:

```py
artist = "Michael Jackson"
def printer1(artist):
    internal_var = artist
    print(artist,"is an artist")
    
printer1(artist)

```


 If we print **internal_var** we get an error. 

**We got a Name Error:**  `name 'internal_var' is not defined`. **Why?**  

It's because all the variables we create in the function is a **local variable**, meaning that the variable assignment does not persist outside the function.  

But there is a way to create **global variables** from within a function as follows:

```py
artist = "Michael Jackson"

def printer(artist):
    global internal_var 
    internal_var= "Whitney Houston"
    print(artist,"is an artist")

printer(artist) 
printer(internal_var)

```


 <a id='ref7'></a>
<center><h2>Scope of a Variable</h2></center>

<hr>

 The scope of a variable is the part of that program where that variable is accessible. Variables that are declared outside of all function definitions, such as the **myFavouriteBand** variable in the code shown here, are accessible from anywhere within the program. As a result, such variables are said to have global scope, and are known as global variables. 
    **myFavouriteBand** is a global variable, so it is accessible from within the **getBandRating** function, and we can use it to determine a band's rating. We can also use it outside of the function, such as when we pass it to the print function to display it:

```py
myFavouriteBand = "AC/DC"

def getBandRating(bandname):
    if bandname == myFavouriteBand:
        return 10.0
    else:
        return 0.0

print("AC/DC's rating is:", getBandRating("AC/DC"))
print("Deep Purple's rating is:",getBandRating("Deep Purple"))
print("My favourite band is:", myFavouriteBand)
```


 Take a look at this modified version of our code. Now the **myFavouriteBand** variable is defined within the **getBandRating** function. A variable that is defined within a function is said to be a local variable of that function. That means that it is only accessible from within the function in which it is defined. Our **getBandRating** function will still work, because **myFavouriteBand** is still defined within the function. However, we can no longer print **myFavouriteBand** outside our function, because it is a local variable of our **getBandRating** function; it is only defined within the **getBandRating** function:

```py
def getBandRating(bandname):
    myFavouriteBand = "AC/DC"
    if bandname == myFavouriteBand:
        return 10.0
    else:
        return 0.0

print("AC/DC's rating is: ", getBandRating("AC/DC"))
print("Deep Purple's rating is: ", getBandRating("Deep Purple"))
print("My favourite band is", myFavouriteBand)
```


 Finally, take a look at this example. We now have two **myFavouriteBand** variable definitions. The first one of these has a global scope, and the second of them is a local variable within the **getBandRating** function. Within the **getBandRating** function, the local variable takes precedence. **Deep Purple** will receive a rating of 10.0 when passed to the **getBandRating** function. However, outside of the **getBandRating** function, the **getBandRating** s local variable is not defined, so the **myFavouriteBand** variable we print is the global variable, which has a value of **AC/DC**:

```py
myFavouriteBand = "AC/DC"

def getBandRating(bandname):
    myFavouriteBand = "Deep Purple"
    if bandname == myFavouriteBand:
        return 10.0
    else:
        return 0.0

print("AC/DC's rating is:",getBandRating("AC/DC"))
print("Deep Purple's rating is: ",getBandRating("Deep Purple"))
print("My favourite band is:",myFavouriteBand)
```


 <a href="http://cocl.us/NotebooksPython101bottom"><img src = "https://ibm.box.com/shared/static/irypdxea2q4th88zu1o1tsd06dya10go.png" width = 750, align = "center"></a>




# About the Authors:  

 [Joseph Santarcangelo]( https://www.linkedin.com/in/joseph-s-50398b136/) has a PhD in Electrical Engineering, his research focused on using machine learning, signal processing, and computer vision to determine how videos impact human cognition. Joseph has been working for IBM since he completed his PhD.
 
 [James Reeve]( https://www.linkedin.com/in/reevejamesd/) James Reeves is a Software Engineering intern at IBM.

 <hr>
Copyright &copy; 2017 [cognitiveclass.ai](cognitiveclass.ai?utm_source=bducopyrightlink&utm_medium=dswb&utm_campaign=bdu). This notebook and its source code are released under the terms of the [MIT License](https://bigdatauniversity.com/mit-license/).