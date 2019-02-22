//Hides fields in the merchandises/new form depending on whether the Donate or Buy selection is chosen in the dropdown menu.

$(function() {
	$('#merchandise_buttontype').change(function(){
		if( $(this).val()==="Donate") {
			$('.perkField').hide("slow");
		} else {
			$('.perkField').show("slow");
		}
	});
});

//Shows uploader depending on selected filetype
$(function() {
	$('.audioField').hide();
	$('.ebookField').hide();
	$('.documentField').hide();
	$('.graphicField').hide();
	$('.videoField').hide();
	$('#perkFiletype').change(function(){
		$('.uploadLabel').show("slow");
		if( $(this).val()==="blank") {
			$('.audioField').hide();
			$('.ebookField').hide();
			$('.documentField').hide();
			$('.graphicField').hide();
			$('.videoField').hide();
		} else if( $(this).val()==="audio") {
			$('.audioField').show("slow");
			$('.ebookField').hide();
			$('.documentField').hide();
			$('.graphicField').hide();
			$('.videoField').hide();
		} else if( $(this).val()==="ebook") {
			$('.audioField').hide();
			$('.ebookField').show("slow");
			$('.documentField').show("slow");
			$('.graphicField').hide();
			$('.videoField').hide();
		} else if( $(this).val()==="graphic") {
			$('.audioField').hide();
			$('.ebookField').hide();
			$('.documentField').hide();
			$('.graphicField').show("slow");
			$('.videoField').hide();
		} else if( $(this).val()==="video") {
			$('.audioField').hide();
			$('.ebookField').hide();
			$('.documentField').hide();
			$('.graphicField').hide();
			$('.videoField').show("slow");
		}
	});
});