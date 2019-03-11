({
	doInit : function(component, event, helper) {
    console.log("initializing...");
    var recId = component.get("v.identifier");
    var action = component.get("c.getHierarchy");
    action.setParams({"recordId": recId});
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(state);
      if (component.isValid() && state === "SUCCESS"){
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        console.log(returnObj.serverResults);
        component.set("v.results", returnObj.serverResults);
        console.log(returnObj.lteAssets);
        component.set("v.lteDevices", returnObj);
        helper.helpGenerateURL(component);
      } else {
        console.log("Failed with state: " + state);
      }
    });
    // Send action off to be executed
    $A.enqueueAction(action);
  }
})