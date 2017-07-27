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
  $('.hidden3more').removeClass('hidden3more').hide();
  $('.accordion-toggle3').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden4more').removeClass('hidden4more').hide();
  $('.accordion-toggle4').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden5more').removeClass('hidden5more').hide();
  $('.accordion-toggle5').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });


  $('.cardinfo').hide();
  $('.buynewcard').hide();
  $('.usedefault').hide();
  $('.usedefault').click(function() {
    $('.last4').show();
    $('.diffcard').show();
    $('.buyexistingcard').show();
    $('.cardinfo').hide();
    $('.buynewcard').hide();
    $('.usedefault').hide();
  });
  $('.diffcard').click(function() {
    $('.cardinfo').show();
    $('.buynewcard').show();
    $('.usedefault').show();
    $('.last4').hide();
    $('.diffcard').hide();
    $('.buyexistingcard').hide();
  });

});

