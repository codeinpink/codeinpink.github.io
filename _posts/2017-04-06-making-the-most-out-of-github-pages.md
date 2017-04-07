---
layout: post
title: Making the Most Out of GitHub Pages
img:
    url: /img/posts/jekyll-github-pages.png
    title: Using Jekyll and GitHub Pages
    alt: Jekyll and GitHub Pages
category: tutorial
tags: github-pages jekyll github creative-frugality
type: hentry
---

{% raw %}
So, I'm a *pretty* big fan of GitHub Pages.  Every time a friend wants to make a portfolio site I *always* recommend GitHub Pages -- and Jekyll, too!  If you aren't familiar with them, [GitHub Pages](https://pages.github.com/) is free hosting for static sites (using your GitHub repositories).  [Jekyll](https://jekyllrb.com/) is a static site generator, which means you can use templates, generate pages from data files, and a bunch of other cool things you don't normally get with plain ol' static sites.

Back in December I used GitHub Pages, Jekyll, and some other free resources to save myself about $90 a year and thought I should make a post about it so other people can save some money, too.

# Small Business
If you've browsed my site before or have [googled my name](https://www.google.com/search?q=shannon+babincsak) then you probably already know my dad has a martial arts studio (if not, TYL).  I've been paying its web bills the past few years, $5-10 for the domain and $80-90 for the hosting.   It might not seem like much, but hey, **$100 is $100**.

<iframe src="//giphy.com/embed/B0dqvPg0rFW0M" width="480" height="397.89473684210526" frameBorder="0" class="giphy-embed center-block" allowFullScreen></iframe>

A martial arts studio doesn't really need much in terms of hosting: 5-7 pages, a contact form, and a gallery (preferably automatically generated).  So why pay $80-90 for it?

Better yet, why pay at all?

# Migrating Over to GitHub Pages
The purpose of GitHub Pages is to let people create sites for their projects, **but they don't *have* to be open source**.  GitHub lets
you create public sites even for your *private* repositories.  This means I can keep the code for the studio's site in a private repository
**for free** (ayyy, student pack) and host it **for free**.  GitHub is also **dependable** with **good up-time**.

The only restriction is that the site **must be static** -- you have no access to a server.  No server processing means the site will be served pretty quickly and won't be subject to all kinds of security risks, but it also limits what you can do.  This is where Jekyll comes in.

# Migrating Over to Jekyll
The original site used PHP's `include` for things like a header and footer and relied on PHP for the gallery.  Every time someone navigated to it, the server would grab the images in that gallery page's folder and display them.  Jekyll supports templates, so I can minimize code repitition easily using those, but what do I do about the gallery?

## Jekyll Plugins
The answer: use a plugin!  Jekyll lists a bunch of plugins people have made for it over on [this](https://jekyllrb.com/docs/plugins/) page.  I decided to write my own plugin, though, since I wanted a few specific things from it:

1. Generate a gallery page for the main gallery folder and each folder inside of it
2. Set the page's title based on the folder 
3. Add each folder's images _and_ sub-folders to the page's data variable
4. Set the sub-folder's image using an image called `cover.jpg` and set each image's `alt` text using the image's file name

**gallery_generator.rb**

<script src="https://gist.github.com/codeinpink/17177e89c02958c4e8eb4f3340d34174.js"></script>

As you can see, the generator plugin will go through the `images/gallery` folder and generate each gallery page, setting the title, pictures, and sub-galleries (sub-folders) as it goes.  The gallery template looks like this:

<script src="https://gist.github.com/codeinpink/b66c912226a6831267c1f8f02f015265.js"></script>

It displays the sub-galleries first and then all of the pictures, making sure to leave out the cover picture.  For the `alt` text,
I use a filter to grab the file name from the image's path (since the path is what is passed in as `{{ img }}`).

<script src="https://gist.github.com/codeinpink/2d68051a77b14c34071e3fc12604f926.js"></script>

I don't remember if I made this or if I got this off of Stack Overflow, but this also could have been done inside
my generator plugin.

Another plugin I made was for the home page's **slideshow**.  I was tired of having to go in and manually change the images
being pointed to and their alt text.  I wanted to just put the images in a folder and have them be used for the slideshow.  Here's my solution:

<script src="https://gist.github.com/codeinpink/7b84d3ce1dc06e4d2eca16b485e56f0c.js"></script>

This plugin takes all of the pictures in the `images/slideshow` directory and adds them to my home page's data variable.  In my home page's template, I can now iterate through them like I would anything else.

## Other Jekyll-y Things
Switching over to Jekyll allowed me to also move some things into **data files** instead of hard-coding them into the HTML.  I moved
the schedule, classes, instructor biographies, and services into their own data files so if I ever have to change the time a class
is offered or add a new service or instructor I can just quickly change a data file.  For example, this is how I handled classes:

<script src="https://gist.github.com/codeinpink/d221175e110d6a3fd456f525f4e9e0b6.js"></script>

As you can see, all I have to do is loop through the classes in my `classes.yml` data file and each class will get its section rendered.  The data file is simple enough to understand that I can even get my dad to modify it when classes change.

# Contact Form
A key component of every business' site is the **contact form**.  This was previously done using PHP, but I don't have a server to use
with GitHub Pages.  Solution?  [FormSpree](https://formspree.io/).

Whenever someone fills out the form and clicks submit, the form data is sent to their server, and they handle sending the email where it needs to go.  You'll need to configure it for each domain (localhost for testing or the *live* domain for production), but that takes 30 seconds.  FormSpree is pretty cool, no complaints here!

# Domain Name
A business obviously can't have its site name be **somename.github.io/business-name**.  This means we can't use GitHub Pages, right?

<iframe src="//giphy.com/embed/3oz8xrkBxxhPyVFgek" width="464.0409207161125" height="480" frameBorder="0" class="giphy-embed center-block" allowFullScreen></iframe>

[GitHub Pages works with custom domains](https://help.github.com/articles/using-a-custom-domain-with-github-pages/).

# Wrapping Up
In conclusion, try out GitHub Pages and Jekyll for your next site.  Most people don't think
of them when they are tasked with creating a site for a small business, but there's nothing stopping you from saving some money!
<iframe src="//giphy.com/embed/11ISwbgCxEzMyY" width="480" height="360" frameBorder="0" class="giphy-embed center-block" allowFullScreen></iframe>

{% endraw %}