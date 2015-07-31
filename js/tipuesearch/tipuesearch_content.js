---
---

var tipuesearch = {"pages": [
    {"title": "Home",
    "text": "Home.",
    "tags": "home, index",
    "url": "{{ site.url }}/"},
    {"title": "About Me",
    "text": "A little about me, including my interests and some random facts!",
    "tags": "about, interests, random facts",
    "url": "{{ site.url }}/#/about"},
    {"title": "Resume",
    "text": "An overview of my resume, including my education, work history, development skills, and more.",
    "tags": "resume, skills, education, school, work, experience, awards, honors, languages, frameworks, databases",
    "url": "{{ site.url }}/#/resume"},
    {"title": "Blog",
    "text": "My latest thoughts, posts, and inspirations.",
    "tags": "blog, latest posts, tutorials",
    "url": "{{ site.url }}/blog"},
    {"title": "Portfolio",
    "text": "My portfolio of projects that I can show.",
    "tags": "portfolio, projects",
    "url": "{{ site.url }}/#/portfolio"},
    {"title": "Contact",
    "text": "Feel free to email me or fill out the contact form to get in touch.",
    "tags": "contact, form, email",
    "url": "{{ site.url }}/#/contact"},

    {% for project_page in site.data.projects %}
    {% assign project = project_page[1] %}
    {"title": "{{ project.title | xml_escape }}",
    "text": "{{ project.description | truncatewords: 50 | markdownify | strip_html | replace_regex:'\n', ' ' }}",
    "tags": "{{ project.category }}, project, {{ project.technology | array_to_sentence_string }}",
    "url": "{{ project.dir | prepend: '/' | prepend: site.url }}"},
    {% endfor %}

    {% for post in site.posts %}
    {"title": "{{ post.title | xml_escape }}",
    "text": "{{ post.excerpt | markdownify | strip_html | replace_regex:'\n', ' ' }}",
    "tags": "{{ post.category }}, {{ post.tags | array_to_sentence_string }}",
    "url": "{{ post.dir | prepend: site.url }}"}{% unless forloop.last %},{% endunless %}
    {% endfor %}
]};
