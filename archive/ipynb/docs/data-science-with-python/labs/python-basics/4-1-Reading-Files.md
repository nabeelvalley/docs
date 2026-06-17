 <div class="alert alert-block alert-info" style="margin-top: 20px">
 <a href="http://cocl.us/NotebooksPython101"><img src = "https://ibm.box.com/shared/static/yfe6h4az47ktg2mm9h05wby2n7e8kei3.png" width = 750, align = "center"></a>


<a href="https://www.bigdatauniversity.com"><img src = "https://ibm.box.com/shared/static/ugcqz6ohbvff804xp84y4kqnvvk3bq1g.png" width = 300, align = "center"></a>



<h1 align=center><font size = 5>Reading Files Python </font></h1>

<br>

This notebook will provide information regarding reading **.txt** files.



## Table of Contents


<div class="alert alert-block alert-info" style="margin-top: 20px">


<li><a href="#ref1">Reading Text Files</a></li>

<br>
<p></p>
Estimated Time Needed: <strong>15 min</strong>
</div>

<hr>

Download data 

```py
!mkdir -p /resources/data
!wget -O /resources/data/Example1.txt https://s3-api.us-geo.objectstorage.softlayer.net/cf-courses-data/CognitiveClass/PY0101EN/labs/example1.txt
```


 

 <div class="alert alert-block alert-info" style="margin-top: 20px">
 <a href="http://cocl.us/PythonforDS_add_loading_data_AD_CCai"><img src = "https://ibm.box.com/shared/static/6qbj1fin8ro0q61lrnmx2ncm84tzpo3c.png" width = 750, align = "center"></a>


<a id="ref1"></a>
<h2 align=center>Reading Text Files</h2>

One way to read or write a file in Python is to use the built-in **open** function. The **open** function provides a **File object** that contains the methods and attributes you need in order to read, save, and manipulate the file. In this notebook, we will only cover **.txt** files. The first parameter you need is the file path and the file name. An example is shown in __Figure 1__:



 <a ><img src = "https://ibm.box.com/shared/static/6wl3vw4ghflafrou0noj70t2n4hbalqr.png" width = 500, align = "center"></a>
  <h4 align=center>  
    Figure 1: Labeled Syntax of a file object.  

  </h4> 

 The mode argument is optional and the default value is **r**. In this notebook we only cover two modes: 

<li>**r** Read mode for reading files </li>
<li>**w** Write mode for writing files</li>

 For the next example, we will use the text file **Example1.txt**. The file is shown in figure 2:


 <a ><img src = "https://ibm.box.com/shared/static/ilzy3av6x1cd3gi61bq2nq0vxb0awhju.png" width = 200, align = "center"></a>
  <h4 align=center>  
    Figure 2: The text file "Example1.txt".

  </h4> 

 We read the file: 

```py
example1="/resources/data/Example1.txt"
file1 = open(example1,"r")
```


 We can view the attributes of the file.

The name of the file:

```py
file1.name
```


 The mode the file object is in:

```py
file1.mode
```


We can read the file and assign it to a variable :

```py
FileContent=file1.read()
FileContent
```


The “/n” means that there is a new line. 

We can print the file: 

```py
print(FileContent)
```


The file is of type string:

```py
type(FileContent)
```


 We must close the file object:

```py
file1.close()
```


 <h3> A  Better Way to Open a File </h3>

Using the **with** statement is better practice, it automatically closes the file even if the code encounters an exception. The code will run everything in the indent block then close the file object. 


```py
with open(example1,"r") as file1:
    FileContent=file1.read()
    print(FileContent)
```


The file object is closed, you can verify it by running the following cell:  

```py
file1.closed
```


 We can see the info in the file:

```py
print(FileContent)
```


The syntax is a little confusing as the file object is after the **as** statement. We also don’t explicitly close the file. Therefore we summarise the steps in a figure:

 <a ><img src = "https://ibm.box.com/shared/static/ywul1ji1ld82xwz60ljxvbg6fs2vrunm.png" width = 500, align = "center"></a>
  <h4 align=center>  
    The syntax for opening a file using a 'with' statement.

  </h4> 

```py
with open(example1,"r") as file1:
    FileContent=file1.readlines()
    print(FileContent)
```


We don’t have to read the entire file, for example, we can read the first 4 characters by entering three as a parameter to the method **.read()**:


```py
with open(example1,"r") as file1:
    print(file1.read(4))
```


Once the method **.read(4)** is called the first 4 characters are called.  If we call the method again, the next 4 characters are called. The output for the following cell will demonstrate the process for different inputs to the method **read() **:



```py
with open(example1,"r") as file1:
    print(file1.read(4))
    print(file1.read(4))
    print(file1.read(7))
    print(file1.read(15))

```


 The process is illustrated in the below figure, and each colour represents the part of the file read after the method **read()** is called:


 <a ><img src = "https://ibm.box.com/shared/static/s0xs6y4vcvabp2ll2pwspa6kd8qeoddj.png" width = 500, align = "center"></a>
  <h4 align=center>  
     Illustration using the method **.read()** to call different characters 

  </h4> 

 Here is an example using the same file, but instead we read 16, 5, and then 9 characters at a time: 

```py
with open(example1,"r") as file1:
    print(file1.read(16))
    print(file1.read(5))
    print(file1.read(9))

```


We can also read one line of the file at a time using the method **readline()**: 

```py
 with open(example1,"r") as file1:
    print("first line: " + file1.readline())

```


 We can use a loop to iterate through each line: 


```py
 with open(example1,"r") as file1:
        i=0;
        for line in file1:
            print("Iteration" ,str(i),":",line)
            i=i+1;
```


We can use the method **readline()** to save the text file to a list: 

```py
with open(example1,"r") as file1:
    FileasList=file1.readlines()
```


 Each element of the list corresponds to a line of text:

```py
FileasList[0]
```


```py
FileasList[1]
```


```py
FileasList[2]
```


 <a href="http://cocl.us/NotebooksPython101bottom"><img src = "https://ibm.box.com/shared/static/irypdxea2q4th88zu1o1tsd06dya10go.png" width = 750, align = "center"></a>



### References

1) <a href="https://ibm.github.io/ibm-cos-sdk-python/reference/core/boto3.html"> ibm-cos-sdk Reference</a>
 
 2) <a href="https://dataplatform.ibm.com/analytics/notebooks/v2/ee1d0b44-0fce-4cf6-8545-e1dc961d0668/view?access_token=c0489b861ab65f63be7e3c5ce962003a2a0197660e67ecb140c477c2e11b5fe3"> IBM Cloud Object Storage In Python</a>
 
 3)<a href="https://console.bluemix.net/docs/services/cloud-object-storage/libraries/python.html#using-python"> IBM Cloud DocsCloud Object Storage In Python</a>

<hr>
### About the Author:  
 [Joseph Santarcangelo]( https://www.linkedin.com/in/joseph-s-50398b136/) has a PhD in Electrical Engineering, his research focused on using machine learning, signal processing, and computer vision to determine how videos impact human cognition. Joseph has been working for IBM since he completed his PhD.

 <hr>
Copyright &copy; 2018 [cognitiveclass.ai](cognitiveclass.ai?utm_source=bducopyrightlink&utm_medium=dswb&utm_campaign=bdu). This notebook and its source code are released under the terms of the [MIT License](https://bigdatauniversity.com/mit-license/).​