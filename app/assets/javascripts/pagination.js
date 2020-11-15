// this function uses AJAX to send a GET request whenever a pagination link is clicked 
$(function () {
    $('.pagination a').click(function () {
        $.get(this.href, null, null, 'script');
        return false;
    });
});