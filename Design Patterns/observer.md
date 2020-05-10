# Observer Design Pattern

[From this video](https://www.youtube.com/watch?v=wiQdrH2YpT4&list=PLF206E906175C7E07&index=4)

## Oserver Pattern

- Positive - When you need many objects to receive an update on the change of another object - Publisher - Subscriber - Lose coupling between objects

- Negative - The subject may send updates that observers don't need

## Code

`Subject.java`

```java
// This interface handles adding, deleting and updating
// all observers

public interface Subject {

	public void register(Observer o);
	public void unregister(Observer o);
	public void notifyObserver();

}
```

`Observer.java`

```java
// The Observers update method is called when the Subject changes

public interface Observer {

	public void update(double ibmPrice, double aaplPrice, double googPrice);

}
```

`StockGrabber.java`

```java
import java.util.ArrayList;

// Uses the Subject interface to update all Observers

public class StockGrabber implements Subject{

	private ArrayList<Observer> observers;
	private double ibmPrice;
	private double aaplPrice;
	private double googPrice;

	public StockGrabber(){

		// Creates an ArrayList to hold all observers

		observers = new ArrayList<Observer>();
	}

	public void register(Observer newObserver) {

		// Adds a new observer to the ArrayList

		observers.add(newObserver);

	}

	public void unregister(Observer deleteObserver) {

		// Get the index of the observer to delete

		int observerIndex = observers.indexOf(deleteObserver);

		// Print out message (Have to increment index to match)

		System.out.println("Observer " + (observerIndex+1) + " deleted");

		// Removes observer from the ArrayList

		observers.remove(observerIndex);

	}

	public void notifyObserver() {

		// Cycle through all observers and notifies them of
		// price changes

		for(Observer observer : observers){

			observer.update(ibmPrice, aaplPrice, googPrice);

		}
	}

	// Change prices for all stocks and notifies observers of changes

	public void setIBMPrice(double newIBMPrice){

		this.ibmPrice = newIBMPrice;

		notifyObserver();

	}

	public void setAAPLPrice(double newAAPLPrice){

		this.aaplPrice = newAAPLPrice;

		notifyObserver();

	}

	public void setGOOGPrice(double newGOOGPrice){

		this.googPrice = newGOOGPrice;

		notifyObserver();

	}

}
```

`StockObserver.java`

```java
// Represents each Observer that is monitoring changes in the subject

public class StockObserver implements Observer {

	private double ibmPrice;
	private double aaplPrice;
	private double googPrice;

	// Static used as a counter

	private static int observerIDTracker = 0;

	// Used to track the observers

	private int observerID;

	// Will hold reference to the StockGrabber object

	private Subject stockGrabber;

	public StockObserver(Subject stockGrabber){

		// Store the reference to the stockGrabber object so
		// I can make calls to its methods

		this.stockGrabber = stockGrabber;

		// Assign an observer ID and increment the static counter

		this.observerID = ++observerIDTracker;

		// Message notifies user of new observer

		System.out.println("New Observer " + this.observerID);

		// Add the observer to the Subjects ArrayList

		stockGrabber.register(this);

	}

	// Called to update all observers

	public void update(double ibmPrice, double aaplPrice, double googPrice) {

		this.ibmPrice = ibmPrice;
		this.aaplPrice = aaplPrice;
		this.googPrice = googPrice;

		printThePrices();

	}

	public void printThePrices(){

		System.out.println(observerID + "\nIBM: " + ibmPrice + "\nAAPL: " +
				aaplPrice + "\nGOOG: " + googPrice + "\n");

	}

}
```

`GrabStocks.java`

```java
public class GrabStocks{

	public static void main(String[] args){

		// Create the Subject object
		// It will handle updating all observers
		// as well as deleting and adding them

		StockGrabber stockGrabber = new StockGrabber();

		// Create an Observer that will be sent updates from Subject

		StockObserver observer1 = new StockObserver(stockGrabber);

		stockGrabber.setIBMPrice(197.00);
		stockGrabber.setAAPLPrice(677.60);
		stockGrabber.setGOOGPrice(676.40);

		StockObserver observer2 = new StockObserver(stockGrabber);

		stockGrabber.setIBMPrice(197.00);
		stockGrabber.setAAPLPrice(677.60);
		stockGrabber.setGOOGPrice(676.40);

		// Delete one of the observers

		// stockGrabber.unregister(observer2);

		stockGrabber.setIBMPrice(197.00);
		stockGrabber.setAAPLPrice(677.60);
		stockGrabber.setGOOGPrice(676.40);

		// Create 3 threads using the Runnable interface
		// GetTheStock implements Runnable, so it doesn't waste
		// its one extendable class option

		Runnable getIBM = new GetTheStock(stockGrabber, 2, "IBM", 197.00);
		Runnable getAAPL = new GetTheStock(stockGrabber, 2, "AAPL", 677.60);
		Runnable getGOOG = new GetTheStock(stockGrabber, 2, "GOOG", 676.40);

		// Call for the code in run to execute

		new Thread(getIBM).start();
		new Thread(getAAPL).start();
		new Thread(getGOOG).start();


	}

}
```

`GetTheStock.java`

```java
import java.text.DecimalFormat;

public class GetTheStock implements Runnable{

	// Could be used to set how many seconds to wait
	// in Thread.sleep() below

	// private int startTime;
	private String stock;
	private double price;

	// Will hold reference to the StockGrabber object

	private Subject stockGrabber;

	public GetTheStock(Subject stockGrabber, int newStartTime, String newStock, double newPrice){

		// Store the reference to the stockGrabber object so
		// I can make calls to its methods

		this.stockGrabber = stockGrabber;

		// startTime = newStartTime;  Not used to have variable sleep time
		stock = newStock;
		price = newPrice;

	}

	public void run(){

		for(int i = 1; i <= 20; i++){

			try{

				// Sleep for 2 seconds
				Thread.sleep(2000);

				// Use Thread.sleep(startTime * 1000); to
				// make sleep time variable
			}
			catch(InterruptedException e)
			{}

			// Generates a random number between -.03 and .03

			double randNum = (Math.random() * (.06)) - .03;

			// Formats decimals to 2 places

			DecimalFormat df = new DecimalFormat("#.##");

			// Change the price and then convert it back into a double

	        price = Double.valueOf(df.format((price + randNum)));

			if(stock == "IBM") ((StockGrabber) stockGrabber).setIBMPrice(price);
			if(stock == "AAPL") ((StockGrabber) stockGrabber).setAAPLPrice(price);
			if(stock == "GOOG") ((StockGrabber) stockGrabber).setGOOGPrice(price);

			System.out.println(stock + ": " + df.format((price + randNum)) +
					" " + df.format(randNum));

			System.out.println();

		}
	}

}
```
