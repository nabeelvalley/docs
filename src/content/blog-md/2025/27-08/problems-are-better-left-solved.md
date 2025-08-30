---
title: Problems are better left solved
description: Some thoughts on Go
published: true
feature: true
subtitle: 27 August 2025
---
![Screen recording of Déjà vu](/projects/dejavu.gif)

I don't enjoy writing Go. I like languages that challenge me, that make me think about processes, model the domain, and force me to be as complete as possible in my thinking. Go does none of this, but it seems to be the only language I program in lately

Corporate work, as you might imagine (or, more likely, understand to your core), is not fun. It tends to be a lot of talking around problems instead of solving them, and solving around metrics instead of people

I've been struggling to find ways to add value and have been moving my focus around a bit. Between people throwing AI at anything that will stick and pushing for MORE OUTPUT constantly, there's little room to make a meaningful impact. Most people are flooded with work and don't really have time to talk about big problems or to find solutions to anything real

I think small frustrations are often undervalued - particularly ones that people think are unique to them. These tend to be quite easy to solve, but since they're perceived as isolated problems we don't really bother to solve them

I've recently noticed a lot of issues popping up where the solution is "read the documentation"

It's something we emphasise a lot as technical people. What always falls by the wayside however, is what documentation? Where do I find it? How do I know what I'm doing is even documented - why would it be if it's a problem I'm only experiencing?

At the moment I'm on a team that develops and supports libraries that other teams use. A large chunk of this involves working with developers to help understand where and how to integrate with our libraries

When working with lots of developers you start to notice patterns. In the way people work, how they use their tools, and the types of issues they run into

Developers in some team may struggle with a bug for days, when across the hall, another team knows the fix

Sure, community channels help, but if the message isn't phrased in a certain way or if the right person doesn't see it then it's of no use

Often, we've documented the solutions, but no one seems to know.

The problem isn't that developers don't read the documentation, it's that we've failed to show it to them at the right time and in the right place

Usually when developers run into an issue, the first place they look is their terminal - do I see any errors? Is there a weird warning of some kind?

I think this space that occupies so much of our time and energy is underutilized, searching for error messages online is hit or miss, and good luck if it's something to do with your company's specific setup

Well, computers read faster than people. I had an idea that I could tie the terminal and documentation together - so I wrote an app that does just that

[Déjà vu](https://github.com/sftsrv/dejavu) is a little app that scans the output of terminal commands in real time to find documentation that may be relevant for issues that developers are facing

It works using existing documentation and is a little program I put together in a few hours using Go

So I'm not a fan of Go.

I've been writing a lot of it recently though. It's easy to set up, has a great ecosystem, is pretty fast, and it just works. Things that would take days to solve in other languages are an evening of work with Go

Recently, the problems I've been trying to solve have revolved around other people. Hacky scripts and complex shell setups are not things they have. Solutions need to be free standing and "just work"

When it comes to other people, I tend to prioritize getting a solution quickly. Small solutions become less valuable as time passes, and people become more annoyed too.

Iterating across people is a lot slower than iterating with yourself, so being able to start conversations early is important.

All of this basically to say - Go helps me solve problems quickly. So what if I don't like it.