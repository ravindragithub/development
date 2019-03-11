({
    fetchuserDetails: function(component, event, helper) {        
        console.log("Parent profile component");
        var action = component.get("c.getUserDetails");        
        action.setCallback(this, function(response) {
            console.log("==state=="+state);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.userdetail",response.getReturnValue());   
                var appEvent = $A.get("e.c:myKVH_profileSpinnerEvent");
                appEvent.setParams({
                    "showspinner": "slds-hide"
                });
                appEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on profile load: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error profile view");
                }
            }
        });
        $A.enqueueAction(action);
    }
})