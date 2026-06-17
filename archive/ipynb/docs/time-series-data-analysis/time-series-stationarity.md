> [View Notebook on Kaggle](https://www.kaggle.com/code/nabeelvalley/time-series-stationarity)

# Components of Time Series data

- Trend
- Seasonality
- Irregularity
- Cyclicality

# When not to use Time Series Analyis

- Values are constant - it's pointless
- Values are in the form of functions - just use the function

# Stationarity

- Constant mean
- Constant variance
- Autovariance that does not depend on time

A stationary series has a high probability to follow the same pattern in future

## Stationarity Tests

- Rolling Statistics - moving average, moving variance, visualization
- ADCF Test

## ARIMA

ARIMA is a common model for analysis

The ARIMA model has the following parameters:: 

- P - Auto Regressive (AR)
- d - Integration (I)
- Q - Moving Average (MA)

# Applying the Above

```py
# This Python 3 environment comes with many helpful analytics libraries installed
# It is defined by the kaggle/python Docker image: https://github.com/kaggle/docker-python
# For example, here's several helpful packages to load

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

import os
for dirname, _, filenames in os.walk('/kaggle/input'):
    for filename in filenames:
        print(os.path.join(dirname, filename))

# You can write up to 20GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using "Save & Run All" 
# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session
```


```py
import seaborn as sns
```


```py
df = pd.read_csv('/kaggle/input/air-passengers/AirPassengers.csv')

df.head()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>Month</th>
      <th>#Passengers</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1949-01</td>
      <td>112</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1949-02</td>
      <td>118</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1949-03</td>
      <td>132</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1949-04</td>
      <td>129</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1949-05</td>
      <td>121</td>
    </tr>
  </tbody>
</table>
</div>

```py
df['Month'] = pd.to_datetime(df['Month'], infer_datetime_format=True)
df = df.set_index(['Month'])

df.head()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>#Passengers</th>
    </tr>
    <tr>
      <th>Month</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1949-01-01</th>
      <td>112</td>
    </tr>
    <tr>
      <th>1949-02-01</th>
      <td>118</td>
    </tr>
    <tr>
      <th>1949-03-01</th>
      <td>132</td>
    </tr>
    <tr>
      <th>1949-04-01</th>
      <td>129</td>
    </tr>
    <tr>
      <th>1949-05-01</th>
      <td>121</td>
    </tr>
  </tbody>
</table>
</div>

```py
sns.lineplot(data=df)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-5-1.png" />

In the above we can see that there is an upward trend as well as some seasonality

Next, we can check some summary statistics using a rolling mean approach

## Rolling Averages

> Note that for the rolling functions we use a window of 12, this is because the data has a seasonality of 12 months

```py
rolling_mean = df.rolling(window=12).mean()
rolling_std = df.rolling(window=12).std()

df_summary = df.assign(Mean=rolling_mean)
df_summary = df_summary.assign(Std=rolling_std)

sns.lineplot(data=df_summary)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-8-1.png" />

Since the mean and standard deviation are not constant we can conclude that the data is not stationary

## ADF Test

The null hypothesis for the test is that the series is non-stationary, we reject it if the resulting probability > 0.05 (or some other threshold)

```py
from statsmodels.tsa.stattools import adfuller
```


```py
def print_adf(adf):
    print('ADF test statistic', adf[0])
    print('p-value', adf[1])
    print('Lags used', adf[2])
    print('Observations used', adf[3])
    print('Critical values', adf[4])
```


```py
adf = adfuller(df['#Passengers'])

print_adf(adf)
```


In the result of the ADF test we can see that the p-value is much higher than 0.05 which means that the data is not stationary

Because the data is non-stationary the next think we need to do is estimate the trend

```py
df_log = np.log(df)

sns.lineplot(data=df_log)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-15-1.png" />

```py
rolling_mean_log = df_log.rolling(window=12).mean()

df_summary = df_log.assign(Mean=rolling_mean_log)

sns.lineplot(data=df_summary)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-16-1.png" />

Using the log there is still some residual effect visible, we can try taking a diff:

```py
df_diff = df - rolling_mean

sns.lineplot(data=df_diff)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-18-1.png" />

```py
rolling_mean_diff = df_diff.rolling(window=12).mean()
rolling_std_diff = df_diff.rolling(window=12).std()

df_summary = df_diff.assign(Mean=rolling_mean_diff)
df_summary = df_summary.assign(Std=rolling_std_diff)

sns.lineplot(data=df_summary)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-19-1.png" />

```py
adf_diff = adfuller(df_diff.dropna())

print_adf(adf_diff)
```


We can do the same with the log:

```py
df_diff_log = df_log - rolling_mean_log

sns.lineplot(data=df_diff_log)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-22-1.png" />

```py
rolling_mean_diff_log = df_diff_log.rolling(window=12).mean()
rolling_std_diff_log = df_diff_log.rolling(window=12).std()

df_summary = df_diff_log.assign(Mean=rolling_mean_diff_log)
df_summary = df_summary.assign(Std=rolling_std_diff_log)

sns.lineplot(data=df_summary)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-23-1.png" />

```py
adf_diff_log = adfuller(df_diff_log.dropna())

print_adf(adf_diff_log)
```


The ADF for the log diff is less than 0.05 so the result is stationary

We can also try a divide using the the original data and the rolling mean:

```py
df_div = df / rolling_mean

sns.lineplot(data=df_div)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-27-1.png" />

```py
rolling_mean_div = df_div.rolling(window=12).mean()
rolling_std_div = df_div.rolling(window=12).std()

df_summary = df_div.assign(Mean=rolling_mean_div)
df_summary = df_summary.assign(Std=rolling_std_div)

sns.lineplot(data=df_summary)
```

```
<AxesSubplot:xlabel='Month'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-28-1.png" />

```py
adf_div = adfuller(df_div.dropna())

print_adf(adf_div)
```


The ADF for the division is less than 0.05 so the result is stationary

Next we can try to do a decomposition on the above series since it is stationary:

```py
from statsmodels.tsa.seasonal import seasonal_decompose
```


```py
decomposition = seasonal_decompose(df_div.dropna())
```


```py
trend = decomposition.trend

sns.lineplot(data=trend.dropna())
```

```
<AxesSubplot:xlabel='Month', ylabel='trend'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-34-1.png" />

```py
seasonal = decomposition.seasonal

sns.lineplot(data=seasonal.dropna())
```

```
<AxesSubplot:xlabel='Month', ylabel='seasonal'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-35-1.png" />

```py
resid = decomposition.resid

sns.lineplot(data=resid.dropna())
```

```
<AxesSubplot:xlabel='Month', ylabel='resid'>
```



```
<Figure size 432x288 with 1 Axes>
```
<img src="/jupyter/src__content__docs-ipynb__time-series-data-analysis__time-series-stationarity-36-1.png" />

```py

```
