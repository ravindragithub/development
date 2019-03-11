({
    loadOptions : function(component, event, helper) {
        var action = component.get("c.getSearchOptions");
        action.setParams({ fieldName : component.get("v.fieldname") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.searchoptions", response.getReturnValue() );
            }            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on loadOptions: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    collapseexpand : function(component, event, helper) {        
        var toggleText = document.getElementById(component.get("v.sectiontitle")) ;
        //alert(toggleText);
        $A.util.toggleClass(toggleText, "slds-is-collapsed");
    }
})