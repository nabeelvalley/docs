[[toc]]

# Calling External API's from Watson Assistant

This document will cover the various methods of calling an external API from a Watson Assistant Dialog Node based on the documentation [here](https://console.bluemix.net/docs/services/conversation/configure-workspace.html#configuring-a-watson-assistant-workspace)


## Using Cloud Function as a Proxy

We can use Cloud Functions as a proxy with which we call our external API

> It is important that our Cloud Function and Watson Assistant instances are located in the same region. Furthermore this needs to be either US South (Dallas) or Germany (Frankfurt)

### Cloud Function

We can create a new Cloud Function Action which will call our external API, we can use a few languages to do this, however we need to keep in mind that due to API calls being asynchronous in some languages, so we will need to make use of async/await or promises to allow our cloud function to return correctly

```javascript
function main(params) {
    var request = require('request')

    var options = {
        method: 'GET',
        url: '<MY API INPUT>',
        qs: { xQueryParam: 'value' },
        headers: {}
    }

    console.log('hello')

    return new Promise((resolve, reject) => {
        request(options, function(error, response, body) {
            if (error) throw new Error(error)
            resolve({ message: JSON.parse(body).messages[0].text })
        })
    })
}
```

```python
import sys
import requests
import json

def main(dict):

    url = "<MY API INPUT>"

    querystring = {"xQueryParam":"value"}

    response = requests.request("GET", url, params=querystring)

    parsedRes = json.loads(response.text)

    return { 'message': parsedRes }
```

## Assistant

From our Watson Assistant node we set our response for the node as a JSON response with

### Calling a Web Action

Once we have defined our function we need to set the endpoint as a Web Action, and note the the URL

![](/docs/assets/image%20%282%29.png)

We can call a function set as a Web Action with the following

```json
{
  "output": {
    "generic": [
      {
        "values": [],
        "response_type": "text",
        "selection_policy": "sequential"
      }
    ]
  },
  "actions": [
    {
      "name": "/your.organization@org.com_space/Package Name/Web Action Name.json",
      "type": "web_action",
      "result_variable": "context.cloudrequest"
    }
  ]
}
```

Note that if we are using the **Default Package** we set the `name` property to `default` as follows, it is important to note this as we will get an error otherwise

```json
{
  "output": {
    "generic": [
      {
        "values": [],
        "response_type": "text",
        "selection_policy": "sequential"
      }
    ]
  },
  "actions": [
    {
      "name": "/your.organization@org.com_space/default/Web Action Name.json",
      "type": "web_action",
      "result_variable": "context.cloudrequest"
    }
  ]
}
```

After this we can jump to a child node which will have a response set based on the context variable we set with

```powershell
Your message was: $cloudrequest.message
```

After this we should get the required response from our cloud function

### Using a Cloud Function

#### Credentials

When using a cloud function, the process is very similar, however we need to be sure to store our Cloud Function Credentials in a context variable, this can be done by creating a private context variable which holds either one of the following objects, we can set the variable **\$private.credentials ** with

The API Key

```json
{
    "api_key": "<USERNAME>:<PASSWORD>"
}
```

Or with the Username and Password properties

```json
{
    "user": "<USERNAME>",
    "password": "<PASSWORD>"
}
```

Alternatively we can simply create a context variable **\$private.credentials.api_key** directly from the context variables tab and set its value to our API Key (or as previously shown, our username and password separated by a colon `:`)

```powershell
$private.credentials.api_key = <USERNAME>:<PASSWORD>
```

#### Setting the Function

Next we can define our dialogue node with the JSON as follows

```json
{
  "output": {
    "generic": [
      {
        "values": [],
        "response_type": "text",
        "selection_policy": "sequential"
      }
    ]
  },
  "actions": [
    {
      "name": "/your.organization@org.com_space/Package Name/Cloud Function Name",
      "type": "cloud_function",
      "result_variable": "context.cloudrequest",
      "credentials":"$private.credentials
    }
  ]
}
```

Note that if we are using the **Default Package** we neglect the *Package Name* in the `name` property as follows

```json
{
  "output": {
    "generic": [
      {
        "values": [],
        "response_type": "text",
        "selection_policy": "sequential"
      }
    ]
  },
  "actions": [
    {
      "name": "/your.organization@org.com_space/Cloud Function Name",
      "type": "cloud_function",
      "result_variable": "context.cloudrequest",
      "credentials":"$private.credentials
    }
  ]
}
```

After this we can jump to a child node which will have a response set based on the context variable we set with

```powershell
Your message was: $cloudrequest.message
```
