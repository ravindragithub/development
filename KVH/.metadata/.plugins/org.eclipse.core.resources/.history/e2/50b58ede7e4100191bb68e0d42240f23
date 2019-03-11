({
  lookupVTID : function(component) {
    //console.log("this is Helper");
    //Setup search array...
    var assetName = component.get("v.searchString");  
    // Create the action...
    var action = component.get("c.getTerminal");
    action.setParams({
      "searchString": assetName
    });
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log("Component state: " + state);
      if (component.isValid() && state === "SUCCESS") {
        //Fire off a couple of events...
        var returnedObj = response.getReturnValue();
        console.log("Status Message: " + returnedObj.statusMessage );
        //setup and fire COMPONENT event
        var searchEvent = component.getEvent("cmpDataUpdated");
        if(returnedObj.statusMessage.substring(0,6) == "ERROR:"){
          //didn't get an Asset....
          component.set("v.searchString", null);
          searchEvent.setParams({"stateChange": "SearchComplete",
                                "statusMessage" : returnedObj.statusMessage});
        } else {
          searchEvent.setParams({"stateChange": "SearchComplete",
                                "statusMessage" : returnedObj.statusMessage,
                                "terminal" : returnedObj.virtualTerminal});
        }
        component.set("v.termId", returnedObj.virtualTerminal.Name);
        searchEvent.fire();
        console.log("Component Event Fired! " + searchEvent.getParam("stateChange") + " " + searchEvent.getParam("statusMessage"));
      } else {
        console.log("Failed with state: " + state);
      }
    });
    $A.enqueueAction(action);
  }
})