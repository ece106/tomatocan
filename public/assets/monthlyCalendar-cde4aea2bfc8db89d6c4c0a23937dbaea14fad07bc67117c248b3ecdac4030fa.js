$(document).ready(function(){
    $('.days').click(function() { 
        if ($( window ).width() < 750) {
            // Get the modal for the current day
            var currModal = $(this).find("div[id*='modal']")[0]

            // Get the <span> element that closes the modal
            var closeButton = $(this).find("span[class*='close']")[0]

            // Show the modal
            $(currModal).show();

            // When the user clicks anywhere outside of the modal or on the x button, close it
            window.onclick = function(event) {
                if (event.target == currModal || event.target == closeButton) {
                    $(currModal).hide();
                }
            }

            // When the user resizes the window to a larger size and the modal was showing, close the modal
            $( window ).resize(function() {
                if (($(currModal).attr("display") != "none") && ($( window ).width() > 750)) {
                    $(currModal).hide();
                }
            });
        }
    });
});
