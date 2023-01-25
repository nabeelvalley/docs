---
title: Let's talk about Feeds
description: A short introduction to RSS feeds
subtitle: 24 January 2023
published: true
---

# Order Up

Life's busy and disastrous and trying to pop in and talk to myself for a few hours is unattainable most of the time 

Recently I've gotten really into RSS. RSS is short for `Really Simple Syndication` and it's basically just a format/standard that enables websites to share their content in a way that's easy for other websites or applications to consume 

# Starter

An RSS Feed is really just an XML file that contains information on a website's content, and depending on the nature of the website this is usually something like a blog or podcast feed, but I've also seen RSS used for things like project statuses or website uptime information 

# Main Course

Here's a sample RSS Feed that I found on [RSS Tools](http://www.rss-tools.com/rss-example.htm) that I modified a bit to represent something you might see when working with websites or blog content: 

```xml 
<?xml version="1.0" encoding="UTF-8"?> 
<rss version="2.0"> 
  <channel> 
    <title>RSS Example</title> 
    <description>This is an example of an RSS feed</description> 
    <link>http://www.domain.com/link.htm</link> 
    <lastBuildDate>Mon, 28 Aug 2006 11:12:55 -0400</lastBuildDate> 
    <pubDate>Tue, 29 Aug 2006 09:00:00 -0400</pubDate> 
    <item> 
      <title>Item Example</title> 
      <description>This is an example of an Item</description> 
      <link>http://www.domain.com/link.htm</link> 
      <guid isPermaLink="false">1102345</guid> 
      <pubDate>Tue, 29 Aug 2006 09:00:00 -0400</pubDate> 
      <content:encoded>This is some content</content:encoded> 
    </item> 
  </channel> 
</rss> 
``` 

In the above example we can see a `channel` which defines a source for content 

Next up we've got the `title`, `description`, `link`, `lastBuildDate`, and `pubDate` which are the metadata for the overall feed and are required for readers that may be accessing the feed 

Now, all of that is really cool, but we're not into the juicy bits yet - diving into the content itself we see in the `item` section.  

A feed can define multiple `item` tags - each of these would have some metadata as well as the actual content associated with the post 

In the example, each `item` has the following:

- `title`
- `description`
- `link`
- `guid`
- `content:encoded`

The above fields are pretty so-so, but the part I find intriguing is the `guid` which is any unique identifier for an item in a feed, this doesn't have a specific format but just needs to be unique to the feed. 

Next, is the `content:encoded` section which is what the feed uses to share it's content - this can either be plain text or HTML, and it's up to the client to figure it out - based on this I suppose you could really share any content or data which is a pretty cool concept 

# Dessert 

Overall, RSS is pretty simple as a format and has some issues and limitation - versions prior to RSS 2.0 can also be a bit difficult to work with as it's not totally standardised 

Another issue I've encountered when working with RSS is the size of the file itself. Some feeds post frequently and may have very long posts. This can lead to very long posts 

I've noticed that some blogs with large RSS feeds choose to only store their latest items on the RSS feed, this means that consumer interested in reading older items need to have some cache of their own which was made when the items were initially posted - you could use the `guid` for this or some kind of diffing method but pretty much anything outside of the XML file delivered is the job of a consumer to work with 

# The Bill 

I've seen a lot of revived interest in the RSS format but there are also competitors to the format like ATOM which is a more complete standard and supports features like paged feeds and explicit content type definitions 

ATOM seems to solve the few issues I have with RSS but RSS is still **literally everywhere** which is tough to fight 

My latest side project is an RSS reader called [Articly](https://articly.vercel.app) which is built with Svelte/SvelteKit since I really wanted to get a feeling for the framework to build a full application and this seemed like a fun opportunity to do that
