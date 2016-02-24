jQuery(document).ready(function($) {
  $('.hiddenamore').removeClass('hiddenamore').hide();
  $('.accordion-togglea').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hiddenrmore').removeClass('hiddenrmore').hide();
  $('.accordion-toggler').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hiddencmore').removeClass('hiddencmore').hide();
  $('.accordion-togglec').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hiddenomore').removeClass('hiddenomore').hide();
  $('.accordion-toggleo').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hiddencardform').removeClass('hiddencardform').hide();
  $('.togglecard').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
});

