---
title: Bad Bots
subtitle: 03 April 2026
description: Some light reading on blocking AI crawlers
published: false
rssOnly: true
---

I have a website that kept randomly going down every few weeks - turned out that I hadn't enabled a healthcheck so the auto-restart didn't know to that it had to restart. So after some annoyance I added a basic check and I think it's fine now - probably ...

Anyways, not the point - I looked into why it kept going down and seemed like it would randomly get thousands of simultaneous requests from bots and I decided that I don't want that anymore?

I remembered reading a post a while back about blocking AI crawlers which upon some searching turned out to be by [Matthais Ott](https://matthiasott.com). And so I did some reading and here's a list of some related content on how to stop the LLMs:

1. [Webspace Invaders - Matthias Ott](https://matthiasott.com/articles/webspace-invaders)
2. [Poisoning Well - Heydon Works](https://heydonworks.com/article/poisoning-well/)
3. [Blocking Bots - Robb Knight](https://rknight.me/blog/blocking-bots-with-nginx/)
4. [Go ahead and block AI web crawlers - Cory Dransfeldt](https://www.coryd.dev/posts/2024/go-ahead-and-block-ai-web-crawlers)
5. [Please stop externalizing your costs directly into my face - Drew DeVault](https://drewdevault.com/2025/03/17/2025-03-17-Stop-externalizing-your-costs-on-me.html)

I particularly resonate with the last paragraph of the last link in that list:

> "If you personally work on developing LLMs et al, know this: I will never work with you again, and I will remember which side you picked when the bubble bursts." - Please stop externalizing your costs directly into my face - Drew DeVault

None of these are Traefik so I'll probably put together a bit of an implementation once I settle on something and put in in [my Traefik notes](/docs/random/traefik)
