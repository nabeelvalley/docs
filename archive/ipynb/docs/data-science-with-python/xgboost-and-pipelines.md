# Data Pipelines and XGBoost

- https://www.kaggle.com/alexisbcook/pipelines
- https://www.kaggle.com/alexisbcook/xgboost

> Data from [Kaggle](https://www.kaggle.com/iabhishekofficial/mobile-price-classification#train.csv)

# Pipelines

```py
import pandas as pd

from xgboost import XGBRegressor

from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error


pd.set_option('display.max_columns', 100)
pd.set_option('display.max_rows', 100)
```


```py
DATA_FILE = 'sample-data/mobile-price-classification/train.csv'
```


## Import Data

```py
df = pd.read_csv(DATA_FILE)
```


```py
df.head()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>battery_power</th>
      <th>blue</th>
      <th>clock_speed</th>
      <th>dual_sim</th>
      <th>fc</th>
      <th>four_g</th>
      <th>int_memory</th>
      <th>m_dep</th>
      <th>mobile_wt</th>
      <th>n_cores</th>
      <th>pc</th>
      <th>px_height</th>
      <th>px_width</th>
      <th>ram</th>
      <th>sc_h</th>
      <th>sc_w</th>
      <th>talk_time</th>
      <th>three_g</th>
      <th>touch_screen</th>
      <th>wifi</th>
      <th>price_range</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>842</td>
      <td>0</td>
      <td>2.2</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>7</td>
      <td>0.6</td>
      <td>188</td>
      <td>2</td>
      <td>2</td>
      <td>20</td>
      <td>756</td>
      <td>2549</td>
      <td>9</td>
      <td>7</td>
      <td>19</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1021</td>
      <td>1</td>
      <td>0.5</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>53</td>
      <td>0.7</td>
      <td>136</td>
      <td>3</td>
      <td>6</td>
      <td>905</td>
      <td>1988</td>
      <td>2631</td>
      <td>17</td>
      <td>3</td>
      <td>7</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>563</td>
      <td>1</td>
      <td>0.5</td>
      <td>1</td>
      <td>2</td>
      <td>1</td>
      <td>41</td>
      <td>0.9</td>
      <td>145</td>
      <td>5</td>
      <td>6</td>
      <td>1263</td>
      <td>1716</td>
      <td>2603</td>
      <td>11</td>
      <td>2</td>
      <td>9</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>615</td>
      <td>1</td>
      <td>2.5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>10</td>
      <td>0.8</td>
      <td>131</td>
      <td>6</td>
      <td>9</td>
      <td>1216</td>
      <td>1786</td>
      <td>2769</td>
      <td>16</td>
      <td>8</td>
      <td>11</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1821</td>
      <td>1</td>
      <td>1.2</td>
      <td>0</td>
      <td>13</td>
      <td>1</td>
      <td>44</td>
      <td>0.6</td>
      <td>141</td>
      <td>2</td>
      <td>14</td>
      <td>1208</td>
      <td>1212</td>
      <td>1411</td>
      <td>8</td>
      <td>2</td>
      <td>15</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>

## Separate Variables

```py
X = df.drop('price_range', axis=1)
y = df.price_range
```


```py
X_train_full, X_valid_full, y_train, y_valid = train_test_split(X, y, train_size=0.8, test_size=0.2, random_state=0)
```


## Split Data types

```py
categorical_cols = [cname for cname in X_train_full.columns if X_train_full[cname].nunique() < 10 and 
                        X_train_full[cname].dtype == "object"]

numerical_cols = [cname for cname in X_train_full.columns if X_train_full[cname].dtype in ['int64', 'float64']]
```


```py
my_cols = categorical_cols + numerical_cols

X_train = X_train_full[my_cols].copy()
X_valid = X_valid_full[my_cols].copy()
```


```py
X_train.head()
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>battery_power</th>
      <th>blue</th>
      <th>clock_speed</th>
      <th>dual_sim</th>
      <th>fc</th>
      <th>four_g</th>
      <th>int_memory</th>
      <th>m_dep</th>
      <th>mobile_wt</th>
      <th>n_cores</th>
      <th>pc</th>
      <th>px_height</th>
      <th>px_width</th>
      <th>ram</th>
      <th>sc_h</th>
      <th>sc_w</th>
      <th>talk_time</th>
      <th>three_g</th>
      <th>touch_screen</th>
      <th>wifi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>582</th>
      <td>1232</td>
      <td>0</td>
      <td>2.9</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>24</td>
      <td>0.3</td>
      <td>169</td>
      <td>5</td>
      <td>17</td>
      <td>361</td>
      <td>809</td>
      <td>1257</td>
      <td>16</td>
      <td>10</td>
      <td>16</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>159</th>
      <td>1840</td>
      <td>0</td>
      <td>0.5</td>
      <td>1</td>
      <td>12</td>
      <td>0</td>
      <td>34</td>
      <td>0.7</td>
      <td>142</td>
      <td>1</td>
      <td>16</td>
      <td>311</td>
      <td>1545</td>
      <td>1078</td>
      <td>8</td>
      <td>0</td>
      <td>10</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1827</th>
      <td>1692</td>
      <td>0</td>
      <td>2.1</td>
      <td>0</td>
      <td>4</td>
      <td>1</td>
      <td>2</td>
      <td>0.9</td>
      <td>106</td>
      <td>1</td>
      <td>17</td>
      <td>1899</td>
      <td>1904</td>
      <td>3779</td>
      <td>9</td>
      <td>3</td>
      <td>7</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>318</th>
      <td>508</td>
      <td>0</td>
      <td>0.8</td>
      <td>0</td>
      <td>7</td>
      <td>1</td>
      <td>42</td>
      <td>0.3</td>
      <td>94</td>
      <td>1</td>
      <td>8</td>
      <td>39</td>
      <td>557</td>
      <td>663</td>
      <td>13</td>
      <td>12</td>
      <td>7</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>708</th>
      <td>977</td>
      <td>1</td>
      <td>2.8</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
      <td>35</td>
      <td>0.6</td>
      <td>165</td>
      <td>2</td>
      <td>15</td>
      <td>1502</td>
      <td>1862</td>
      <td>3714</td>
      <td>19</td>
      <td>3</td>
      <td>10</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>

## Create Transformers for the diferent types of data

```py
numerical_transformer = SimpleImputer(strategy='constant')


categorical_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])
```


## Add these transformers to a Preprocessor

```py
preprocessor = ColumnTransformer(
    transformers=[
        ('num', numerical_transformer, numerical_cols),
        ('cat', categorical_transformer, categorical_cols)
    ])
```


## Define Model

```py
model = RandomForestRegressor(n_estimators=100, random_state=0)
```


## Create Pipeline

```py
pipeline = Pipeline(steps=[('preprocessor', preprocessor),
                              ('model', model)])
```


## Run the Pipeline

```py
pipeline.fit(X_train, y_train)
```

```
Pipeline(memory=None,
         steps=[('preprocessor',
                 ColumnTransformer(n_jobs=None, remainder='drop',
                                   sparse_threshold=0.3,
                                   transformer_weights=None,
                                   transformers=[('num',
                                                  SimpleImputer(add_indicator=False,
                                                                copy=True,
                                                                fill_value=None,
                                                                missing_values=nan,
                                                                strategy='constant',
                                                                verbose=0),
                                                  ['battery_power', 'blue',
                                                   'clock_speed', 'dual_sim',
                                                   'fc', 'four_g', 'int_memory',
                                                   'm_dep...
                 RandomForestRegressor(bootstrap=True, ccp_alpha=0.0,
                                       criterion='mse', max_depth=None,
                                       max_features='auto', max_leaf_nodes=None,
                                       max_samples=None,
                                       min_impurity_decrease=0.0,
                                       min_impurity_split=None,
                                       min_samples_leaf=1, min_samples_split=2,
                                       min_weight_fraction_leaf=0.0,
                                       n_estimators=100, n_jobs=None,
                                       oob_score=False, random_state=0,
                                       verbose=0, warm_start=False))],
         verbose=False)
```


```py
predictions = pipeline.predict(X_valid)
```


```py
results = X_valid
results['predicted'] = predictions
results['actual'] = y_valid
results['diff'] = abs(results['predicted'] - results['actual'])
results.head(10)
```
<div>

<table>
  <thead>
    <tr>
      <th></th>
      <th>battery_power</th>
      <th>blue</th>
      <th>clock_speed</th>
      <th>dual_sim</th>
      <th>fc</th>
      <th>four_g</th>
      <th>int_memory</th>
      <th>m_dep</th>
      <th>mobile_wt</th>
      <th>n_cores</th>
      <th>pc</th>
      <th>px_height</th>
      <th>px_width</th>
      <th>ram</th>
      <th>sc_h</th>
      <th>sc_w</th>
      <th>talk_time</th>
      <th>three_g</th>
      <th>touch_screen</th>
      <th>wifi</th>
      <th>predicted</th>
      <th>actual</th>
      <th>diff</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>405</th>
      <td>1454</td>
      <td>1</td>
      <td>0.5</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>34</td>
      <td>0.7</td>
      <td>83</td>
      <td>4</td>
      <td>3</td>
      <td>250</td>
      <td>1033</td>
      <td>3419</td>
      <td>7</td>
      <td>5</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>2.98</td>
      <td>3</td>
      <td>0.02</td>
    </tr>
    <tr>
      <th>1190</th>
      <td>1092</td>
      <td>1</td>
      <td>0.5</td>
      <td>1</td>
      <td>10</td>
      <td>0</td>
      <td>11</td>
      <td>0.5</td>
      <td>167</td>
      <td>3</td>
      <td>14</td>
      <td>468</td>
      <td>571</td>
      <td>737</td>
      <td>14</td>
      <td>4</td>
      <td>11</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0.00</td>
      <td>0</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>1132</th>
      <td>1524</td>
      <td>1</td>
      <td>1.8</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>10</td>
      <td>0.6</td>
      <td>174</td>
      <td>4</td>
      <td>1</td>
      <td>154</td>
      <td>550</td>
      <td>2678</td>
      <td>16</td>
      <td>5</td>
      <td>13</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>1.97</td>
      <td>2</td>
      <td>0.03</td>
    </tr>
    <tr>
      <th>731</th>
      <td>1807</td>
      <td>1</td>
      <td>2.1</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>49</td>
      <td>0.8</td>
      <td>125</td>
      <td>1</td>
      <td>10</td>
      <td>337</td>
      <td>1384</td>
      <td>1906</td>
      <td>17</td>
      <td>13</td>
      <td>13</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1.69</td>
      <td>2</td>
      <td>0.31</td>
    </tr>
    <tr>
      <th>1754</th>
      <td>1086</td>
      <td>1</td>
      <td>1.7</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>43</td>
      <td>0.2</td>
      <td>111</td>
      <td>6</td>
      <td>1</td>
      <td>56</td>
      <td>1150</td>
      <td>3285</td>
      <td>11</td>
      <td>5</td>
      <td>17</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>2.70</td>
      <td>2</td>
      <td>0.70</td>
    </tr>
    <tr>
      <th>1178</th>
      <td>909</td>
      <td>1</td>
      <td>0.5</td>
      <td>1</td>
      <td>9</td>
      <td>0</td>
      <td>30</td>
      <td>0.4</td>
      <td>97</td>
      <td>3</td>
      <td>10</td>
      <td>290</td>
      <td>773</td>
      <td>594</td>
      <td>12</td>
      <td>0</td>
      <td>4</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>0.00</td>
      <td>0</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>1533</th>
      <td>642</td>
      <td>1</td>
      <td>0.5</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>38</td>
      <td>0.8</td>
      <td>86</td>
      <td>5</td>
      <td>10</td>
      <td>887</td>
      <td>1775</td>
      <td>435</td>
      <td>9</td>
      <td>2</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0.08</td>
      <td>0</td>
      <td>0.08</td>
    </tr>
    <tr>
      <th>1303</th>
      <td>888</td>
      <td>0</td>
      <td>2.6</td>
      <td>1</td>
      <td>2</td>
      <td>1</td>
      <td>33</td>
      <td>0.4</td>
      <td>198</td>
      <td>2</td>
      <td>17</td>
      <td>327</td>
      <td>1683</td>
      <td>3407</td>
      <td>12</td>
      <td>1</td>
      <td>20</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>2.68</td>
      <td>3</td>
      <td>0.32</td>
    </tr>
    <tr>
      <th>1857</th>
      <td>914</td>
      <td>1</td>
      <td>0.7</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>60</td>
      <td>0.9</td>
      <td>198</td>
      <td>5</td>
      <td>4</td>
      <td>740</td>
      <td>840</td>
      <td>3736</td>
      <td>14</td>
      <td>8</td>
      <td>5</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>2.84</td>
      <td>3</td>
      <td>0.16</td>
    </tr>
    <tr>
      <th>18</th>
      <td>1131</td>
      <td>1</td>
      <td>0.5</td>
      <td>1</td>
      <td>11</td>
      <td>0</td>
      <td>49</td>
      <td>0.6</td>
      <td>101</td>
      <td>5</td>
      <td>18</td>
      <td>658</td>
      <td>878</td>
      <td>1835</td>
      <td>19</td>
      <td>13</td>
      <td>16</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0.95</td>
      <td>1</td>
      <td>0.05</td>
    </tr>
  </tbody>
</table>
</div>

## Get the Mean Absolute Error

The MAE is a value that tells us within what distance of the actual value our prediction will fall, in this case it means that the model will return a result within 0.17 of the actual result (in our case our expected values range between 1 and 3) on average 

```py
score = mean_absolute_error(y_valid, predictions)
print('MAE:', score)
```


## XGBoost

> We'll use the same data as above

```py
df = pd.read_csv(DATA_FILE)

X = df.drop('price_range', axis=1)
y = df.price_range

X_train, X_valid, y_train, y_valid = train_test_split(X, y, train_size=0.8, test_size=0.2, random_state=0)

categorical_cols = [cname for cname in X_train_full.columns if X_train_full[cname].nunique() < 10 and 
                        X_train_full[cname].dtype == "object"]

numerical_cols = [cname for cname in X_train_full.columns if X_train_full[cname].dtype in ['int64', 'float64']]

my_cols = categorical_cols + numerical_cols

X_train = X_train_full[my_cols].copy()
X_valid = X_valid_full[my_cols].copy()

numerical_transformer = SimpleImputer(strategy='constant')

categorical_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])

preprocessor = ColumnTransformer(
    transformers=[
        ('num', numerical_transformer, numerical_cols),
        ('cat', categorical_transformer, categorical_cols)
    ])
```


### Train the Model

### Using the Default Parameters

#### 1. Create Model Instance

Below we have an example of a model instance created using no parameters, so everything is defaulted, and we can train that like so:

```py
model = XGBRegressor()

pipeline = Pipeline(steps=[('preprocessor', preprocessor),
                              ('model', model)])

pipeline.fit(X_train, y_train)
```

Some of the params we can set are:

- `n_estimators` which is essentially how many models we want in the ensemble, this is usually between 100 and 1000 but is impacted by the learning rate
- `learning_rate` is how much we want the model to retain between passes, by default this is `0.1`, but we can choose a lower value which will mean the model retains less, this can help us to prevent overfitting
- `early_stopping_rounds` is the number of rounds after deteration that we want the model to stop increasing the `n_estimators` this is done by giving it a set of testing data `eval_set` which it will use to optimize with, a good value for this is `early_stopping_rounds=5`
- `objective` is a string or function that lets us specify the objective/type of model we would like to build -  a list of `objective`s can be found [here](https://xgboost.readthedocs.io/en/latest/parameter.html#learning-task-parameters)
- If using a multi-class (`multi:softmax`) classifier you also have to state the number of classes as `num_class=4`

Below we'll use a bit of a more complex mode configuration


```py
model = XGBRegressor(n_estimators=1000, learning_rate=0.1, objective='multi:softmax', num_class=4)
```


#### 2. Add the Model to a Pipeline

```py
pipeline = Pipeline(steps=[('preprocessor', preprocessor),
                              ('model', model)])
```


#### 3. Train the Pipeline

- Note that we need to pre-format our `eval_set` data so that it has the proprocessing steps applied so that the data structures are aligned
- We also need to prefix any inputs that we want passed on to our model with `model__` so that the pipeline passes it to the correct object

```py
preprocessor.fit(X_valid)
X_valid_transformed = preprocessor.transform(X_valid)
```


```py
pipeline.fit(X_train, y_train, 
                model__early_stopping_rounds=20, 
                model__eval_set=[(X_valid_transformed, y_valid)],
                model__verbose=False)
```

```
Pipeline(memory=None,
         steps=[('preprocessor',
                 ColumnTransformer(n_jobs=None, remainder='drop',
                                   sparse_threshold=0.3,
                                   transformer_weights=None,
                                   transformers=[('num',
                                                  SimpleImputer(add_indicator=False,
                                                                copy=True,
                                                                fill_value=None,
                                                                missing_values=nan,
                                                                strategy='constant',
                                                                verbose=0),
                                                  ['battery_power', 'blue',
                                                   'clock_speed', 'dual_sim',
                                                   'fc', 'four_g', 'int_memory',
                                                   'm_dep...
                              colsample_bylevel=1, colsample_bynode=1,
                              colsample_bytree=1, gamma=0,
                              importance_type='gain', learning_rate=0.1,
                              max_delta_step=0, max_depth=3, min_child_weight=1,
                              missing=None, n_estimators=1000, n_jobs=1,
                              nthread=None, num_class=4,
                              objective='multi:softmax', random_state=0,
                              reg_alpha=0, reg_lambda=1, scale_pos_weight=1,
                              seed=None, silent=None, subsample=1,
                              verbosity=1))],
         verbose=False)
```


#### 4. Predict using the Pipeline

```py
predictions = pipeline.predict(X_valid)
print("Mean Absolute Error: " + str(mean_absolute_error(predictions, y_valid)))
```


## Cross Validation

We can do cross-validation using the `cross_val_score` function from `sklearn` by:

1. Defining the pipeline
2. Defining the number of folds
3. Defining the model
4. Applying the cross-validation to the pipeline

### 1. Define the Pipeline

```py
df = pd.read_csv(DATA_FILE)

X = df.drop('price_range', axis=1)
y = df.price_range

numerical_transformer = SimpleImputer(strategy='constant')

categorical_transformer = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])

preprocessor = ColumnTransformer(
    transformers=[
        ('num', numerical_transformer, numerical_cols),
        ('cat', categorical_transformer, categorical_cols)
    ])
```


```py
# n_estimators based on the previous value
model = XGBRegressor(n_estimators=190, learning_rate=0.1, objective='multi:softmax', num_class=4)
```


```py
validation_result = cross_val_score(pipeline, X, y, cv=3)
```


```py
validation_result
```


```py

```
