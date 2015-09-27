---
layout: post
title: "My Second Term at ADTRAN: First Month"
category: general
tags: work wordpress angular django hackathon
type: hentry
---

I returned in August for my second term as a co-op, and this term I got the **UX/UI
team**, a team I really wanted. Over the summer, I learned Django, a MVT back end
framework, but I didn't know any MVC front end frameworks yet. Spending a term
with these guys would *definitely* teach me more about front end development since
that's all I would be doing! *Well, that's what I thought, at least*. The first month has actually been an interesting
mix of work. I'm *supposed* to develop the front end for key products using Angular,
but outside of ensuring cross-browser compatibility, all of my development has been
for miscellaneous (and unplanned) things!

## Wordpress Plugin ##
My first task was to update one of our internal training sites and add a way to
track who has seen what videos. Surprisingly, a Wordpress plugin that does *just* this
**doesn't actually exist**. I had to write my own plugin, and since I hadn't written
a Wordpress plugin before (or used PHP in a few years), this was **pretty daunting**.

Thankfully, there were plugins I could look at to get a general idea of what I
needed to do, but what I noticed was that developing a plugin for Wordpress *kind
of sucks* -- at least, as a beginner. There's no structure. *None*. One plugin had all of its code in one long
file, and another had at least separated its views from its controllers, but that one still
had some functions ~50 lines long. Ultimately, I suppose it *is* up to *us*, the developers, to
structure our code, but I really do appreciate how some frameworks really force the
idea of "separation of concerns." I also appreciate MVC/T frameworks in general, which
again goes back to my complaint about lack of structure.

In the end, I wrote a Wordpress plugin in PHP and JavaScript to track, display, and export
video plays and the users associated with the plays. While I had complained earlier, my
plugin was *too small* to even be concerned about structure, and like I said, the
responsibility is on *us*, the developers, to write good code. Now that I somewhat
understand how to write a Wordpress plugin, I don't think it's too bad. It's actually
kind of fun!

## Cross Browser Compatibility ##
Everyone loves to joke about how crappy IE is, but you don't **truly** understand
until you're trying to make something compatible with it. My problems with IE started
before I could even look at the debugger, **literally**.

<div class="tagline"><h3>I couldn't even use the debugger. The browser
itself would show a stack trace whenever I tried to open it.</h3></div>

Do you know how hard it is to fix **major** CSS issues in IE without using the
debugger? It's even more difficult when some problems exist in IE10 but not IE11,
and *especially* when they exist in IE11 but not IE10 -- which, by the way,
makes me wonder: **how is that even possible?**

Thankfully, when I restarted my computer the next week the problem went away, so I could
finally use my debugger and actually test on IE10. I can say with certainty, however, that the
time spent fixing these IE issues was the most bored I have ever been at work. I
actually *dreaded* going to work because of how **boring** it was. Eek.

Now that I have worked on making something compatible in IE, it actually **scares** me
to think about what all of my sites might look like in that browser. I saw some **weird
stuff**, man.

## Hackathon / PSI Planning Tool ##
I also participated in my third hackathon! My team's project was a PSI planning tool
that teams could hopefully use a week and a half later for PSI planning. Our goal
for the hackathon was a web app in which teams could commit to features and add risks and
dependencies for each commitment, preferably using some type of wizard to make the process more
enjoyable. We had something like this for the hackathon, though the wizard that
someone on our team worked on was completely separate and was never hooked up
to the rest of the app or the back end and was discarded afterwards. We were definitely
too optimistic about how much the three of us could accomplish in one day!

Two of us continued working on the tool once the hackathon was over, but I ended up
doing all of the back end and most of the front end. This gave me pretty good
experience with Django and Angular. I knew Django going into this, but it's always
good to solidify things, and I got to try out Django REST Framework which I now love.
Seriously. I went into the hackathon thinking the package wouldn't do what I needed it to do
and that I would have to write the all of the urls and queries myself, but Django REST Framework
is super flexible and customizable. I also finally got to learn and use **a lot** of Angular!
MVC front end frameworks are great, and I'm excited now that I finally know one!

The company used it for PSI planning! If you want to read more, you can
[view the project entry](/#/portfolio/portfolio/psi-planning-tool) for it, and if
you want to see (or even use) the project, you can
[view it on GitHub](http://github.com/codeinpink/project-saturn).

Stay tuned for more info about the rest of my term!
