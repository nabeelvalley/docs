[[toc]]

A short lil guide to setting up Home Assistant on a RaspberryPi using WiFi instead of Ethernet

1. Download Balena Etcher and install from [here](https://www.balena.io/etcher/)
2. Go to the HomeAssistant website and copy the relevant release URL from [here](https://github.com/home-assistant/operating-system/releases/download/5.12/hassos_rpi3-64-5.12.img.xz)
3. Connect your RaspberryPi's SD card to your computer
4. Open Balena Etcher and select `Flash from URL` and select the RaspberryPi's SD to flash to
5. Once flashing is complete, open the RaspberryPi's SD in File Explorer, and create the following file:

`RASPBERRYPIDRIVE/CONFIG/network/my-network`

```
!cat .\my-network
[connection]
id=my-network
uuid=72111c67-4a5d-4d5c-925e-f8ee26efb3c3
type=802-11-wireless
[802-11-wireless]
ssid=YOUR_WIFI_NETWORK_NAME
#hidden=true

[802-11-wireless-security]
auth-alg=open
key-mgmt=wpa-psk
psk=YOUR_WIFI_PASSWORD

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

> Be sure to use `LF` line endings, additional information on this setup can be found [on GitHub](https://github.com/home-assistant/operating-system/blob/dev/Documentation/network.md)