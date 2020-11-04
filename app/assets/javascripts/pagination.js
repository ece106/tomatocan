// this function uses AJAX to send a GET request whenever the pagination links in the calendar list view are clicked 
$(function () {
    $('.pagination a').click(function () {
            $.get(this.href, null, null, 'script');
            return false;
    });
});