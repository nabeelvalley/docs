---
published: true
title: Real-time Communication with MQTT
subtitle: 12 November 2019
description: MQTT and real-time communication with the browser, JavaScript, Web Sockets and a Mosquitto message broker
---

[[toc]]

# Overview

MQTT is an open standard for communication and is especially useful for communication between IoT devices due to its low bandwidth requirements

Today we're going to be taking a look at using MQTT to easily communicate between multiple applications. We'll look at using a static website and Eclipse Mosquitto as a message broker to enable communication between two instances of the application, but the same principles can be extended to other programming languages and MQTT clients. For our clients we'll be using `MQTT.js` which runs in the browser via CDN and we interact with it using JavaScript, but can also be added from `npm`

If you'd like to follow along with the completed code you can get it <a href="https://github.com/nabeelvalley/RTCWithMQTT" target="_blank">here</a>

# Broker

> Eclipse Mosquitto is an open-source (EPL/EDL licensed) message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1. Mosquitto is lightweight and is suitable for use on all devices from low power single board computers to full servers. (<a href="https://mosquitto.org/" target="_blank">Eclipse Mosquitto</a> )

Message brokers are a method of intra-application communication, MQTT makes use of a publish/subscribe model for application communication. In this model different applications, or clients, can publish messages to a topic which can then be picked up and operated on by any other applications that are subscribed to the topic

## Setting Up the Broker

You will first need to download Mosquitto from <a href="https://mosquitto.org/download/" target="_blank">here</a> , all `1.5mb` of it, and run through the installer and then ensure that `mosquitto` is in your path. If you need to know how to add something to your path take a look at <a href="https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7" target="_blank">this Gist</a> . For a Windows 64 bit installation of Mosquitto you should add the following to your path `C:\Program Files\mosquitto`

The MQTT installation should include the following three commands

1. `mosquitto` - This runs the MQTT server/broker
2. `mosquitto_pub` - A simple message publisher
3. `mosquitto_sub` - A simple message subscriber

We can get more information by running either of the above commands with the `--help` flag, e.g. `mosquitto --help`

## Basic Messaging

1. Let's start the message broker in verbose mode by opening a new shell and running the `mosquitto -v` command, you should see some output like the following:

```raw
1573494107: mosquitto version 1.6.7 starting
1573494107: Using default config.
1573494107: Opening ipv6 listen socket on port 1883.
1573494107: Opening ipv4 listen socket on port 1883.
```

We can see from the above that the message broker is running on our local port `1883`

2. In a new shell, we can create a client which is subscribed to a topic. We'll name this topic `messages` but it can be pretty much anything you want, to start the subscriber client we can run `mosquitto_sub -t "messages" -v`, you won't see any output in the subscriber shell as yet, but looking at the broker shell you should logging which says that a client was connected

```raw
1573494642: New connection from ::1 on port 1883.
1573494642: New client connected from ::1 as mosq-fwbsJxdXOnQW0LOaIn (p2, c1, k60).
1573494642: No will message specified.
1573494642: Sending CONNACK to mosq-fwbsJxdXOnQW0LOaIn (0, 0)
1573494642: Received SUBSCRIBE from mosq-fwbsJxdXOnQW0LOaIn
1573494642:     messages (QoS 0)
1573494642: mosq-fwbsJxdXOnQW0LOaIn 0 messages
1573494642: Sending SUBACK to mosq-fwbsJxdXOnQW0LOaIn
1573494702: Received PINGREQ from mosq-fwbsJxdXOnQW0LOaIn
1573494702: Sending PINGRESP to mosq-fwbsJxdXOnQW0LOaIn
```

3. To publish a message open another shell and run `mosquitto_pub -t "messages" -m "This is my message!"`, in our subscriber shell we should see the following output:

```raw
messages This is my message!
```

And in the broker we'll see the following:

```raw
1573494844: New connection from ::1 on port 1883.
1573494844: New client connected from ::1 as mosq-MWbaa2TpZGV0FrTmcF (p2, c1, k60).
1573494844: No will message specified.
1573494844: Sending CONNACK to mosq-MWbaa2TpZGV0FrTmcF (0, 0)
1573494844: Received PUBLISH from mosq-MWbaa2TpZGV0FrTmcF (d0, q0, r0, m0, 'messages', ... (19 bytes))
1573494844: Sending PUBLISH to mosq-fwbsJxdXOnQW0LOaIn (d0, q0, r0, m0, 'messages', ... (19 bytes))
1573494844: Received DISCONNECT from mosq-MWbaa2TpZGV0FrTmcF
1573494844: Client mosq-MWbaa2TpZGV0FrTmcF disconnected.
```

When you're done with this you can close the open shell windows

## Broker with WebSockets

For our usecase, we will make use of WebSockets so we can communicate directly from the browser. When starting up the message broker we have the option to pass in a configuration file. Let's create one that states the port and the protocol we would like to use. Create a new directory called `mqtt`, and in it create a new file called `mosquitto.conf` and place the following contents which simply tell it to listen on port `9001` and use the `websockets` protocol

`mosquitto.conf`

```
listener 9001
protocol websockets
```

If you'd like to know what else can be done in the configuration file you can <a href="https://mosquitto.org/man/mosquitto-conf-5.html" target="_blank">read the documentation</a>

We can start the broker again from the `mqtt` directory using `mosquitto -c mosquitto.conf -v`, this time we should see that it is running on `9001` with `websockets`

```
1573499281: mosquitto version 1.6.7 starting
1573499281: Config loaded from mosquitto.conf.
1573499281: Opening websockets listen socket on port 9001.
```

Now that we have configured the broker to use Web Sockets we can start connecting to it from a web page and publish some messages

# Client

We'll be using <a href="https://github.com/mqttjs/MQTT.js" target="_blank">MQTT.js</a> to connect to our message broker. MQTT.js is a simple MQTT Client Library for connecting to message brokers, we'll be using it via CDN for the sake of simplicity and will also be using <a href="https://materializecss.com/" target="_blank">Materialize</a> for our CSS because I'm not going to write a bunch of CSS and I don't want this to look completely terrible

## HTML

Let's first setup the `index.html`. It consists of a two-column layout with the following:

- Main Heading with a badge to indicate if we successfully connected to the broker
- Inputs to Publish Message
- Table of all received messages
- Materialize and MQTT.js files via CDN
- Script tag for all our JavaScript, because we don't need two files for this

`index.html`

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Real-time Communication with MQTT</title>

    <!-- MQTT.js -->
    <script src="https://unpkg.com/mqtt@3.0.0/dist/mqtt.min.js"></script>

    <!-- Materialize -->
    <!-- Compiled and minified CSS -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"
    />
  </head>

  <body>
    <div class="container">
      <!-- Page Content goes here -->
      <div class="row">
        <div class="col s12">
          <h1>
            Messages
            <span
              id="connect-badge"
              class="new badge orange"
              data-badge-caption=""
              >connecting</span
            >
          </h1>
        </div>
      </div>
      <div class="row">
        <div class="col s12 m6">
          <h2>Input</h2>
          <div class="input-field">
            <input id="name" type="text" class="validate" />
            <label class="active" for="name">First Name</label>
          </div>

          <div class="input-field">
            <textarea
              id="message"
              class="materialize-textarea"
              data-length="120"
            ></textarea>
            <label for="message">Message</label>
          </div>

          <button class="waves-effect waves-light btn" onclick="handleSubmit()">
            Publish Message
          </button>
        </div>
        <div class="col s12 m6">
          <h2>Output</h2>
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Message</th>
              </tr>
            </thead>
            <tbody id="messages"></tbody>
          </table>
        </div>
      </div>
    </div>

    <script>
      // Our Javascript will go here
    </script>
  </body>

  <!-- Materialize -->
  <!-- Compiled and minified JavaScript -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</html>
```

## Running the Website

Since we are including resources from other domains your browser may have some issues with you using the 'double click' method of running the files, so we're going to need to use a web server

A list of quick one-line web servers can be found on this <a href="https://gist.github.com/willurd/5720255" target="_blank">Gist</a> and if you're using Visual Studio Code you can use the Live Server Extension

## Connecting to the Message Broker

Now that we're up and running we can connect to the broker that we set up previously. The Mosquitto Broker should be running on `127.0.0.1:9001`, using the `mqtt` object that is exposed in the global space by `MQTT.js` we can simply create an instance of the client in our `<script>` section with:

```js
const client = mqtt.connect("mqtt://127.0.0.1:9001")
```

This gives us a `client` object that is the MQTT Client connected to our broker. Next, we need to set a handler for the `connect` event which is when the client successfully connects to the message broker, we do this with the following code:

```js
client.on("connect", function() {
  client.subscribe("messages", function(err) {
    if (!err) {
      const badge = document.getElementById("connect-badge")
      badge.innerText = "connected"
      badge.classList.remove("orange")
      badge.classList.add("green")
    }
  })
})
```

You can see that the `client.on` function takes a callback, in which we tell our client to subscribe to the `messages` topic as we did previously via the `mosquitto_sub`, and then once it has successfully subscribed we change the badge status to indicate that we are connected

Since we have successfully subscribed the client to the broker we should be able to publish messages. We'll do that using the data from the input fields in on the page and the `Publish Message` button's handler

## Publishing Messages

Create a handler for the `Publish Message` button called `handleSubmit`, we've already referenced this in our button's HTML. The handler simply needs to read the values from the input fields and call `client.publish` with a stringified form of the data

```js
function handleSubmit() {
  const nameInput = document.getElementById("name")
  const messageInput = document.getElementById("message")

  const data = {
    name: nameInput.value,
    message: messageInput.value
  }

  const payload = JSON.stringify(data)

  client.publish("messages", payload)
}
```

The `client.publish` function above takes in a `topic` and `message` as its inputs, in our case we want to publish to the `messages` topic and we are publishing the JSON object as a string

Refreshing the page, entering some text into the fields and clicking the `Publish Message` button should publish the message to the broker, we should see this in the message broker's output

```raw
1573506416: Received PUBLISH from mqttjs_d5cdbc8e (d0, q0, r0, m0, 'messages', ... (34 bytes))
1573506416: Sending PUBLISH to mqttjs_d5cdbc8e (d0, q0, r0, m0, 'messages', ... (34 bytes))
```

Now that we can publish messages to the topic, we will need to create a handler for the `message` event which is triggered every time one of our subscribed topics has something published to it. We can do this again with the `client.on` function:

```js
client.on("message", function(topic, message) {
  const data = JSON.parse(message)

  document.getElementById("messages").innerHTML += `<tr><td>${
    data.name
  }</td><td>${data.message.replace(/\n/g, "<br>")}</td></tr>`
})
```

Our message handler receives the `topic`, which in our case will always be `messages` and the `message` which is a buffer of the data published to the topic, this will be the same data that we published using the `client.publish` function, this time we read the JSON back into an object and add it to the messages table as HTML

You should be able to open a few different windows of the web page and they should all be able to Publish Messages to one another

# What Next?

If you're not familiar with message brokers this could be a lot to take in and that's okay. I think playing around with the `mosquitto_pub` and `mosquitto_sub` tools can be helpful to get a more interactive feel for the way everything works. You can also just play with the MQTT.js code we used via your browser console and looking at the documentation on the website

If you want to take a look at a free instance of an MQTT Broker that you can play around with take a look at <a href="https://www.cloudmqtt.com/" target="_blank">Cloud MQTT</a> , and if you want to look at how you can take the concepts covered here today and play around with some IoT concepts as well then it may also be worth taking a look at this <a href="https://developer.ibm.com/tutorials/iot-mobile-phone-iot-device-bluemix-apps-trs/" target="_blank">IBM Developer Tutorial</a> using IBM Cloud and Watson IoT

If you're interested in spinning up your own MQTT broker with custom functionality you can take a look at <a href="http://www.mosca.io/">Mosca</a> or get an even deeper understanding of the MQTT Protocol <a href="https://developer.ibm.com/articles/iot-mqtt-why-good-for-iot/" target="_blank">on IBM Developer</a>

# Conclusion

We've used a couple of different technologies and depending on your background you may not be familiar with everything here. The best thing I'd say to get to understand what we've covered would be to play around with the code as well as look at some of the other services and use-cases for message brokers and get a feel for what's out there

Good luck

> Nabeel Valley