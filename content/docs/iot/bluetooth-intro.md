[[toc]]

# Overview

Bluetooth Low Energy (BLE) devices make use of a few different concepts for reading and writing data. At a high level, bluetooth data is organized as follows:

![GATT Data hierarchy](/docs/iot/bluetooth-data-hierarchy.png)

Each characteristic contains the following attributes:

- **Properties** -  specify the operations allowed on a characteristic, e.g. `read`, `write` 
- **UUID** - A unique ID for this characteristic, this can be a 16-bit, approved UUID from [this list](https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf) or a custom 128 bit as specified by the device manufacturer
- **Value** - The actual value contained in a characteristic. How this value is interpreted is based on the UUID and is either a standard value or a custom manufacturer-specific value

# Reading Bluetooth Data

I'm going to be using Bleak with Python to read Bluetooth data and characteristics. Although it's also possible to use the _nrf Connect_ app or another bluetooth debugging tool to do much of the same kind of stuff I'm doing here

## Install Bleak

In order to connect to bluetooth devices I'm using a library called Bleak. To install Bleak you can use the following command:

```sh
pip3 install bleak
```

## Scan for Devices

To scan for devices we can use the `BleakScanner.discover` method:

`discover.py`

```py
import asyncio
from bleak import BleakScanner

async def main():
  async with BleakScanner() as scanner:
      devices = await scanner.discover()
      for d in devices:
          print(d)

if __name__ == "__main__":
    asyncio.run(main())
```

This will print all devices that were found during the discover call in the form of:

```
Device Address: Device Name
```

An example can be seen below:

```txt
24:71:89:CC:09:05: Device Name
```

## List Services and Characteristics

To list the services of a device we can make use of the `BleakClient` class. To do this we need a client address as we saw above:

`get_device_info.py`

```py
import asyncio
import sys
from bleak import BleakClient

async def main(address):
  async with BleakClient(address) as client:
    if (not client.is_connected):
      raise "client not connected"

    services = await client.get_services()

    for service in services:
      print('service', service.handle, service.uuid, service.description)
    

if __name__ == "__main__":
  address = sys.argv[1]
  print('address:', address)
  asyncio.run(main(address))
```

We can expand on the above to list the characteristics and descriptors of each service as well:

`get_device_info.py`

```py
import asyncio
import sys
from bleak import BleakClient

async def main(address):
  async with BleakClient(address) as client:
    if (not client.is_connected):
      raise "client not connected"

    services = await client.get_services()

    for service in services:
      print('\nservice', service.handle, service.uuid, service.description)

      characteristics = service.characteristics

      for char in characteristics:
        print('  characteristic', char.handle, char.uuid, char.description, char.properties)
        
        descriptors = char.descriptors

        for desc in descriptors:
          print('    descriptor', desc)

if __name__ == "__main__":
  address = sys.argv[1]
  print('address:', address)
  asyncio.run(main(address))
```

Below you can see the results of reading from a sample server that I've configured which has a few characteristics with different permissions

```txt
service 1 00001801-0000-1000-8000-00805f9b34fb Generic Attribute Profile
  characteristic 2 00002a05-0000-1000-8000-00805f9b34fb Service Changed ['indicate']

service 40 0000180d-0000-1000-8000-00805f9b34fb Heart Rate
  characteristic 41 00002a37-0000-1000-8000-00805f9b34fb Heart Rate Measurement ['notify']
    descriptor 00002902-0000-1000-8000-00805f9b34fb (Handle: 43): Client Characteristic Configuration
  characteristic 44 00002a38-0000-1000-8000-00805f9b34fb Body Sensor Location ['read']
  characteristic 46 00002a39-0000-1000-8000-00805f9b34fb Heart Rate Control Point ['write']

service 48 0000aaa0-0000-1000-8000-aabbccddeeff Unknown
  characteristic 49 0000aaa1-0000-1000-8000-aabbccddeeff Unknown ['read', 'notify']
    descriptor 00002902-0000-1000-8000-00805f9b34fb (Handle: 51): Client Characteristic Configuration
    descriptor 0000aab0-0000-1000-8000-aabbccddeeff (Handle: 52): None
    descriptor 00002901-0000-1000-8000-00805f9b34fb (Handle: 53): Characteristic User Description
    descriptor 00002904-0000-1000-8000-00805f9b34fb (Handle: 54): Characteristic Presentation Format
  characteristic 55 0000aaa2-0000-1000-8000-aabbccddeeff Unknown ['write-without-response', 'write', 'indicate']
    descriptor 00002902-0000-1000-8000-00805f9b34fb (Handle: 57): Client Characteristic Configuration

service 58 0000181c-0000-1000-8000-00805f9b34fb User Data
  characteristic 59 00002a8a-0000-1000-8000-00805f9b34fb First Name ['read', 'write']
  characteristic 61 00002a90-0000-1000-8000-00805f9b34fb Last Name ['read', 'write']
  characteristic 63 00002a8c-0000-1000-8000-00805f9b34fb Gender ['read', 'write']
```

Using the above, I can read some characteristics using their UUID like so:

```py
import asyncio
import sys
from bleak import BleakClient

FIRST_NAME_ID = '00002a8a-0000-1000-8000-00805f9b34fb'

async def main(address):
  async with BleakClient(address) as client:
    if (not client.is_connected):
      raise "client not connected"

    services = await client.get_services()

    name_bytes = await client.read_gatt_char(FIRST_NAME_ID)
    name = bytearray.decode(name_bytes)
    print('name', name)

if __name__ == "__main__":
  address = sys.argv[1]
  print('address:', address)
  asyncio.run(main(address))
```

> Depending on the data structure and type the requirements for decoding the data may be different.

Using the above idea, Bleak also gives us a way to listen to data that's being sent from a client by way of the `BleakClient.start_notify` method which takes a characteristic to listen to and a callback which will receive a handle for the characteristic as well as the value

```py
import asyncio
import sys
from bleak import BleakClient

HEART_RATE_ID = '00002a37-0000-1000-8000-00805f9b34fb'

def heart_rate_callback(handle, data):
  print(handle, data)

async def main(address):
  async with BleakClient(address) as client:
    if (not client.is_connected):
      raise "client not connected"

    services = await client.get_services()

    
    client.start_notify(heart_rate_char, heart_rate_callback)
    await asyncio.sleep(60)
    await client.stop_notify(heart_rate_char)
```

# References

## Overview

A good overview of how Bluetooth and how GATT (The Generic Attribute Profile) for a bluetooth device structures data can be found in [Getting Started with Bluetooth Low Energy by Kevin Townsend, Carles Cufí, Akiba, Robert Davidson](https://www.oreilly.com/library/view/getting-started-with/9781491900550/). A good overview of what we'll be using can be found on [Chapter 1 - Introduction](https://www.oreilly.com/library/view/getting-started-with/9781491900550/ch01.html) and [Chapter 4 - GATT (Services and Characteristics)](https://www.oreilly.com/library/view/getting-started-with/9781491900550/ch04.html)

## Library

A library I've found to be fairly simple for using to play around with Bluetooth is [Bleak]() which is a multi-platform library for Python 

> I've had some issues using Bleak with Windows so I would recommend a Linux-based OS instead

## Debugging Tool

A useful and easy to use tool for snooping around for bluetooth activity and exploring bluetooth data is the [nrf Connect Android App](https://play.google.com/store/apps/details?id=no.nordicsemi.android.mcp&hl=en_ZA&gl=US)


## Reverse Engineering

An approach for reverse engineering the data structure for a simple bluetooth device can be found on [BLE Reverse engineering — Mi Band 5](https://medium.com/@_celianvdb/ble-reverse-engineering-mi-band-5-c3deed12c7)

## List of Bluetooth IDs

A database of bluetooth numbers can be found in the [Bluetooth numbers database](https://github.com/NordicSemiconductor/bluetooth-numbers-database) as well as the previously mentioned {Bluetooth specifications document}(https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf)

# Next Ideas

It may be worth looking into creating a Bluetooth Server. The library installed on Raspberry Pi is Bluez and it looks it supports creating a Bluetooth Server. The documentation for Bluez can be found [here](http://www.bluez.org/). Additionally, there's also the [Bluetooth for Linux developers](https://www.bluetooth.com/bluetooth-resources/bluetooth-for-linux/) which goes through creating a device that acts as a Bluetooth LE peripheral which could be useful in simulating a BLE device