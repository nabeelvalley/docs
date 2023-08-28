---
published: true
title: VirtualBox Setup
subtitle: Some Personal Preferences and Troubleshooting
---

---
published: true
title: VirtualBox Setup
subtitle: Some Personal Preferences and Troubleshooting
---

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

## SSH into Guest from Host

The instructions are from [this Stackoverflow post](https://stackoverflow.com/questions/5906441/how-to-ssh-to-a-virtualbox-guest-externally-through-a-host)

On your Host, go to `VM > Settings > Network` and ensure that it is set to NAT, then click on `Advanced > Port Forwarding` and add a new **Rule**, make the rule **Name** `ssh` and set the **Host Port** to `3022`, leave the rest blank

Also be sure to install an SSH server on the VM with

```bash
sudo apt-get install openssh-server
```

And finally SSH into the VM with

```bash
ssh -p 3022 user@127.0.0.1
```

where `user` is the VM username

## Port Forwarding

VirtualBox lets you do Port Forwarding simply by going to `VM > Settings > Network > Advanced > Port Forwarding`
