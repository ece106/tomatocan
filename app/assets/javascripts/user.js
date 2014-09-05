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
