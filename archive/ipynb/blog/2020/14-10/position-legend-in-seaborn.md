```py
import pandas as pd
import seaborn as sns

DATA_PATH = '../input/iris/Iris.csv'

df = pd.read_csv(DATA_PATH)

df.head(1)
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>Id</th>
      <th>SepalLengthCm</th>
      <th>SepalWidthCm</th>
      <th>PetalLengthCm</th>
      <th>PetalWidthCm</th>
      <th>Species</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>5.1</td>
      <td>3.5</td>
      <td>1.4</td>
      <td>0.2</td>
      <td>Iris-setosa</td>
    </tr>
  </tbody>
</table>
</div>

When working with Python and Seaborn (`sns`) it's common to have plots in which the legend overlaps the plot content, we can see this issue in the below code output:


```py
g = sns.scatterplot(x = 'SepalWidthCm', y = 'SepalLengthCm', hue = 'Species', data = df)
```

```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__blog-ipynb__2020__14-10__position-legend-in-seaborn-2-0.png" />

Using the `g.legend` function of a graph we are able to move the legend to a more suitable location

```py
g = sns.scatterplot(x = 'SepalWidthCm', y = 'SepalLengthCm', hue = 'Species', data = df)
g.legend(loc = 'center left', bbox_to_anchor = (1, 0.5), ncol = 1)
```

```
<matplotlib.legend.Legend at 0x7fc2034acb10>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__blog-ipynb__2020__14-10__position-legend-in-seaborn-4-1.png" />

> You can find out more about how the `legend` function works [in the Matplotlib Docs](https://matplotlib.org/3.1.1/api/_as_gen/matplotlib.pyplot.legend.html), and you can find an interactive version of this notebook [on Kaggle](https://www.kaggle.com/nabeelvalley/position-legends-in-seaborn)