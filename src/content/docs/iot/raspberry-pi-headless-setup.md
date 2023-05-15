---
published: true
title: Raspberry Pi Headless
subtitle: Setting up WiFi and SSH on a Raspberry PI Headlessly
---

[[toc]]

# Get the OS Ready

To setup a headless Pi you need to do the following:

1. Download the [Raspberry Pi Imager](https://www.raspberrypi.org/downloads/)
2. Download the OS you want (You can find them [here](https://www.raspberrypi.org/downloads/raspberry-pi-os/))
3. Apply the downloaded image to an SD Card using the imager

# Configure WiFi

> [Docs](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md)

## With Raspberry Pi Imager

> Information on using th Raspberry Pi Imager advanced options can be found on [the Raspberry Pi website](https://www.raspberrypi.com/news/raspberry-pi-imager-update-to-v1-6/)

Using Raspberry Pi Imager, you can click on the advanced options icon (cog) at the bottom right of the UI or type `ctrl + shift + x` to open the menu. In this menu be sure to configure the following options

- Enable SSH
- WiFi SSID and Password
- Optional: Change Username and Password
- Optional: Set Hostname

## Without Raspberry Pi Imager

Since you won't be able to interact with the Pi (because it's headless) you will want to configure the WiFi if you will be using it through that

### Setup WiFi

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

### Enable SSH

> [Docs](https://www.raspberrypi.org/documentation/remote-access/ssh/README.md)

Next, you will want to configure SSH, you just need to add an empty file named `ssh` to the filesystem directory, note that when you SSH in later, the default username is `pi` and the password is `raspberry`

You can wait a few minutes and try to reach the pi with `ping rasberrypi.local`, if this responds then you can possibly just skip the IP stuff if you don't need it to be static and you can SSH with:

```sh
ssh pi@raspberrypi.local
```

If you're not able to do so you may need to look around and try to find the IP some other way

# Get the PI IP

> [Docs](https://www.raspberrypi.org/documentation/remote-access/ip-address.md)

1. Get your current PC's IP
2. Run `sudo nmap -sn <YOUR IP>/24` (linux) or `arp -a` (windows) to view the IP's of devices on your network
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

# Add Node.js

Installing Node involves getting the installation script and running the script, you can do this by running the following command:

```sh
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
```

Then:

```sh
sudo apt-get install -y nodejs
```

Finally, you can check the version with:

```sh
node --version
npm --version
```

# Add Yarn

Similar to Node, you need to install Yarn using a setup script:

```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

And then:

```sh
sudo apt update && sudo apt install yarn
```
