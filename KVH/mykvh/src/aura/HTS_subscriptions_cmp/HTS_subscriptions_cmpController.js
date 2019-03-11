({
	doInit : function(component, event, helper) {
    console.log("Initializing....");
    var action = component.get("c.getSubscription");
    action.setParams({ recId : component.get("v.identifier") });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.subscriptionList", returnObj);
        component.set("v.statusMessage", returnObj.statusMessage);
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
	}
})