---
title: Week 37, Server Management
description: Some utilities that simplify self hosting
published: true
feature: false
subtitle: 14 September 2025
---
# Off topic

Something off-topic but I just came across [this explainer](https://biomousavi.com/difference-between-process-nexttick-setimmediate-and-settimeout-in-node-js) on the different task queues and related methods in Node.js that I thought would be a nice share

# What I Found

I've been looking into/exploring some solutions for self hosting and had a little exploration/review of some tools with [Kurt Lourens](https://kurtlourens.com/) on some of the tech that's available

## Proxies

*   [Traefik](https://github.com/traefik/traefik) is a reverse proxy that integrates really nicely with Docker by letting you configure endpoints via the container configuration in your environment
    
*   [Caddy](https://github.com/caddyserver/caddy) is a web server and reverse proxy that supports TLS out of the box and is really nice to configure
    

## Application Management

*   [Portainer](https://github.com/portainer/portainer) is a management layer and UI for Docker and Kubernetes
    
*   [Arcane](https://github.com/ofkm/arcane) is another UI for managing Docker containers
    
*   [Komodo](https://github.com/moghtech/komodo) is a tool that simplifies the building and deployment of software across many servers