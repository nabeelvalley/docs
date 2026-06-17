 <div class="alert alert-block alert-info" style="margin-top: 20px">
 <a href="http://cocl.us/NotebooksPython101"><img src = "https://ibm.box.com/shared/static/yfe6h4az47ktg2mm9h05wby2n7e8kei3.png" width = 750, align = "center"></a>




<a href="https://www.bigdatauniversity.com"><img src = "https://ibm.box.com/shared/static/ugcqz6ohbvff804xp84y4kqnvvk3bq1g.png" width = 300, align = "center"></a>



<h1 align=center><font size = 5>Numpy in Python</font></h1>

```py
import time 
import sys
import numpy as np 

import matplotlib.pyplot as plt
%matplotlib inline  
```


```py
def Plotvec1(u,z,v):
    #this function is used in code 
    ax = plt.axes()
    ax.arrow(0, 0, *u, head_width=0.05,color ='r', head_length=0.1)
    plt.text(*(u+0.1), 'u')
    
    ax.arrow(0, 0, *v, head_width=0.05,color ='b', head_length=0.1)
    plt.text(*(v+0.1), 'v')
    ax.arrow(0, 0, *z, head_width=0.05, head_length=0.1)
    plt.text(*(z+0.1), 'z')
    plt.ylim(-2,2)
    plt.xlim(-2,2)



def Plotvec2(a,b):
    #this function is used in code 
    ax = plt.axes()
    ax.arrow(0, 0, *a, head_width=0.05,color ='r', head_length=0.1)
    plt.text(*(a+0.1), 'a')
    ax.arrow(0, 0, *b, head_width=0.05,color ='b', head_length=0.1)
    plt.text(*(b+0.1), 'b')

    plt.ylim(-2,2)
    plt.xlim(-2,2)
```


If you recall, a  Python list is a container that allows you to store and access data. We can create a Python List as follows:

```py
a=["0",1,"two","3",4]
```


We can access the data via an index:

<img src = "https://ibm.box.com/shared/static/myq8bs3maj0g1sqn9yqo910zwparhhtj.png" width = 660, align = "center">


We can access each element using a square bracket as follows: 

```py
print("a[0]:",a[0])
print("a[1]:",a[1])
print("a[2]:",a[2])
print("a[3]:",a[3])
print("a[4]:",a[4])
```


A numpy array is similar to a list, it's usually fixed in size and each element is of the same type. We can cast a list to a numpy array by first importing numpy: 

```py
import numpy as np 
```


 We then cast the list as follows:

```py
a=np.array([0,1,2,3, 4])
a
```


Each element is of the same type, in this case integers: 

<img src = "https://ibm.box.com/shared/static/sb97ysreaayf24b8ece1452e8m5e2vol.png" width = 500, align = "center">


 As with lists, we can access each element via a square bracket:

```py
print("a[0]:",a[0])
print("a[1]:",a[1])
print("a[2]:",a[2])
print("a[3]:",a[3])
print("a[4]:",a[4])
```


The value of “a” is stored a follows: 

```py
a
```


If we check the type of the array we get "numpy.ndarray":

```py
type(a)
```


As numpy arrays contain data of the same type, we can use the attribute "dtype" to obtain the Data-type of the array’s elements. In this case a 64-bit integer: 


```py
a.dtype
```


We can create a numpy array with real numbers:

```py
b=np.array([3.1,11.02,6.2, 213.2,5.2])
```


When we check the type of the array we get "numpy.ndarray":

```py
type(b)
```


If we examine the attribute "dtype" we see float 64, as the elements are not integers: 

```py
b.dtype
```


We can change the value of the array, consider the array "c":

```py
c=np.array([20,1,2,3,4])
c
```


We can change the first element of the array to 100 as follows:

```py
c[0]=100
c
```


We can change the 5th element of the array as follows:

```py
c[4]=0
c
```



Like lists, we can slice the numpy array, and we can select the elements from 1 to 3 and assign it to a new numpy array 'd' as follows:


```py
d=c[1:4]
d
```


We can assign the corresponding indexes to  new values as follows: 

```py
c[3:5]=300,400
c
```


Similarly, we can use a list to select a specific index.
The list ' select ' contains several values:


```py
select=[0,2,3]
```


We can use the list as an argument in the brackets. The output is the elements corresponding to the particular index:

```py
d=c[select]
d
```


We can assign the specified elements to  a new value. For example, we can assign the values to 100 000 as follows:

```py
c[select]=100000
c
```


Let's review some basic array attributes using the array ‘a’:

```py
a=np.array([0,1,2,3, 4])
a
```


The attribute size is the Number of elements in the array:

```py
a.size
```


The next two attributes will make more sense when we get to higher dimensions but let's review them. The attribute “ndim” represents the Number of array dimensions or the rank of the array, in this case, one:

```py
a.ndim
```


The attribute “shape” is a tuple of integers indicating the size of the array in each dimension:

```py
a.shape
```


```py
a=np.array([1,-1,1,-1])
```


```py
mean=a.mean()
mean
```


```py
standard_deviation=a.std()
standard_deviation
```


```py
b=np.array([1,2,3,4,5])
b
```


```py
max_b=b.max()
```


```py
max_b=b.min()
```


## Array Addition 

Consider the numpy array 'u':

```py
u=np.array([1,0])
u
```


Consider the numpy array 'v':

```py
v=np.array([0,1])
v
```


We can add the two arrays and assign it to z:

```py
z=u+v
z
```


 The operation is equivalent to vector addition:

```py
Plotvec1(u,z,v)
```


####   Implement the following vector subtraction in numpy: u-v  

```py

```


 <div align="right">
<a href="#1" class="btn btn-default" data-toggle="collapse">Click here for the solution</a>

</div>
<div id="1" class="collapse">
```
u-v
```
</div>

Consider the vector numpy array 'y':

```py
y=np.array([1,2])
y
```


We can multiply every element in the array by 2:

```py
z=2*y
z
```


 This is equivalent to multiplying a vector by a scaler: 

####   Multiply the numpy array z with -2:

```py

```


 <div align="right">
<a href="#2" class="btn btn-default" data-toggle="collapse">Click here for the solution</a>

</div>
<div id="2" class="collapse">
```
-2*z
```
</div>

## Product of two numpy arrays 

 Consider the following array 'u':

```py
u=np.array([1,2])
u
```


 Consider the following array 'v':

```py
v=np.array([3,2])
v
```


 The product of the two numpy arrays 'u' and 'v' is given by:

```py
z=u*v
z
```


####  Consider the list [1,2,3,4,5] and [1,0,1,0,1], and cast both lists to a numpy array then multiply them together:

```py

```


Double-click __here__ for the solution.
<!-- 
a=np.array([1,2,3,4,5])
b=np.array([1,0,1,0,1])
a*b
 -->

#### Dot Product

 The dot product of the two numpy arrays 'u' and 'v' is given by:

```py
np.dot(u,v)
```


####  Convert the list [-1,1] and [1,1] to  numpy arrays 'a' and 'b'.  Then, plot the arrays as vectors using the fuction Plotvec2  and find the dot product:

```py

```



Double-click __here__ for the solution.
<!-- 
a=np.array([-1,1])
b=np.array([1,1])
Plotvec2(a,b)
print("the dot product is",np.dot(a,b) )
 -->


#### Convert the list [1,0] and [0,1] to numpy arrays 'a' and 'b'. Then, plot the arrays as vectors using the function Plotvec2 and find the dot product:


```py

```


Double-click __here__ for the solution.
<!-- 
a=np.array([1,0])
b=np.array([0,1])
Plotvec2(a,b)
print("the dot product is",np.dot(a,b) )
 -->

#### Convert the list [1,1] and [0,1] to numpy arrays 'a' and 'b'. Then plot the arrays as vectors using the fuction Plotvec2 and find the dot product:




```py

```


Double-click __here__ for the solution.
<!-- 
a=np.array([1,1])
b=np.array([0,1])
Plotvec2(a,b)
print("the dot product is",np.dot(a,b) )
print("the dot product is",np.dot(a,b) )
 -->

####   Why is the result of the dot product for question 4 and 5 zero, but not zero for question 6? Hint: study the corresponding figures, pay attention to the direction the arrows are pointing to. 

```py

```



Double-click __here__ for the solution.
<!-- 
```
The vectors used for question 4 and 5 are perpendicular. As a result, the dot product is zero. -->

### Adding Constant to a numpy Array 

Consider the following array: 

```py
u=np.array([1,2,3,-1]) 
u
```


 Adding the constant 1 to the array adds 1 to each element in the array:

```py
u+1
```


 The process is summarised in the following animation:

 <img src = "https://ibm.box.com/shared/static/aqcmsph1r0p5la73p1zw8p9vj01opx3h.gif" width = 500, align = "center">

 This part of <a href="https://docs.scipy.org/doc/numpy-1.13.0/user/basics.broadcasting.html" > Broadcasting</a> check out the link for more detail. 

### Mathematical Functions 

 We can access the value of pie in numpy as follows :

```py
np.pi
```


 We can create the following numpy array in Radians:

```py
x=np.array([0,np.pi/2 , np.pi] )
```


 We can apply the function "sine" to the array 'x' and assign the values to the array 'y'; this applies the sine function to each element in the array:  

```py
y=np.sin(x)
y
```


#### Linspace

 A useful function for plotting mathematical functions is "linespace".   Linespace returns evenly spaced numbers over a specified interval. We specify the starting point of the sequence and the ending point of the sequence. The parameter "num" indicates the Number of samples to generate, in this case 5:

```py
np.linspace(-2,2,num=5)
```


 If we change the parameter **num** to 9, we get 9  evenly spaced numbers over the interval from -2 to 2: 

```py
np.linspace(-2,2,num=9)
```


We can use the function line space to generate 100 evenly spaced samples from the interval 0 to 2 pi: 

```py
x=np.linspace(0,2*np.pi,num=100)

```


We can apply the sine function to each element in the array 'x' and assign it to the array 'y': 

```py
y=np.sin(x)
```


```py
plt.plot(x,y)
```


 <a href="http://cocl.us/NotebooksPython101bottom"><img src = "https://ibm.box.com/shared/static/irypdxea2q4th88zu1o1tsd06dya10go.png" width = 750, align = "center"></a>


#### About the Authors:  

 [Joseph Santarcangelo]( https://www.linkedin.com/in/joseph-s-50398b136/) has a PhD in Electrical Engineering, his research focused on using machine learning, signal processing, and computer vision to determine how videos impact human cognition. Joseph has been working for IBM since he completed his PhD.


Copyright &copy; 2017 [cognitiveclass.ai](https:cognitiveclass.ai). This notebook and its source code are released under the terms of the [MIT License](cognitiveclass.ai).

```py

```
