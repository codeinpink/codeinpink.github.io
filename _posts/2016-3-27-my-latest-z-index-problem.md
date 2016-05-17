---
layout: post
title: "My Latest Z-index Problem"
date: 2016-05-17
img:
    url: /img/posts/z-index.png
    title: "My Recent Z-index Bug"
    alt: "A screenshot of the iOS navigation bug"
category: web development
tags: css ios
type: hentry
---

Two months ago I launched a site for a gaming project that I'm involved in.  I
received a lot of good feedback from people, but it wasn't long before I had my
first bug report, something I was expecting from my lack of browser testing: the
navigation dropdown on iPhones was behind the home page content.  *Great*.

## The Problem ##
You could probably guess that I was using Bootstrap (**correct**), and if you have
a decent understanding of CSS, you also know just by looking at the image that it's a
z-index issue.  Somehow, *only on iPhones*, the navbar was showing behind the other
content on the page.  No other device/platform had this problem.  One thing you
probably *don't* know is that the screenshot
isn't mine because **I don't even own an iPhone**.  Nothing quite like blindly trying to solve
a platform-specific bug.

I specified z-index on various elements (nav, nav elements, carousel, announcements, etc.) -- **nothing**.
I googled, tried a few suggestions on Stack Overflow -- **nothing**.  What the hell?
That's when I came across <a href="http://sevenspark.com/diagnosis/z-index-submenu-hidden-behind-content" target="_blank">this article</a>.
I didn't even have to read all of the article to identify the issue.

## The Solution ##
At some point `position: static` had made its way into my styling of `.navbar`.
I don't know if it came from one of the suggestions on Stack Overflow or something else,
but it was the problem.  Like the article says, **z-index only affects elements with position --
NOT STATIC ELEMENTS.**  Sure enough, I removed that styling and my nav-related
z-index additions worked.

This frustrating (*and small*) bug taught me or reminded me of a few things:

1.  Don't use `position: static` when also specifying z-index
2.  I'm still not a master at CSS
3.  Most people aren't masters at CSS, either
4.  Cross browser testing is still very important (*and valuable*)
