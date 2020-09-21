!function(d,s,id){
  var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
  if(!d.getElementById(id)){
    js=d.createElement(s);
    js.id=id;js.src=p+"://platform.twitter.com/widgets.js";
    fjs.parentNode.insertBefore(js,fjs);
  }
}(document,"script","twitter-wjs");

  (function(i,s,o,g,r,a,m)
    {i['GoogleAnalyticsObject']=r;i[r]=i[r]||function()
      {(i[r].q=i[r].q||[]).push(arguments)},
      i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];
      a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })
  (window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-150909386-1', 'auto');
  ga('send', 'pageview');

 // Check if current url is a profileinfo or edit page. urlArray[3] == "stories" &&

var urlArray = window.location.href.split( '/' );

if ( urlArray[4] == "profileinfo?")  {

  function youtube1userCountdown() 
  {  
    var remaining = 255 - jQuery('#user_videodesc1').val().length;
    jQuery('.viddesc1usercount').text(remaining + ' characters remaining');
  }
  jQuery(document).ready(function($) 
  {
    youtube1userCountdown();
    $('#user_videodesc1').change(youtube1userCountdown);
    $('#user_videodesc1').keyup(youtube1userCountdown);
  });

  function youtube2userCountdown() 
  {  
    var remaining = 255 - jQuery('#user_videodesc2').val().length;
    jQuery('.viddesc2usercount').text(remaining + ' characters remaining');
  }
  jQuery(document).ready(function($) 
  {
    youtube2userCountdown();
    $('#user_videodesc2').change(youtube2userCountdown);
    $('#user_videodesc2').keyup(youtube2userCountdown);
  });
  
  function youtube3userCountdown() 
  {  
    var remaining = 255 - jQuery('#user_videodesc3').val().length;
    jQuery('.viddesc3usercount').text(remaining + ' characters remaining');
  }
  jQuery(document).ready(function($) 
  {
    youtube3userCountdown();
    $('#user_videodesc3').change(youtube3userCountdown);
    $('#user_videodesc3').keyup(youtube3userCountdown);
  });
}
else if ( urlArray[4] == "edit?")  {  
  function updateCountdown() 
  {   
    var remaining = 140 - jQuery('#book_fiftychar').val().length;
    jQuery('.charcount').text(remaining + ' characters remaining');
    if(remaining <= 0)
    {
      $("input.btn.btn-large.btn-primary").attr("disabled", "true"); 
    } //not doing a button at this time but keeping code for future example
    else
    {
      $("input.btn.btn-large.btn-primary").removeAttr("disabled");
    }
  }
  jQuery(document).ready(function($) 
  {
    updateCountdown();
    $('#book_fiftychar').change(updateCountdown);
    $('#book_fiftychar').keyup(updateCountdown);
  });

  function blurbCountdown() 
  {  
    var remaining = 2000 - jQuery('#book_blurb').val().length;
    jQuery('.blurbcount').text(remaining + ' characters remaining');
  }
  jQuery(document).ready(function($) 
  {
    blurbCountdown();
    $('#book_blurb').change(blurbCountdown);
    $('#book_blurb').keyup(blurbCountdown);
  });

  function youtube1bookCountdown() 
  {  
    var remaining = 255 - jQuery('#book_bkvideodesc1').val().length;
    jQuery('.youtube1bookcount').text(remaining + ' characters remaining');
  }
  jQuery(document).ready(function($) 
  {
    youtube1bookCountdown();
    $('#book_bkvideodesc1').change(youtube1bookCountdown);
    $('#book_bkvideodesc1').keyup(youtube1bookCountdown);
  });

  function youtube2bookCountdown() 
  {  
    var remaining = 255 - jQuery('#book_bkvideodesc2').val().length;
    jQuery('.youtube2bookcount').text(remaining + ' characters remaining'); 
  }
  jQuery(document).ready(function($) 
  {
    youtube2bookCountdown();
    $('#book_bkvideodesc2').change(youtube2bookCountdown);
    $('#book_bkvideodesc2').keyup(youtube2bookCountdown);
  });
}
  
