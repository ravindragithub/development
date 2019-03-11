({
   onRender : function(component, event, helper){
        var deviceHeight = screen.availHeight;
        var midHeight = deviceHeight + 25;
        var finalHeight = midHeight +"px";
        //alert(finalHeight);
        component.set("v.miniheight",finalHeight);
      
        
    }
})