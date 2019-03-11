({
	
    getImagelisthelper: function(component, event, helper) {
        console.log('in side apex getImagelisthelper');
        var action = component.get("c.getImagelist");
        console.log(action,component);
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('@@ getImagelist');
                console.log(response.getReturnValue());
                            
                component.set("v.imagelst", response.getReturnValue());      
               
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handlePortalViewChangeEvent: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})