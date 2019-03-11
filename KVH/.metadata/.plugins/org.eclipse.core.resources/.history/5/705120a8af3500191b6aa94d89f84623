({
  helperSetupStatic : function(component, event, helper) {
    var compEvent = component.getEvent("refresh");
    compEvent.setParams({stateChange : "busy"});
    compEvent.fire();
    var mySub = component.get("v.singleSub");
    // Create the action...
    var action = component.get("c.setupStaticIP");
    action.setParams({
      "parentSub": mySub
    });
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log("Component state: " + state);
      if (component.isValid() && state === "SUCCESS") {
        //Fire off a couple of events...
        var returnedObj = response.getReturnValue();
        console.log("Status Message: " + returnedObj.statusMessage);
        if(returnedObj.success == true){
          component.set("v.statusMessage", "SUCCESS: Static IP provisioned successfully!");
        } else {
          component.set("v.statusMessage", "ERROR: Failed to provision Static IP!");
        }
        var compEvent = component.getEvent("refresh");
        compEvent.setParams({stateChange : "done"});
        compEvent.fire();
      } else {
        console.log("Failed with state: " + state);
      }
    });
    $A.enqueueAction(action);
  }
})