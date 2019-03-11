({
  getSubscriptions : function(component, event, helper) {
    console.log("Initializing....");
    var action = component.get("c.runDiagnostics");
    action.setParams({ VTID : component.get("v.vtid") });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //verify that there is an existing subscriber in OSS
        var ossSubscriptions = returnObj.activeSubscriptions;
        console.log(ossSubscriptions);
        if(ossSubscriptions.length == 0){
          //add a string to the validationResults list
          returnObj.validationResults.unshift("ERROR: no subscriptions returned from OSS");
        }
        //setup and fire EVENT or set values...
        component.set("v.diagnostics", returnObj);
        component.set("v.statusMessage", returnObj.statusMessage);
        //invoke helper function
        helper.processDiagResults(component, returnObj);
        //setup and fire an event
        var validationEvent = component.getEvent("validationComplete");
        validationEvent.setParams({"statusMessage":returnObj.statusMessage,
                                  "diagnostics" : returnObj});
        validationEvent.fire();
        console.log("validationEvent fired!");
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  }

})