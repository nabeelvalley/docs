# VirtualBox Bugs

## Guest Additions

If anything like shared clipboard, screen resizing, and shared folders doesn't work be sure to do the **VirtualBox Guest Additions CD**, the link to install this can be found in `Devices > Insert Guest Additions CD...` and then insert and install that.

If you encounter the following error:

```raw
Verifying archive integrity... All good.
Uncompressing VirtualBox 5.2.12 Guest Additions for Linux........
VirtualBox Guest Additions installer
Copying additional installer modules ...
Installing additional modules ...
VirtualBox Guest Additions: Building the VirtualBox Guest Additions kernel modules.
This system is currently not set up to build kernel modules.
Please install the gcc make perl packages from your distribution.
VirtualBox Guest Additions: Running kernel modules will not be replaced until the system is restarted
VirtualBox Guest Additions: Starting.
Press Return to close this window...
```

You will need to run the following commands

```bash
sudo apt-get update
sudo apt-get install build-essential gcc make perl dkms
reboot
```

And then **Resinstall the Guest Additions CD**

