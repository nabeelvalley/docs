```py
import pandas as pd
import seaborn as sns

DATA_PATH = '../input/iris-flower-dataset/IRIS.csv'

df = pd.read_csv(DATA_PATH)

df.head(1)
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>sepal_length</th>
      <th>sepal_width</th>
      <th>petal_length</th>
      <th>petal_width</th>
      <th>species</th>
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
  </tbody>
</table>
</div>

A Linear Regression model tries to fit a straight line to the given data set, to train a linear regression model with `sklearn` you will need to first split the data into `x` and `y` components:


```py
x_labels = ['sepal_length', 'petal_width']
y_labels = ['petal_length']

np_x = df[x_labels].to_numpy()
np_y = df[y_labels].transpose().to_numpy()[0]
```


Next, we need to split our training and testing data

```py
from sklearn.model_selection import train_test_split

x_train, x_test, y_train, y_test = train_test_split(np_x, np_y)
```


Once we've got our data split into `test` and `train` sets, we can train our model using the `test` data using the `fit` function of the `LinearRegression` model

```py
from sklearn.linear_model import LinearRegression

model = LinearRegression().fit(x_train, y_train)
```


Lastly, we can use `model.score` to get the $R^2$ value for the model

```py
model.score(x_test, y_test)
```

```
0.931396085809373
```


> You can find out more about how the `LinearRegression` model works [in the Sklearn Docs](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html), and you can find an interactive version of this notebook [on Kaggle](https://www.kaggle.com/nabeelvalley/linear-regression-model-with-sklearn)