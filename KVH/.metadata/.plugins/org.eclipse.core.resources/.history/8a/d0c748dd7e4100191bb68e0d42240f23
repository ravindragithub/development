({
	doInit : function(component, event, helper) {
    console.log("INIT handler invoked....");
    var action = component.get("c.checkIsAgilePlan");
    var caseId = component.get("v.caseId");
    console.log("Account ID: " + caseId);
    action.setParams({"caseId": caseId});
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
        var state = response.getState();
        console.log(state);
        if (component.isValid() && state === "SUCCESS") {
          var checkResult = response.getReturnValue();
          if(checkResult == true){
            component.set("v.isAgilePlan", "This is an AgilePlan Case");
          } else {
            component.set("v.isAgilePlan", "");
          }
            //console.log("Success with state: " + response.getReturnValue());
            //component.set("v.isAgilePlan", response.getReturnValue());
        } else {
            console.log("Failed with state: " + state);
        }
    });
    // Send action off to be executed
    $A.enqueueAction(action);
	}
})