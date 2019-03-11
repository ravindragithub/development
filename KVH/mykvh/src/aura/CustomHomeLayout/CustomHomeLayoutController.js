({
	onRender : function(component, event, helper){
        var deviceHeight = screen.availHeight;
        var midHeight = deviceHeight + 25;
        var finalHeight = midHeight +"px";
        //alert(finalHeight);
        component.set("v.miniheight",finalHeight);
    },
    toggleSpinner: function(cmp, event, helper) {
      
        var spinner = cmp.find("custommySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
    
})