({
    helperMethod : function(component) {
        var action = component.get("c.getBillingAccountList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From helperMethod : " + JSON.stringify(response.getReturnValue()));
                component.set("v.accountHierarchyWrapper",response.getReturnValue());
                if(response.getReturnValue().length > 0){
                    var intiMethod = response.getReturnValue();
                    if(intiMethod[0].typeOfWrapper != undefined)
                        component.set("v.typeForm",intiMethod[0].typeOfWrapper); 
                }
                else
                    component.set("v.isOpen",false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
})