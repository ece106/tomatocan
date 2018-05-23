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
  $('.hidden1more').removeClass('hidden1more').hide();
  $('.accordion-toggle1').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden2more').removeClass('hidden2more').hide();
  $('.accordion-toggle2').click(function() {
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
  $('.hidden6more').removeClass('hidden6more').hide();
  $('.accordion-toggle6').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden7more').removeClass('hidden7more').hide();
  $('.accordion-toggle7').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden8more').removeClass('hidden8more').hide();
  $('.accordion-toggle8').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden9more').removeClass('hidden9more').hide();
  $('.accordion-toggle9').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden10more').removeClass('hidden10more').hide();
  $('.accordion-toggle10').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden11more').removeClass('hidden11more').hide();
  $('.accordion-toggle11').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden12more').removeClass('hidden12more').hide();
  $('.accordion-toggle12').click(function() {
    $(this).find('span').each(function() { $(this).toggle(); });
  });
  $('.hidden13more').removeClass('hidden13more').hide();
  $('.accordion-toggle13').click(function() {
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

