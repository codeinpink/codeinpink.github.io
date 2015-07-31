$(document).ready(function() {
    $('.header-search').slideToggle();
    $('#search').tipuesearch();
    $('.blog-posts h1').append(' - "' + $('input#search').val() + '"');
});
