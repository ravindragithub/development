({
    handlePortalViewChange: function(component, event, helper) {
        var selectedOption = event.getParam("selectedOption");
        component.set("v.selectedView", selectedOption);
        var css = component.get("v.dispComp");
        console.log('before: '+ css);
        var action = component.get("c.Documentlistget");
        action.setParams({ selectedView : selectedOption });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Documentlist", response.getReturnValue());
                if(response.getReturnValue().length > 0 ){
                    component.set("v.nodocs", "nodis");
                    component.set("v.dispdocs", "dis");
                    component.set("v.dispComp", "dis");
                } else{
                    component.set("v.nodocs", "dis");
                    component.set("v.dispdocs", "nodis");
                    component.set("v.dispComp", "dis");
                }
                console.log("success " + response.getReturnValue())
            } else{
                component.set("v.nodocs", "dis");
                    component.set("v.dispdocs", "nodis");
                    component.set("v.dispComp", "dis");
                console.log("state = " +state)
            }
        });
        $A.enqueueAction(action);
    }
})