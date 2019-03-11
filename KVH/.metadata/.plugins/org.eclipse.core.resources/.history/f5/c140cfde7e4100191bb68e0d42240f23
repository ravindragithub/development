({
    lookupI2CM : function(component) {
        //console.log("this is Helper");
        //Setup search array...
        var assetNames = [component.get("v.searchString")];
        //Fire off Searching event....spinner?
        //Maybe this is a flavor of the component event...
        var searchEvent = component.getEvent("cmpDataUpdated");
        searchEvent.setParam("stateChange", "Searching");
        searchEvent.fire();
        console.log("Component Event Fired! " + searchEvent.getParam("stateChange"));
        
        // Create the action...
        var action = component.get("c.lookupAssets");
        action.setParams({
            "searchList": assetNames
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log(state);
            if (component.isValid() && state === "SUCCESS") {
                //Fire off a couple of events...
                var returnedObj = response.getReturnValue();
                console.log("Status Message: " + returnedObj.statusMessage );
                //setup and fire COMPONENT event
                var foundEvent = component.getEvent("cmpDataUpdated");
                // Optional: set some data for the event (also known as event shape)
                foundEvent.setParams({"stateChange" : "SearchComplete",
                                        "assetList" : returnedObj.assetCollection,
                                        "statusMessage" : returnedObj.statusMessage,
                                        "listLength" : returnedObj.assetCollection.length});
                foundEvent.fire();
                console.log("Component Event Fired! " + foundEvent.getParam("stateChange") + " " + foundEvent.getParam("statusMessage"));
                //setup and fire APPLICATION Event
                var appEvent = $A.get("e.c:HTS_terminals_application_evt");
                appEvent.setParams({"assetList" : returnedObj.assetCollection,
                                    "statusMessage" : returnedObj.statusMessage,
                                    "searchString" : component.get("v.searchString") });
                console.log(appEvent.getParam("searchString"));
                appEvent.fire();
                console.log("Application Event Fired with: " +appEvent.getParam("statusMessage") );
            } else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})