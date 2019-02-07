# OOP Review - [Part 1](https://www.youtube.com/watch?v=vNHpsC5ng_E&list=PLF206E906175C7E07&index=1) and [Part 2](https://www.youtube.com/watch?v=yRJ1rRoMnIM&list=PLF206E906175C7E07&index=2)
## Class
- A blueprint for an object
- Fields
- Parameters
- Methods

## Inheritance
- What classes have in common
- Abstracted features
- Ovrride or extend methods 
- Avoid duplicate 
- Anything in superclass will be reflected in all subclasses

## Main
- Create objects
- Allow them to interact

## Encapsulation
Allows us to validate or perform input information for a field and use _Setters_ and _Getters_

## Instance vs Local variables
- Instance
	- Defined inside of a class
- Local
	- Defined in a method

## Polymorphism
- Allow the subclass to redifine methods in the parents
- Refer to subclasses by their superclass type
- Can treat the objects as if they're of the superclass type
- Cannot access methods that only exist in the subclass

## Abstract classes
- Cannot be an object in itself
- May contain state and/or implementation
- Subclasses cannot inherit protected fields

## Interface
- Does not contain an implementation
- Only abstract methods
- Allows classes of different inheritance trees can still communicate
- Avoid interfaces that just force redefinition by subclasses

## Code

`Animal.java`
```java
public class Animal {
	
	private String name;
	private double height;
	private int weight;
	private String favFood;
	private double speed;
	private String sound;
	
	public void setName(String newName){ name = newName; }
	public String getName(){ return name; }
	
	public void setHeight(double newHeight){ height = newHeight; }
	public double getHeight(){ return height; }
	
	public void setWeight(int newWeight){ 
		if (newWeight > 0){
			weight = newWeight; 
		} else {
			System.out.println("Weight must be bigger than 0");
		}
	}
	public double getWeight(){ return weight; }
	
	public void setFavFood(String newFavFood){ favFood = newFavFood; }
	public String getFavFood(){ return favFood; }
	
	public void setSpeed(double newSpeed){ speed = newSpeed; }
	public double getSpeed(){ return speed; }
	
	public void setSound(String newSound){ sound = newSound; }
	public String getSound(){ return sound; }
	
	// A private method can only be accessed by other public methods
	// that are in the same class
	
	private void bePrivate(){
		System.out.println("I'm a private method");
	}
	
	public static void main(String[] args){
		
		Animal dog = new Animal();
		
		dog.setName("Grover");
		
		System.out.println(dog.getName());
		
	}
	
}
```

`Dog.java`
```java
public class Dog extends Animal{
	
	public void digHole(){
		
		System.out.println("Dug a hole");
		
	}
	
	public void changeVar(int randNum){
		
		randNum = 12;
		
		System.out.println("randNum in method value: " + randNum);
		
	}
	
	
	/* This private method can only be accessed through using other 
	 * methods in the class */
	
	private void bePrivate(){
		System.out.println("In a private method");
	} 
	
	public void accessPrivate(){
		bePrivate();
	}
	
	// The constructor initializes all objects
	
	public Dog(){
		
		// Executes the parents constructor
		// Every class has a constructor whether you make it or not
		
		super();
		
		// Sets bark for all Dog objects by default
		
		setSound("Bark");
		
	}
	
}
```

`Cat.java`
```java
public class Cat extends Animal{
	
	// The constructor initializes all objects
	
	public Cat(){
		
		// Executes the parents constructor
		// Every class has a constructor whether you make it or not
		
		super();
		
		// Sets bark for all Dog objects by default
		
		setSound("Meow");
		
	}
	
	// If you want to make sure a method isn't overridden mark it as Final
	
	final void attack(){
		// Do stuff that can never change
	}
	
	// A field marked with final can't be changed
	
	public static final double FAVNUMBER = 3.14;
	
	// A class labeled as final can't be extended
	
}
```

`WorkWithAnimals.java`
```java
public class WorkWithAnimals{
	
	int justANum = 10;
	
	public static void main(String[] args){
		
		Dog fido = new Dog();
		
		fido.setName("Fido");
		System.out.println(fido.getName());
		
		fido.digHole();
		
		fido.setWeight(-1);
		
		// Everything is pass by value
		// The original is not effected by changes in methods
		
		int randNum = 10;
		fido.changeVar(randNum);
		
		System.out.println("randNum after method call: " + randNum);
		
		// Objects are passed by reference to the original object
		// Changes in methods do effect the object
		
		changeObjectName(fido);
		
		System.out.println("Dog name after method call: " + fido.getName());
		
		System.out.println("Animal Sound: " + fido.getSound());
		
		// Create a Dog and Cat object with the super class
		// but the Dog and Cat reference type
		
		Animal doggy = new Dog();
		Animal kitty = new Cat();
		
		System.out.println("Doggy says: " + doggy.getSound());
		System.out.println("Kitty says: " + kitty.getSound() + "\n");
		
		// Now you can make arrays of Animals and everything just works
		
		Animal[] animals = new Animal[4];
		animals[0] = doggy;
		animals[1] = kitty;
		
		System.out.println("Doggy says: " +animals[0].getSound());
		System.out.println("Kitty says: " +animals[1].getSound() + "\n");
		
		// Sends Animal objects for processing in a method
		
		speakAnimal(doggy);
		
		// Polymorphism allows you to write methods that don't need to 
		// change if new subclasses are created.
		
		// You can't reference methods, or fields that aren't in Animal
		// if you do, you'll have to cast to the required object
		
		((Dog) doggy).digHole();
		
		// You can't use non-static variables or methods in a static function
		
		// System.out.println(justANum);
		
		// sayHello();
		
		// You can't call a private method even if you define it in
		// the subclass
		
		// fido.bePrivate();
		
		// You can execute a private method by using another public
		// method in the class
		
		fido.accessPrivate();
		
		// Creating a Giraffe from an abstract class
		
		Giraffe giraffe = new Giraffe();
		
		giraffe.setName("Frank");
		
		System.out.println(giraffe.getName());
		
	}
	
	// Any methods that are in a class and not tied to an object must
	// be labeled static. Every object created by this class will
	// share just one static method
	
	public static void changeObjectName(Dog fido){
		
		fido.setName("Marcus");
		
	}
	
	// Receives Animal objects and makes them speak
	
	public static void speakAnimal(Animal randAnimal){
		
		System.out.println("Animal says: " + randAnimal.getSound());
		
	}
	
	// This is a non-static method used to demonstrate that you can't
	// call a non-static method inside a static method
	
	public void sayHello(){
		
		System.out.println("Hello");
		
	}
	
}
```

`Creature.java`
```java
//If you don't want the user to create objects from
//a class mark it as abstract.
//Subclasses can still extend it

abstract public class Creature{
	
	// protected fields are like private fields except 
	// subclasses can inherit them 
	
	protected String name;
	protected double height;
	protected int weight;
	protected String favFood;
	protected double speed;
	protected String sound;
	
	// There are no abstract fields in Java, but
	// there are abstract methods. Every method
	// marked abstract must be overridden
	// Not all methods must be abstract and you
	// can also use static methods
	
	public abstract void setName(String newName);
	public abstract String getName();
	
	public abstract void setHeight(double newheight);
	public abstract double getHeight();
	
	public abstract void setWeight(double newWeight);
	public abstract double getWeight();
	
	public abstract void setFavFood(String newFood);
	public abstract String getFavFood();
	
	public abstract void setSpeed(double newSpeed);
	public abstract double getSpeed();
	
	public abstract void setSound(String newSound);
	public abstract String getSound();
	
}
```

`Giraffe.java`
```java
public class Giraffe extends Creature{

	private String name;
	
	@Override
	public void setName(String newName) {
		name = newName;
		
	}

	@Override
	public String getName() {
		// TODO Auto-generated method stub
		return name;
	}

	@Override
	public void setWeight(double newWeight) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public double getWeight() {
		// TODO Auto-generated method stub
		return 0;
	}
}
```