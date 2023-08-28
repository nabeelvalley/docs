---
published: true
title: Control a Raspberry Pi GPIO with Python
subtitle: 28 March 2021
description: Flicker and control and LED via a Raspberry Pi's GPIO Output pins using Python and RPi.GPIO
---

---
published: true
title: Control a Raspberry Pi GPIO with Python
subtitle: 28 March 2021
description: Flicker and control and LED via a Raspberry Pi's GPIO Output pins using Python and RPi.GPIO
---

# Circuit Diagram

This script will make use of the GPIO Pins to flicker an LED

The circuit diagram is below:

![Circuit diagram](/content/stdout/2021/27-03/led-circuit.png)

I've used a $330\Omega$ resistor for the resistor connected in series $R_LED$, however the resistance for a given LED can be calculated with this equation (From [Circuit Specialists](https://www.circuitspecialists.com/blog/how-to-determine-resistor-value-for-led-lighting/)):

$$
R_{LED} = \frac{V_{source} - V_{LED}}{I_{LED}}
$$

> It's important to connect the LED in the correct direction on the circuit

# Code

Below is a simple python script which will handle turning the GPIO pins on and off using the [RPi.GPIO](https://pypi.org/project/RPi.GPIO/) library

```py
import RPi.GPIO as GPIO
import time

pin = 21
dur = 1

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(pin, GPIO.OUT)

while True:
  GPIO.output(pin, GPIO.HIGH)
  print "LED ON"
  time.sleep(dur)

  GPIO.output(pin, GPIO.LOW)
  print "LED OFF"
  time.sleep(dur)
```
