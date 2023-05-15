---
published: true
title: TJBot Setup
subtitle: Setting up a Raspberry PI as a TJ Bot
---

[[toc]]

# Setting up a Bot

## Build the Bot

Build the bot as per the instructions on [IBM Research Site](https://ibmtjbot.github.io/)

## Setting Up the Pi

The Raspberry Pi will need to have the OS installed first, this is done by copying the NOOBS OS onto the SD Card. Thereafter connect a mouse, keyboard and screen and run the following command via the terminal:

```text
curl -sL http://ibm.biz/tjbot-bootstrap | sudo sh -
```

* If you run into this error when turning on the bot for the first time _Waiting for SD Card \(Settings Partition\)_, format the SD Card and copy the OS back onto it. We used a 32kb chunk size which seemed to work.

## Getting the Sample Code

Clone the tjbot repo to your Bot's Desktop:

```text
git clone https://github.com/ibmtjbot/tjbot.git
```

Additionally you will have to run `npm install` inside of every the directory for every recipe you would like use

## Running Tests

[From The Documentation](https://github.com/ibmtjbot/tjbot/blob/master/bootstrap/README.md)

```text
npm install ~/Desktop/tjbot/bootstrap/test
cd ~/Desktop/tjbot/bootstrap
./runTests.sh
```

To run a specific test you can run any of the following:

```text
cd ~/Desktop/tjbot/bootstrap/tests
sudo node test.camera.js
sudo node test.led.js
sudo node test.servo.js
sudo node test.speaker.js
```

## Recipes

There are three recipes included with the Sample code which make use of Watson Services, these are as follows:

* [Voice Control](https://www.instructables.com/id/Use-Your-Voice-to-Control-a-Light-With-Watson/)
* [Watson Conversation](https://www.instructables.com/id/Build-a-Talking-Robot-With-Watson-and-Raspberry-Pi/)
* [Sentiment Analysis](https://www.instructables.com/id/Make-Your-Robot-Respond-to-Emotions-Using-Watson/)

In order to run any of the Recipes you need to do the following inside of the respective recipe's folder 1. Make a copy of the `config.default.js` file in the same folder and name it `config.js` 2. Add your IBM Cloud API login credentials for the relevant Watson API's in this file. These are NOT your IBM Cloud account credentials, but will consist of:

* a username like `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx` 
* a password like `xxxxxxxxxxxx` 1. You are now set to run the program with the following command \(from the recipe's respective directory\)

  ```text
     sudo node recipe-name.js
  ```

  Note that for the Coversation API you will need to

## Changing the Voice

The voice can be changed via the `tjbot.js` file in `node_modules/tjbot/lib`, or in your `conversation.js` file by modifying the `TJBot.prototype.defaultConfiguration` which has the following properties:

* `robot.name`
* `root.gender`
* `listen.language`
* `speak.language`

