jQuery(document).ready(function($) {
	$('a[data-popup]').live('click', function(e) { 
    window.open($(this).attr('href')); 
    e.preventDefault(); 
}); 
}