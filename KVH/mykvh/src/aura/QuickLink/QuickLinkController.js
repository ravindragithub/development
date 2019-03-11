({
    loadQuickLinks: function(component, event, helper) {
         console.log('@@ v.quicklinks start');
        var action = component.get("c.constructQuickLinks");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //component.set("v.quicklinks", response.getReturnValue());
                console.log('@@ v.quicklinks');
                // console.log(component.get("v.quicklinks"));
                var remaningItems = 0;
                var linklst =  response.getReturnValue();
                var blankQuicklink = component.get("v.blankQuicklink")
                if(linklst.length>0){
                    remaningItems = linklst.length % 4;                   
                    for(var i=4;i>4-remaningItems;i--){
                        linklst.push(blankQuicklink);
                    }
                }
                
                component.set("v.quicklinks", linklst);
                
             //   var gridLength = 'slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-1 slds-large-size--1-of-' + response.getReturnValue().length;
               // component.set("v.gridClass", gridLength);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on loadQuickLinks: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } 
        });

        $A.enqueueAction(action);
    }
})