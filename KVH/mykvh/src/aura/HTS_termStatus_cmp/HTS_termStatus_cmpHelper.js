({
  lookupVTID : function(component, event, helper) {
    
    console.log("this is Helper");
    //Fire off Searching event....
    var searchEvent = component.getEvent("searchVTID");
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
        var foundEvent = component.getEvent("searchVTID_done");
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
  },

  getTerminalStatus : function(component, obj_id_from_event) {
    // Create the action
    console.log("Getting Terminal Status from OSS...");
    var action = component.get("c.getStatusbyId");
    console.log("Object ID passed from Controller: " + obj_id_from_event);
    action.setParams({
      "obj_id_string": obj_id_from_event
    });
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(state);
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        if(returnObj["activation_state"] == "activated"){
          component.set("v.isActive", "TRUE");
        } else {
          component.set("v.isActive", "FALSE");
        }
        //console.log(statusItems);
      } else {
        console.log("Failed with state: " + state);
      }
    });
    // Send action off to be executed
    $A.enqueueAction(action);
}
})