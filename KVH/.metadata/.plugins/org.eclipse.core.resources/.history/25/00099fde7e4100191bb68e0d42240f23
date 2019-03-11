({
  helpCreateSubs : function(component){
    console.log("Creating subscriptions...");
    var priSub = component.get("v.primaryPlan");
    var secSub = component.get("v.secondaryPlan");
    var kontract = component.get("v.kontract");
    var vTerm = component.get("v.terminal");
    var reg = component.get("v.region");

    var action = component.get("c.createTwoSubs");
    
    action.setParams({kont : kontract,
                      asse : vTerm, 
                      priSubId : priSub, 
                      secSubId : secSub,
                      region_obj_id : reg});
    console.log(action.getParam("kont"));
    console.log(action.getParam("asse"));
    console.log(action.getParam("priSubId"));
    console.log(action.getParam("secSubId"));
    console.log(action.getParam("region_obj_id"));
    console.log("Setting Callback...");
    action.setCallback(this, function(response){
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.primarySub", returnObj.primarySub);
        component.set("v.secondarySub", returnObj.secondarySub);
        component.set("v.statusMessage", returnObj.statusMessage);
        var cmpEvent = component.getEvent("cmpDataUpdated");
        cmpEvent.setParams({"stateChange": "SubscriptionsComplete"});
        cmpEvent.fire();
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  },
  
  helpProvisionHybrids : function(component){
    console.log("Provisioning Hybrids...");
    var priSub = component.get("v.primarySub");
    var secSub = component.get("v.secondarySub");

    var action = component.get("c.invokeServiceClass");
    action.setParams({primarySub : priSub, 
                      secondarySub : secSub});
    action.setCallback(this, function(response){
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var returnObj = response.getReturnValue();
        console.log(returnObj);
        //setup and fire EVENT or set values...
        component.set("v.statusMessage", returnObj.statusMessage);
        var cmpEvent = component.getEvent("cmpDataUpdated");
        cmpEvent.setParams({"stateChange": "ProvisioningComplete"});
        cmpEvent.fire();
      } else {
        console.log("Failed with state: " + state);
      }
    }),
    $A.enqueueAction(action);
  }
})