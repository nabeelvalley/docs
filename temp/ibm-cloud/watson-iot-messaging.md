# Watson IoT Messaging - Node

Basic connections for connecting to Watson IoT Platform with Node.js making use of the `ibmiotf` package

## Installing Dependencies

Install dependencies with NPM

```bash
npm install
```

We use the following dependencies and scripts in our `package.json` file

```json 
{
  "name": "watsoniotmessaging",
  "version": "1.0.0",
  "description": "Simple Messaging to Watson IoT Platform for Node with MQTT",
  "main": "app.js",
  "scripts": {
    "client" : "node client.js",
    "app" : "node app.js"
  },
  "author": "Nabeel Valley",
  "license": "Apache-2.0",
  "dependencies": {
    "dotenv": "^6.1.0",
    "ibmiotf": "^0.2.41"
  }
}
```

## Credentials

You will need credentials for your Device as well as an API Key for your Application Connection, this can be done by creating a new device as well and creating a new App API Key on Watson IoT Platform 

Next create a file called `.env` with the following contents

```env
ORG_ID=orginization_id
API_KEY=app_api_key
AUTH_TOKEN=app_auth_token
DEVICE_TYPE=device_type
DEVICE_ID=device_id
DEVICE_TOKEN=device_token
```

## Running the Apps

In a terminal window run `app.js` to monitor events and in a separate window run `client.js` to send some sample events for you to view, note that `app.js` will log any events passing through your WatsonIoT service

### Application 

An application that will log events on a Watson IoT Platform instance

This can be run with 

```bash
npm run app
```

For our logging application we create a new `appClient` and connect to our MQTT Broker on Watson IoT Platform by reading our config from the environment and using the `ibmiotf` package 

```javascript
require('dotenv').config()

var Client = require('ibmiotf')
var appClientConfig = {
    org: process.env.ORG_ID,
    id: process.env.DEVICE_ID,
    domain: 'internetofthings.ibmcloud.com',
    'auth-key': process.env.API_KEY,
    'auth-token': process.env.AUTH_TOKEN
}

var appClient = new Client.IotfApplication(appClientConfig)
```

We then subscribe to device events as follows

```javascript 
appClient.connect()
// setting the log level to 'trace'
// appClient.log.setLevel('trace')
appClient.on('connect', () => {
    // Subscribe to Events from All Devices
    appClient.subscribeToDeviceEvents()

    // Subscribe to Events from Specific Devices
    // appClient.subscribeToDeviceEvents(process.env.DEVICE_TYPE)
})

```

Once we have subscribed to our device events we can listen for a specific event or log all events as follows

```javascript 
// Log all events
appClient.on(
    'deviceEvent',
    (deviceType, deviceId, eventType, format, payload) => {
        console.log(
            'Device Event from :: ' +
                deviceType +
                ' : ' +
                deviceId +
                ' of event ' +
                eventType +
                ' with payload : ' +
                payload
        )
    }
)

```

### Device

This will simply post a message to Watson IoT Platform ten times on a fixed interval then disconnect

The IoT Client app can be run with 

```bash
npm run client
```

We can then simulate a device by just sending sample data to our Watson IoT Platform instance. We first need to initialize our configuration and create a new `deviceClient`

```javascript 
require('dotenv').config()

var Client = require('ibmiotf')
var iotConfig = {
    domain: 'internetofthings.ibmcloud.com',
    org: process.env.ORG_ID,
    id: process.env.DEVICE_ID,
    type: process.env.DEVICE_TYPE,
    'auth-method': 'token',
    'auth-token': process.env.DEVICE_TOKEN
}

var deviceClient = new Client.IotfDevice(iotConfig)
```

Then we connect our device to the Watson IoT Platform simply with

```javascript
deviceClient.connect()
deviceClient.log.setLevel('trace')
deviceClient.on('connect', startClient)
``` 

Once that has been done, we listen for the `connect` event, which indicates that our connection is on, we also pass in a function called startClient which is defined as below, which will just publish 10 messages to the Watson IoT Platform with the `deviceClient.publish` function and then disconnect

```javascript 
startClient = () => {
    var publishCount = 0
    var interval = setInterval(() => {
        publishCount++
        console.log(publishCount)
        deviceClient.publish(
            'status',
            'json',
            JSON.stringify({ text: 'Hello World!', count: publishCount })
        )
        if (publishCount == 10) {
            clearInterval(interval)
            deviceClient.disconnect()
        }
    }, 1000)
}
```