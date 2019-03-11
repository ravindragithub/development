({
	helpPostLTEDeviceToOSS : function(component, event, helper) {
    // Create the action...
    var action = component.get("c.postLTEDevice");
    var payload = component.get("v.assetsCreated");
    console.log(payload);
    action.setParams({"inputHierarchy": payload});
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(state);
      if (component.isValid() && state === "SUCCESS"){
        var returnObj = response.getReturnValue();
        component.set("v.results", returnObj);
        console.log(component.get("v.results"));
        var cmpEvent = component.getEvent("svcCLassEvent");

        if(returnObj.startsWith("SUCCESS:")){
          cmpEvent.setParams({"state": "SUCCESS",
                              "results" : returnObj});
        } else {
          cmpEvent.setParams({"state": "ERROR",
                              "results" : returnObj});
        }
        cmpEvent.fire();
      } else {
        console.log("Failed with state: " + state);
      }
    });
    // Send action off to be executed
    $A.enqueueAction(action);
	}
})