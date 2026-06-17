# Deep Learning and Neural Networks with Keras

> Notes from [this YouTube Series](https://www.youtube.com/watch?v=zYnI4iWRmpc), Full course notes can be found on [GitHub](https://github.com/jeffheaton/t81_558_deep_learning)

## Overview of Neural Networks

A Neural Network takes the some kind of data and has the ability to handle and process data that other ML models are not really able to process

In a normal model you would pass in a 1D vector such as a list of predictors, with a an NN you can pass in more complex data and the model will place weight on the position as well as the values of a respective data point which is something other models can't necessarily handle

Some examples of higher order data can be:

1. 1D Vector - Normal input, like a row in a spreadsheet
2. 2D Matrix - Grayscale image
3. 3D Matrix - Colour image
4. nD Matrix - Any higher order data

With traditional models we speak about regression or classification. 

A regression network could have a single numerical output, or a classification network could have a set of potential binary outputs for each classes (like one-hot) or a probability of the result being each of the possible outputs

Neural Networks are also capble of more complex outputs or even combinations of outputs

In general an NN consists of an Input Layer which takes in the input data, a few hidden layers which proces the data, and an output layer which is our target outcome. Each layer passes a weighted data to each model

There are usually these types of neurons:

1. Input - get the input data
2. Hidden - between input and output and abstract processing
3. Output - the output that's calculated
4. Context - hold state between calls to the network
5. Bias Neurons - similar to a y-intercept, alow us to offset the data to a neurons


Neural networks pass data to nodes using Activation functions, some common ones are:

- Rectified Linear Unit (ReLU) - used for hidden layers
- Softmax - output for classification
- Linear - for regression

The Bias Neuron along with a Weight allow us to move and scale our activation functions

## Tensorflow and Keras

TensorFlow is the low-level library for Neural Networks, and Keras is an API that sits on top of TF and allows you to interact with it at a higher level

> The current version of TF requires Python 3.7, so just align with that

TensorBoard is a way to visualize Neural Networks 

### Using Tensorflow Directly

#### Simple Matrix Multiplication

```py
import tensorflow as tf
```


```py
matrix1 = tf.constant([[3., 3.]])

matrix2 = tf.constant([[2.], [2.]])

product = tf.matmul(matrix1, matrix2)

print(product)
float(product)
```



```
12.0
```


#### Using Variables

Variables can be created, used, and resasigned and recalculated with

```py
x = tf.Variable([1., 2.])
a = tf.constant([3., 3.])

print(tf.subtract(x, a).numpy())
```


```py
x.assign([4., 6.])

print(tf.subtract(x, a).numpy())
```


### Using Keras with MPG Dataset

Keras enables us to think about the Layers in an NN, we'll use the Miles Per Gallon dataset which uses the 

```py
import numpy as np
import pandas as pd

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation

from sklearn import metrics
```


```py
DATA_URL = 'https://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data'

COLUMN_NAMES = [
        'mpg', 
        'cylinders', 
        'displacement', 
        'horsepower', 
        'weight', 
        'acceleration', 
        'model year', 
        'origin', 
        'car name'
    ]
```


```py
import pandas as pd
from tensorflow.keras.layers import Dense, Activation

df = pd.read_fwf(
    DATA_URL, 
    names=COLUMN_NAMES,
    na_values=['NA', '?']
)

# fill missing
df['horsepower'] = df['horsepower'].fillna(df['horsepower'].median())
```


```py
df.head()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>mpg</th>
      <th>cylinders</th>
      <th>displacement</th>
      <th>horsepower</th>
      <th>weight</th>
      <th>acceleration</th>
      <th>model year</th>
      <th>origin</th>
      <th>car name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>18.0</td>
      <td>8</td>
      <td>307.0</td>
      <td>130.0</td>
      <td>3504.0</td>
      <td>12.0</td>
      <td>70</td>
      <td>1</td>
      <td>"chevrolet chevelle malibu"</td>
    </tr>
    <tr>
      <th>1</th>
      <td>15.0</td>
      <td>8</td>
      <td>350.0</td>
      <td>165.0</td>
      <td>3693.0</td>
      <td>11.5</td>
      <td>70</td>
      <td>1</td>
      <td>"buick skylark 320"</td>
    </tr>
    <tr>
      <th>2</th>
      <td>18.0</td>
      <td>8</td>
      <td>318.0</td>
      <td>150.0</td>
      <td>3436.0</td>
      <td>11.0</td>
      <td>70</td>
      <td>1</td>
      <td>"plymouth satellite"</td>
    </tr>
    <tr>
      <th>3</th>
      <td>16.0</td>
      <td>8</td>
      <td>304.0</td>
      <td>150.0</td>
      <td>3433.0</td>
      <td>12.0</td>
      <td>70</td>
      <td>1</td>
      <td>"amc rebel sst"</td>
    </tr>
    <tr>
      <th>4</th>
      <td>17.0</td>
      <td>8</td>
      <td>302.0</td>
      <td>140.0</td>
      <td>3449.0</td>
      <td>10.5</td>
      <td>70</td>
      <td>1</td>
      <td>"ford torino"</td>
    </tr>
  </tbody>
</table>
</div>

```py
X = df.drop(['mpg', 'car name'], axis=1).values
y = df[['mpg']].values
```


### Build Regression Model with Keras

When building a Neural Network we take the following steps:

1. Create a Sequential
2. Define the Hidden Layers
3. Define the Output Layer
4. Compile and Train the Model

#### 1. Create Sequential

```py
model = Sequential()
```


#### 2. Define Hidden Layers

Define the first hiddel layer with the `input_dim` to be the shape of our input data set (`X` columns in this case)

> A dense layer is one where each neuron is connected to the next

```py
model.add(Dense(25, input_dim=X.shape[1], activation='relu'))
model.add(Dense(10, activation='relu'))
```


#### 3. Define the Output Layer

This is depends on the dimensionality of the output, similar to the input. For this case it is one dimensional

```py
model.add(Dense(1))
```


#### 3. Compile and train the model

We specify a `loss` function and an `optimizer` for the model, and then give it the `X` and `y` values to train on a well as how many `epoch`s we want it to train for

For a Regression NN you usually use MSE as the loss

> We can also make use of methods to increase the model's effectiveness and identifying the optimal number of epochh

```py
model.compile(loss='mean_squared_error', optimizer='adam')
model.fit(X, y, verbose=0, epochs=400)
```

```
<tensorflow.python.keras.callbacks.History at 0x2041a5ff688>
```


#### Test the Model

```py
y_pred = model.predict(X)
score = np.sqrt(metrics.mean_squared_error(y_pred, y))
'MSE: ' + str(score)
```

```
'MSE: 3.4881811444565303'
```


### Build a Classification Model with Keras

Building a Classification Model is much the same, however we need to ensure that we hot-encode our categorical values, and in this case we'll have a categorical output which means more than one potential result

For this we're making use of the [Iris Dataset](https://archive.ics.uci.edu/ml/datasets/Iris)

However for a Multi-Class classification we use `softmax` and `categorical_crossentropy`

For a Binary we can additionally use an appliccable loss and activation

```py
DATA_URL = 'https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data'

COLUMN_NAMES = [
   'sepal length',
   'sepal width',
   'petal length',
   'petal width',
   'class'
]
```


```py
df = pd.read_csv(DATA_URL, names=COLUMN_NAMES)
```


```py
df.head()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>sepal length</th>
      <th>sepal width</th>
      <th>petal length</th>
      <th>petal width</th>
      <th>class</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>5.1</td>
      <td>3.5</td>
      <td>1.4</td>
      <td>0.2</td>
      <td>Iris-setosa</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4.9</td>
      <td>3.0</td>
      <td>1.4</td>
      <td>0.2</td>
      <td>Iris-setosa</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4.7</td>
      <td>3.2</td>
      <td>1.3</td>
      <td>0.2</td>
      <td>Iris-setosa</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4.6</td>
      <td>3.1</td>
      <td>1.5</td>
      <td>0.2</td>
      <td>Iris-setosa</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5.0</td>
      <td>3.6</td>
      <td>1.4</td>
      <td>0.2</td>
      <td>Iris-setosa</td>
    </tr>
  </tbody>
</table>
</div>

```py
X = df.drop('class', axis=1).values
dummies = pd.get_dummies(df['class'])

species = dummies.columns
y = dummies.values
```


```py
model = Sequential()

model.add(Dense(50, input_dim=X.shape[1], activation='relu'))
model.add(Dense(25, activation='relu'))
model.add(Dense(y.shape[1], activation='softmax'))

model.compile(loss='categorical_crossentropy', optimizer='adam')
model.fit(X, y, verbose=0, epochs=100)
```

```
<tensorflow.python.keras.callbacks.History at 0x2041b8c9c88>
```


```py
y_pred = model.predict(X)

predict_classes = np.argmax(y_pred,axis=1)
expected_classes = np.argmax(y,axis=1)
print(f"Predictions: {predict_classes}")
print(f"Expected: {expected_classes}")

print(species[predict_classes[1:10]])

score = metrics.accuracy_score(expected_classes,predict_classes)
'Accuracy: ' + str(score)
```



```
'Accuracy: 0.9733333333333334'
```


## Saving and Loading Neural Networks

We can store data in a few different formats, the ideal one is the `HDF5` format which stores the structure and weights for the network

### Save Model

We can save the model we just trained with:

```py
MODEL_SAVE_PATH = './exported-models/iris-model.h5'
```


```py
model.save(MODEL_SAVE_PATH)
```


### Load Model

```py
from tensorflow.keras.models import load_model
```


```py
loaded_model = load_model(MODEL_SAVE_PATH)

loaded_model
```

```
<tensorflow.python.keras.engine.sequential.Sequential at 0x2041b8141c8>
```


## Early Stopping to prevent Overfitting

We can make use of test/train sets to help us prevent overfitting, this is done by helping us identify when to stop training the network

It's important that we save our score at a good fitted value

Data is usually split into the following sets:

- Test 
- Train 
- Holdout

If we have have a lot of data we can even try to have multiple test and train sets

To train the model we'll do the normal preprocessing and model definition as before, and then we'll implement `EarlyStopping` from Keras when doing the `model.fit` portion

### Categorical

```py
from sklearn.model_selection import train_test_split
from tensorflow.keras.callbacks import EarlyStopping
```


#### Preprocessing and Model Definition

```py
DATA_URL = 'https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data'

COLUMN_NAMES = [
   'sepal length',
   'sepal width',
   'petal length',
   'petal width',
   'class'
]
```


```py
df = pd.read_csv(DATA_URL, names=COLUMN_NAMES)

X = df.drop('class', axis=1).values
dummies = pd.get_dummies(df['class'])

species = dummies.columns
y = dummies.values
```


```py
model = Sequential()

model.add(Dense(50, input_dim=X.shape[1], activation='relu'))
model.add(Dense(25, activation='relu'))
model.add(Dense(y.shape[1], activation='softmax'))

model.compile(loss='categorical_crossentropy', optimizer='adam')
```


#### Train/Test Split

```py
X_train, X_test, y_train, y_test = train_test_split (
    X, y,
    test_size=0.25,
    random_state=0
)
```


#### Train the Model

> The below applies to both categorical and regression models

We can train the model using an `EarlyStopping` callback, in this we specify:

1. The metric we want to monitor for change, `val_loss` to use the validation `loss` we defined for the model as the metric
2. The minimum change we want to for stability, this will not have much of an impact if made smaller
3. The number of rounds we want the delta to be small for before stopping
4. The mode, usually keep this at `auto` but it is whether to minimize or maximize the error
5. Restore best weights automatically, always keep this at `True`

```py
monitor = EarlyStopping(
    monitor='val_loss', 
    min_delta=1e-3, 
    patience=50,
    verbose=1,
    mode='auto',
    restore_best_weights=True
)
```


```py
model.fit(
    X_train, y_train, 
    validation_data=(X_test, y_test),
    callbacks=[monitor],
    verbose=0,
    epochs=1000
)
```



```
<tensorflow.python.keras.callbacks.History at 0x204254a7108>
```


#### Measure the Accuracy

```py
y_pred = model.predict(X_test)
predicted_classes = np.argmax(y_pred, axis=1)
expected_classes = np.argmax(y_test, axis=1)
score = metrics.accuracy_score(expected_classes, predicted_classes)

'Accuracy: ' + str(score)
```

```
'Accuracy: 0.9736842105263158'
```


## Feature Vectors and Tabular Data

All data that comes into a Neural Network must be numerical

Some of the processing we will typically do are:

1. Convert categorical values to dummies (features and target)
2. Drop any columns like ID, etc.
3. Get all the different numerical data to be in a the same range
4. Center numerical data around a mean of zero
5. Fill missing values as appropriate for the relevant data 
6. If we have missing data in the targe column we should drop those rows

> We can use a Z-score to work with points 3 and 4


## CLassification Metrics

Sometimes we care about additional factors than just the accuracy, such as the counts of false positives or negatives etc.

### ROC Values

- Flase Positives
- False Negatives
- True Positives
- True Negatives

These can also be be described as Type-1 and Type-2 Erors as well as Test Sensitivity and Specificity

A sensitive NN will lead to more false positives, and more specific NN will lead towards fewer false positives 

A ROC chart compares our model to random predictions, the higher up our line is the more accurate our model. We measure the area under this curve to get the AUC Value, if our model falls below the `0.5` mark (below the random line) it means our model is doing worse than a random guess (which is really bad)

### Log Loss

A Log Loss calculation we can get a sort of accuracy score that's more harsh on overconfidence

### Confusion Matrix

This compares our predicted values to the actual values, in this we would ideally want to see a strong diagonal correlation

## Regression Metrics

When working with regression models there are different metrics that we can use in order to 

### Mean Squared Error and Root Mean Squared Error

We usually work with the MSE value which is sort of releative to our dataset, square rooting this gives us the RMSE which tells us how close we are to our actual value in the same units as our target data 

### Lift Chart

A Lift chart is a way to compare our model output to the actual test data in order to see how our model compares over specific value ranges in the target vector

## Backpropagation

We have a few two types of backpropagation which we use when training a model

1. Classic - using gradient descent (e.g. 0.1, 0.01, 0.001)
2. Momentum - pushes weights in order to avoid local minumums (e.g. 0.9)
3. Batch and Online - update weights in batches instead of every iteration
4. Stochastic Gradient Descent - Often used with batching, network trained on differing sets of the data and decreases overfitting by focusing on a smaller number of weights

Additionally we have a few methods that can help us to automate certain hyperparameters;

- Resilient Propogation - uses only the gradient magnitude and allows each neuron it's own learning rate
- Nesterov accelerated gradient - helps mitigate the risk of choosing a bad batch
- Adagrad - allows an automatically decaying learning rate and momentum per weight 
- Adadelta - Based on on Adagrad, monotonically decreasing learning rate


There are also other non gradient methods such as:

- Simulated Annealing
- Generic Algorithm
- Particle Swarm Optimization
- Nelder Mead

> [Some interestnig diagrams](https://ruder.io/optimizing-gradient-descent/index.html#visualizationofalgorithms) comparing different algorithms

## Regularization

Regularization is used to combat overfitting. The two types of Regularization we have Lasso (L1) and Ridge (L2) regularization

L1 regularization can help a network focus on the important factors

The `alpha` value lets us say how important the regularization is to our model, in general a higher `alpha` will cause the model to have a lower accuracy but prevent overfitting

### Lasso (L1)

```py
from sklearn.linear_model import Lasso

model = Lasso(random_state=0, alpha=0.1)

model.fit(X_train, y_train)
```

```
Lasso(alpha=0.1, copy_X=True, fit_intercept=True, max_iter=1000,
      normalize=False, positive=False, precompute=False, random_state=0,
      selection='cyclic', tol=0.0001, warm_start=False)
```


### Ridge (L2)

L2 Regression (Ridge) lets us focus a bit less on the weightings than the L1 method and penalizes the model less for large weights 

```py
from sklearn.linear_model import Ridge

model = Ridge(random_state=0, alpha=0.1)

model.fit(X_train, y_train)
```

```
Ridge(alpha=0.1, copy_X=True, fit_intercept=True, max_iter=None,
      normalize=False, random_state=0, solver='auto', tol=0.001)
```


### ElasticNet

ElasticNet uses a combination of L1 and L2 regularization

```py
from sklearn.linear_model import ElasticNet

model = ElasticNet(random_state=0, alpha=0.1)

model.fit(X_train, y_train)
```

```
ElasticNet(alpha=0.1, copy_X=True, fit_intercept=True, l1_ratio=0.5,
           max_iter=1000, normalize=False, positive=False, precompute=False,
           random_state=0, selection='cyclic', tol=0.0001, warm_start=False)
```


### Dropout

Dropout is another method of regularization and is applied during training

When using dropout we disable random neurons in each epoch to prevent them from becoming too specialized. This helps us to prevent overfitting as well as reduce the variance in the overall trained network

The dropped neurons are re-added once the training is complete

In order to use dropout in Keras we can add a `Dropout` layer with a value for what fraction of neurons we want to be dropped out

> The suggestion is usually not to use a dropout after the final hidden layer

```py
DATA_URL = 'https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data'

COLUMN_NAMES = [
   'sepal length',
   'sepal width',
   'petal length',
   'petal width',
   'class'
]
```


```py
import pandas as pd
import numpy as np

from sklearn import metrics
from sklearn.utils import resample
from sklearn.model_selection import train_test_split

from tensorflow.keras import regularizers
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation, Dropout
```


```py
df = pd.read_csv(DATA_URL, names=COLUMN_NAMES)

X = df.drop('class', axis=1).values
dummies = pd.get_dummies(df['class'])

species = dummies.columns
y = dummies.values
```


```py
X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size=0.25,
    random_state=0
)
```


Below we will train the model, the model has the following:

1. 1st Dense Layer with 50 neurons and ReLU activation
2. A dropout of 50%
3. 2nd Dense Layer with 25 neurons, ReLU, and an L1 Regularization
4. An Output Layer with the categories and Softmax activation 

```py
model = Sequential()

model.add(Dense(50, input_dim=X.shape[1], activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(
        25, 
        activation='relu',
        activity_regularizer=regularizers.l1(1e-4)
    ))

model.add(Dense(y.shape[1], activation='softmax'))
```


```py
model.compile(loss='categorical_crossentropy', optimizer='adam')
```


```py
model.fit(
    X_train, 
    y_train, 
    validation_data=(X_test, y_test),
    verbose=0,
    epochs=100
)
```

```
<tensorflow.python.keras.callbacks.History at 0x1804e5a00c8>
```


```py
y_pred = model.predict(X_test)
```


```py
predicted_classes = np.argmax(y_pred, axis=1)
expected_classes = np.argmax(y_test, axis=1)

print(predicted_classes)
print(expected_classes)
```


```py
score = metrics.accuracy_score(expected_classes, predicted_classes)

'Accuracy: ' + str(score)
```

```
'Accuracy: 0.9736842105263158'
```


## Benchmarking and Regularization

So far we've seen of a network is based on the following:

- Number of layers
- How many neurons per layers
- Activation functions for each layers
- Droppout per layer 
- L2 and L2 Regularization

There are additional parameters that can also influence the network

Due to the different parameters and the random nature of a network it can be difficult to see if our change in hyperparameters is actually impacting the output of a network

We can do something called Bootstrapping which is similar to cross validation with replacement and early stopping to help our network average converge and after how many epochs this takes

```py
import pandas as pd
import numpy as np

from sklearn import metrics
from sklearn.utils import resample
from sklearn.model_selection import ShuffleSplit, StratifiedShuffleSplit

from tensorflow.keras import regularizers
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation, Dropout
from tensorflow.keras.callbacks import EarlyStopping
```


```py
SPLITS = 15
```


### Bootstrap

For a Regression model we can use:

```py
boot = ShuffleSplit(n_splits=SPLITS, test_size=0.1)
```

and then:

```py
for train, test in boot.split(X):
    # train model
```

However, for a Categorical classification we want to ensure that we have a class balance, we can do this with the `StratifiedShuffleSplit` which works like so:

> Note that the `EarlyStopping` monitor returns `0` if the training was not early stopped (e.g. trained till end)

```py
boot = StratifiedShuffleSplit(n_splits=SPLITS, test_size=0.2)
```


### Progress Tracking

```py
accuracy_tracker = []
epoch_tracker = []
```


```py
for train, test in boot.split(X, y): # using the data from the last import

    X_train = X[train]
    X_test = X[test]
    y_train = y[train]
    y_test = y[test]

    model = Sequential()
    model.add(Dense(50, input_dim=X.shape[1], activation='relu'))
    model.add(Dropout(0.5))
    model.add(Dense(
            25, 
            activation='relu'
        ))
    model.add(Dense(y.shape[1], activation='softmax'))

    model.compile(loss='categorical_crossentropy', optimizer='adam')

    monitor = EarlyStopping(
        monitor='val_loss',
        min_delta=1e-3,
        patience=50,
        verbose=0,
        mode='auto',
        restore_best_weights=True
    )

    model.fit(
        X_train, y_train, 
        validation_data=(X_test, y_test),
        callbacks=[monitor],
        verbose=0,
        epochs=1000
    )

    epoch_tracker.append(
        monitor.stopped_epoch if monitor.stopped_epoch > 0 else 1000
    )

    y_pred = model.predict(X_test)

    predicted_classes = np.argmax(y_pred, axis=1)
    expected_classes = np.argmax(y_test, axis=1)

    score = metrics.accuracy_score(expected_classes, predicted_classes)

    accuracy_tracker.append(score)
```


```py
pd.DataFrame({ 
    "Score": accuracy_tracker,
    "Epochs": epoch_tracker
}).describe()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>Score</th>
      <th>Epochs</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>15.000000</td>
      <td>15.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.993333</td>
      <td>350.200000</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.013801</td>
      <td>76.766064</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.966667</td>
      <td>226.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>1.000000</td>
      <td>308.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1.000000</td>
      <td>321.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1.000000</td>
      <td>397.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>1.000000</td>
      <td>528.000000</td>
    </tr>
  </tbody>
</table>
</div>

```py

```
