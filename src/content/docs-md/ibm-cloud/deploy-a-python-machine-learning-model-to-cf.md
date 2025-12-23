## Deploy a Python Machine Learning Model as a CF Web Service

An important part of machine learning is model deployment, deploying a machine learning mode so that other applications can consume the model in production.

An effective way to deploy a machine learning model for consumption is be means of a web service

This tutorial will cover the steps required from getting your data and training a model with it to deploying your model as a web service to Cloud Foundry

## Learning Objectives

Upon completion of this tutorial you will know how to export a machine learning model and create a web service that will expose your model for other applications to use by means of a Cloud Foundry Application or Docker Container.

## Prerequisites

This tutorial requires the following:

- Basic understanding of Python
- Experience using Skikit Learn to train Machine Learning Models
- Basic understanding of REST
- An IBM Cloud Account
- Familiarity with [Jupyter Notebook](https://jupyter.org/)
- [IBM Cloud CLI](https://console.bluemix.net/docs/cli/index.html)
- Docker and a Docker Hub Account

## Estimated Time

This tutorial should take between 15 and 30 minutes to complete.

## Steps

### Get the data

The first step of deploying a machine learning model is having some data to train a model on. The data to be generated will be a two-column dataset that conforms to a Linear Regression Approximation.

1. Create a directory for the project, and in it create a directory for your training files called `train`
2. For this tutorial some generated data will be used. We can create a new Jupyter Notebook in the `train` directory called `generatedata.ipynb`, you can generate the data by running the following python code in a Notebook Cell.

```python
import numpy as np

x = np.arange(-5.0, 5.0, 0.1)
y = 2*(x) + 3
y_noise = 2 * np.random.normal(size=x.size)
ydata = y + y_noise
```

3. Next you can view the generated data as a Data Frame by running the following code.

```python
import pandas as pd

df = pd.DataFrame()
df['Independent Variable'] = x
df['Dependent Variable'] = ydata
df.head()
```

4. Lastly export the data to a CSV file so it can be used to train the model.

```python
df.to_csv('data.csv', sep=',')
```

### Train the model

Once the data has been exported a machine learning model can be trained on it. This tutorial will use the Scikit-Learn Linear Regression model.

1. Create a new Jupyter Notebook in the `train` directory called `train.ipynb` and import and view the data that was just exported with the following code:

```python
import pandas as pd

df = pd.read_csv('data.csv')
df.head()
```

2. Next, use Scikit-Learn's Linear Regression model to train the model.

```python
from sklearn.linear_model import LinearRegression
import numpy as np

lm = LinearRegression()
X = np.asanyarray(df[['Independent Variable']])
Y = np.asanyarray(df[['Dependent Variable']])
lm.fit(X, Y)
```

3. Once the model has been trained, you look at some predictions by using the `lm.predict()` function.

```python
lm.predict([[-2], [0], [4]])
```

Which should result in the following output:

```raw
array([[-0.84154182],
       [ 3.20582465],
       [11.3005576 ]])
```

4. Lastly, we can use `pickle` to export our model object as a binary which can be used by the Web Service that will be created in the next step.

```python
import pickle

pickle.dump(lm, open("../deploy/linearmodel.pkl","wb"))
```

### Expose the model as a web service

Exposing the model as a web service can be done by creating a Python Flask application with an endpoint that can take a JSON body of features and return a prediction based on those features

1. Create a new file in the `deploy` directory and name it `app.py`.
2. Inside of the `app.py` file, add the following code to import the necessary packages and define your app. Pickle will be used to read the model binary that was exported earlier, and Flask will be used to create the web server.

```python
import pickle
import flask
import os

app = flask.Flask(__name__)
port = int(os.getenv("PORT", 9099))
```

3. Then import the model file that was created previously.

```python
model = pickle.load(open("linearmodel.pkl","rb"))
```

4. Next, add a route that will allow you to send a JSON body of features and will return a prediction.

```python
@app.route('/predict', methods=['POST'])
def predict():

    features = flask.request.get_json(force=True)['features']
    prediction = model.predict([features])[0,0]
    response = {'prediction': prediction}

    return flask.jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)
```

5. The route that was just defined will expect a JSON input of the following form:

```json
{
	"features": [feature1]
}
```

And will return a response with the following form:

```json
{
    "prediction": value
}
```

If your model requires multiple features to make a prediction, you can simply add more features to the `feature` array as follows:

```json
{
	"features": [feature1, feature2, feature3,...]
}
```

6. You can run your Python application from the terminal or your Python IDE. From the terminal, run the following command

```bash
python app.py
```

You will need to add Python to your path, this can be done by following the instructions for [Windows](https://superuser.com/questions/143119/how-do-i-add-python-to-the-windows-path) and [Linux or Mac](https://www.tutorialspoint.com/python/python_environment.htm).

7. You can make use of a POST to make a prediction, you make the request from Terminal on Mac or bash on Linux with:

```bash
curl -X POST \
  http://localhost:9099/predict \
  -H 'Content-Type: application/json' \
  -d '{"features": [0]}'
```

Or from Powershell with:

```powershell
Invoke-RestMethod -Method POST -Uri http://localhost:9099/predict -Body '{"features":[0]}'
```

### Deployment Configuration

There are two methods of configuring the application deployment that are covered here, namely using the Cloud Foundry Python Runtime or using the Cloud Foundry Docker Runtime

If you would like to deploy the application using the Cloud Foundry Python Runtime look at the next section [Configure the Cloud Foundry Python Deployment](#configure-the-cloud-foundry-python-deployment)

If you would like to deploy the application as a Docker Image, skip ahead to the [Configure the Cloud Foundry Docker Deployment Section](#configure-the-cloud-foundry-docker-deployment)

#### Configure the Cloud Foundry Python Deployment

In order to deploy to Cloud Foundry, a few additional files need to be created inside of your deploy folder

1. Cloud Foundry apps require a manifest file with some application configurations to be defined, these must be in the application root (the `deploy` directory) in this case. The `manifest.yml` file must be created and should contain the following:

```yaml
---
applications:
  - name: MLModelAPI
    random-route: true
    buildpack: python_buildpack
    command: python app.py
    memory: 256M
```

2. Next, the Cloud Foundry runtime version for the application must be defined in the `runtime.txt` file. In the `deploy` directory create the `runtime.txt` file and add the following to it:

```txt
python-3.6.4
```

3. Lastly, the application dependencies must be defined in the `requirements.txt`. Create this file in the `deploy` directory and add the following:

```txt
flask
numpy
scipy
scikit-learn
```

Upon completing the above, your `deploy` directory should be as follows:

```raw
- deploy
    - app.py
    - linearmodel.pkl
    - manifest.yml
    - requirements.txt
    - runtime.txt
```

#### Configure the Cloud Foundry Docker Deployment

If it is preferred to make use of a Docker image that can be run via the Cloud Foundry Runtime or any other Docker runtime for deployment, the following steps can be followed instead

If you have already completed the instructions in the [Configure the Cloud Foundry Python Deployment Section](#configure-the-cloud-foundry-python-deployment) you can skip this and jump ahead to [Deploy the Application from the CLI](#deploy-the-application-from-the-cli)

In order to deploy the Docker image on Cloud Foundry we need to first create a few additional files in the `deploy` directory

1. Cloud Foundry apps require a manifest file with some application configurations to be defined, these must be in the application root (the `deploy` directory) in this case. The `manifest.yml` file must be created and should contain the following:

```yaml
---
applications:
  - name: MLModelAPI
    random-route: true
    buildpack: python_buildpack
    command: python app.py
    memory: 256M
    docker:
      image: <YOUR DOCKERHUB USERNAME>/python-ml-service
```

2. The application dependencies must be defined in the `requirements.txt`. Create this file in the `deploy` directory and add the following:

```txt
flask
numpy
scipy
scikit-learn
```

3. Next, the Dockerfile application must be defined. In the `deploy` directory create a `Dockerfile` file and add the following to it:

```dockerfile
FROM python:3.6.4-slim
COPY requirements.txt /requirements.txt
RUN pip install -r requirements.txt
EXPOSE 9099
COPY . /.
CMD ["python","app.py"]
```

4. From the `deploy` directory, build the docker image with the following command

```bash
docker image build -t <YOUR DOCKERHUB USERNAME>/python-ml-service .
```

Take note of the `.` at the end of the command which specifies that you are building the image based on the `Dockerfile` in this directory

5. Before you can deploy the application it needs to be pushed to a container registry, in this case Docker Hub will be used. Log into Docker Hub with the following command, and enter your username and password

```bash
docker login
```

6. Lastly, push the image to Docker Hub with the following command

```bash
docker push <YOUR DOCKERHUB USERNAME>/python-ml-service
```

Upon completing the above, your `deploy` directory should be as follows:

```raw
- deploy
    - app.py
    - Dockerfile
    - linearmodel.pkl
    - manifest.yml
    - requirements.txt
```

### Deploy the Application from the CLI

Lastly, you will deploy the application to Cloud Foundry on IBM Cloud, this will be done with the [IBM Cloud CLI](https://console.bluemix.net/docs/cli/index.html).

Regardless of whether you're using the Cloud Foundry Python Runtime or the Cloud Foundry Docker Runtime, the following steps should be the same

1. Navigate to your `deploy` directory from your command line.

2. Download the IBM Cloud CLI if you do not already have it as directed [here](https://console.bluemix.net/docs/cli/index.html) or as shown below.

For Linux/Mac, you can download it with the following command:

```bash
curl -sL https://ibm.biz/idt-installer | bash
```

And for Windows from Powershell as an Administrator with:

```powershell
Set-ExecutionPolicy Unrestricted; iex(New-Object Net.WebClient).DownloadString('http://ibm.biz/idt-win-installer')
```

3. Next, verify your installation by running the following command:

```bash
ibmcloud --help
```

4. Once you have verified that the CLI is correctly installed, log into IBM Cloud, and then target Cloud Foundry from the CLI with the following:

```bash
ibmcloud login
ibmcloud target --cf
```

Note that if you are using a Federated ID and see the following when running `ibmcloud login`:

```raw
You are using a federated user ID, please use one time passcode ( C:\Program Files\IBM\Cloud\bin\ibmcloud.exe login --sso ), or use API key ( C:\Program Files\IBM\Cloud\bin\ibmcloud.exe --apikey key or @key_file ) to authenticate.
```

First try to login using `ibmcloud login --sso`, and if that does not work then use the API Key method

5. Next, you can simply push your application to Cloud Foundry from the CLI.

```bash
ibmcloud cf push
```

When the deployment has completed, you will see something like the following output

```raw
name:              MLModelAPI
requested state:   started
instances:         1/1
usage:             256M x 1 instances
routes:            https://<HOSTNAME>.<REGION>.mybluemix.net
last uploaded:     Mon 14 Jan 14:26:10 SAST 2019
stack:             cflinuxfs2
buildpack:         python_buildpack
start command:     python app.py
```

6. Lastly, you can try to use the endpoint that was defined to make predictions with a POST as before using Terminal on Mac or bash on Linux with the following command:

```bash
curl -X POST \
  https://<HOSTNAME>.<REGION>.mybluemix.net/predict \
  -H 'Content-Type: application/json' \
  -d '{"features": [0]}'
```

Or from Powershell with:

```powershell
Invoke-RestMethod -Method POST -Uri http://<HOSTNAME>.<REGION>.mybluemix.net/predict -Body '{"features":[0]}'
```

## Troubleshooting

### Python not found/recognized

If you encounter the following error from bash:

```raw
bash: python: command not found
```

Or on Powershell

```raw
python : The term 'python' is not recognized as the name of a cmdlet, function, script file, or operable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
At line:1 char:1
+ python
+ ~~~~~~
    + CategoryInfo          : ObjectNotFound: (python:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
```

Ensure that Python is in your `PATH`, the process for doing this is dependant on your Python installation and OS and is not covered here

### ModuleNotFound

If you encounter a `ModuleNotFound` when importing a Python package

```raw
---------------------------------------------------------------------------
ModuleNotFoundError                       Traceback (most recent call last)
<ipython-input-1-5b23471a9b60> in <module>
----> 1 import ...

ModuleNotFoundError: No module named '...'
```

You need to install the package, this can be done using Pip via the terminal with:

```bash
pip install <PACKAGE NAME>
```

Or within a Jupyter Notebook by running the following from a cell

```bash
!pip install <PACKAGE NAME>
```

### Unicode Decode Error

If when importing the model binary into the app, you encounter the following error

```raw
UnicodeDecodeError: 'charmap' codec can't decode byte 0x81 in position 49: character maps to <undefined>
```

Ensure that you are reading the file in binary mode with `rb` and not just `r` in the `app.py` file as follows

```python
model = pickle.load(open("linearmodel.pkl","rb"))
```

### Underlying connection closed - Powershell

If you encounter the following error when testing your endpoints from Powershell

```raw
Invoke-RestMethod : The underlying connection was closed: An unexpected error occurred on a send.
At line:1 char:1
+ Invoke-RestMethod -Method POST -Uri "https://mlmodelapi-forgiving-war ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke-RestMethod], WebExc
   eption
    + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeRestMethodCommand
```

Ensure that you are using the `http://<HOSTNAME>.<REGION>.mybluemix.net` endpoint above, and not the HTTPS.

## Summary

You have successfully completed the process of training and deploying your Python machine learning model as a Web Service as well as interacting with it by means of an HTTP POST to the service in order to make prediction.

You can also read more about using [Flask as a Python Web Framework](http://flask.pocoo.org/) and about [Developing Machine Learning models with Python](https://cognitiveclass.ai/courses/machine-learning-with-python/).

## Resources

Some additional resources that can be helpful for additional information:

- [Tutorial GitHub Repo](https://github.com/nabeelvalley/ExposePythonMLModel)
- [Python Flask](http://flask.pocoo.org/)
- [Ivan Yung's Article on Deploying Python Machine Learning Models](https://medium.freecodecamp.org/a-beginners-guide-to-training-and-deploying-machine-learning-models-using-python-48a313502e5a)
- [Ian Huston's Python Cloud Foundry Examples](https://github.com/ihuston/python-cf-examples)
- [Cloud Foundry Manifests](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html)
- [Cloud Foundry Python Buildpacks](https://docs.cloudfoundry.org/buildpacks/python/index.html)

## Related Content

- [Deep learning models using Watson Studio Neural Network Modeler and Experiments](https://developer.ibm.com/tutorials/create-and-experiment-with-dl-models-using-nn-modeler/)
- [Build a handwritten digit recognizer in Watson Studio and PyTorch](https://developer.ibm.com/patterns/handwritten-digit-recognizer-in-watson-studio-and-pytorch/)
- [Predict heart medicine using machine learning](https://developer.ibm.com/patterns/predict-heart-medicine-using-machine-learning/)
