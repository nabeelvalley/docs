 <div class="alert alert-block alert-info" style="margin-top: 20px">
 <a href="http://cocl.us/NotebooksPython101"><img src = "https://ibm.box.com/shared/static/yfe6h4az47ktg2mm9h05wby2n7e8kei3.png" width = 750, align = "center"></a>



<a href="https://www.bigdatauniversity.com"><img src = "https://ibm.box.com/shared/static/ugcqz6ohbvff804xp84y4kqnvvk3bq1g.png" width = 300, align = "center"></a>

<h1 align=center><font size = 5>PYTHON OBJECTS AND CLASSES</font></h1>

# Welcome!

Objects in programming are like objects in real life. Like life, there are different classes of objects. In this notebook, we will create two classes called Circle and Rectangle. By the end of this notebook, you will have a better idea about :

-what a class is

-what an attribute is

-what a method is

Don’t worry if you don’t get it the first time, as much of the terminology is confusing. Don’t forget to do the practice tests in the notebook.


### Introduction 

#### Creating a Class 
 The first part of creating a class is giving it a name: In this notebook, we will create two classes, Circle and Rectangle. We need to determine all the data that make up that class, and we call that an attribute. Think about this step as creating a blue print that we will use to create objects. In figure 1 we see two classes, circle and rectangle. Each has their attributes, they are variables. The class circle has the attribute radius and colour, while the rectangle has the attribute height and width. Let’s use the visual examples of these shapes before we get to the code, as this will help you get accustomed to the vocabulary.




 <a ><img src = "https://ibm.box.com/shared/static/h2w03relr84lb8ofto2zk0dp9naiykfg.png" width = 500, align = "center"></a>
 <h4 align=center>


#### Figure 1: Classes circle and rectangle, and each has their own attributes. The class circle has the attribute radius and colour, the rectangle has the attribute height and width. 


#### Instances of a Class: Objects and Attributes

An instance of an object is the realisation of a class, and in figure 2 we see three instances of the class circle. We give each object a name: red circle, yellow circle and green circle. Each object has different attributes, so let's focus on the attribute of colour for each object.

 <a ><img src = "https://ibm.box.com/shared/static/bz20uxc78sbv8knixnl3a52z2u2r74zp.png" width = 500, align = "center"></a>
 <h4 align=center>
 Figure 2: Three instances of the class circle or three objects of type circle.  




 The colour attribute for the red circle is the colour red, for the green circle object the colour attribute is green, and for the yellow circle the colour attribute is yellow.   


#### Methods 

Methods give you a way to change or interact with the object; they are functions that interact with objects. For example, let’s say we would like to increase the radius by a specified amount of a circle. We can create a method called **add_radius(r)** that increases the radius by **r**. This is shown in figure 3, where after applying the method to the "orange circle object", the radius of the object increases accordingly. The “dot” notation means to apply the method to the object, which is essentially applying a function to the information in the object.

 <a ><img src = "https://ibm.box.com/shared/static/53b39xh7snepk0my8z7t9n9wzres4drf.png" width = 500, align = "center"></a>
 <h4 align=center>
 Figure 3: Applying the method “add_radius” to the object orange circle object .  




# Creating a Class

Now we are going to create a class circle, but first, we are going to import a library to draw the objects: 

```py
import matplotlib.pyplot as plt
%matplotlib inline  

```


 The first step in creating your own class is to use the **class** keyword, then the name of the class as shown in Figure 4. In this course the class parent will always be object: 


 <a ><img src = "https://ibm.box.com/shared/static/q9394f3aip7lbu4k1yct5pczst5ec3sk.png" width = 400, align = "center"></a>
 <h4 align=center>
 Figure 4: Three instances of the class circle or three objects of type circle.  



The next step is a special method called a constructor **__init__**, which is used to initialize the object. The input are data attributes. The term **self** contains all the attributes in the set. For example the **self.color** gives the  value of the attribute colour and **self.radius** will give you the radius of the object. We also have the method **add_radius()** with the parameter **r**, the method adds the value of **r** to the attribute radius. To access the radius we use the sintax **self.radius**. The labeled syntax is summarized in Figure 5:



 <a ><img src = "https://ibm.box.com/shared/static/25j0jezklf6snhh3ps61d0djzwx8kgwa.png" width = 600, align = "center"></a>
 <h4 align=center>
 Figure 5: Labeled  syntax of the object circle.




The actual object is shown below. We include the method drawCircle to display the image of a circle. We set the default radius to 3 and the default colour to blue:

```py

class Circle(object):
    
    def __init__(self,radius=3,color='blue'):
        
        self.radius=radius
        self.color=color 
    
    def add_radius(self,r):
        
        self.radius=self.radius+r
        return(self.radius)
    def drawCircle(self):
        
        plt.gca().add_patch(plt.Circle((0, 0), radius=self.radius, fc=self.color))
        plt.axis('scaled')
        plt.show()  
```


### Creating an instance of a class Circle

 Let’s create the object **RedCircle** of type Circle to do the following:

```py
RedCircle=Circle(10,'red')
```


We can use the **dir** command to get a list of the object's methods. Many of them are default Python methods.

```py
dir(RedCircle)
```


We can look at the data attributes of the object: 

```py
RedCircle.radius
```


```py
RedCircle.color
```


 We can change the object's data attributes: 

```py
RedCircle.radius=1
```


```py
RedCircle.radius
```


 We can draw the object by using the method **drawCircle()**:

```py
RedCircle.drawCircle()
```


We can increase the radius of the circle by applying the method **add_radius()**. Let increases the radius by 2 and then by 5:  

```py
print('Radius of object:',RedCircle.radius)
RedCircle.add_radius(2)
print('Radius of object of after applying the method add_radius(2):',RedCircle.radius)
RedCircle.add_radius(5)
print('Radius of object of after applying the method add_radius(5):',RedCircle.radius)
```


 Let’s  create a blue circle. As the default colour is blue, all we have to do is specify what the radius is:

```py
BlueCircle=Circle(radius=100)
```


 As before we can access the attributes of the instance of the class by using the dot notation:

```py
BlueCircle.radius
```


```py
BlueCircle.color
```


 We can draw the object by using the method **drawCircle()**:

```py
BlueCircle.drawCircle()
```


 Compare the x and y axis of the figure to the figure  for **RedCircle**; they are different.

### The Rectangle  Class 

Let's create a class rectangle with the attributes of height, width and colour. We will only add the method to draw the rectangle object:


```py
class Rectangle(object):
    
    def __init__(self,width=2,height =3,color='r'):
        self.height=height 
        self.width=width
        self.color=color
    
    def drawRectangle(self):
        import matplotlib.pyplot as plt
        plt.gca().add_patch(plt.Rectangle((0, 0),self.width, self.height ,fc=self.color))
        plt.axis('scaled')
        plt.show()
```


 Let’s create the object **SkinnyBlueRectangle** of type Rectangle. Its width will be 2 and height will be 3, and the colour will be blue:


```py
SkinnyBlueRectangle= Rectangle(2,10,'blue')
```


 As before we can access the attributes of the instance of the class by using the dot notation:

```py
SkinnyBlueRectangle.height 
```


```py
SkinnyBlueRectangle.width
```


```py
SkinnyBlueRectangle.color
```


 We can draw the object:

```py
SkinnyBlueRectangle.drawRectangle()
```


Let’s create the object “FatYellowRectangle” of type Rectangle :

```py
FatYellowRectangle = Rectangle(20,5,'yellow')
```


 We can access the attributes of the instance of the class by using the dot notation:

```py
FatYellowRectangle.height 
```


```py
FatYellowRectangle.width
```


```py
FatYellowRectangle.color
```


 We can draw the object:

```py
FatYellowRectangle.drawRectangle()
```


 <a href="http://cocl.us/NotebooksPython101bottom"><img src = "https://ibm.box.com/shared/static/irypdxea2q4th88zu1o1tsd06dya10go.png" width = 750, align = "center"></a>



# About the Authors:  
[Joseph Santarcangelo]( https://www.linkedin.com/in/joseph-s-50398b136/) has a PhD in Electrical Engineering, his research focused on using machine learning, signal processing, and computer vision to determine how videos impact human cognition. Joseph has been working for IBM since he completed his PhD.

<hr>
Copyright &copy; 2017 [Cognitiveclass.ai](https://cognitiveclass.ai/?utm_source=bducopyrightlink&utm_medium=dswb&utm_campaign=bdu). This notebook and its source code are released under the terms of the [MIT License](https://bigdatauniversity.com/mit-license/).​