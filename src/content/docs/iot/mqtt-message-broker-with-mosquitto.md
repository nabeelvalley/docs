---
published: true
title: MQTT with Mosquitto
subtitle: Using Mosquitto as a Message Broker
---

[[toc]]

MQTT makes use of a publish/subscribe model in which a client will either publish messages to a topic or subscribe to messages on the topic

# Help

We can run the following to get the `mosquitto` help menus

## General

```powershell
> mosquitto --help

mosquitto version 1.5.4

mosquitto is an MQTT v3.1.1 broker.

Usage: mosquitto [-c config_file] [-d] [-h] [-p port]

 -c : specify the broker config file.
 -d : put the broker into the background after starting.
 -h : display this help.
 -p : start the broker listening on the specified port.
      Not recommended in conjunction with the -c option.
 -v : verbose mode - enable all logging types. This overrides
      any logging options given in the config file.

See http://mosquitto.org/ for more information.
```

## Publisher

```powershell
> mosquitto_pub --help

mosquitto_pub is a simple mqtt client that will publish a message on a single topic and exit.
mosquitto_pub version 1.5.4 running on libmosquitto 1.5.4.

Usage: mosquitto_pub {[-h host] [-p port] [-u username [-P password]] -t topic | -L URL}
                     {-f file | -l | -n | -m message}
                     [-c] [-k keepalive] [-q qos] [-r]
                     [-A bind_address]
                     [-i id] [-I id_prefix]
                     [-d] [--quiet]
                     [-M max_inflight]
                     [-u username [-P password]]
                     [--will-topic [--will-payload payload] [--will-qos qos] [--will-retain]]
                     [{--cafile file | --capath dir} [--cert file] [--key file]
                      [--ciphers ciphers] [--insecure]]
                     [--psk hex-key --psk-identity identity [--ciphers ciphers]]
                     [--proxy socks-url]
       mosquitto_pub --help

...
```

## Subscriber

```powershell
> mosquitto_sub --help

mosquitto_sub is a simple mqtt client that will subscribe to a set of topics and print all messages it receives.
mosquitto_sub version 1.5.4 running on libmosquitto 1.5.4.

Usage: mosquitto_sub {[-h host] [-p port] [-u username [-P password]] -t topic | -L URL [-t topic]}
                     [-c] [-k keepalive] [-q qos]
                     [-C msg_count] [-R] [--retained-only] [-T filter_out] [-U topic ...]
                     [-F format]
                     [-A bind_address]
                     [-i id] [-I id_prefix]
                     [-d] [-N] [--quiet] [-v]
                     [--will-topic [--will-payload payload] [--will-qos qos] [--will-retain]]
                     [{--cafile file | --capath dir} [--cert file] [--key file]
                      [--ciphers ciphers] [--insecure]]
                     [--psk hex-key --psk-identity identity [--ciphers ciphers]]
                     [--proxy socks-url]
       mosquitto_sub --help

...
```

# Starting a Server

We can start an MQTT Broker Server with `mosquitto` in verbose mode as follows

```powershell
mosquitto -v
```

This will allow us to publish and subscribe message

# Subscribe to a Topic

We can subscribe to a topic with the following

```powershell
mosquitto_sub -t "hello" -v
```

# Publish to a Topic

We can publish messages to a topic with the following

```powershell
mosquitto_pub -t "hello" -m "Hello World!"
```
