$(document).ready(function(){
  $(".stripe-button-el span").remove();
  $("button.stripe-button-el").removeAttr('style').css({
    "display": "inline-block",
    "margin-bottom": "0",
    "font-weight": "normal",
    "text-align": "center",
    "vertical-align": "middle",
    "cursor": "pointer",
    "background-image": "none",
    "border": "1px solid transparent",
    "white-space": "nowrap",
    "padding": "6px 12px",
    "font-size": "14px",
    "line-height": "1.428571429",
    "border-radius": "0px",
    "border-color": "#eea236",
    "background-color": "#f0ad4e",
    "color": "#FFF",
    "font-size":"1.3em" }).html("Donate");
});
