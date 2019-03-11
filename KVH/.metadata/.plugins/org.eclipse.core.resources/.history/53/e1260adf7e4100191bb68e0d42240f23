({
	helpHandleAssetNameChange : function(component, event, helper) {
    console.log("Entering handleAssetNameChange action...");
    //TODO: invoke server side action...
    var action = component.get("c.getSubscriptionList");
    action.setParams({ asset_name : component.get("v.assetName")});
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.subscriptionList", returnObj);
        //setup and fire an event
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
	}
})