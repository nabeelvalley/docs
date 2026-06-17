```py
DATA_URL = 'http://archive.ics.uci.edu/ml/machine-learning-databases/balance-scale/balance-scale.data'
```


```py
import pandas as pd
```


# Handling Imbalanced Classes

> From [this article](https://elitedatascience.com/imbalanced-classes)

Class imbalances are a common occurence and can very easily lead to skewing of models as well as models that provide inaccurate accuracies for performance

An example of a class imbalence would be something like in the `balance scale dataset` from [here](http://archive.ics.uci.edu/ml/datasets/balance+scale):

```py
df = pd.read_csv(
    DATA_URL, 
    names=['balance', 'var1', 'var2', 'var3', 'var4']
)

# transform into binary classification
df['balance'] = [1 if b=='B' else 0 for b in df.balance]

df.head()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>balance</th>
      <th>var1</th>
      <th>var2</th>
      <th>var3</th>
      <th>var4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>

```py
df.balance.count()
```

```
625
```


In the above dataset we have the case where we have an imbalance of the class distribution in `balance`, we have `657` of the `False` class but only `49` of the `True` class. We can see this below:

```py
df.balance.value_counts()
```

```
0    576
1     49
Name: balance, dtype: int64
```


This means that even a model that only returns `False` will be correct `576/265` times, this isn't very meaningful to us. Since most ML algorithms try to optimize accuracy it will potentially yield something close to the above ratio

A model as described would have a good accuracy overall, but be very bad at predicting the `True` values

In order to counter this effect we need to balance our data in some way, we have two ways we can do this:

1. Down-sample the majority class - potential data loss
2. Up-sample the minority class - potential overfitting on minority class
3. Penalize imbalanced predictions (if your model supports it)
4. Use a tree-based algorithm (I've had issues with this in practice but claims to work in theory)
5. Use Synthetic Samples for minority data (kind of like up-sampling)
6. Use an Anomaly Detection algorithm to identify your minority classes

We can do both of the above using the `sklearn.utils.resample` function

> Try both for your model and see which yields better results

```py
from sklearn.utils import resample
```


## 1. Down-sample the majority class

```py
df_minority = df[df.balance == 1]
df_majority = df[df.balance == 0]

df_majority_downsampled = resample(
    df_majority, 
    replace=False,    
    n_samples=len(df_minority), 
    random_state=0
)

df_balanced = pd.concat([df_minority, df_majority_downsampled])
```


```py
df_balanced.balance.value_counts()
```

```
1    49
0    49
Name: balance, dtype: int64
```


## 2. Up-sample the minority class

```py
df_minority = df[df.balance == 1]
df_majority = df[df.balance == 0]

df_minority_upsampled = resample(
    df_minority, 
    replace=True,    
    n_samples=len(df_majority), 
    random_state=0
)

df_balanced = pd.concat([df_minority_upsampled, df_majority])
```


```py
df_balanced.balance.value_counts()
```

```
1    576
0    576
Name: balance, dtype: int64
```


## 3. Penalize mistakes on minority classes

If we're using a classifier like an SVM that supports penalization for incorrect predictions on minority classes we can use that too, for example the `sklearn.svm.SVC` we can set the `class_weight='balanced'` to make this happen

```py
from sklearn.svm import SVC
```


```py
X = df.drop('balance', axis=1)
y = df.balance

model = SVC(
    kernel='linear', 
    class_weight='balanced',
    probability=True
)
```


## Other Mehtods

The methods above can be helpful at a general level, however some other things that can be looked into are:

### Synthetic Sampling 

Synthetic sampling is a method of upsampling that slightly disturbs the samples so as not to be identical to the initial sample

### Anomaly Detection

If trying to detect a specific occurence of a class that isn't very common it may be useful to use an anomaly detection algorithm to identify these class instances, these might work well in cases where the class you're trying to identify has some 'abnormal' characteristics

```py

```
