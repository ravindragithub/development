({
	onBackHome : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
        });
        urlEvent.fire();
    },
})