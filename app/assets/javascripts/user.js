!function(d,s,id){
	var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
	if(!d.getElementById(id)){
		js=d.createElement(s);
		js.id=id;js.src=p+"://platform.twitter.com/widgets.js";
		fjs.parentNode.insertBefore(js,fjs);
	}
}(document,"script","twitter-wjs");

    function OneStat_Pageview()    {
        var d=document;
        var sid="436141";
        var CONTENTSECTION="";
        var osp_URL=d.URL;
        var osp_Title=d.title;
        var t=new Date();
        var p="http"+(d.URL.indexOf('https:')==0?'s':'')+"://stat.onestat.com/stat.aspx?tagver=2&sid="+sid;
        p+="&url="+escape(osp_URL);
        p+="&ti="+escape(osp_Title);
        p+="&section="+escape(CONTENTSECTION);
        p+="&rf="+escape(parent==self?document.referrer:top.document.referrer);
        p+="&tz="+escape(t.getTimezoneOffset());
        p+="&ch="+escape(t.getHours());
        p+="&js=1";
        p+="&ul="+escape(navigator.appName=="Netscape"?navigator.language:navigator.userLanguage);
        if(typeof(screen)=="object"){
           p+="&sr="+screen.width+"x"+screen.height;p+="&cd="+screen.colorDepth;
           p+="&jo="+(navigator.javaEnabled()?"Yes":"No");
        }
        d.write('<a href="http://www.onestatfree.com/aspx/login.aspx?sid='+sid+'" target=_blank ><img id="ONESTAT_TAG" width = "0" height="0" border="0" src="'+p+'" ></'+'a>');
    }
    OneStat_Pageview();

function updateCountdown() 
{  
  var remaining = 140 - jQuery('#book_fiftychar').val().length;
  jQuery('.charcount').text(remaining + ' characters remaining');
  if(remaining <= 0)
  {
      $("input.btn.btn-large.btn-primary").attr("disabled", "true");
  }
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
  if(remaining <= 0)
  {
      $("input.btn.btn-large.btn-primary").attr("disabled", "true");
  }
  else
  {
      $("input.btn.btn-large.btn-primary").removeAttr("disabled");
  }
}

jQuery(document).ready(function($) 
{
  blurbCountdown();
  $('#book_blurb').change(blurbCountdown);
  $('#book_blurb').keyup(blurbCountdown);
});

//editblurbcount doesn't work
function editblurbCountdown() 
{  
  var remaining = 2000 - jQuery('#booklist_blurb').val().length;
  jQuery('.signup').text(remaining + ' characters remaining');
  if(remaining <= 0)
  {
      $("input.btn.btn-large.btn-primary").attr("disabled", "true");
  }
  else
  {
      $("input.btn.btn-large.btn-primary").removeAttr("disabled");
  }
}

jQuery(document).ready(function($) 
{
  editblurbCountdown();
  $('#booklist_blurb').change(editblurbCountdown);
  $('#booklist_blurb').keyup(editblurbCountdown);
});

