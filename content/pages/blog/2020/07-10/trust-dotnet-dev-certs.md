---
published: true
title: Trust .NET Core Dev Certificates
description: Adding .NET Core Certificates to the Cert store from the CLI
date: 2020-10-07
---

When developing .NET Core web applications with HTTPS, to simplifiy your experience and avoid browser warnings you can trust the .NET Core dev certs on your local device with the followning commands:

```sh
dotnet dev-certs https --clean
dotnet dev-certs https --trust
```