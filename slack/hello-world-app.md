# Hello World App

## Incoming Webhooks

[Based on this tutorial](https://api.slack.com/tutorials/slack-apps-hello-world)

You can create a new [Slack App here](https://api.slack.com/apps/new)

1. Select a Name and Workspace for your application to be in, then select the **Incomming Webhooks** Option and Activate Incoming Webhooks
2. Add a **New Webhook to Workspace** and select the channel that it can post to
3. You can then test your Webhook with a **curl** request which will post to a channel based on a JSON input

```bash
curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' <YOUR WEBHOOK URL>
```

Once we are done with that we will see a message in our Slack Channel

![Slack Message](../.gitbook/assets/image%20%2821%29.png)

Once we are done with that, we can go back to our **Basic Information** tab of our app's configuration and follow the instructions to distribute our app \(if for some incomprehensible reason you want to do that now\), but I'll do that later

## Slash Commands

[Based on this tutorial](https://api.slack.com/slash-commands)

### Introduction

Slack Slash Commands allow users to trigger an interaction with our app from the message box, but these are not messages. They will cause a payload to be sent from Slack to an App, allowing the app to respond in any way it likes

These commands are starting points for complex workflows, and integrations

Slack has some [prebuilt commands](https://slack.zendesk.com/hc/en-us/articles/201259356-using-slash-commands?sid=zd-of-tdqu4b49e-udrs8rm29)

### Command Structure

Slash commands consist of two parts, this example for a To-do app is as follows

```text
/todo ask @crushermd to bake a birthday cake for @worf in #d-social
```

1. The `/todo` part is the command that tells slack to treat this as a **slash command**
2. Everything after that is the `text` option which is treated as a single parameter that will be sent to the app that is going to work with this command

### Creating Our Command

Commands have a few parameters that can be defined when we create a command on our Slack App

1. **Command** which is the name of the command
2. **Request URL** which is the URL to which Slack will send the payload
3. **Description** of what the command does
4. **Usage Hint** is an example of what the user can try to do when invoking the command, keep this brief
5. **Escape channels, users, and links** will modify the parameters sent with a command by a user by wrapping usernames, channels, and links with angle brackets if enabled

So this

```text
/todo ask @crushermd to bake a birthday cake for @worf in #d-social
```

Will become this

```text
ask <@U012ABCDEF> to bake a birthday cake for <@U345GHIJKL> in <#C012ABCDE>
```

{% hint style="warning" %}
It is important to note that Slack Commands are not namespaced, and Slack will take preference of the last installed app's command
{% endhint %}

### Receiving Commands

When a Slack command is invoked it will send an HTTP POST to the Request URL which will contain the payload in `application.x-www-form-urlencoded` form with the following fields

1. `command` which is the command that was typed, this is useful if we want to use a single service to handle multiple slash commands
2. `text` is the text part of the command
3. `response_url` which we can use to respond to the command
4. And a bunch of different ID types such as `trigger_id` , `user_id` , `team_id`, etc. 

### Responding to Commands

When responding to a command we have three parts

1. Confirm receipt of the payload
2. Do something useful right away
3. Do something useful later

#### Confirming Receipt

This confirmation is done by simply responding with an `HTTP 200`, which can even be empty, just to acknowledge the initial request. This must be done within 3000ms of the initial response

#### Sending an Immediate Response

However this response can also contain some information in the payload response as type `application/json` as follows

```javascript
{
    "text": "Hello World!",
    "attachments" : [
        {
            "text": "From Nabeel's App"
        }
    ]
}
```

Information on composing response messages can be found [here](https://api.slack.com/docs/messages#composing_messages)

It can be valuable to send the initial user's command as a message in the channel as well buy setting the payload's  `response_type` to `in_channel` as follows

```javascript
{
    "response_type": "in_channel",
    "text": "Hello World!",
    "attachments" : [
        {
            "text": "From Nabeel's App"
        }
    ]
}
```

#### Sending a Delayed Response

When sending a delayed response we need to construct an `HTTP POST` to the `response_url` in our initial Slack Request's body with type `application/json` . This is the same as the Immediate Response type, additionally if we encounter errors we should also deliver these to the user as a normal message

#### Best Practices

It is also helpful to respond to the help command which will respond to our user with additional information

```text
/todo help
```

### Implementation

I'm linking my app to a Cloud Function which will handle the requests

#### IBM Cloud Function

Create a new Cloud Function on IBM Cloud, in my case I'm going to make it with `Node.js 8` and the code will be as follows

{% code-tabs %}
{% code-tabs-item title="Cloud Function" %}
```javascript
function main(params) {
    let req = JSON.stringify(params, null, 2);
    req = "```" + req + "```";
    
	return {
        response_type: "in_channel",
        text: "Hello World!",
        attachments : [
            {
                text: "From Nabeel's App on IBM Cloud Functions, your initial request was"
            },
            {
                text: req
            }
        ]       
    };
}

```
{% endcode-tabs-item %}
{% endcode-tabs %}

The function will simply respond with a `Hello World!` output, along with the original input body as pretty-printed JSON

Next be sure to enable your function as a Web Action with Raw HTTP Handling, we then need to note our function endpoint, which in this case is the one that ends with `.json`, for my case it is

```text
https://openwhisk.eu-gb.bluemix.net/api/v1/web/nabeel.valley%40ibm.com_dev/Slack/Slack%20API%20Hello%20World.json
```

#### Slack

First, on Slack create a new Slash Command for your application and set the relevant fields as follows

![](../.gitbook/assets/image%20%2824%29.png)

#### Testing it out

Finally, we can try out our Slack App by going to the channel we set it on and calling the command \(at this point with any  given input\)

```text
/nabeel random text here
```

And we will see the response as a message

![](../.gitbook/assets/image%20%2812%29.png)

