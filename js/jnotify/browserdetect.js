$(document).ready(function(){
    var userAgent = navigator.userAgent.toLowerCase();
    $.browser.chrome = /chrome/.test(navigator.userAgent.toLowerCase()); 
    
    if($.browser.msie){
        $('body').addClass('bIE');
        $('body').addClass('bIE' + $.browser.version.substring(0,1));
    }
    
    if($.browser.chrome){
    
        $('body').addClass('bChrome');
        
        userAgent = userAgent.substring(userAgent.indexOf('chrome/') +7);
        userAgent = userAgent.substring(0,1);
        $('body').addClass('bChrome' + userAgent);
        
        $.browser.safari = false;
    }
    
    if($.browser.safari){
        $('body').addClass('bSafari');
        
        userAgent = userAgent.substring(userAgent.indexOf('version/') +8);
        userAgent = userAgent.substring(0,1);
        $('body').addClass('bSafari' + userAgent);
    }
    
    if($.browser.mozilla){
        
        if(navigator.userAgent.toLowerCase().indexOf('firefox') != -1){
            $('body').addClass('bFirefox');
            
            userAgent = userAgent.substring(userAgent.indexOf('firefox/') +8);
            userAgent = userAgent.substring(0,1);
            $('body').addClass('bFirefox' + userAgent);
        }
        else{
            $('body').addClass('bMozilla');
        }
    }
    
    if($.browser.opera){
        $('body').addClass('bOpera');
    }
});
