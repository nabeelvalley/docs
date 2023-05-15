---
published: true
title: WSL
subtitle: Miscellaneous WSL Things
description: WSL tips and tricks
---

# Troubleshooting

When using WSL, you may occasionally see the following error message:

```
Err:1 http://archive.ubuntu.com/ubuntu focal/main amd64 binutils-common amd64 2.34-6ubuntu1
  Temporary failure resolving 'archive.ubuntu.com'
Unable to correct missing packages.
E: Failed to fetch http://archive.ubuntu.com/ubuntu/pool/main/b/binutils/binutils-common_2.34-6ubuntu1_amd64.deb  Temporary failure resolving 'archive.ubuntu.com'
E: Aborting install.
```

This may be due to the `resolv.conf` file being incorrect, you can fix this by updating the nameserver. You can do this by setting it as follows (e.g. using the OpenDNS IP):

`/etc/resolv.conf`

```conf
nameserver 208.67.222.222
```

You should then be able to run `apt-get update` and everything should connect as expected
