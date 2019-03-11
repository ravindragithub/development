({
    onRender : function(component, event, helper){    
       /* var deviceHeight = window.screen.availHeight;  
        var width = window.screen.availWidth;
        var headerheight = 60;
        var footerheight;
        if(width < 750){
            footerheight = 144;
        }
        else if(width > 750 && width < 1400){
            footerheight = 117;            
        }
            else if(width > 1400 ){
                footerheight = 104;            
            }
        var finalHeight = deviceHeight - headerheight - footerheight;
        component.set("v.maxheight",finalHeight);*/
        var width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);        
        var deviceHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);     
        var headerheight = 60;
        var footerheight = 90;
        if(width < 750){
             footerheight = 90;
        }
        var finalHeight = deviceHeight - headerheight - footerheight;
       // alert(finalHeight);
        component.set("v.maxheight",finalHeight);
    },
})