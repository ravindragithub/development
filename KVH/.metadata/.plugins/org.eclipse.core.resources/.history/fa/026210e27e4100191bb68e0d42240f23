({
    lookupVTID : function(component) {
        
        console.log("this is Helper");
        //Fire off Searching event....
        var searchEvent = component.getEvent("searchingVTID");
        searchEvent.fire();
        
        // Create the action...
        var action = component.get("c.lookupVTID");
        console.log(component.get("v.search"));
        action.setParams({
            "VTID": component.get("v.search")
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (component.isValid() && state === "SUCCESS") {
                //console.log("Success with state: " + response.getReturnValue());
                //component.set("v.terminalStatus", response.getReturnValue());
                var foundEvent = component.getEvent("lookupVTID_done");
                // Optional: set some data for the event (also known as event shape)
                foundEvent.setParams({"VTIDmap" : response.getReturnValue() });
                foundEvent.fire();
                console.log("Component Event Fired! " + foundEvent.getParam("VTIDmap"));
            } else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})