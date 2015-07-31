function initReadMore() {
    $('#description, #reflection').readmore({
        collapsedHeight: 200,
        moreLink: '<div class="text-center"><a href="#" class="text-center button small">Read More</a></div>',
        lessLink: '<div class="text-center"><a href="#" class="text-center button small">Read Less</a></div>'
    });
}
