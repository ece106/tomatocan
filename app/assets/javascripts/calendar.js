function adjustCalendar(currentWidth){
  if(currentWidth > 660){
    $(".lgEvents").show();
    $(".smEvents").hide();
    $(".caler").css("width", "100%");
    $(".caler td").each(function(){
      $(this).css("height", "150px");});
  } else {
    $(".lgEvents").hide();
    $(".smEvents").show();
    $(".caler").css("width", "490px");
    $(".caler").css("margin", "auto");
    $(".caler td").each(function(){
      $(this).css("height", "45px");});
  }
}

$(document).ready(function(){
  adjustCalendar($(window).width());
});

$(window).resize(function(){
  adjustCalendar($(window).width());
});

function monthMoreEvents(button){
  $(button).prev().toggle();
  $(button).siblings('.dots').toggle();
  $(button).find('.total').show();
  if($(button).text()=='More Conversations'){
    $(button).text('Less Conversations');
  } else {
    $(button).text('More Conversations');
  }
}
