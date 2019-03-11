({
  checkJobStatus : function(component, event, helper) {
    console.log("invoking checkJobStatus helper method...");
    var finished = component.get("v.asynchTerm.complete");
    console.log(finished);
    if(!finished){
      console.log("Asynch job not finished, checking...");
      //fire off a state change event...
      var checkingEvent = component.getEvent("stateChange");
      checkingEvent.setParams({"newState":"Checking"});
      checkingEvent.fire();
      var that = this;  //Allows us to re-invoke this action
      var terminalId = component.get("v.VTID"); 
      // Create the action...
      var action = component.get("c.getAsynchStatusByVtid");
      action.setParams({
        "termId": terminalId
      });
      // Add callback behavior for when response is received
      action.setCallback(this, function(response) {
        var state = response.getState();
        console.log(state);
        if (component.isValid() && state === "SUCCESS") {
          //Fire off a couple of events...
          var checkedEvent = component.getEvent("stateChange");
          checkedEvent.setParams({"newState":"Checked"});
          checkedEvent.fire();
          var returnedObj = response.getReturnValue();
          console.log("Response Code: " + returnedObj.response_code );
          component.set("v.asynchTerm", returnedObj); //Has complete/finished flag
        } else {
          console.log("Failed with state: " + state);
        }
      });
      // Send action off to be executed
      $A.enqueueAction(action);
      //re-invoke the action based on the timeout interval....
      window.setTimeout(
        $A.getCallback(function() {
          console.log("re-checking...");
          that.checkJobStatus(component,event,helper);
        }), 20000
      );
    } else {  //Asynch job is finished and won't return a status anymore
      console.log("Asynch job finished, no need to check again");
    }
	}
})