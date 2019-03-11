({
	showeditsection : function(component, event, helper) {
		 var appEvent = $A.get("e.c:myKVH_profileEditClickEvent");
            appEvent.setParams({
                "showview": false,
                "showedit": true,
                "showThankyou": false
         });
         appEvent.fire();
	},
    refreshHome : function(component) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"
        });
        urlEvent.fire();
    },    
    techSupportRedirect : function(component) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/mykvh-technical-support"
        });
        urlEvent.fire();
    },    
})