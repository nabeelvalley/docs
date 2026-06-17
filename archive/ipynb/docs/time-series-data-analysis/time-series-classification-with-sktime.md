> [View this Notebook on Kaggle](https://www.kaggle.com/code/nabeelvalley/time-series-classification-with-sktime)

# Time Series Classification with SKTime

> [SKTime Docs](https://www.sktime.org/)

![SKTime Tasks](https://raw.githubusercontent.com/sktime/sktime-tutorial-pydata-global-2021/main/images/reduction-relations.png)

## Resources

- [Overview of time series analysis Python packages](https://siebert-julien.github.io/time-series-analysis-python/)
- [sktime - A Unified Toolbox for ML with Time Series - Markus Löning | PyData Global 2021](https://www.youtube.com/watch?v=ODspi8-uWgo)
- [GitHub SKTime Tutorial](https://github.com/sktime/sktime-tutorial-pydata-global-2021)

```py
!pip install sktime
```


# Methodology

Using `sktime` for classification is similar to using it for forecasting wherein there are either predefined models or we can transform exising `sklearn` models to make them usable with time series data

## Importing Data

We can import the arrow head dataset and graph some of the entries

```py
import pandas as pd

from sktime.datasets import load_arrow_head
from sktime.utils.plotting import plot_series
from sklearn.model_selection import train_test_split

```


```py
X, y = load_arrow_head()
```


```py
X.head()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>dim_0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0     -1.963009
1     -1.957825
2     -1.95614...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0     -1.774571
1     -1.774036
2     -1.77658...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0     -1.866021
1     -1.841991
2     -1.83502...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0     -2.073758
1     -2.073301
2     -2.04460...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0     -1.746255
1     -1.741263
2     -1.72274...</td>
    </tr>
  </tbody>
</table>
</div>

```py
y[:5]
```

```
array(['0', '1', '2', '0', '1'], dtype='<U1')
```


```py
X_0 = list(X['dim_0'][0])
plot_series(pd.Series(X_0))
```

```
(<Figure size 1152x288 with 1 Axes>, <AxesSubplot:>)
```



```
<Figure size 1152x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-classification-with-sktime-8-1.png" />

```py
X_1 = list(X['dim_0'][1])
plot_series(pd.Series(X_1))
```

```
(<Figure size 1152x288 with 1 Axes>, <AxesSubplot:>)
```



```
<Figure size 1152x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-classification-with-sktime-9-1.png" />

## Train/Test Split

Train/Test splitting can be cone using sklearn as normal since each row is a different series/observation

```py
from sklearn.model_selection import train_test_split
```


```py
X_train, X_test, y_train, y_test = train_test_split(X, y)
```


## Using a Classifier

`sktime` has built in classifiers that can be used as normal `sklearn` classifiers:

```py
from sktime.classification.interval_based import TimeSeriesForestClassifier
```


```py
classifier = TimeSeriesForestClassifier()
classifier.fit(X_train, y_train)
```

```
TimeSeriesForestClassifier()
```


And predictions can be made using the `predict` method:

```py
y_pred = classifier.predict(X_test)
```


## Model Evaluation

We can also check the accuracy using normal `sklearn` metrics, for example `accuracy_score`

```py
from sklearn.metrics import accuracy_score
accuracy_score(y_test, y_pred)
```

```
0.9056603773584906
```


```py
from sklearn.metrics import confusion_matrix
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay

matrix = confusion_matrix(y_test, y_pred)
disp = ConfusionMatrixDisplay(matrix)
disp.plot()
```

```
<sklearn.metrics._plot.confusion_matrix.ConfusionMatrixDisplay at 0x7f826205ddd0>
```



```
<Figure size 432x288 with 2 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-classification-with-sktime-20-1.png" />

## Use with SKLearn Classifiers

`sktime` also allows the conversion of data such that it can be used with `sklearn` tabular classifiers. This is done by transforming the classifier using the `Tabularizer` in a sklearn pipeline

```py
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.pipeline import make_pipeline

from sktime.transformations.panel.reduce import Tabularizer
```


```py
classifier = make_pipeline(Tabularizer(), GradientBoostingClassifier())
classifier.fit(X_train, y_train)
```

```
Pipeline(steps=[('tabularizer', Tabularizer()),
,                ('gradientboostingclassifier', GradientBoostingClassifier())])
```


```py
y_pred = classifier.predict(X_test)
```


```py
accuracy_score(y_test, y_pred)
```

```
0.9056603773584906
```


```py
matrix = confusion_matrix(y_test, y_pred)
disp = ConfusionMatrixDisplay(matrix)
disp.plot()
```

```
<sklearn.metrics._plot.confusion_matrix.ConfusionMatrixDisplay at 0x7f8261ebb810>
```



```
<Figure size 432x288 with 2 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-classification-with-sktime-26-1.png" />

```py

```
