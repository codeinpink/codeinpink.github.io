---
layout: post
title: "My First Term at ADTRAN"
date: 2015-07-30
img:
    url: /img/posts/adtran-2.jpeg
    title: An Overview of My First Term at ADTRAN
    alt: ADTRAN's Huntsville campus in late Winter/early Spring
category: general
tags: work
type: hentry
---
When I accepted an offer to co-op at ADTRAN, I was initially worried about what I'd work on.
ADTRAN is in the telecommunications industry, so most of their software
developers probably work on embedded programming. My resume had a lot on it, but all of
the recent things were web-related, and I wanted to learn back end web development.
However, I also wanted to work on something that wouldn't *just* be a typical CRUD
application. Would I find a fit? Would I enjoy my work?

**Yes!**

I obviously didn't know this back then, but many companies need some kind
of web development done; it doesn't have to be your typical customer-facing
website. In my case, it was one of ADTRAN's internal sites used to help developers
with packaging code. I was lucky to start my term when the site was still very small,
so I worked on a lot of fun features and saw the site grow from one page to 6-7 +
~200 (dynamic). Furthermore, the site wasn't just a CRUD application.

<div class="tagline"><h3>The features I worked on taught me a lot and, overall,
helped me grow as a programmer, software engineer, and web developer.</h3></div>

(In the rest of this post, when I refer to packages, I mean packages of code.)


## My Team ##
My team's responsibilities were maintaining and developing tools for packaging, getting
more of the code base packaged, and planning and guiding the future of packages at
the company.  One task that
all of us participated in was releasing packages, and a fun tradition was to send
funny pictures whenever one of us released a package. My pictures typically involved
cats, sea creatures, or weird animal hybrids -- the best kind of pictures.

## My Mentor ##
My mentor, Pat, was pretty awesome! He took my interests into consideration when planning
later features, provided excellent advice and guidance, and often taught me new things
and encouraged me to always learn more. He was also a fun person to share funny pictures
with, so there's that.

## Things I Worked On ##
I won't bore you with *literally every single thing* I worked on while at ADTRAN,
but I will give an overview of my term and talk about the things I found fun!

### First Few Releases ###
The beginning of my term was spent making small changes to the site: bug fixes,
a design overhaul, and small, new features or improvements, such as adding
autocomplete to email fields or adding a new form to the site. I also tried to
clean up (through refactoring or deleting) the site's code as I went along, and
I made small improvements whenever I could. These things were meant to get me accustomed
to the site's code and Python in general, a language I didn't know yet.

### Admin Page ###
In late February, I started releasing major updates to the site, the first being an admin
page to release packages. Before the admin page, releasing packages required doing a lot
of checks, SSHing into the package server, and manually moving a package from one folder to
the next (an obvious contender for automation, right?!). This was spread across multiple
windows, and if you weren't careful you could accidentally delete a folder or move it by
accident (*cough*). Being able to release a package through the site would at
least take care of the easily-automated portion -- plus ease the minds of the
(rightfully) paranoid.

The next release added onto the admin portion of the site by showing a list of
packages pending release, information on the request, and who was taking care of
the package (if anyone yet). It also added more actions, so the someone could
sign up for a package, reject a package, or release a package with the click
of a button.

My team *really* loved this one. To put this into perspective, a
few weeks prior we had *one* person request ~15-20 packages to be released at *once*,
and some of the packages needed fixing, so there was discussion in emails. **And it was
awful**. So many emails to go through, so many packages to keep track of, and so
many steps to go through for each package. With these changes, releasing a package
could take under two minutes if the changes were small enough.

This was my first experience building a dynamic page! Once finished loading, the page gets
the package request info from the server and constructs a table with it. The page
then fetches this data every 5 or 10 seconds and reconstructs the table if there
were any changes.

### Sharepoint Replacement AKA Release Notes Scraper  ###
The next major release was in late March for a SharePoint replacement (called
Release Notes Scraper) which would automatically post release notes of released
packages onto the package site. Before this, teams would have to frustratingly
deal with posting release notes on SharePoint every time they released
a new package version -- and the release notes were typically just copy-pasted,
yet another contender for automation!

Getting the release notes file was easy; Python's tarfile library made it
simple to get a list names of the contents inside each package tarball, so I just
had to get the file with "releasenotes.txt" in its name. From there, I had to make some
assumptions about the content of the file. Fortunately, one of the requirements to
release a package was that the release notes needed to contain the previous
release notes and release versions, the current release notes, and the current
release version, so I could assume it had these things. The problem was that
people also included other information between the release version and the
release notes. This stuff could be useful to collect, but it meant that parsing
these files wouldn't be so uniform. From looking at random packages, I made my
assumptions:

* Releases are separated by at least two "="
* The release notes may reference a previous release (and thus include a previous
release version)
* A release header contains the version number and misc. info, and it is separated
from the release notes by yet another two "="

Using these assumptions, I made my release parser as a state design pattern which
would determine the current line type based on regex and then insert the line into
the appropriate dictionary key. I would just need to feed it the contents of the
file, and it would signal when done, returning to me the contents of a release
separated into the version, date, header, and release notes. From there, I just
needed to call this after every release and then store the results in the database.

To take care of the old releases for all ~200 packages as well as
any packages that might be missed on a day-to-day basis, I made a thread that would
collect all of the releases for every package once a day using the latest release
for that package. Since each release should contain the previous releases' release
notes, I could use one release per package to get all of the release notes while
avoiding having to go through each release for every package. Efficient!

The next release added onto this by offering the ability to subscribe to and unsubscribe
from packages for release notifications via email. This was one of the features of
using SharePoint, and if we were going to replace SharePoint, we obviously needed
to offer this feature, too.

The SharePoint Replacement/Release Notes Scraper was my biggest release and my
favorite!

<div class="tagline"><h3>It was pretty big, wanted by many people, and it was
fun designing the different parts of this system and making them interact with each other.</h3></div>

I also got some good experience working with a database and good exposure to MongoDB, a type of database that
wasn't covered in my Database Management class.

## Final Releases ##
The last few features of my term were pretty small. I got a little experience with
D3.js by adding a feature that would track the number of files in one of
our products and then using this information in a graph which would show changes
over time.

The next feature tracked the different package requests (release/creation), and I
added a page with a simple date-picker so my team would be able to get these
numbers for a specified time range.

My last feature was actually incorporating my second hackathon project into the
site! See below to read about it.

## Hackathons ##
One of the really cool things about ADTRAN is that it has internal hackathons once (sometimes twice!) an iteration.
It's only for one day, and you work on your project during work hours, so it doesn't require any weekend commitments
or crazy hours (thankfully); the only requirement is that it benefits the company!

I participated in my first hackathon in mid February as part of my mentor's group,
and we won our category! I did the front end work for the project, so I
worked with JavaScript and jQuery to display and update certain data.

In mid April (actually a few days before my birthday!), I participated in my
second hackathon. This project automatically generated online documentation
for each package using Doxygen and converted each package's user guide into
HTML. Just like with the Release Notes Scraper, this would generate the
documentation/convert the user guide after a package is released and would run daily
to catch any missing packages. We didn't win, but I was really happy with the project
because it was really useful to any package users at ADTRAN, and I had plenty of time
left in the term to implement it into the site!

Now that I have experienced two hackathons, I really hope my future company has
them, too!

## Testing ##
Like many other Computer Science students have experienced, college doesn't really
teach you to test your code. If we want to know that something works, we'll run our
code and add in some print statements. Thankfully, this isn't how it's done in
the real world -- at least, *I hope not*. I learned how to test my code and how
important testing is.

<div class="tagline"><h3>Of course it's useful to make sure the code you're
writing works, but it also helps to know that you didn't break any
existing code in the process.</h3></div>

We tested as much of the site as we could, so I had to write *a lot* of tests.
In particular, I got a lot of experience using Selenium WebDriver, a browser
automation tool. We used Selenium WebDriver to test each of the site's pages by
going through actions like a typical user would and then checking that everything was working
properly. I can't recommend Selenium WebDriver enough.

## In Conclusion ##
Overall, my first term was pretty great! I was fortunate enough to have an
awesome mentor and get to work on things that were really interesting and fun.
This term also taught me *so* much about programming, Python, testing, and web development!
This experience was very rewarding, and I hope my next term will be just as great!
