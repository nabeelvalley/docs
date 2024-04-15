---
title: Passwords
description: Some casual commentary
subtitle: 12 April 2024
published: false
---

> "Good design is actually a lot harder to notice than poor design, in part because good designs fit our needs so well that the design is invisible, serving us without drawing attention to itself. Bad design, on the other hand, screams out its inadequacies, making itself very noticeable." - Don Norman

Just had a silly experience. I needed to log into an app on my browser and had the following nonsensical series of steps:

1. Go to website
2. Click "Login"
3. Username automatically filled in by my password manager
4. Click "Next"
5. Password is automatically filled in by my password manager
6. Click "Submit"

Maybe there's trickiness I'm not seeing here but from my perspective it doesn't look like I'm required in this flow?

Between my browser and my password manager, and to some extent the application I'm logging into, this problem can be solved without my involvement. You have enough information to know who I am and log me in automatically when visiting a page - there's no real reason I ever need to see a login page when using an application on my device/browser

I'm thinking that since the data is already there at a hardware level this should be a solved problem

Then again, maybe this is what [Web Authentication API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Authentication_API) is meant to solve but I'm not too sure, I think it's still a click too many. That and my experiences with it have been a little inconsistent

I think we're still missing some unifying solution - some means of tying my identity to a set of devices once and having the friction removed at every other point

Generally things get smoother as time goes but I feel that hasn't been then case with auth. Every day there's a new step - OTPs, "Magic Links" or "Your password can't be the same as your past 5 passwords" which create a mess for most people. We like to think that most people just use password managers but that isn't really the case. Many people struggle with this constantly

I'm not sure what the solution is but I think we need to start thinking about security from a bit more of a human angle and less of a computer one