# Get the OS Ready

> These notes mostly apply to Raspberry OS, for Ubuntu take a look [here]

To setup a headless Pi you need to do the following:

1. Download the [Raspberry Pi Imager](https://www.raspberrypi.org/downloads/)
2. Download the OS you want (You can find them [here](https://www.raspberrypi.org/downloads/raspberry-pi-os/))
3. Apply the downloaded image to an SD Card using the imager

# Configure WiFi

> [Docs](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md)

Since you won't be able to ineract with the Pi (because it's headless) you will want to configure the WiFi if you will be using it through that

Create a `wpa_supplicant.conf` in your Pi's root directory in your SD Card, this will be copied to the correct place when starting up. The file should have the following contents:

`wpa_supplicant.conf`

```sh
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=<Insert 2 letter ISO 3166-1 country code here>

network={
 ssid="<Name of your wireless LAN>"
 psk="<Password for your wireless LAN>"
}
```

# Configure SSH

> [Docs](https://www.raspberrypi.org/documentation/remote-access/ssh/README.md)

Next, you will want to configure SSH, you just need to add an empty file named `ssh` to the filesystem directory, note that when you SSH in later, the default username is `pi` and the password is `raspberry`

# Get the PI IP

> [Docs](https://www.raspberrypi.org/documentation/remote-access/ip-address.md)

1. Get your current PC's IP
2. Run ` sudo nmap -sn <YOUR IP>/24` to view all the IP's of devices on your network
3. Check if any have the hostname `raspberrypi` and check the IP. If none of them have the hostname just wing it and try a few, idk.
4. Next use `ssh pi@<RaspberryPi IP>` and log in with the password `raspberry`

Once you're logged in, the device will prompt you to change the password, you can do this from the Pi's config. To open the config menu run:

```sh
sudo raspi-config
```

And then select the first option to `Change User Password`

# Make the IP Static

> [Some Instructions](https://www.ionos.com/digitalguide/server/configuration/provide-raspberry-pi-with-a-static-ip-address/)

1. From your Pi, run the following command:

```sh
sudo nano /etc/dhcpcd.conf
```

And edit/uncomment the Example Static IP Configuration, the only important thing to do here is to set the `interface` to be `wlan0` and set the `ip_address` to the IP you want to use, everything else doesn't really matter too much and can likely stay as-is

```sh
interface wlan0
static ip_address=<IP Address>/24
static ip6_address=<IPv6 Address>/64
static routers=192.168.0.1
static domain_name_servers=192.168.0.1 8.8.8.8 fd51:42f8:caae:d92e::1
```

Then quit and save, now that you've set the IP, you can reboot your Pi with:

```sh
sudo reboot
```

And then SSH using your new IP Address that you assigned above. This is to ensure that you can always find the Pi on your network easily. You will now be prompted to login - be sure to use the updated password that you configured