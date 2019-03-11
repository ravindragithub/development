({
    doLookup : function(component) {
        
        console.log("this is Helper");
        //Fire off Searching event....
        var searchEvent = component.getEvent("cmpDataUpdated");
        searchEvent.setParams({"stateChange" : "Searching"});
        searchEvent.fire();
        console.log("Component Event Fired! " + searchEvent.getParam("status"));
        // Create the action...
        var action = component.get("c.lookupSatRouter");
        console.log(component.get("v.searchString"));
        action.setParams({
            "serial": component.get("v.searchString")
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (component.isValid() && state === "SUCCESS") {
                var returnedObj = response.getReturnValue();
                console.log("Success with state: " + returnedObj);
                var finishedEvent = component.getEvent("cmpDataUpdated");
                // Optional: set some data for the event (also known as event shape)
                finishedEvent.setParams({"stateChange" : "SearchingDone",
                                         "statusMessage" : returnedObj.statusMessage,
                                         "assetList" : returnedObj.assetCollection,
                                         "satRouterMap" : returnedObj.satRouterMap
                                        });
                finishedEvent.fire();
                console.log("Component Event Fired! " + finishedEvent.getParam("statusMessage"));
                //setup and fire APPLICATION event
                var appEvent = $A.get("e.c:HTS_SatRouter_Application_evt");
                appEvent.setParams({"searchString" : component.get("v.searchString")
                                   });
                appEvent.fire();
                console.log("Application Event Fired with: " +appEvent.getParam("searchString"));
            } else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})