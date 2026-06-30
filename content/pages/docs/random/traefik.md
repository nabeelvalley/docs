---
title: Traefic
description: General notes and reference on using Traefik
---

[Traefik](https://traefik.io/traefik) is a reverse proxy that plays really well with [Docker](https://www.docker.com/) (or I guess any [Open Container Initiative](https://opencontainers.org/) environment)

This document doesn't currently serve as a how-to-use-traefik page but simply as a quick reference for some handy stuff

## Global Configuration

### Logging

#### User Agent Logging

> [Traefik Logs & AccessLogs Docs](https://doc.traefik.io/traefik/reference/install-configuration/observability/logs-and-accesslogs/)

The Access Log is configured in the `traefik.yml` or similar file. Here's an example configuration for ensuring that the `User-Agent` is in the logs

```yml
accessLog:
  filePath: /path/to/logfile/access.log
  format: json
  bufferingSize: 100

  fields:
    headers:
      names:
        User-Agent: keep
```

## Middleware

### Redirect to HTTPS

> [Traefik RedirectScheme Docs](https://doc.traefik.io/traefik/reference/routing-configuration/http/middlewares/redirectscheme/)

You obviously want to use HTTPS wherever possible, the config for this in the `middlewares.yml` file can be added to `http.middlewares`:

```yml
http:
  middlewares:
    redirect-to-https:
      redirectScheme:
        scheme: https
        permanent: true
```

### Rate Limiting

> [Traefik RateLimit Docs](https://doc.traefik.io/traefik/reference/routing-configuration/http/middlewares/ratelimit/)

To avoid getting spammed by bots, you may want to implement some rate limiting, you can do this with the `rateLimit` middleware which can be added to your `middlewares.yml` file in `http.middlewares`

```yml
http:
  middlewares:
    general-rate-limit:
      rateLimit:
        average: 100
        period: 1s
        burst: 200
```
