({
    fetchLoggedInUserDetails : function(component) {
        var action = component.get("c.getCurrentUser"); // method in the apex class
        action.setCallback(this, function(a) {
            console.log('header loading');
            console.log(a.getReturnValue());
            component.set("v.runningUser",a.getReturnValue());
            //component.set("v.selectedPortalView",a.getReturnValue().Portal_View__c);
            component.set("v.currentUserType",a.getReturnValue().Profile.Name.split('-')[1]) ;
        });
        $A.enqueueAction(action);
    }
})