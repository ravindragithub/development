({
	doInit : function(component) {
        var action = component.get("c.getCurrentUser"); // method in the apex class
        action.setCallback(this, function(a) {
            component.set("v.runningUser",a.getReturnValue());
        });
        $A.enqueueAction(action);
    },    
    onBackHome : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
        });
        urlEvent.fire();
    },    
    onServiceCenter : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/mykvh-support-landing'
        });
        urlEvent.fire();
    },
})