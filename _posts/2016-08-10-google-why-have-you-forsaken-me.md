---
layout: post
title: Google, Why Have You Forsaken Me?
img:
    url: /img/posts/virus-warning.png
    title: My Experience With Google Drive API
    alt: Google Drive virus scan warning
category: general
tags: google-api rant creative-frugality
type: hentry
footer_notes:
    - Yes, I know it's because I'm accessing all of that account's files.  Still, it shouldn't be so difficult to just get the list of some public files.
    - Not really.  "Pissed off" would be a more accurate assessment.
    - The only way to bypass it that seemed promising is sadly going away on August 31st http://stackoverflow.com/questions/20665881/direct-download-from-google-drive-using-google-drive-api.  :(
---

As I sit here staring at the HTML of a virus scan warning page, I wonder where I went wrong in my life.  Is this because I kept using Visual Basic and
didn't switch to C#?  Am I being punished for not buying a WinRAR license?  Is it because I (correctly) pronounce GIF with a soft G?

At this point, you may be wondering what tragic experience our Google overlords inflicted upon me.
To really understand my pain and suffering, I need to explain what I've dealt with the past 48 hours.

# My Idea
My goal the past few days has been to change how the launcher I'm writing for my game project downloads patches.
Before, it would connect to our temporary FTP server and struggle to download files because:

1. it's visual basic (maybe not a real reason but real enough in my eyes), and
2. it's some crappy, visual basic FTP dll

As our need for a temporary FTP server for development transformed into a permanent need
for deployment and distribution, we tried to find a good enough web host that was cheap enough to cover
our bandwidth needs for ~2000 players. It also needed to not care as much as US-based companies do about DMCA notices for a dead, 10 year old
Star Wars MMO.  This search was proving difficult.

That's when it hit me.  We've been using Google Drive to distribute the game files to our players.  It's free.
If the files get taken down then we can easily make a new account.  Why not use Google Drive as our CDN/patch server?

# Cue My Creative and Inevitable Struggle

## Predictability
I started writing a script in Python that generates a `manifest.json` that would contain all the patches and their relevant information,
such as the checksum and file path.  Still riding the high from discovering a new way to be
cheap and take advantage of the free resources out there, I coded away under the assumption that Google Drive files
have predictable URLs -- as if my years of using Google Drive as an online file storage suddenly vanished.

**They aren't predictable.**

<iframe src="//giphy.com/embed/CtoJMGuws3mqQ?html5=true" width="480" height="270" frameBorder="0" class="giphy-embed center-block" allowFullScreen></iframe>

Whoops.

## API Time
So now my only option was to use an API to get the list of files for this *public-to-literally-anyone-on-the-internet folder*.  Why am I emphasizing
the *public-to-literally-anyone-on-the-internet* part?  Because I figured I should be able to just query some REST endpoint to
get the data I need for this *public-to-literally-anyone-on-the-internet folder* and its *public-to-literally-anyone-on-the-internet files*,
but Google doesn't agree.

Guess what, kids?  You need to be **authorized**!

So I set up a bunch of API keys (took me a few times to figure out the one I *actually* needed) and downloaded one of their starter scripts that
took care of most of the work for me.  I ran it, hoping to see it print a list of 10 Google Drive files as specified in the script.  Instead
what I got was my internet browser prompting me to select which of my 10 Google accounts to use and if I wanted to allow
the script to view some information about my files.

Wat?

Why do I need to explicitly give permission to view files that I already made public to literally anyone on the internet? <a href="#footer-note-1" id="footer-reference-1"><sup>[1]</sup></a>

## pageSize? What pageSize?
Moving on, I discovered a few pleasant things:

- Google generates a MD5 checksum for each file, saving me time and effort
- Each file has a mime type (yes, even that `application/vnd.google-apps.folder`)
- You can view the parents of a file and use it to create a folder structure
- Each file actually has a *ton* of information (not that I need most of it)

The bad things:

- You have to explicitly request each field you want, such as `fields="files(id, name, md5Checksum, size)`.
I tried to use the docs and the try-it-yourself REST interface to get the list of fields I needed, but sadly some fields didn't
work.  Rather than play the guessing game, it was easier to just do `fields="files"` and call it a day (thanks, Stack Overflow! (sorry, Google server)).
- Specifying `pageSize`, contrary to what the docs say, doesn't actually work.  No matter what value you give it, it will always
return 100 results.  You'll need to use that `pageToken`.  Sorry!

## Download Pls
The most important field is the download URL; this is for downloading patches, after all.  This field proved to be the most difficult.

So I have my pretty-printed json manifest that my launcher gets and uses to compute which files it needs to download.  Everything
is going well until I try to actually download a file.  It downloads something, but not the file I wanted it to download: it's the HTML
of the download page.

Each file in the list contains a `webContentLink`, but simply downloading each file's `webContentLink` isn't going to work.  What I really
needed to download was the response's `ResponseUri`.  Kind of wonky to have the launcher visit a URL only to download something else, but
it works, I guess?

**Just kidding.**  At least, kinda.

It was working... for ~200 of the files.  It downloaded them, and the checksums matched up.  Some of them weren't working, though.
Every restart of the program would report that it needed to download 50ish files.  My first guess was to check the checksums: was it calculating
them correctly?  Next, maybe it was my logic.  Was I correctly accounting for case when comparing checksums?  Did I somehow mess up the conditions
that determine when I need to download a file?

As I was scrolling through the files trying to figure out what it could be, something in the corner of my eye caught my attention: a
crispy 36 KB under the Size column of my File Explorer window.  Actually, to be precise, multiple 36 KB entries.

Okay, maybe it's on Google's end.  Are they stopping my download at a certain
size?  My search reported nothing.  If they aren't limiting the download, then what the hell is the launcher downloading?

Because Atom seriously sucks for viewing large documents and while 36 KB isn't much I don't want to also deal with any possible disappointment
from my favorite text editor, I threw that `patch_09.tre` bad boy into Notepad++ and was amazed. <a href="#footer-note-2" id="footer-reference-2"><sup>[2]</sup></a>

**I was looking at yet another HTML document.**

<iframe src="//giphy.com/embed/QUCNMrMxExBeM?html5=true" width="480" height="360" frameBorder="0" class="giphy-embed center-block" allowFullScreen></iframe>

## But Wait, There's More!
Google detected that I was almost done and wanted to throw one more obstacle in my path -- only, this obstacle is more like tire killers
and I just lost my 2 front tires when I was almost at the finish line.

If you've ever downloaded a large file from Google Drive, you may remember being warned about how the file size exceeded the size that Google
can scan and that it may or may not contain a virus.  For each large file you would need to click "Download Anyway" to proceed.  See where
I'm going with this?

Downloading does work... If your file is under 25 MB.  At 25 MB Google warns you about a virus, and that 36 KB warning page is
what's being downloaded.  50ish times.

**Nice.**

So now I need to check the size of the file I'm about to download, and if it's >= 25 MB then I need to parse that page for the download
link inside that "Download Anyway" button since it's randomly generated each time you refresh the page.  Doable, right?  That means it's
not gonna work.  Sorry.

Google also sets a cookie with a randomized key/value pair, and I assume it verifies that with the confirm key in the "Download Anyway" link.

## Can't Stop, Won't Stop (Not Really)
Once I got to this section of the post I thought, "Hm, what if?" and attempted to work around this problem.  The key may be random, but I can
still get it from the header, and if I can get it and set it in my next request then maybe it will work instead of returning an error.

Well, after 30 minutes, I can say that's not doable. <a href="#footer-note-3" id="footer-reference-3"><sup>[3]</sup></a>

Maybe I'm missing some other cookies that might be needed, or maybe setting the cookies
isn't good enough because there's some other magical voodoo check that Google is doing to protect all the grandmas out there from
accidentally getting a virus instead of a picture of little Joey at soccer practice.

<iframe src="//giphy.com/embed/aMjfEsaBsbqCs?html5=true" width="480" height="415" frameBorder="0" class="giphy-embed center-block" allowFullScreen></iframe>

I could keep trying, but at this point I really need to ask myself why I keep trying to force this to happen when it so clearly
*isn't* going to happen.  In Google's eyes I'm some sinister hacker/malware-provider/something-else-bad, but really I'm just a nerd
who wants the thousands of other Star Wars nerds to enjoy this 10 year old, shut down, non-profit Star Wars MMO without having
to rely on even more donations to cover the bandwidth of an actual patch server.

After researching the alternatives, I think we'll probably need to just spend the money on an actual server and hope for the best.
I mourn the loss of what could have been great, though.  Google/Google Drive API crushed my frugal, creative
dreams and let me down, and it's time for me to go home.

<iframe src="//giphy.com/embed/3o7Zesyac4CuSN5rsA?html5=true" width="480" height="360" frameBorder="0" class="giphy-embed center-block" allowFullScreen></iframe>
