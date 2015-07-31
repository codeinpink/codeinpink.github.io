---
layout: post
title: "Adding Autocomplete/Suggestions to Inputs Through Twitter's Typeahead"
date: 2015-07-29
img:
    url: /img/posts/typeahead.png
    title: "How to Add Twitter's Typeahead Library to Your Site"
    alt: "A screenshot of Twitter's Typeahead library in action"
category: web development
tags: javascript tutorial typeahead jQuery
type: hentry
preview: "http://mymovielib.com/"
related_articles:
- {title: "Typeahead Github Page", url: "https://github.com/twitter/typeahead.js"}
- {title: "Typeahead Examples", url: "https://twitter.github.io/typeahead.js/examples/"}
- {title: "Typeahead Documentation", url: "https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md"}
- {title: "Bloodhound Documentation", url: "https://github.com/twitter/typeahead.js/blob/master/doc/bloodhound.md"}
---

I recently used Twitter's JavaScript library **typeahead.js** (now referred to
as **typeahead** in the rest of the post) in one of my projects,
[MovieLib](http://mymovielib.com/), and I can't wait to use it again!
Once I understood how to use it, it was easy to implement it into my project, and I
think it really improved the user experience in a few areas of the site.

This post will show the code/styling I used to achieve the autocomplete that MovieLib uses.
I remember I couldn't quite get my suggestions working right when I first started out,
so hopefully this helps out someone else!

## Some Background ##
The first place I implemented typeahead is in the search bar, so users can see movie results as they
type in the title of the movie they're looking for. The more important place, however,
is in one of the forms used to add movies to a user's library.

By default, the form's input for the movie field is a select field, but since MovieLib has more than
400,000 movies in the database, loading all of those into the user's form would *surely*
fail. The second option is to change the form input to a text field, which then
presents two more options: title or id? Since one movie can share a title with many
other movies, the title can't be used here since the server won't know what movie to add.
The IMDB ID is the clear winner.

<div class="tagline"><h3>But, that's <em>still</em> wrong because what user would want
to google for the IMDB ID of each movie they own <em>just</em> to add it to their library?</h3></div>

This is where typeahead comes in! The user can type the movie title into a text field,
select the movie, and the server will get the IMDB ID of the movie selected. Crisis
averted!

## Getting Started
First, visit [typeahead's github page](https://github.com/twitter/typeahead.js) and
download [typeahead.bundle.js](http://twitter.github.io/typeahead.js/releases/latest/typeahead.bundle.js) or [typeahead.bundle.min.js](http://twitter.github.io/typeahead.js/releases/latest/typeahead.bundle.min.js). This library depends
on [jQuery](https://jquery.com/), so you obviously need that, too. Make sure these files
are included.

## Adding Typeahead to Search Bar
Add your search input if you don't have one already, and make sure you have a way to uniquely identify this input. Mine looked like this:

{: .prettyprint}
~~~
<input type="text" class="form-control typeahead" name="q" id="q" placeholder="Search Movies...">
~~~

To start with, we need to initialize our search bar's typeahead once the page is
done loading, so add this to your JavaScript file:

{: .prettyprint .linenums}
~~~
$(document).ready(function() {
    setSearchAutocomplete();
}
~~~

Next, we need to make the setSearchAutocomplete function that will be called.
Add the following function:

{: .prettyprint .linenums}
~~~ javascript
function setSearchAutocomplete() {
    var movies = new Bloodhound({
        datumTokenizer: function(d) {return Bloodhound.tokenizers.whitespace(d.title); },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: {
            url: '/autocomplete/movies?q=%QUERY%',
            wildcard: '%QUERY%'
        }
    });

    // .typeahead is the selector for my search bar
    setTypeaheadBinding('.typeahead', movies);
}
~~~

This function creates a Bloodhound object and then calls
a function to initialize typeahead using this Bloodhound object on the given selector.
Bloodhound is the suggestion engine that you're passing in when you initialize
your instance of typeahead. Here is a break down of what each part does:

- This queryTokenizer removes the whitespace before it tokenizes the query (turns
it into an array of string tokens)

- The datumTokenizer is what tokenizes each datum. Like with the queryTokenizer,
I want it to remove the whitespace, but I also want it to return the title of the
datum object. Why? Because when it gets data from the
specified URL, the server returns results in this format:
```[{"title": title "imdb_id": imdb_id, "plot": plot, "year": year, "poster": poster}, {...}, ...]```
I want my suggestions to be based off of the title of the movie, so that's why I
return the title of the datum object. Without returning the title, it will base
suggestions off of *all* properties of the datum object (plot, year, etc), which wouldn't be useful.
If you're wondering what the other information is for, I use those in the movie
suggestion displays (or "movie cards").

- Bloodhound can either have a local source or a remote source, and since I am dealing
    with movie suggestions, I use remote so that it can fetch results for the given
    query from my server

Bloodhound has other options which you can utilize, such as prefetching data, and
you can even make your own tokenizers, but this was all I needed.

Now, we will finally initialize typeahead on our given element. Add the following
function:

{: .prettyprint .linenums}
~~~
function setTypeaheadBinding(selector, adapter) {
    $(selector).typeahead(null, {
        name: 'movies',
        displayKey: 'title',
        source: adapter.ttAdapter(),
        templates: {
            empty: [
                '<div class="empty-message text-center">',
                'No movies found.<br>',
                '<a href="/search" class="text-center">More Advanced Search</a>',
                '</div>',
            ].join('\n'),
            suggestion: function(data) {
                return ['<div class="movie-card">',
                      '<img class="movie-card-poster" src="' + data.poster + '">',
                      '<div class="movie-card-details">',
                      '<div class="movie-card-name">' + data.title + '</div>',
                      '<div class="movie-card-year pull-right">' + data.year + '</div>',
                      '<div class="movie-card-plot">' + data.plot + '</div>',
                      '</div>',
                      '</div>'].join('\n');
            },
            footer: '<a href="/search" id="view-more-movies" class="btn btn-primary btn-sm text-center center-block">View More</a>'
        }
    });
}
~~~

This function initializes typeahead on the selector using the adapter passed in -- the Bloodhound
object created in the previous function. As you can see, typeahead lets you customize
every part of the display, so you can get it to look just how you want it to look.
Most of this initialization is just setting the templates, so here's the CSS to go with it:

{: .prettyprint .linenums}
~~~
/** Twitter Typeahead **/
.twitter-typeahead, .typeahead, .empty-message  {
    width: 100%;
}

.tt-menu {
    background: white;
    width: 100%;
}

.tt-suggestion {
    overflow: hidden;
    display: table;
    width: 100%;
    padding: 10px 10px;
    border-bottom: 1px solid #e9ecf2;
}

/** Movie Card (Movie Suggestions) **/
.movie-card {
    position: relative;
    padding: 8px;
}

.movie-card-poster {
    position: absolute;
    top: 8px;
    left: 8px;
    width: 52px;
    height: 52px;
    border: 2px solid #ccd6dd;
    border-radius: 5px;
}

.movie-card:hover .movie-card-poster {
    border-color: #f5f8fa;
}

.movie-card-details {
    min-height: 60px;
    padding-left: 60px;
}

.movie-card-name,
.movie-card-year {
    display: inline-block;
}

.movie-card-name {
    font-weight: 700;
}

.movie-card-year {
    color: #8899a6;
}

.movie-card:hover .movie-card-year {
    color: #fff;
}

.movie-card-plot {
    margin-top: 5px;
    font-size: 14px;
    line-height: 18px;
}

.movie-card:hover,
.movie-card.is-active {
    color: #fff;
    background: #0088CC;
    cursor: pointer;
}

.empty-message {
    position: relative;
    padding: 10px;
    font-size: 16px;
    line-height: 30px;
    text-align: center;
}
~~~


The suggestion display ("movie card") for a movie is based off of the "user card"
on Twitter and used a lot of CSS from a typeahead example. I use some helper
classes from Bootstrap, so if you aren't using Bootstrap, then you'll need to add
in the alignments yourself so things look right.

## View More Results##
This isn't really anything specific to typeahead; this is just something useful.
At the bottom of each list of suggestions, I have a link to view more results,
and this function simply takes the current search term and includes it in the
query. This way, when the user clicks the link, the search page will actually
show all of the results for their current search term and not just bring them to
a blank search page.

{: .prettyprint .linenums}
~~~
// #view-more-movies is the link shown at the bottom of the list of suggestions
$(document).on('click', '#view-more-movies', function(e) {
    e.stopPropagation();
    e.preventDefault();
    query = $(e.target).parent().parent().siblings('.tt-input').val();
    window.location.href = '/search?q=' + encodeURIComponent(query);
});
~~~

## Do Something When User Clicks a Suggestion ##
On MovieLib, when a user clicks on a suggestion from the search bar, a modal will
pop up with info on that movie. To display that modal, I need to get the IMDB ID from the
suggestion so I know what movie to fetch:

{: .prettyprint .linenums}
~~~
$('.typeahead').on('typeahead:selected typeahead:autocompleted', function(e, datum) {
    $.magnificPopup.open({
        items: {
            src: 'movies/view/' + datum.imdb_id
        },
        type: 'ajax'
    });
});
~~~

You probably aren't using Magnific Popup, but as you can see, you can easily access
properties of the datum object that was selected. This example also shows just how
easy typeahead makes it to bind to certain typeahead events!
For a full list of typeahead events you can bind to, click [here](https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md#custom-events).

## Using Typeahead in Forms ##
MovieLib also uses typeahead in the "Add Movie" forms. What the server expects
from the form is an IMDB ID to indicate the movie being added, so when a user
selects a movie, all I need to do is set the value of the movie input.  If you're
wondering why I'm using two different inputs here, it's because of how Django
handles form widgets. It was easier to add a second input to use for the suggestions
and make the *actual* movie input hidden from the user.

{: .prettyprint .linenums}
~~~
// #select-movie is the input I used to initialize typeahead
$('#select-movie').on('typeahead:selected typeahead:autocompleted', function(e, datum) {
    // this input is the input that needs the imdb_id value
    $('input[name=movie]').val(datum.imdb_id);
});
~~~

## In Conclusion ##
So, that basically wraps it up! I recommend looking at the documentation for
typeahead if you want to do more with it. It's definitely a fun library
to mess around with! To see these examples in action, check out my site below!
