<div class="alert alert-block alert-info" style="margin-top: 20px">
 <a href="http://cocl.us/NotebooksPython101"><img src = "https://ibm.box.com/shared/static/yfe6h4az47ktg2mm9h05wby2n7e8kei3.png" width = 750, align = "center"></a>





<a href="https://www.bigdatauniversity.com"><img src = "https://ibm.box.com/shared/static/ugcqz6ohbvff804xp84y4kqnvvk3bq1g.png" width = 300, align = "center"></a>

<h1 align=center><font size = 5>LOOPS  IN PYTHON</font></h1>

## Table of Contents


<div class="alert alert-block alert-info" style="margin-top: 20px">
<li><a href="#ref1">For Loops</a></p></li>
<li><a href="#ref2">While Loops </a></p></li>
<br>
<p></p>
Estimated Time Needed: <strong>15 min</strong>
</div>

<hr>

<a id="ref1"></a>
<center><h2>For Loops</h2></center>

Sometimes, you might want to repeat a given operation many times. Repeated executions like this are performed by **loops**. We will look at two types of loops, **for** loops and **while** loops.

Before we discuss loops lets discuss the **range** object. It is helpful to think of the range object as an ordered list. For now, let's look at the simplest case. If we would like to generate a sequence that contains three elements ordered from 0 to 2 we simply use the following command:

```py
range(3)
```


<a ><img src = "https://ibm.box.com/shared/static/mxzjehamhqq5dljnxeh0vwqlju67j6z8.png" width = 300, align = "center"></a>
  <h4 align=center>:Example of range function.

  </h4> 



### The `for` loop
The **for** loop enables you to execute a code block multiple times. For example, you would use this if you would like to print out every element in a list.    
Let's try to use a **for** loop to print all the years presented in the list  **dates**:

This can be done as follows:

```py
dates = [1982,1980,1973]
N=len(dates)

for i in range(N):
     
    print(dates[i])     
```


The code in the indent is executed **N** times, each time the value of **i** is increased by 1 for every execution. The statement executed is to** print** out the value in the list at index **i** as shown here:


<a ><img src = "https://ibm.box.com/shared/static/w021psh5dtxcl2qheyc5d19d8tik7vq3.gif" width = 1000, align = "center"></a>
  <h4 align=center>  Example of printing out the elements of a list.
  </h4> 


In this example we can print out a sequence of numbers from 0 to 7:

```py
for i in range(0,8):
    print(i)
```


#### Write a for loop the prints out all the element between -5 and 5 using the range function.

Double-click __here__ for the solution.
<!-- 
for i in range(-5,6):
    print(i)
 -->
 

In Python we can directly access the elements in the list as follows: 

```py
for year in dates:  
    print(year)  
 
```


For each iteration, the value of the variable **years** behaves like the value of **dates[i]** in the  first example:


<a ><img src = "https://ibm.box.com/shared/static/zljq7m9stw8znv7ca2it6vkekaudfuwf.gif" width = 1100, align = "center"></a>
  <h4 align=center> Example of a for loop

  </h4> 

#### Print the elements of the following list:
**Genres=[ 'rock', 'R&B', 'Soundtrack' 'R&B', 'soul', 'pop']**
Make sure you follow Python conventions. 

```py

```


Double-click __here__ for the solution.
<!-- 
Genres=[ 'rock', 'R&B', 'Soundtrack' 'R&B', 'soul', 'pop']
for Genre in Genres:
    print(Genre)
 -->

We can change the elements in a list:

```py
squares=['red','yellow','green','purple','blue ']

for i in range(0,5):
    print("Before square ",i, 'is',  squares[i])
    
    squares[i]='wight'
    
    print("After square ",i, 'is',  squares[i])
    
    
    
```


#### Write a for loop that prints out the following list: squares=['red','yellow','green','purple','blue ']:

```py

```


Double-click __here__ for the solution.
<!-- 
squares=['red','yellow','green','purple','blue ']
for square in squares:
    print(square)
 -->




 We can access the index and the elements of a list as follows: 

```py
squares=['red','yellow','green','purple','blue ']

for i,square in enumerate(squares):
    print(i,square)
    
```


 <a id="ref2"></a>
<center><h2>While Loops</h2></center>

As you can see, the **for** loop is used for a controlled flow of repetition. However, what if we don't know when we want to stop the loop? What if we want to keep executing a code block until a certain condition is met? The **while** loop exists as a tool for repeated execution based on a condition. The code block will keep being executed until the given logical condition returns a **False** boolean value.


Let’s say we would like to iterate through list **dates** and stop at the year 1973, then print out the number of iterations.  This can be done with the following block of code:

```py
dates = [1982,1980,1973,2000]

i=0;
year=0
while(year!=1973):
    year=dates[i]
    i=i+1
    print(year)
    
    
print("it took ", i ,"repetitions to get out of loop")
```


A while loop iterates merely until the condition in the argument  is not  met, as shown in the following figure :

<a ><img src = "https://ibm.box.com/shared/static/hhe9tiskw1qqpycs4b8l2l2q58e2kn54.gif" width = 1000, align = "center"></a>
  <h4 align=center> An  Example of indices as negative numbers

  </h4> 

#### Write a while loop to display the values of the Rating of an album playlist stored in the list “PlayListRatings”. If the score is less than 6, exit the loop. The list “PlayListRatings” is given by: PlayListRatings = [10,9.5,10, 8,7.5, 5,10, 10]:



```py
PlayListRatings = [10,9.5,10,8,7.5,5,10,10]
```


Double-click __here__ for the solution.
<!-- 
PlayListRatings = [10,9.5,10, 8,7.5, 5,10, 10]
i=0;
Rating=100
while(Rating>6):
    Rating=PlayListRatings[i]
    i=i+1
    print(Rating)
 -->

<hr>

#### Write a while loop to copy the strings 'orange' of the list 'squares' to the list 'new_squares'. Stop and exit the loop if the value on the list is not 'orange':

```py
squares=['orange','orange','purple','blue ','orange']
new_squares=[];

```


Double-click __here__ for the solution.
<!-- 
squares=['orange','orange','purple','blue ','orange']
new_squares=[];
i=0
while(squares[i]=='orange'):
    new_squares.append(squares[i])
    i=i+1
 -->

 <a href="http://cocl.us/NotebooksPython101bottom"><img src = "https://ibm.box.com/shared/static/irypdxea2q4th88zu1o1tsd06dya10go.png" width = 750, align = "center"></a>



# About the Authors:  

 [Joseph Santarcangelo]( https://www.linkedin.com/in/joseph-s-50398b136/) has a PhD in Electrical Engineering, his research focused on using machine learning, signal processing, and computer vision to determine how videos impact human cognition. Joseph has been working for IBM since he completed his PhD.


 Copyright &copy; 2017 [cognitiveclass.ai](https:cognitiveclass.ai). This notebook and its source code are released under the terms of the [MIT License](cognitiveclass.ai).