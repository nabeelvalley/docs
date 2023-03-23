---
title: Postman Flows
subtitle: 03 March 2023
description: First impressions playing with the new Postman Flows
---

Postman is a tool used for making HTTP requests during development that enables easy testing and experimentation with HTTP/REST APIs

Recently Postman released something called Flows which is a visual editor for building API flows between different applications and stitching them together into some kind of output view

Flows can be done to DO things but can also be used to SHOW information based on the data that passes through them

Below is an example of a Postman Flow that reads the posts from my website and lists/counts them when run from postman

![Postman flow example](/content/blog/2023/23-03/postman-flow-example.png)

Another example of a Postman Flow is of their [Stock dashboard  example](https://www.postman.com/postman/workspace/utility-flows/flow/64123b57c224290033fcb089)

# References

For more information on how to build an use a flow you can take a look at the [Postman Flows Overview](https://learning.postman.com/docs/postman-flows/gs/flows-overview/)

Postman flows seems targeted at more technical users. In addition to this I think [IFTTT](http://ifttt.com/) is worth taking a look at if you're interested in doing some small flow-style automations

For a bit of a more self-hosted alernative, you can also take a look at [Node-RED](https://nodered.org)